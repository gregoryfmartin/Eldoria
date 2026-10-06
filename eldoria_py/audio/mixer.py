"""
Master audio mixer and crossfader for Eldoria.
Combines streaming BGM and multiple concurrent SFX into a unified PCM stream.
"""

from __future__ import annotations

import array
import logging
import threading
from typing import Dict, Generator, List, Optional

from eldoria_py.audio.stream import AudioStream
from eldoria_py.audio.types import AudioChannel, AudioTrackInfo, PlaybackState

logger = logging.getLogger("eldoria.audio.mixer")


class MasterMixer:
    """
    Thread-safe real-time audio mixer that blends background music (BGM),
    crossfading tracks, and concurrent sound effects (SFX) into a 16-bit stereo PCM stream.
    """

    SAMPLE_RATE = 44100
    NCHANNELS = 2  # Stereo

    def __init__(self) -> None:
        self.master_volume: float = 1.0
        self.music_volume: float = 0.8
        self.sfx_volume: float = 1.0
        self.is_muted: bool = False

        self.current_bgm: Optional[AudioStream] = None
        self.crossfade_bgm: Optional[AudioStream] = None

        self.fade_mode: Optional[str] = None  # "crossfade", "fade_out", "fade_in"
        self.fade_duration_frames: int = 0
        self.fade_frames_elapsed: int = 0

        self.sfx_streams: Dict[int, AudioStream] = {}
        self._next_sfx_handle: int = 1

        self._lock: threading.RLock = threading.RLock()

    # ── Volume Control ──

    def set_master_volume(self, volume: float) -> None:
        with self._lock:
            self.master_volume = max(0.0, min(1.0, volume))

    def set_music_volume(self, volume: float) -> None:
        with self._lock:
            self.music_volume = max(0.0, min(1.0, volume))

    def set_sfx_volume(self, volume: float) -> None:
        with self._lock:
            self.sfx_volume = max(0.0, min(1.0, volume))

    def toggle_mute(self) -> bool:
        with self._lock:
            self.is_muted = not self.is_muted
            return self.is_muted

    # ── Background Music (BGM) ──

    def play_bgm(self, stream: AudioStream) -> None:
        """Plays BGM immediately, replacing any existing track."""
        with self._lock:
            if self.current_bgm is not None:
                self.current_bgm.stop()
            if self.crossfade_bgm is not None:
                self.crossfade_bgm.stop()
                self.crossfade_bgm = None

            self.fade_mode = None
            self.fade_frames_elapsed = 0
            self.fade_duration_frames = 0

            stream.fade_gain = 1.0
            stream.state = PlaybackState.PLAYING
            self.current_bgm = stream

    def stop_bgm(self) -> None:
        """Stops the current background music immediately."""
        with self._lock:
            if self.current_bgm is not None:
                self.current_bgm.stop()
                self.current_bgm = None
            if self.crossfade_bgm is not None:
                self.crossfade_bgm.stop()
                self.crossfade_bgm = None
            self.fade_mode = None

    def pause_bgm(self) -> None:
        """Pauses the current background music."""
        with self._lock:
            if self.current_bgm is not None:
                self.current_bgm.pause()
            if self.crossfade_bgm is not None:
                self.crossfade_bgm.pause()

    def resume_bgm(self) -> None:
        """Resumes the current background music."""
        with self._lock:
            if self.current_bgm is not None:
                self.current_bgm.resume()
            if self.crossfade_bgm is not None:
                self.crossfade_bgm.resume()

    def start_crossfade(self, next_stream: AudioStream, duration_seconds: float = 1.5) -> None:
        """Fades current BGM out while fading next_stream in over duration_seconds."""
        with self._lock:
            fade_frames = max(1, int(duration_seconds * self.SAMPLE_RATE))

            if self.current_bgm is None or self.current_bgm.state == PlaybackState.STOPPED:
                # No active track to fade from; fade in the new track
                next_stream.fade_gain = 0.0
                next_stream.state = PlaybackState.FADING
                self.current_bgm = next_stream
                self.crossfade_bgm = None
                self.fade_mode = "fade_in"
            else:
                self.current_bgm.state = PlaybackState.FADING
                next_stream.fade_gain = 0.0
                next_stream.state = PlaybackState.FADING
                self.crossfade_bgm = next_stream
                self.fade_mode = "crossfade"

            self.fade_duration_frames = fade_frames
            self.fade_frames_elapsed = 0

    def start_fade_out(self, duration_seconds: float = 1.5) -> None:
        """Fades current BGM out to silence over duration_seconds."""
        with self._lock:
            if self.current_bgm is None or self.current_bgm.state == PlaybackState.STOPPED:
                return
            self.current_bgm.state = PlaybackState.FADING
            self.fade_mode = "fade_out"
            self.fade_duration_frames = max(1, int(duration_seconds * self.SAMPLE_RATE))
            self.fade_frames_elapsed = 0

    def get_current_bgm_info(self) -> Optional[AudioTrackInfo]:
        """Returns metadata for the currently active BGM stream."""
        with self._lock:
            if self.current_bgm is not None and self.current_bgm.state != PlaybackState.STOPPED:
                return self.current_bgm.get_info()
            return None

    # ── Sound Effects (SFX) ──

    def play_sfx(self, stream: AudioStream) -> int:
        """Registers and starts a sound effect stream, returning its handle ID."""
        with self._lock:
            handle = self._next_sfx_handle
            self._next_sfx_handle += 1
            stream.handle_id = handle
            stream.channel = AudioChannel.SFX
            stream.state = PlaybackState.PLAYING
            self.sfx_streams[handle] = stream
            return handle

    def stop_sfx(self, handle_id: Optional[int] = None) -> None:
        """Stops a specific SFX stream, or all active SFX if handle_id is None."""
        with self._lock:
            if handle_id is None:
                for stream in list(self.sfx_streams.values()):
                    stream.stop()
                self.sfx_streams.clear()
            elif handle_id in self.sfx_streams:
                self.sfx_streams[handle_id].stop()
                del self.sfx_streams[handle_id]

    def pause_sfx(self, handle_id: Optional[int] = None) -> None:
        """Pauses a specific SFX stream, or all active SFX if handle_id is None."""
        with self._lock:
            if handle_id is None:
                for stream in self.sfx_streams.values():
                    stream.pause()
            elif handle_id in self.sfx_streams:
                self.sfx_streams[handle_id].pause()

    def resume_sfx(self, handle_id: Optional[int] = None) -> None:
        """Resumes a specific SFX stream, or all active SFX if handle_id is None."""
        with self._lock:
            if handle_id is None:
                for stream in self.sfx_streams.values():
                    stream.resume()
            elif handle_id in self.sfx_streams:
                self.sfx_streams[handle_id].resume()

    def is_sfx_playing(self, handle_id: int) -> bool:
        """Returns True if the specified sound effect is actively playing."""
        with self._lock:
            stream = self.sfx_streams.get(handle_id)
            return stream is not None and stream.state == PlaybackState.PLAYING

    def get_playing_sfx_info(self) -> List[AudioTrackInfo]:
        """Returns a snapshot list of metadata for all active sound effects."""
        with self._lock:
            return [stream.get_info() for stream in self.sfx_streams.values()]

    # ── Mixer Core & Device Callback ──

    def render_frames(self, num_frames: int) -> array.array:
        """
        Renders and mixes exactly `num_frames` stereo samples into a signed 16-bit PCM array.
        Called by the device callback generator or test simulator.
        """
        total_samples = num_frames * self.NCHANNELS
        out = array.array("h", [0] * total_samples)

        with self._lock:
            if self.is_muted or self.master_volume <= 0.0:
                # Keep state counters moving even if muted, but output silence
                self._advance_streams_muted(num_frames)
                return out

            accum = [0.0] * total_samples
            active_count = 0

            # 1. Background Music (BGM)
            active_count += self._mix_bgm(accum, num_frames)

            # 2. Sound Effects (SFX)
            active_count += self._mix_sfx(accum, num_frames)

            if active_count == 0:
                return out

            # Clamp and convert accumulated floats to signed 16-bit integers
            for i in range(total_samples):
                val = int(accum[i])
                if val > 32767:
                    out[i] = 32767
                elif val < -32768:
                    out[i] = -32768
                else:
                    out[i] = val

        return out

    def _advance_streams_muted(self, num_frames: int) -> None:
        """Pumps stream frame reads while muted so playback positions advance accurately."""
        if self.current_bgm is not None:
            self.current_bgm.read_frames(num_frames)
        if self.crossfade_bgm is not None:
            self.crossfade_bgm.read_frames(num_frames)
        finished = []
        for handle, stream in self.sfx_streams.items():
            chunk = stream.read_frames(num_frames)
            if chunk is None or stream.state == PlaybackState.STOPPED:
                finished.append(handle)
        for handle in finished:
            self.sfx_streams.pop(handle, None)

    def _mix_bgm(self, accum: List[float], num_frames: int) -> int:
        """Reads BGM streams, computes fading gains, and accumulates samples."""
        active = 0
        total_samples = num_frames * self.NCHANNELS

        # Update fade state machine
        if self.fade_mode is not None and self.fade_duration_frames > 0:
            self._update_fade_progress(num_frames)

        # Mix current BGM
        if self.current_bgm is not None and self.current_bgm.state in (PlaybackState.PLAYING, PlaybackState.FADING):
            chunk = self.current_bgm.read_frames(num_frames)
            if chunk:
                gain = self.master_volume * self.music_volume * self.current_bgm.volume * self.current_bgm.fade_gain
                for i in range(min(len(chunk), total_samples)):
                    accum[i] += chunk[i] * gain
                active += 1
            elif self.current_bgm.state == PlaybackState.STOPPED:
                self.current_bgm = None

        # Mix crossfading incoming BGM
        if self.crossfade_bgm is not None and self.crossfade_bgm.state in (PlaybackState.PLAYING, PlaybackState.FADING):
            chunk = self.crossfade_bgm.read_frames(num_frames)
            if chunk:
                gain = self.master_volume * self.music_volume * self.crossfade_bgm.volume * self.crossfade_bgm.fade_gain
                for i in range(min(len(chunk), total_samples)):
                    accum[i] += chunk[i] * gain
                active += 1
            elif self.crossfade_bgm.state == PlaybackState.STOPPED:
                self.crossfade_bgm = None

        return active

    def _update_fade_progress(self, num_frames: int) -> None:
        """Updates linear fade gains across active fade modes."""
        self.fade_frames_elapsed += num_frames
        progress = min(1.0, self.fade_frames_elapsed / self.fade_duration_frames)

        if self.fade_mode == "crossfade":
            if self.current_bgm:
                self.current_bgm.fade_gain = 1.0 - progress
            if self.crossfade_bgm:
                self.crossfade_bgm.fade_gain = progress

            if progress >= 1.0:
                # Crossfade complete: promote incoming track
                if self.current_bgm:
                    self.current_bgm.stop()
                self.current_bgm = self.crossfade_bgm
                if self.current_bgm:
                    self.current_bgm.fade_gain = 1.0
                    self.current_bgm.state = PlaybackState.PLAYING
                self.crossfade_bgm = None
                self.fade_mode = None

        elif self.fade_mode == "fade_out":
            if self.current_bgm:
                self.current_bgm.fade_gain = 1.0 - progress
            if progress >= 1.0:
                if self.current_bgm:
                    self.current_bgm.stop()
                    self.current_bgm = None
                self.fade_mode = None

        elif self.fade_mode == "fade_in":
            if self.current_bgm:
                self.current_bgm.fade_gain = progress
            if progress >= 1.0:
                if self.current_bgm:
                    self.current_bgm.fade_gain = 1.0
                    self.current_bgm.state = PlaybackState.PLAYING
                self.fade_mode = None

    def _mix_sfx(self, accum: List[float], num_frames: int) -> int:
        """Reads all active sound effects, scales by volume, and accumulates samples."""
        active = 0
        total_samples = num_frames * self.NCHANNELS
        finished_handles: List[int] = []

        for handle, stream in list(self.sfx_streams.items()):
            if stream.state not in (PlaybackState.PLAYING, PlaybackState.FADING):
                if stream.state == PlaybackState.STOPPED:
                    finished_handles.append(handle)
                continue

            chunk = stream.read_frames(num_frames)
            if chunk:
                gain = self.master_volume * self.sfx_volume * stream.volume
                for i in range(min(len(chunk), total_samples)):
                    accum[i] += chunk[i] * gain
                active += 1
            else:
                finished_handles.append(handle)

        for handle in finished_handles:
            self.sfx_streams.pop(handle, None)

        return active

    def callback_generator(self) -> Generator[array.array, int, None]:
        """
        Device callback generator compatible with miniaudio.PlaybackDevice.start().
        Receives requested frame count from miniaudio and yields rendered PCM arrays.
        """
        num_frames = yield array.array("h")
        while True:
            rendered = self.render_frames(num_frames)
            num_frames = yield rendered
