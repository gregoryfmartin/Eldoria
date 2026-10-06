"""
Audio subsystem for Eldoria.
Built upon miniaudio for zero-dependency streaming playback, crossfading,
and multi-channel mixing.
"""

from eldoria_py.audio.assets import resolve_audio_path
from eldoria_py.audio.mixer import MasterMixer
from eldoria_py.audio.sound_engine import AudioEngine, SoundEngine, get_audio_engine
from eldoria_py.audio.stream import AudioStream
from eldoria_py.audio.types import AudioChannel, AudioTrackInfo, PlaybackState

__all__ = [
    "AudioEngine",
    "SoundEngine",
    "get_audio_engine",
    "PlaybackState",
    "AudioChannel",
    "AudioTrackInfo",
    "AudioStream",
    "MasterMixer",
    "resolve_audio_path",
]
