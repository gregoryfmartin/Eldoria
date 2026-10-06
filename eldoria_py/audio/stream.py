"""
Streaming audio source wrapper over miniaudio.
Handles on-the-fly streaming, position tracking, and seamless looping.
"""

from __future__ import annotations

import array
import logging
from pathlib import Path
from typing import Generator, Optional, Union

from eldoria_py.audio.types import AudioChannel, AudioTrackInfo, PlaybackState

logger = logging.getLogger("eldoria.audio.stream")

try:
    import miniaudio
    MINIAUDIO_AVAILABLE = True
except ImportError:
    miniaudio = None  # type: ignore
    MINIAUDIO_AVAILABLE = False


class AudioStream:
    """
    Wraps an audio file streaming generator with playback state, volume attenuation,
    position tracking, and seamless looping.
    """

    SAMPLE_RATE = 44100
    NCHANNELS = 2  # Stereo

    def __init__(
        self,
        file_path: Union[str, Path],
        channel: AudioChannel = AudioChannel.MUSIC,
        loop: bool = True,
        volume: float = 1.0,
        handle_id: Optional[int] = None,
        name: Optional[str] = None,
    ) -> None:
        self.file_path = Path(file_path).resolve()
        self.channel = channel
        self.loop = loop
        self.volume = max(0.0, min(1.0, volume))
        self.fade_gain: float = 1.0
        self.handle_id = handle_id
        self.name = name or self.file_path.stem

        self.state: PlaybackState = PlaybackState.PLAYING
        self.frames_played: int = 0
        self.loop_count: int = 0

        self.total_frames: int = 0
        self.duration_seconds: float = 0.0
        self._inspect_file()

        self._gen: Optional[Generator[array.array, int, None]] = None
        self._init_generator()

    def _inspect_file(self) -> None:
        if not MINIAUDIO_AVAILABLE or not self.file_path.is_file():
            return
        try:
            info = miniaudio.get_file_info(str(self.file_path))
            self.duration_seconds = float(info.duration)
            self.total_frames = int(info.num_frames)
        except Exception as exc:
            logger.debug("Could not inspect audio file info for '%s': %s", self.file_path, exc)
            self.duration_seconds = 0.0
            self.total_frames = 0

    def _init_generator(self) -> bool:
        if not MINIAUDIO_AVAILABLE or not self.file_path.is_file():
            self.state = PlaybackState.STOPPED
            return False

        try:
            self._gen = miniaudio.stream_file(
                str(self.file_path),
                output_format=miniaudio.SampleFormat.SIGNED16,
                nchannels=self.NCHANNELS,
                sample_rate=self.SAMPLE_RATE,
            )
            # Prime generator
            self._gen.send(None)
            return True
        except Exception as exc:
            logger.warning("Failed to start audio stream for '%s': %s", self.file_path, exc)
            self._gen = None
            self.state = PlaybackState.STOPPED
            return False

    def read_frames(self, num_frames: int) -> Optional[array.array]:
        """
        Reads up to `num_frames` stereo samples from the stream.
        Handles seamless loop re-priming on EOF.
        
        Returns:
            array.array of signed 16-bit integers ('h'), or None if stopped/exhausted.
        """
        if self.state in (PlaybackState.STOPPED, PlaybackState.PAUSED):
            return None

        if self._gen is None:
            return None

        result: Optional[array.array] = None
        frames_needed = num_frames

        while frames_needed > 0:
            try:
                chunk = self._gen.send(frames_needed)
                if not chunk or len(chunk) == 0:
                    raise StopIteration

                chunk_frames = len(chunk) // self.NCHANNELS
                self.frames_played += chunk_frames

                if result is None:
                    result = chunk
                else:
                    result.extend(chunk)

                frames_needed -= chunk_frames
                if frames_needed <= 0:
                    break

            except (StopIteration, Exception):
                if self.loop:
                    self.loop_count += 1
                    # Seamless loop: re-initialize generator and continue filling needed frames
                    if not self._init_generator():
                        self.state = PlaybackState.STOPPED
                        break
                else:
                    self.state = PlaybackState.STOPPED
                    self._close_generator()
                    break

        return result

    def pause(self) -> None:
        """Pauses stream playback."""
        if self.state == PlaybackState.PLAYING:
            self.state = PlaybackState.PAUSED

    def resume(self) -> None:
        """Resumes stream playback."""
        if self.state == PlaybackState.PAUSED:
            self.state = PlaybackState.PLAYING

    def stop(self) -> None:
        """Stops stream playback and closes underlying resources."""
        self.state = PlaybackState.STOPPED
        self._close_generator()

    def _close_generator(self) -> None:
        if self._gen is not None:
            try:
                self._gen.close()
            except Exception:
                pass
            self._gen = None

    @property
    def position_seconds(self) -> float:
        """Current playback position in seconds (wrapped within single track duration if looping)."""
        if self.duration_seconds > 0 and self.loop:
            elapsed = self.frames_played / self.SAMPLE_RATE
            return elapsed % self.duration_seconds
        return self.frames_played / self.SAMPLE_RATE

    def get_info(self) -> AudioTrackInfo:
        """Returns metadata and playback state snapshot."""
        return AudioTrackInfo(
            name=self.name,
            path=str(self.file_path),
            channel=self.channel,
            state=self.state,
            volume=self.volume,
            duration_seconds=self.duration_seconds,
            position_seconds=round(self.position_seconds, 2),
            loop=self.loop,
            loop_count=self.loop_count,
            handle_id=self.handle_id,
        )
