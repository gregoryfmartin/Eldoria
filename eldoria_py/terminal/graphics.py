"""
Multi-protocol terminal graphics (TIString: Sixel & Kitty Graphics Protocol) and string animation engine.
"""

from __future__ import annotations
from enum import Enum, auto
import sys
from typing import List, Optional, Sequence, Union


class TIStringMode(Enum):
    """Supported terminal image protocol formats."""
    SIXEL = 0
    KITTY = 1


class TIString:
    """
    Text-Image String holding multiple protocol variants (e.g. Sixel, Kitty Graphics Protocol)
    for a single graphical image or animation frame.
    """

    def __init__(self, variants: Sequence[str] = ()) -> None:
        self.variants: List[str] = list(variants)

    def get_mode_variant(self, mode: TIStringMode) -> str:
        idx = mode.value
        if 0 <= idx < len(self.variants):
            return self.variants[idx]
        return self.variants[0] if self.variants else ""


class StringAnimator:
    """
    Time-based animator for text/ASCII/string frames driven by high-precision delta-time.
    """

    def __init__(self, frames: Sequence[str] = (), fps: int = 10) -> None:
        self.frames: List[str] = list(frames)
        self.fps: int = max(1, fps)
        self.frame_duration: float = 1.0 / self.fps
        self.timer: float = 0.0
        self.current_frame_index: int = 0

    def update(self, dt: float) -> None:
        if not self.frames or self.frame_duration <= 0:
            return
        self.timer += dt
        while self.timer >= self.frame_duration:
            self.timer -= self.frame_duration
            self.current_frame_index = (self.current_frame_index + 1) % len(self.frames)

    def get_current_frame(self) -> str:
        if not self.frames:
            return ""
        return self.frames[self.current_frame_index]


class TIStringAnimator:
    """
    Time-based animator for multi-protocol graphical frames (TIString) driven by delta-time.
    """

    def __init__(
        self,
        frames: Sequence[TIString] = (),
        fps: int = 10,
        mode: Optional[TIStringMode] = None,
    ) -> None:
        self.frames: List[TIString] = list(frames)
        self.fps: int = max(1, fps)
        self.frame_duration: float = 1.0 / self.fps
        self.timer: float = 0.0
        self.current_frame_index: int = 0
        if mode is not None:
            self.mode: TIStringMode = mode
        else:
            self.mode = TIStringMode.KITTY if sys.platform == "darwin" else TIStringMode.SIXEL

    def update(self, dt: float) -> None:
        if not self.frames or self.frame_duration <= 0:
            return
        self.timer += dt
        while self.timer >= self.frame_duration:
            self.timer -= self.frame_duration
            self.current_frame_index = (self.current_frame_index + 1) % len(self.frames)

    def get_current_frame(self, mode: Optional[TIStringMode] = None) -> str:
        if not self.frames:
            return ""
        target_mode = mode if mode is not None else self.mode
        return self.frames[self.current_frame_index].get_mode_variant(target_mode)
