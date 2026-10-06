"""
Audio subsystem data types, enumerations, and metadata containers.
"""

from __future__ import annotations

from dataclasses import dataclass
from enum import Enum
from typing import Optional


class PlaybackState(str, Enum):
    """Lifecycle states of an audio stream."""
    STOPPED = "STOPPED"
    PLAYING = "PLAYING"
    PAUSED = "PAUSED"
    FADING = "FADING"


class AudioChannel(str, Enum):
    """Audio bus channel categories."""
    MASTER = "MASTER"
    MUSIC = "MUSIC"
    SFX = "SFX"


@dataclass
class AudioTrackInfo:
    """Detailed metadata and current playback status for a tracked audio item."""
    name: str
    path: str
    channel: AudioChannel
    state: PlaybackState
    volume: float
    duration_seconds: float
    position_seconds: float
    loop: bool
    loop_count: int = 0
    handle_id: Optional[int] = None
