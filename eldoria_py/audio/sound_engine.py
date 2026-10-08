"""
High-level Audio Subsystem Facade for Eldoria.
Provides background music streaming, sound effect management, crossfading,
volume hierarchy control, and seamless headless fallback via miniaudio.
"""

from __future__ import annotations

import atexit
import json
import logging
import os
import sys
import threading
from pathlib import Path
from typing import List, Optional, Union

from eldoria_py.audio.assets import resolve_audio_path
from eldoria_py.audio.mixer import MasterMixer
from eldoria_py.audio.stream import AudioStream
from eldoria_py.audio.types import AudioChannel, AudioTrackInfo, PlaybackState

logger = logging.getLogger("eldoria.audio")


def _emit_web_audio_event(action: str, **kwargs) -> None:
    """Emits an in-band OSC 777 sequence consumed by web terminal audio managers."""
    if os.environ.get("ELDORIA_WEB_AUDIO") == "1":
        payload = json.dumps({"action": action, **kwargs})
        try:
            sys.stdout.write(f"\033]777;eldoria-audio;{payload}\007")
            sys.stdout.flush()
        except Exception:
            pass


try:
    import miniaudio
    MINIAUDIO_AVAILABLE = True
except ImportError:
    miniaudio = None  # type: ignore
    MINIAUDIO_AVAILABLE = False


class AudioEngine:
    """
    Primary audio engine for Eldoria.
    Coordinates device streaming, asset resolution, BGM crossfading, and polyphonic SFX.
    """

    DEFAULT_BUFFER_SIZE_MSEC: int = 400

    def __init__(self, autostart_device: bool = True, buffersize_msec: Optional[int] = None) -> None:
        self.mixer = MasterMixer()
        self.is_available: bool = False
        self._device: Optional[miniaudio.PlaybackDevice] = None
        self._generator = None
        self._lock = threading.RLock()
        self.buffersize_msec: int = buffersize_msec if buffersize_msec is not None else self.DEFAULT_BUFFER_SIZE_MSEC

        atexit.register(self.cleanup)

        if autostart_device:
            self._start_device()

    def _start_device(self, buffersize_msec: Optional[int] = None) -> bool:
        """Initializes and starts the miniaudio PlaybackDevice with the master mixer callback."""
        if os.environ.get("ELDORIA_WEB_AUDIO") == "1":
            logger.info("ELDORIA_WEB_AUDIO active; routing audio through web terminal OSC events.")
            self.is_available = True
            return True

        if not MINIAUDIO_AVAILABLE:
            logger.info("miniaudio library not available; running in headless audio mode.")
            self.is_available = False
            return False

        effective_buffer_msec = buffersize_msec if buffersize_msec is not None else self.buffersize_msec

        try:
            self._generator = self.mixer.callback_generator()
            # Prime generator
            self._generator.send(None)

            self._device = miniaudio.PlaybackDevice(
                output_format=miniaudio.SampleFormat.SIGNED16,
                nchannels=MasterMixer.NCHANNELS,
                sample_rate=MasterMixer.SAMPLE_RATE,
                buffersize_msec=effective_buffer_msec,
            )
            self._device.start(self._generator)
            self.is_available = True
            logger.info(
                "AudioEngine initialized successfully on native audio device (buffer=%dms).",
                effective_buffer_msec,
            )
            return True
        except Exception as exc:
            logger.warning("Could not initialize native audio device (%s); running in headless audio mode.", exc)
            self._device = None
            self.is_available = False
            return False

    # ── Background Music (BGM) ──

    def play_bgm(
        self,
        name_or_path: Union[str, Path],
        loop: bool = True,
        volume: float = 1.0,
    ) -> bool:
        """
        Starts streaming background music immediately, replacing any active track.
        
        Args:
            name_or_path: Audio track name (e.g. "Title Theme A") or file path.
            loop: Whether the track should loop indefinitely.
            volume: Track-specific volume (0.0 to 1.0).
            
        Returns:
            True if track resolved and started, False otherwise.
        """
        resolved = resolve_audio_path("BGM", name_or_path)
        track_asset = resolved.stem if resolved else Path(name_or_path).stem
        _emit_web_audio_event("play_bgm", track=track_asset, loop=loop, volume=volume)

        if resolved is None:
            logger.warning("BGM asset not found: '%s'", name_or_path)
            return False

        stream = AudioStream(
            resolved,
            channel=AudioChannel.MUSIC,
            loop=loop,
            volume=volume,
            name=Path(name_or_path).stem,
        )
        self.mixer.play_bgm(stream)
        return True

    def stop_bgm(self) -> None:
        """Stops the current background music immediately."""
        _emit_web_audio_event("stop_bgm")
        self.mixer.stop_bgm()

    def pause_bgm(self) -> None:
        """Pauses the current background music."""
        _emit_web_audio_event("pause_bgm")
        self.mixer.pause_bgm()

    def resume_bgm(self) -> None:
        """Resumes paused background music."""
        _emit_web_audio_event("resume_bgm")
        self.mixer.resume_bgm()

    def fade_to_bgm(
        self,
        name_or_path: Union[str, Path],
        duration_seconds: float = 1.5,
        loop: bool = True,
        volume: float = 1.0,
    ) -> bool:
        """
        Smoothly crossfades from current BGM to a new track over duration_seconds.
        If no track is currently playing, smoothly fades in the new track from silence.
        
        Args:
            name_or_path: Audio track name or file path.
            duration_seconds: Transition duration in seconds.
            loop: Whether the incoming track loops.
            volume: Incoming track volume multiplier (0.0 to 1.0).
            
        Returns:
            True if resolved and fading initiated, False otherwise.
        """
        resolved = resolve_audio_path("BGM", name_or_path)
        track_asset = resolved.stem if resolved else Path(name_or_path).stem
        _emit_web_audio_event(
            "fade_to_bgm",
            track=track_asset,
            duration=duration_seconds,
            loop=loop,
            volume=volume,
        )

        if resolved is None:
            logger.warning("BGM asset not found for crossfade: '%s'", name_or_path)
            return False

        stream = AudioStream(
            resolved,
            channel=AudioChannel.MUSIC,
            loop=loop,
            volume=volume,
            name=Path(name_or_path).stem,
        )
        if os.environ.get("ELDORIA_WEB_AUDIO") == "1":
            # In web mode, the browser Web Audio API handles crossfading over duration_seconds.
            # Immediately update the mixer's current_bgm so that state tracking
            # (such as get_current_bgm() and pre_battle_bgm_track) remains 100% accurate.
            self.mixer.play_bgm(stream)
        else:
            self.mixer.start_crossfade(stream, duration_seconds=duration_seconds)
        return True

    def fade_out_bgm(self, duration_seconds: float = 1.5) -> None:
        """Smoothly fades out current BGM to silence over duration_seconds."""
        _emit_web_audio_event("fade_out_bgm", duration=duration_seconds)
        if os.environ.get("ELDORIA_WEB_AUDIO") == "1":
            # In web mode, the browser Web Audio API handles the fade-out.
            # Mark the mixer BGM as stopped so get_current_bgm() reflects silence.
            self.mixer.stop_bgm()
        else:
            self.mixer.start_fade_out(duration_seconds=duration_seconds)

    def get_current_bgm(self) -> Optional[AudioTrackInfo]:
        """Returns metadata and playback state of current BGM track, or None if idle."""
        return self.mixer.get_current_bgm_info()

    # ── Sound Effects (SFX) ──

    def play_sfx(
        self,
        name_or_path: Union[str, Path],
        loop: bool = False,
        volume: float = 1.0,
    ) -> Optional[int]:
        """
        Streams and mixes a sound effect. Supports polyphony (concurrent SFX).
        
        Args:
            name_or_path: SFX name (e.g. "UI Chevron Move") or file path.
            loop: Whether the sound effect should loop.
            volume: Instance volume multiplier (0.0 to 1.0).
            
        Returns:
            Handle ID integer if resolved and started, None if asset could not be found.
        """
        resolved = resolve_audio_path("SFX", name_or_path)
        sound_asset = resolved.stem if resolved else Path(name_or_path).stem
        _emit_web_audio_event("play_sfx", sound=sound_asset, loop=loop, volume=volume)

        if resolved is None:
            logger.warning("SFX asset not found: '%s'", name_or_path)
            return None

        stream = AudioStream(
            resolved,
            channel=AudioChannel.SFX,
            loop=loop,
            volume=volume,
            name=Path(name_or_path).stem,
        )
        return self.mixer.play_sfx(stream)

    def stop_sfx(self, handle_id: Optional[int] = None) -> None:
        """Stops a specific SFX handle, or all sound effects if handle_id is None."""
        _emit_web_audio_event("stop_sfx", handle_id=handle_id)
        self.mixer.stop_sfx(handle_id)

    def pause_sfx(self, handle_id: Optional[int] = None) -> None:
        """Pauses a specific SFX handle, or all sound effects if handle_id is None."""
        _emit_web_audio_event("pause_sfx", handle_id=handle_id)
        self.mixer.pause_sfx(handle_id)

    def resume_sfx(self, handle_id: Optional[int] = None) -> None:
        """Resumes a specific SFX handle, or all sound effects if handle_id is None."""
        _emit_web_audio_event("resume_sfx", handle_id=handle_id)
        self.mixer.resume_sfx(handle_id)

    def is_sfx_playing(self, handle_id: int) -> bool:
        """Checks if a specific sound effect handle is still playing."""
        return self.mixer.is_sfx_playing(handle_id)

    def get_playing_sfx(self) -> List[AudioTrackInfo]:
        """Returns a snapshot list of metadata for all currently active sound effects."""
        return self.mixer.get_playing_sfx_info()

    # ── Volume Controls ──

    def set_master_volume(self, volume: float) -> None:
        """Sets master volume (0.0 to 1.0)."""
        _emit_web_audio_event("set_master_volume", volume=volume)
        self.mixer.set_master_volume(volume)

    def set_music_volume(self, volume: float) -> None:
        """Sets music volume (0.0 to 1.0)."""
        _emit_web_audio_event("set_music_volume", volume=volume)
        self.mixer.set_music_volume(volume)

    def set_sfx_volume(self, volume: float) -> None:
        """Sets SFX volume (0.0 to 1.0)."""
        _emit_web_audio_event("set_sfx_volume", volume=volume)
        self.mixer.set_sfx_volume(volume)

    def get_master_volume(self) -> float:
        """Returns master volume (0.0 to 1.0)."""
        return self.mixer.master_volume

    def get_music_volume(self) -> float:
        """Returns music volume (0.0 to 1.0)."""
        return self.mixer.music_volume

    def get_sfx_volume(self) -> float:
        """Returns SFX volume (0.0 to 1.0)."""
        return self.mixer.sfx_volume

    def adjust_master_volume(self, delta: float) -> float:
        """Adjusts master volume by delta and returns the new value clamped to 0.0 - 1.0."""
        new_vol = max(0.0, min(1.0, self.mixer.master_volume + delta))
        self.mixer.set_master_volume(new_vol)
        _emit_web_audio_event("set_master_volume", volume=new_vol)
        return new_vol

    def toggle_mute(self) -> bool:
        """Toggles audio mute and returns new muted state."""
        muted = self.mixer.toggle_mute()
        _emit_web_audio_event("set_mute", muted=muted)
        return muted

    @property
    def is_muted(self) -> bool:
        """Whether audio output is currently muted."""
        return self.mixer.is_muted

    # ── Shutdown & Cleanup ──

    def cleanup(self) -> None:
        """Stops all playback and releases native audio device resources."""
        with self._lock:
            _emit_web_audio_event("stop_bgm")
            _emit_web_audio_event("stop_sfx")
            self.mixer.stop_bgm()
            self.mixer.stop_sfx()
            if self._device is not None:
                try:
                    self._device.close()
                except Exception:
                    pass
                self._device = None
            self.is_available = False

    def shutdown(self) -> None:
        """Alias for cleanup()."""
        self.cleanup()


# Alias for backward compatibility with initial stubs
SoundEngine = AudioEngine

# Singleton instance reference
_DEFAULT_ENGINE: Optional[AudioEngine] = None
_ENGINE_LOCK = threading.Lock()


def get_audio_engine(autostart_device: bool = True, buffersize_msec: Optional[int] = None) -> AudioEngine:
    """Returns the process-wide AudioEngine singleton instance."""
    global _DEFAULT_ENGINE
    if _DEFAULT_ENGINE is None:
        with _ENGINE_LOCK:
            if _DEFAULT_ENGINE is None:
                _DEFAULT_ENGINE = AudioEngine(
                    autostart_device=autostart_device,
                    buffersize_msec=buffersize_msec,
                )
    return _DEFAULT_ENGINE
