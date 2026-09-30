"""
UIChevron: Directional chevron indicator (❮ / ❯) with focus/active styling.
"""

from __future__ import annotations
from enum import IntEnum
from typing import Optional
from ..base import UIBase
from ...terminal.ansi import ATCoordinates, ATControlSequences
from ...terminal.color import ColorLibrary


class UIChevronOrientation(IntEnum):
    LEFT = 0
    RIGHT = 1


class UIChevron(UIBase):
    """
    Renders a left or right Unicode chevron indicator (❮ or ❯).
    """

    UNICODE_CHEVRON_LEFT = "\u276E"
    UNICODE_CHEVRON_RIGHT = "\u276F"

    def __init__(
        self,
        orientation: UIChevronOrientation = UIChevronOrientation.LEFT,
        coordinates: Optional[ATCoordinates] = None,
    ) -> None:
        super().__init__(coordinates=coordinates)
        self.orientation: UIChevronOrientation = orientation
        self.draw_coordinates: ATCoordinates = coordinates or ATCoordinates(1, 1)
        self.behavior.can_have_focus = True
        self.behavior.active = True
        self.dirty = True

    def to_ansi_control_sequence_string(self) -> str:
        coord_seq = self.draw_coordinates.to_ansi()

        if self.behavior.active:
            if self.behavior.has_focus:
                fg_color = ColorLibrary.UIChevronHasFocus
            else:
                fg_color = ColorLibrary.UIChevronActive
        else:
            fg_color = ColorLibrary.UIChevronInactive

        char = (
            self.UNICODE_CHEVRON_RIGHT
            if self.orientation == UIChevronOrientation.RIGHT
            else self.UNICODE_CHEVRON_LEFT
        )
        return f"{coord_seq}{fg_color.to_ansi_fg()}{char}{ATControlSequences.SGR_RESET}"
