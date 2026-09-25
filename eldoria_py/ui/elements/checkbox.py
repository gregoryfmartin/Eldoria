"""
UICheckbox: Interactive checkbox component with Unicode box characters and focus styling.
"""

from __future__ import annotations
from enum import IntEnum
from typing import Optional
from ..base import UIBase
from ...core.context import Context
from ...core.fsm import SMState
from ...terminal.ansi import ATCoordinates, ATControlSequences, ATDecoration
from ...terminal.color import ColorLibrary
from ...terminal.input import KeyCode


class UICheckboxState(IntEnum):
    UNCHECKED = 0
    CHECKED = 1
    NONE = 2


class UICheckbox(UIBase):
    """
    Renders an interactive checkbox (☐/☑) with label text and focus state.
    """

    UNICODE_BOX_UNCHECKED = "\u2610"
    UNICODE_BOX_CHECKED = "\u2611"

    def __init__(
        self,
        label: str = "",
        coordinates: Optional[ATCoordinates] = None,
    ) -> None:
        super().__init__(text=label, coordinates=coordinates)
        self.state: UICheckboxState = UICheckboxState.UNCHECKED
        self.draw_coordinates: ATCoordinates = coordinates or ATCoordinates(1, 1)
        self.behavior.can_have_focus = True
        self.dirty = True
        self._setup_states()

    def _setup_states(self) -> None:
        def on_inactive(ctx: Context) -> None:
            self.fg_color = ColorLibrary.UICheckboxInactiveColor
            self.dirty = True

        def on_active(ctx: Context) -> None:
            self.fg_color = ColorLibrary.UICheckboxActive
            self.dirty = True

        def on_focus(ctx: Context) -> None:
            self.decorations.italic = True
            self.dirty = True

        def on_unfocus(ctx: Context) -> None:
            self.decorations.italic = False
            self.dirty = True

        self.subscribe({
            "SMUiElementInactive_OnEnter": on_inactive,
            "SMUiElementActive_OnEnter": on_active,
            "SMUiElementFocused_OnEnter": on_focus,
            "SMUiElementFocused_OnExit": on_unfocus,
        })

    def toggle_checkbox(self) -> None:
        if self.state == UICheckboxState.UNCHECKED:
            self.state = UICheckboxState.CHECKED
        elif self.state == UICheckboxState.CHECKED:
            self.state = UICheckboxState.UNCHECKED
        self.dirty = True

    def update(self, context: Context) -> None:
        super().update(context)
        # Check for keyboard toggle when focused
        if len(context.references) > 1 and isinstance(context.references[1], Context):
            orig_ctx = context.references[1]
            keys_pressed = orig_ctx.get(SMState.ContextKeysPressed)
            if self.behavior.has_focus and isinstance(keys_pressed, list) and len(keys_pressed) > 0:
                for key_info in list(keys_pressed):
                    if key_info.key in (KeyCode.SPACE, KeyCode.ENTER):
                        self.toggle_checkbox()
                        keys_pressed.remove(key_info)
                        break

    def to_ansi_control_sequence_string(self) -> str:
        box_char = (
            self.UNICODE_BOX_CHECKED
            if self.state == UICheckboxState.CHECKED
            else self.UNICODE_BOX_UNCHECKED
        )

        if self.state == UICheckboxState.CHECKED:
            box_color = (
                ColorLibrary.UICheckboxChecked
                if self.behavior.active
                else ColorLibrary.UICheckboxInactiveColor
            )
        else:
            box_color = (
                ColorLibrary.TextColor
                if self.behavior.active
                else ColorLibrary.UICheckboxInactiveColor
            )

        if self.behavior.active:
            if self.behavior.can_have_focus and self.behavior.has_focus:
                label_color = ColorLibrary.UICheckboxHasFocus
            else:
                label_color = ColorLibrary.TextColor
        else:
            label_color = ColorLibrary.UICheckboxInactiveColor

        coord_str = self.draw_coordinates.to_ansi()
        dec_str = self.decorations.to_ansi() if self.decorations else ""

        box_part = f"{coord_str}{box_color.to_ansi_fg()}{box_char} {ATControlSequences.SGR_RESET}"
        label_part = f"{dec_str}{label_color.to_ansi_fg()}{self.user_data}{ATControlSequences.SGR_RESET}"

        return f"{box_part}{label_part}"
