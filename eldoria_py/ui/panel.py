"""
UIPanel: Container specialized to house child UI elements with circular Tab-focus navigation.
"""

from __future__ import annotations
from typing import Dict, List, Optional
from .base import UIBase
from .container import UIContainer
from ..core.context import Context
from ..core.fsm import SMState
from ..terminal.ansi import ATCoordinates
from ..terminal.input import ConsoleKeyInfo, KeyCode


class UIPanel(UIContainer):
    """
    Houses UI elements and manages circular Tab focus cycling across child components.
    """

    def __init__(
        self,
        left_top: Optional[ATCoordinates] = None,
        right_bottom: Optional[ATCoordinates] = None,
        title: str = "",
        ui_element_listing: Optional[Dict[int, UIBase]] = None,
    ) -> None:
        super().__init__(left_top, right_bottom, title)
        self.active_index: int = 0
        self.ui_element_listing: Dict[int, UIBase] = ui_element_listing if ui_element_listing is not None else {}
        self._initialize_tab_focus_handling()

    def _initialize_tab_focus_handling(self) -> None:
        def on_tab_check(context: Context) -> None:
            # Context references: [0]: UIPanel (Self), [1]: OriginalContext
            if len(context.references) > 1 and isinstance(context.references[1], Context):
                orig_ctx = context.references[1]
                keys_pressed = orig_ctx.get(SMState.ContextKeysPressed)
                if isinstance(keys_pressed, list) and len(keys_pressed) > 0:
                    tab_key: Optional[ConsoleKeyInfo] = None
                    for key in keys_pressed:
                        if key.key == KeyCode.TAB:
                            tab_key = key
                            break
                    if tab_key is not None:
                        self.cycle_focus(orig_ctx)
                        if tab_key in keys_pressed:
                            keys_pressed.remove(tab_key)

        self.subscribe({
            "SMUiElementFocused_OnUpdate": on_tab_check,
            "SMUiElementActive_OnUpdate": on_tab_check,
        })

    def cycle_focus(self, original_context: Optional[Context] = None) -> None:
        """Cycles active focus to the next child element in index order."""
        if not self.ui_element_listing:
            return

        sorted_keys = sorted(self.ui_element_listing.keys())
        try:
            current_pos = sorted_keys.index(self.active_index)
        except ValueError:
            current_pos = -1

        next_pos = (current_pos + 1) % len(sorted_keys)
        self.active_index = sorted_keys[next_pos]

        for key, element in self.ui_element_listing.items():
            elem_ctx = Context([element, original_context])
            if key == self.active_index:
                element.focus(elem_ctx)
            else:
                element.unfocus(elem_ctx)

    def update(self, context: Context) -> None:
        super().update(context)
        if self.active:
            for element in self.ui_element_listing.values():
                element.update(Context([element, context]))

    def draw(self) -> None:
        super().draw()
        if self.active:
            for element in self.ui_element_listing.values():
                element.draw()

    def activate(self, context: Optional[Context] = None) -> bool:
        res = super().activate(context)
        for element in self.ui_element_listing.values():
            element.activate(Context([element, context]))
        return res

    def deactivate(self, context: Optional[Context] = None) -> bool:
        res = super().deactivate(context)
        for element in self.ui_element_listing.values():
            element.deactivate(Context([element, context]))
        return res
