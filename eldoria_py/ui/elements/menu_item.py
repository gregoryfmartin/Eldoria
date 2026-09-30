"""
UIMenuItem: Granular selectable menu item with symmetric styling and action callback.
"""

from __future__ import annotations
from typing import Callable, Optional, TYPE_CHECKING
from ..base import UIBase
from ...terminal.ansi import ATCoordinates, ATControlSequences, ATDecoration
from ...terminal.box import visible_width
from ...terminal.color import TrueColor, ColorLibrary

if TYPE_CHECKING:
    from ..container import UIContainer


class UIMenuItem(UIBase):
    """
    Granular menu option offering focused/selected chevron styling and action callbacks.
    Employs symmetric character padding so selected and unselected states share identical visual width.
    """

    def __init__(
        self,
        label: str,
        index: int,
        coordinates: Optional[ATCoordinates] = None,
        action: Optional[Callable[[], None]] = None,
        parent: Optional[UIContainer] = None,
        selected: bool = False,
    ) -> None:
        self.label: str = label
        self.index: int = index
        self.action: Optional[Callable[[], None]] = action
        self.parent: Optional[UIContainer] = parent
        self.selected: bool = selected

        # Calculate symmetric formatted strings
        initial_text = self._format_text(selected)
        super().__init__(
            text=initial_text,
            coordinates=coordinates,
            fg_color=ColorLibrary.AppleYellowLight if selected else ColorLibrary.White,
            decorations=ATDecoration(bold=True) if selected else ATDecoration(bold=False),
        )

        if self.parent and self.coordinates:
            self.validate_bounds()

    def _format_text(self, selected: bool) -> str:
        if selected:
            return f"❱   [ {self.index}. {self.label} ]   ❰"
        return f"      {self.index}. {self.label}      "

    def validate_bounds(self) -> None:
        if not self.parent or not self.coordinates:
            return

        vlen = visible_width(self.text)
        if vlen > self.parent.inner_width:
            raise ValueError(
                f"MenuItem '{self.label}' (visible width {vlen}) exceeds parent inner_width ({self.parent.inner_width})"
            )

        row = self.coordinates.row
        col = self.coordinates.column

        if not (self.parent.inner_top <= row <= self.parent.inner_bottom):
            raise ValueError(
                f"MenuItem row {row} is outside parent vertical inner bounds [{self.parent.inner_top}..{self.parent.inner_bottom}]"
            )

        if col < self.parent.inner_left:
            raise ValueError(
                f"MenuItem column {col} starts outside parent inner_left ({self.parent.inner_left})"
            )

        if col + vlen - 1 > self.parent.inner_right:
            exceeded = (col + vlen - 1) - self.parent.inner_right
            raise ValueError(
                f"MenuItem '{self.label}' exceeds parent right border by {exceeded} column(s). Allowed inner_right is {self.parent.inner_right}."
            )

    def set_selected(self, selected: bool) -> None:
        if self.selected != selected:
            self.selected = selected
            self.fg_color = ColorLibrary.AppleYellowLight if selected else ColorLibrary.White
            self.decorations = ATDecoration(bold=True) if selected else ATDecoration(bold=False)
            self.set_user_data(self._format_text(selected))

    def execute(self) -> None:
        if self.action is not None:
            self.action()
