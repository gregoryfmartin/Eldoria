"""
Audio Engine: Cross-platform sound effect and looping background music player using miniaudio.
Gracefully degrades to silent no-op if no audio device is available (headless, sandbox, CI).
"""

from __future__ import annotations
import os
import threading
import time
from typing import Optional

try:
    import miniaudio
    MINIAUDIO_AVAILABLE = True
except ImportError:
    MINIAUDIO_AVAILABLE = False


class SoundEngine:
    """
    Manages background music and sound effects playback via miniaudio.
    """

    def __init__(self) -> None:
        self.master_volume: float = 1.0
        self.music_volume: float = 0.8
        self.sfx_volume: float = 1.0
        self.is_muted: bool = False
        self.is_available: bool = False

        self._music_device: Optional[miniaudio.PlaybackDevice] = None
        self._current_music_path: Optional[str] = None
        self._music_thread: Optional[threading.Thread] = None
        self._stop_music_event: threading.Event = threading.Event()
        self._lock: threading.Lock = threading.Lock()

        self._probe_audio()

    def _probe_audio(self) -> None:
        if not MINIAUDIO_AVAILABLE:
            self.is_available = False
            return

        try:
            # Attempt to query devices
            devices = miniaudio.Devices()
            self.is_available = True
        except Exception:
            self.is_available = False

    def play_music(self, file_path: str, loop: bool = True) -> bool:
        """Plays background music asynchronously with optional looping."""
        if not self.is_available or self.is_muted or not os.path.exists(file_path):
            return False

        self.stop_music()

        with self._lock:
            self._current_music_path = file_path
            self._stop_music_event.clear()
            self._music_thread = threading.Thread(
                target=self._music_loop,
                args=(file_path, loop),
                daemon=True,
                name="EldoriaMusicThread",
            )
            self._music_thread.start()
        return True

    def _music_loop(self, file_path: str, loop: bool) -> None:
        try:
            while not self._stop_music_event.is_set():
                stream = miniaudio.stream_file(file_path)
                with miniaudio.PlaybackDevice() as device:
                    self._music_device = device
                    device.start(stream)

                    while device.is_running and not self._stop_music_event.is_set():
                        time.sleep(0.05)

                if not loop or self._stop_music_event.is_set():
                    break
        except Exception:
            pass
        finally:
            self._music_device = None

    def stop_music(self) -> None:
        """Stops current background music."""
        self._stop_music_event.set()
        if self._music_device and self._music_device.is_running:
            try:
                self._music_device.stop()
            except Exception:
                pass
        if self._music_thread and self._music_thread.is_alive():
            self._music_thread.join(timeout=0.2)
        self._current_music_path = None

    def play_sfx(self, file_path: str) -> bool:
        """Plays a one-shot sound effect asynchronously."""
        if not self.is_available or self.is_muted or not os.path.exists(file_path):
            return False

        def _play_sfx_thread() -> None:
            try:
                sound = miniaudio.decode_file(file_path)
                with miniaudio.PlaybackDevice() as device:
                    device.start(sound)
                    while device.is_running:
                        time.sleep(0.02)
            except Exception:
                pass

        thread = threading.Thread(target=_play_sfx_thread, daemon=True, name="EldoriaSfxThread")
        thread.start()
        return True

    def set_master_volume(self, volume: float) -> None:
        self.master_volume = max(0.0, min(1.0, volume))

    def set_music_volume(self, volume: float) -> None:
        self.music_volume = max(0.0, min(1.0, volume))

    def set_sfx_volume(self, volume: float) -> None:
        self.sfx_volume = max(0.0, min(1.0, volume))

    def toggle_mute(self) -> bool:
        self.is_muted = not self.is_muted
        if self.is_muted:
            self.stop_music()
        return self.is_muted

    def cleanup(self) -> None:
        """Stops all audio playback and cleans up devices."""
        self.stop_music()
