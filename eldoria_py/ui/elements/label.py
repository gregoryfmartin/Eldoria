"""
UILabel: Static or dynamic text label UI element.
"""

from __future__ import annotations
from typing import Optional, TYPE_CHECKING
from ..base import UIBase
from ...terminal.ansi import ATCoordinates, ATDecoration
from ...terminal.color import TrueColor
from ...terminal.box import visible_width

if TYPE_CHECKING:
    from ..container import UIContainer


class UILabel(UIBase):
    """Simple text label element extending UIBase with parent container bounds validation."""

    def __init__(
        self,
        text: str = "",
        coordinates: Optional[ATCoordinates] = None,
        fg_color: Optional[TrueColor] = None,
        bg_color: Optional[TrueColor] = None,
        decorations: Optional[ATDecoration] = None,
        parent: Optional[UIContainer] = None,
    ) -> None:
        super().__init__(text, coordinates, fg_color, bg_color, decorations)
        self.parent: Optional[UIContainer] = parent
        vlen = visible_width(self.text)
        if self.parent and self.coordinates:
            max_avail = max(0, self.parent.inner_right - self.coordinates.column + 1)
            self.set_blank_size(min(vlen, max_avail))
            self.validate_bounds()
        else:
            self.set_blank_size(vlen)

    def validate_bounds(self) -> None:
        """
        Validates that the label's text strictly fits within the parent container's inner bounds.
        Raises ValueError if text exceeds available container width (zero silent truncation).
        """
        if not self.parent or not self.coordinates:
            return

        vlen = visible_width(self.text)
        if vlen > self.parent.inner_width:
            raise ValueError(
                f"Label text '{self.text}' (visible width {vlen}) exceeds parent container inner_width ({self.parent.inner_width})"
            )

        row = self.coordinates.row
        col = self.coordinates.column

        if not (self.parent.inner_top <= row <= self.parent.inner_bottom):
            raise ValueError(
                f"Label row {row} is outside parent container vertical inner bounds [{self.parent.inner_top}..{self.parent.inner_bottom}]"
            )

        if col < self.parent.inner_left:
            raise ValueError(
                f"Label column {col} starts outside parent container inner_left ({self.parent.inner_left})"
            )

        if col + vlen - 1 > self.parent.inner_right:
            exceeded = (col + vlen - 1) - self.parent.inner_right
            raise ValueError(
                f"Label '{self.text}' exceeds parent container right border by {exceeded} column(s). Allowed inner_right is {self.parent.inner_right}."
            )

    def set_user_data(self, data: str) -> None:
        """Sets the display text, marks dirty, and re-validates against parent bounds."""
        super().set_user_data(data)
        vlen = visible_width(self.text)
        if self.parent and self.coordinates:
            max_avail = max(0, self.parent.inner_right - self.coordinates.column + 1)
            target_blank = max(len(self.blank), vlen)
            self.set_blank_size(min(target_blank, max_avail))
            self.validate_bounds()
        else:
            self.set_blank_size(max(len(self.blank), vlen))

