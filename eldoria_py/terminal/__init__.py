"""
Terminal subsystem: ANSI escape codes, TrueColor, input handling, and graphics protocols.
"""

from .ansi import ATControlSequences
from .color import TrueColor, ColorChannel, ColorLibrary, dim_ansi, dim_buffer
from .input import InputManager, KeyEvent, KeyCode
from .screen import TerminalScreen
from .box import (
    strip_ansi,
    char_width,
    str_width,
    visible_width,
    truncate_ansi,
    make_box_row,
    make_border_row,
    clear_buffer_tail,
)

__all__ = [
    "ATControlSequences",
    "TrueColor",
    "ColorChannel",
    "ColorLibrary",
    "dim_ansi",
    "dim_buffer",
    "InputManager",
    "KeyEvent",
    "KeyCode",
    "TerminalScreen",
    "strip_ansi",
    "char_width",
    "str_width",
    "visible_width",
    "truncate_ansi",
    "make_box_row",
    "make_border_row",
    "clear_buffer_tail",
]

