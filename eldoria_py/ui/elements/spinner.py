"""
UICellSpinner: Single-cell animated spinner element ('|', '/', '-', '\\').
"""

from __future__ import annotations
from typing import Optional
from ..base import UIBase
from ...core.context import Context
from ...core.fsm import SMState
from ...terminal.ansi import ATCoordinates, ATControlSequences
from ...terminal.color import TrueColor, ColorLibrary
from ...terminal.graphics import StringAnimator


class UICellSpinner(UIBase):
    """
    Renders an animated single-cell spinner cycling through '|', '\\', '-', '/'.
    """

    FRAMES = ["|", "\\", "-", "/"]

    def __init__(
        self,
        fps: int = 2,
        fg_color: Optional[TrueColor] = None,
        coordinates: Optional[ATCoordinates] = None,
    ) -> None:
        super().__init__(text="|", coordinates=coordinates, fg_color=fg_color or ColorLibrary.AppleMintLight)
        self.animator = StringAnimator(self.FRAMES, fps=fps)
        self.animation_speed_scalar: float = 1.0
        self.set_user_data(self.animator.get_current_frame())

    def update(self, context: Context) -> None:
        super().update(context)
        dt = 0.0
        if len(context.references) > 1 and isinstance(context.references[1], Context):
            orig_ctx = context.references[1]
            val = orig_ctx.get(SMState.ContextDeltaTime)
            if isinstance(val, (int, float)):
                dt = float(val)
        elif len(context.references) > 0 and isinstance(context.references[0], (int, float)):
            dt = float(context.references[0])

        if dt > 0:
            old_frame = self.animator.get_current_frame()
            self.animator.update(dt * self.animation_speed_scalar)
            new_frame = self.animator.get_current_frame()
            if new_frame != old_frame:
                self.set_user_data(new_frame)
                self.dirty = True

    def to_ansi_control_sequence_string(self) -> str:
        coord_seq = self.coordinates.to_ansi() if self.coordinates else ""
        fg_seq = self.fg_color.to_ansi_fg() if self.fg_color else ""
        return f"{coord_seq}{fg_seq}{self.user_data}{ATControlSequences.SGR_RESET}"
