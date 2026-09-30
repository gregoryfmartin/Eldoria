"""
UITextInput: Interactive text entry field element with cursor editing and focus handling.
"""

from __future__ import annotations
from typing import Optional
from ..base import UIBase
from ...core.context import Context
from ...core.fsm import SMState
from ...terminal.ansi import ATCoordinates, ATControlSequences
from ...terminal.color import TrueColor, ColorLibrary
from ...terminal.input import ConsoleKeyInfo, KeyCode


class UITextInput(UIBase):
    """
    Text input field with keyboard focus, character appending, backspace, and cursor display.
    """

    def __init__(
        self,
        placeholder: str = "",
        coordinates: Optional[ATCoordinates] = None,
        max_length: int = 32,
    ) -> None:
        super().__init__(text="", coordinates=coordinates)
        self.placeholder: str = placeholder
        self.max_length: int = max_length
        self.cursor_pos: int = 0
        self.value: str = ""
        self.behavior.can_have_focus = True
        self.dirty = True

    def update(self, context: Context) -> None:
        super().update(context)
        if not self.behavior.has_focus:
            return

        if len(context.references) > 1 and isinstance(context.references[1], Context):
            orig_ctx = context.references[1]
            keys_pressed = orig_ctx.get(SMState.ContextKeysPressed)
            if isinstance(keys_pressed, list) and len(keys_pressed) > 0:
                for key_info in list(keys_pressed):
                    if key_info.key == KeyCode.BACKSPACE:
                        if self.cursor_pos > 0:
                            self.value = self.value[:self.cursor_pos - 1] + self.value[self.cursor_pos:]
                            self.cursor_pos -= 1
                            self.dirty = True
                        keys_pressed.remove(key_info)
                    elif key_info.key == KeyCode.LEFT_ARROW:
                        if self.cursor_pos > 0:
                            self.cursor_pos -= 1
                            self.dirty = True
                        keys_pressed.remove(key_info)
                    elif key_info.key == KeyCode.RIGHT_ARROW:
                        if self.cursor_pos < len(self.value):
                            self.cursor_pos += 1
                            self.dirty = True
                        keys_pressed.remove(key_info)
                    elif key_info.char and len(key_info.char) == 1 and ord(key_info.char) >= 32:
                        if len(self.value) < self.max_length:
                            self.value = (
                                self.value[:self.cursor_pos]
                                + key_info.char
                                + self.value[self.cursor_pos:]
                            )
                            self.cursor_pos += 1
                            self.dirty = True
                        keys_pressed.remove(key_info)

    def to_ansi_control_sequence_string(self) -> str:
        coord_seq = self.coordinates.to_ansi() if self.coordinates else ""
        if self.value:
            display_text = self.value
            color = ColorLibrary.TextActiveColor if self.behavior.active else ColorLibrary.TextInactiveColor
        else:
            display_text = self.placeholder
            color = ColorLibrary.TextInactiveColor

        return f"{coord_seq}{color.to_ansi_fg()}[{display_text}]{ATControlSequences.SGR_RESET}"
