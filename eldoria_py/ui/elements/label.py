"""
UILabel: Static or dynamic text label UI element.
"""

from __future__ import annotations
from typing import Optional
from ..base import UIBase
from ...terminal.ansi import ATCoordinates, ATDecoration
from ...terminal.color import TrueColor


class UILabel(UIBase):
    """Simple text label element extending UIBase."""

    def __init__(
        self,
        text: str = "",
        coordinates: Optional[ATCoordinates] = None,
        fg_color: Optional[TrueColor] = None,
        bg_color: Optional[TrueColor] = None,
        decorations: Optional[ATDecoration] = None,
    ) -> None:
        super().__init__(text, coordinates, fg_color, bg_color, decorations)
