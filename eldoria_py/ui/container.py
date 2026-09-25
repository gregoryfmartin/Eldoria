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
    ) -> None:
        super().__init__()
        self.left_top: ATCoordinates = left_top or ATCoordinates(1, 1)
        self.right_bottom: ATCoordinates = right_bottom or ATCoordinates(1, 1)
        self.width: int = 0
        self.height: int = 0

        self.use_title: bool = False
        self.title_dirty: bool = False
        self.complex_title: bool = False
        self.title: str = title
        self.title_color: TrueColor = ColorLibrary.TEXT_COLOR

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

    def setup_title(self, title: str, color: Optional[TrueColor] = None) -> None:
        self.use_title = True
        self.title_dirty = True
        self.title = title
        self.title_color = color if color is not None else ColorLibrary.TEXT_COLOR

    def set_all_dirty(self) -> None:
        self.border_draw_dirty = [True, True, True, True]
        if self.use_title:
            self.title_dirty = True

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
        """Renders dirty border pieces and title to TerminalScreen."""
        buf: List[str] = []

        # Top border
        if self.border_draw_dirty[WindowBorderPartDirty.TOP]:
            top_str = (
                self.left_top.to_ansi()
                + self.border_draw_colors[WindowBorderPart.LEFT_TOP].to_ansi_fg()
                + self.current_window_designs[WindowBorderPart.LEFT_TOP]
                + self.border_draw_colors[WindowBorderPart.TOP].to_ansi_fg()
                + (self.current_window_designs[WindowBorderPart.TOP] * max(0, self.width - 1))
                + self.border_draw_colors[WindowBorderPart.RIGHT_TOP].to_ansi_fg()
                + self.current_window_designs[WindowBorderPart.RIGHT_TOP]
                + ATControlSequences.SGR_RESET
            )
            buf.append(top_str)
            self.border_draw_dirty[WindowBorderPartDirty.TOP] = False

        # Bottom border
        if self.border_draw_dirty[WindowBorderPartDirty.BOTTOM]:
            bottom_left_coord = ATCoordinates(self.right_bottom.row, self.left_top.column)
            bottom_str = (
                bottom_left_coord.to_ansi()
                + self.border_draw_colors[WindowBorderPart.LEFT_BOTTOM].to_ansi_fg()
                + self.current_window_designs[WindowBorderPart.LEFT_BOTTOM]
                + self.border_draw_colors[WindowBorderPart.BOTTOM].to_ansi_fg()
                + (self.current_window_designs[WindowBorderPart.BOTTOM] * max(0, self.width - 1))
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

        # Title
        if self.use_title and self.title_dirty:
            title_coord = ATCoordinates(self.left_top.row, self.left_top.column + 2)
            title_str = (
                title_coord.to_ansi()
                + self.title_color.to_ansi_fg()
                + f" {self.title} "
                + ATControlSequences.SGR_RESET
            )
            buf.append(title_str)
            self.title_dirty = False

        if buf:
            TerminalScreen.write("".join(buf))
