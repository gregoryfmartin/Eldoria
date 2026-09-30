"""
UIContainer: Window container component with rounded/square borders and title support.
"""

from __future__ import annotations
from enum import IntEnum
from typing import Dict, List, Optional
from .base import UIBase
from ..core.context import Context
from ..terminal.ansi import ATCoordinates, ATString, ATControlSequences
from ..terminal.color import TrueColor, ColorLibrary
from ..terminal.screen import TerminalScreen
from ..terminal.box import visible_width
from .elements.divider import UIDivider


class WindowBorderPart(IntEnum):
    LEFT_TOP = 0
    TOP = 1
    RIGHT_TOP = 2
    RIGHT = 3
    RIGHT_BOTTOM = 4
    BOTTOM = 5
    LEFT_BOTTOM = 6
    LEFT = 7


class WindowBorderPartDirty(IntEnum):
    TOP = 0
    BOTTOM = 1
    LEFT = 2
    RIGHT = 3


class UIContainer(UIBase):
    """
    Renders a framed window/container on the terminal buffer with Unicode borders and optional title.
    """

    WINDOW_DESIGN_ROUNDED: Dict[WindowBorderPart, str] = {
        WindowBorderPart.LEFT_TOP: "╭",
        WindowBorderPart.TOP: "─",
        WindowBorderPart.RIGHT_TOP: "╮",
        WindowBorderPart.LEFT: "│",
        WindowBorderPart.RIGHT: "│",
        WindowBorderPart.LEFT_BOTTOM: "╰",
        WindowBorderPart.BOTTOM: "─",
        WindowBorderPart.RIGHT_BOTTOM: "╯",
    }

    WINDOW_DESIGN_SQUARE: Dict[WindowBorderPart, str] = {
        WindowBorderPart.LEFT_TOP: "┌",
        WindowBorderPart.TOP: "─",
        WindowBorderPart.RIGHT_TOP: "┐",
        WindowBorderPart.LEFT: "│",
        WindowBorderPart.RIGHT: "│",
        WindowBorderPart.LEFT_BOTTOM: "└",
        WindowBorderPart.BOTTOM: "─",
        WindowBorderPart.RIGHT_BOTTOM: "┘",
    }

    def __init__(
        self,
        left_top: Optional[ATCoordinates] = None,
        right_bottom: Optional[ATCoordinates] = None,
        title: str = "",
        has_border: bool = True,
    ) -> None:
        super().__init__()
        self.active: bool = False
        self.has_border: bool = has_border
        self.left_top: ATCoordinates = left_top or ATCoordinates(1, 1)
        self.right_bottom: ATCoordinates = right_bottom or ATCoordinates(1, 1)
        self.width: int = 0
        self.height: int = 0

        self.use_title: bool = False
        self.title_dirty: bool = False
        self.complex_title: bool = False
        self.title: str = title
        self.title_color: TrueColor = ColorLibrary.TEXT_COLOR
        self.title_align: str = "center"

        self.use_footer: bool = False
        self.footer_dirty: bool = False
        self.footer: str = ""
        self.footer_color: TrueColor = ColorLibrary.TEXT_COLOR

        self.dividers: List[UIDivider] = []

        self.current_window_designs: Dict[WindowBorderPart, str] = dict(self.WINDOW_DESIGN_ROUNDED)

        # 8 colors for the 8 border segments
        self.border_draw_colors: List[TrueColor] = [
            ColorLibrary.WINDOW_BORDER_ACTIVE_COLOR for _ in range(8)
        ]
        # 4 dirty flags for Top, Bottom, Left, Right
        self.border_draw_dirty: List[bool] = [True, True, True, True]

        if left_top and right_bottom:
            self.update_dimensions()

        if title:
            self.setup_title(title, ColorLibrary.TEXT_COLOR)

        # Subscribe to FSM active / inactive events
        self.subscribe({
            "SMUiElementActive_OnEnter": self._on_active_enter,
            "SMUiElementInactive_OnEnter": self._on_inactive_enter,
        })

    def _on_active_enter(self, context: Context) -> None:
        self.border_draw_colors = [
            ColorLibrary.WINDOW_BORDER_ACTIVE_COLOR for _ in range(8)
        ]
        self.title_color = ColorLibrary.TEXT_ACTIVE_COLOR
        self.active = True
        self.set_all_dirty()

    def _on_inactive_enter(self, context: Context) -> None:
        self.border_draw_colors = [
            ColorLibrary.WINDOW_BORDER_INACTIVE_COLOR for _ in range(8)
        ]
        self.title_color = ColorLibrary.TEXT_INACTIVE_COLOR
        self.active = False
        self.set_all_dirty()

    def update_dimensions(self) -> None:
        self.width = max(0, self.right_bottom.column - self.left_top.column)
        self.height = max(0, self.right_bottom.row - self.left_top.row)

    @property
    def inner_left(self) -> int:
        return self.left_top.column + 1 if self.has_border else self.left_top.column

    @property
    def inner_right(self) -> int:
        return self.right_bottom.column - 1 if self.has_border else self.right_bottom.column

    @property
    def inner_top(self) -> int:
        return self.left_top.row + 1 if self.has_border else self.left_top.row

    @property
    def inner_bottom(self) -> int:
        return self.right_bottom.row - 1 if self.has_border else self.right_bottom.row

    @property
    def inner_width(self) -> int:
        return max(0, self.inner_right - self.inner_left + 1)

    @property
    def inner_height(self) -> int:
        return max(0, self.inner_bottom - self.inner_top + 1)

    def setup_title(self, title: str, color: Optional[TrueColor] = None, align: str = "center") -> None:
        self.use_title = True
        self.title_dirty = True
        self.title = title
        self.title_color = color if color is not None else ColorLibrary.TEXT_COLOR
        self.title_align = align

    def setup_footer(self, footer: str, color: Optional[TrueColor] = None) -> None:
        self.use_footer = True
        self.footer_dirty = True
        self.footer = footer
        self.footer_color = color if color is not None else ColorLibrary.TEXT_COLOR

    def add_divider(
        self,
        row: int,
        title: str = "",
        left: str = "├",
        fill: str = "─",
        right: str = "┤",
        color: Optional[TrueColor] = None,
    ) -> UIDivider:
        div = UIDivider(row=row, title=title, left=left, fill=fill, right=right, fg_color=color, parent=self)
        self.dividers.append(div)
        return div

    def set_all_dirty(self) -> None:
        self.border_draw_dirty = [True, True, True, True]
        if self.use_title:
            self.title_dirty = True
        if self.use_footer:
            self.footer_dirty = True
        for div in self.dividers:
            div.dirty = True

    def activate(self, context: Optional[Context] = None) -> bool:
        return super().activate(Context([self, context]))

    def deactivate(self, context: Optional[Context] = None) -> bool:
        return super().deactivate(Context([self, context]))

    def update(self, context: Context) -> None:
        super().update(Context([self, context]))

    def toggle_active(self, context: Optional[Context] = None) -> None:
        if self.is_active():
            self.deactivate(context)
        else:
            self.activate(context)

    def set_border_color(self, color: TrueColor) -> None:
        if self.active:
            self.border_draw_colors = [color for _ in range(8)]
            self.set_all_dirty()

    def set_border_colors(self, colors: List[TrueColor]) -> None:
        if self.active and len(colors) >= 8:
            self.border_draw_colors = list(colors[:8])
            self.set_all_dirty()

    def draw(self) -> None:
        """Renders dirty border pieces, title, footer, and dividers to TerminalScreen."""
        buf: List[str] = []

        if self.has_border:
            # Top border
            if self.border_draw_dirty[WindowBorderPartDirty.TOP] or (self.use_title and self.title_dirty):
                top_left_coord = self.left_top.to_ansi()
                corner_left = (
                    self.border_draw_colors[WindowBorderPart.LEFT_TOP].to_ansi_fg()
                    + self.current_window_designs[WindowBorderPart.LEFT_TOP]
                )
                corner_right = (
                    self.border_draw_colors[WindowBorderPart.RIGHT_TOP].to_ansi_fg()
                    + self.current_window_designs[WindowBorderPart.RIGHT_TOP]
                )
                bcolor = self.border_draw_colors[WindowBorderPart.TOP].to_ansi_fg()
                fill_ch = self.current_window_designs[WindowBorderPart.TOP]
                inner_w = max(0, self.width - 1)

                if self.use_title and self.title:
                    clean_title = self.title.strip(" ─-")
                    if clean_title:
                        title_len = visible_width(clean_title)
                        if title_len + 2 <= inner_w:
                            rem = inner_w - (title_len + 2)
                            pad = " "
                        else:
                            rem = max(0, inner_w - title_len)
                            pad = ""

                        if getattr(self, "title_align", "center") == "left":
                            lp = 1 if pad else 0
                            rp = max(0, rem - lp)
                        elif getattr(self, "title_align", "center") == "right":
                            rp = 1 if pad else 0
                            lp = max(0, rem - rp)
                        else:  # "center"
                            lp = rem // 2
                            rp = rem - lp

                        tcolor = self.title_color.to_ansi_fg() if self.title_color else ""
                        mid_str = f"{bcolor}{fill_ch * lp}{pad}{tcolor}{clean_title}{bcolor}{pad}{fill_ch * rp}"
                        self.title_dirty = False
                    else:
                        mid_str = bcolor + (fill_ch * inner_w)
                        self.title_dirty = False
                else:
                    mid_str = bcolor + (fill_ch * inner_w)

                top_str = (
                    top_left_coord
                    + corner_left
                    + mid_str
                    + corner_right
                    + ATControlSequences.SGR_RESET
                )
                buf.append(top_str)
                self.border_draw_dirty[WindowBorderPartDirty.TOP] = False

            # Bottom border
            if self.border_draw_dirty[WindowBorderPartDirty.BOTTOM] or (self.use_footer and self.footer_dirty):
                bottom_left_coord = ATCoordinates(self.right_bottom.row, self.left_top.column)
                bcolor = self.border_draw_colors[WindowBorderPart.BOTTOM].to_ansi_fg()
                fill_ch = self.current_window_designs[WindowBorderPart.BOTTOM]
                inner_w = max(0, self.width - 1)

                if self.use_footer and self.footer:
                    clean_footer = self.footer.strip(" ─-")
                    if clean_footer:
                        footer_len = visible_width(clean_footer)
                        if footer_len + 2 <= inner_w:
                            rem = inner_w - (footer_len + 2)
                            pad = " "
                        else:
                            rem = max(0, inner_w - footer_len)
                            pad = ""

                        lp = rem // 2
                        rp = rem - lp
                        fcolor = self.footer_color.to_ansi_fg() if self.footer_color else ""
                        mid_str = f"{bcolor}{fill_ch * lp}{pad}{fcolor}{clean_footer}{bcolor}{pad}{fill_ch * rp}"
                        self.footer_dirty = False
                    else:
                        mid_str = bcolor + (fill_ch * inner_w)
                        self.footer_dirty = False
                else:
                    mid_str = bcolor + (fill_ch * inner_w)

                bottom_str = (
                    bottom_left_coord.to_ansi()
                    + self.border_draw_colors[WindowBorderPart.LEFT_BOTTOM].to_ansi_fg()
                    + self.current_window_designs[WindowBorderPart.LEFT_BOTTOM]
                    + mid_str
                    + self.border_draw_colors[WindowBorderPart.RIGHT_BOTTOM].to_ansi_fg()
                    + self.current_window_designs[WindowBorderPart.RIGHT_BOTTOM]
                    + ATControlSequences.SGR_RESET
                )
                buf.append(bottom_str)
                self.border_draw_dirty[WindowBorderPartDirty.BOTTOM] = False

            # Left border
            if self.border_draw_dirty[WindowBorderPartDirty.LEFT]:
                left_color = self.border_draw_colors[WindowBorderPart.LEFT].to_ansi_fg()
                left_char = self.current_window_designs[WindowBorderPart.LEFT]
                for r in range(1, self.height):
                    pos = ATCoordinates(self.left_top.row + r, self.left_top.column)
                    buf.append(f"{pos.to_ansi()}{left_color}{left_char}{ATControlSequences.SGR_RESET}")
                self.border_draw_dirty[WindowBorderPartDirty.LEFT] = False

            # Right border
            if self.border_draw_dirty[WindowBorderPartDirty.RIGHT]:
                right_color = self.border_draw_colors[WindowBorderPart.RIGHT].to_ansi_fg()
                right_char = self.current_window_designs[WindowBorderPart.RIGHT]
                for r in range(1, self.height):
                    pos = ATCoordinates(self.left_top.row + r, self.right_bottom.column)
                    buf.append(f"{pos.to_ansi()}{right_color}{right_char}{ATControlSequences.SGR_RESET}")
                self.border_draw_dirty[WindowBorderPartDirty.RIGHT] = False

        if buf:
            TerminalScreen.write("".join(buf))

        # Draw any dividers
        for div in self.dividers:
            div.draw()
