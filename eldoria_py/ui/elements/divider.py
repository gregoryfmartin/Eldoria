"""
UIDivider: Container-aware horizontal divider line with junction glyphs.
"""

from __future__ import annotations
from typing import Optional, TYPE_CHECKING
from ..base import UIBase
from ...terminal.ansi import ATCoordinates, ATControlSequences
from ...terminal.box import visible_width
from ...terminal.color import TrueColor, ColorLibrary

if TYPE_CHECKING:
    from ..container import UIContainer


class UIDivider(UIBase):
    """
    Horizontal divider row spanning container width with boundary junction characters.
    e.g. ├──────────────────────┤
    """

    def __init__(
        self,
        row: int,
        title: str = "",
        left: str = "├",
        fill: str = "─",
        right: str = "┤",
        fg_color: Optional[TrueColor] = None,
        parent: Optional[UIContainer] = None,
    ) -> None:
        super().__init__(text=title, coordinates=ATCoordinates(row, 1), fg_color=fg_color)
        self.row: int = row
        self.title: str = title
        self.left_glyph: str = left
        self.fill_glyph: str = fill
        self.right_glyph: str = right
        self.parent: Optional[UIContainer] = parent
        self.dirty: bool = True

    def set_title(self, title: str) -> None:
        self.title = title
        self.user_data = title
        self.text = title
        self.dirty = True

    def to_ansi_control_sequence_string(self) -> str:
        left_col = self.parent.left_top.column if self.parent else (self.coordinates.column if self.coordinates else 1)
        inner_w = self.parent.inner_width if self.parent else 78

        # Color
        color = self.fg_color
        if color is None:
            if self.parent and hasattr(self.parent, "border_draw_colors") and len(self.parent.border_draw_colors) > 0:
                color = self.parent.border_draw_colors[0]
            else:
                color = ColorLibrary.WINDOW_BORDER_ACTIVE_COLOR

        color_ansi = color.to_ansi_fg() if color else ""

        if self.title:
            vlen = visible_width(self.title)
            rem = max(0, inner_w - vlen - 2)
            lp = rem // 2
            rp = rem - lp
            mid_str = f"{self.fill_glyph * lp} {self.title} {color_ansi}{self.fill_glyph * rp}"
        else:
            mid_str = self.fill_glyph * inner_w

        coord_ansi = ATCoordinates(self.row, left_col).to_ansi()
        return f"{coord_ansi}{color_ansi}{self.left_glyph}{mid_str}{color_ansi}{self.right_glyph}{ATControlSequences.SGR_RESET}"

    def draw(self) -> None:
        if self.dirty:
            from ...terminal.screen import TerminalScreen
            TerminalScreen.write(self.to_ansi_control_sequence_string())
            self.dirty = False
