"""
UIMenu: Compound container and coordinator for granular UIMenuItems.
Manages item creation, circular navigation, and action delegation.
"""

from __future__ import annotations
from typing import Callable, List, Optional, TYPE_CHECKING
from ..base import UIBase
from .menu_item import UIMenuItem
from ...core.context import Context
from ...core.fsm import SMState
from ...terminal.ansi import ATCoordinates
from ...terminal.box import visible_width
from ...terminal.input import KeyCode

if TYPE_CHECKING:
    from ..container import UIContainer


class UIMenu(UIBase):
    """
    Manages a list of UIMenuItems, coordinating vertical positioning,
    circular navigation (Up/Down/W/S), number shortcut jumping (1..N),
    and action execution on selection confirmation.
    """

    def __init__(
        self,
        parent: Optional[UIContainer] = None,
        start_row: int = 8,
        row_spacing: int = 2,
        align: str = "center",
    ) -> None:
        super().__init__()
        self.parent: Optional[UIContainer] = parent
        self.start_row: int = start_row
        self.row_spacing: int = row_spacing
        self.align: str = align
        self.items: List[UIMenuItem] = []
        self.selected_index: int = 0

    def add_item(
        self,
        label: str,
        action: Optional[Callable[[], None]] = None,
        row: Optional[int] = None,
        align: Optional[str] = None,
    ) -> UIMenuItem:
        """
        Creates and registers a new UIMenuItem with sequential index and calculated coordinates.
        """
        idx = len(self.items) + 1
        r = row if row is not None else (self.start_row + len(self.items) * self.row_spacing)
        al = align if align is not None else self.align

        # Measure width using standard sample text
        sample_text = f"      {idx}. {label}      "
        vlen = visible_width(sample_text)

        if self.parent:
            if vlen > self.parent.inner_width:
                raise ValueError(
                    f"Menu item '{label}' (visible width {vlen}) exceeds parent inner_width ({self.parent.inner_width})"
                )
            if al == "center":
                col = self.parent.inner_left + (self.parent.inner_width - vlen) // 2
            elif al == "left":
                col = self.parent.inner_left
            elif al == "right":
                col = self.parent.inner_right - vlen + 1
            else:
                raise ValueError(f"Unknown align '{al}'")
        else:
            col = 1

        is_selected = len(self.items) == 0  # First item selected by default
        item = UIMenuItem(
            label=label,
            index=idx,
            coordinates=ATCoordinates(r, col),
            action=action,
            parent=self.parent,
            selected=is_selected,
        )

        self.items.append(item)
        if self.is_active():
            item.activate()

        return item

    def select_next(self) -> None:
        if not self.items:
            return
        old_idx = self.selected_index
        new_idx = (self.selected_index + 1) % len(self.items)
        if old_idx != new_idx:
            self.items[old_idx].set_selected(False)
            self.items[new_idx].set_selected(True)
            self.selected_index = new_idx

    def select_prev(self) -> None:
        if not self.items:
            return
        old_idx = self.selected_index
        new_idx = (self.selected_index - 1) % len(self.items)
        if old_idx != new_idx:
            self.items[old_idx].set_selected(False)
            self.items[new_idx].set_selected(True)
            self.selected_index = new_idx

    def select_index(self, idx: int) -> None:
        if not (0 <= idx < len(self.items)):
            return
        if idx != self.selected_index:
            self.items[self.selected_index].set_selected(False)
            self.items[idx].set_selected(True)
            self.selected_index = idx

    def execute_selected(self) -> None:
        if 0 <= self.selected_index < len(self.items):
            self.items[self.selected_index].execute()

    def handle_input(self, key_info) -> bool:
        """
        Processes menu navigation keys. Returns True if handled.
        """
        if not self.items:
            return False

        if key_info.key == KeyCode.UP:
            self.select_prev()
            return True
        elif key_info.key == KeyCode.DOWN:
            self.select_next()
            return True
        elif key_info.char in [str(i + 1) for i in range(len(self.items))]:
            self.select_index(int(key_info.char) - 1)
            self.execute_selected()
            return True
        elif key_info.key == KeyCode.ENTER or key_info.char in ("\r", "\n"):
            self.execute_selected()
            return True

        return False

    def draw(self) -> None:
        for item in self.items:
            item.draw()

    def set_all_dirty(self) -> None:
        for item in self.items:
            item.dirty = True

    def activate(self, context: Optional[Context] = None) -> bool:
        res = super().activate(context)
        for item in self.items:
            item.activate()
        return res

    def deactivate(self, context: Optional[Context] = None) -> bool:
        res = super().deactivate(context)
        for item in self.items:
            item.deactivate()
        return res
