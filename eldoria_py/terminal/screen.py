"""
Terminal screen buffer manager, alternate screen buffer handling, and synchronized frame rendering.
"""

from __future__ import annotations
import atexit
import shutil
import sys
from typing import Tuple
from .ansi import ATControlSequences, ATCoordinates


class TerminalScreen:
    """Manages full-screen terminal operations, buffer clearing, and atomic synchronized rendering."""

    _initialized: bool = False

    @classmethod
    def enter(cls) -> None:
        """Enters alternate screen buffer and hides cursor."""
        if cls._initialized:
            return
        cls._initialized = True
        sys.stdout.write(
            ATControlSequences.AlternateScreenEnable
            + ATControlSequences.CursorHide
            + ATControlSequences.ClearScreen
            + ATControlSequences.CursorHome
        )
        sys.stdout.flush()
        atexit.register(cls.exit)

    @classmethod
    def exit(cls) -> None:
        """Restores main screen buffer and makes cursor visible."""
        if not cls._initialized:
            return
        cls._initialized = False
        sys.stdout.write(
            ATControlSequences.CursorShow
            + ATControlSequences.AlternateScreenDisable
            + ATControlSequences.ModifierReset
        )
        sys.stdout.flush()

    @staticmethod
    def get_size() -> Tuple[int, int]:
        """Returns terminal dimensions as (columns, rows)."""
        size = shutil.get_terminal_size((90, 40))
        return size.columns, size.lines

    @staticmethod
    def clear_screen() -> None:
        sys.stdout.write(
            ATControlSequences.DrawOptimizeOff
            + ATControlSequences.ModifierReset
            + ATControlSequences.ClearScreen
            + ATControlSequences.ClearScrollback
            + ATControlSequences.CursorHome
            + ATControlSequences.DeleteAllKittyImages
        )
        sys.stdout.flush()

    clear = clear_screen

    @staticmethod
    def clear_area(top: int, left: int, width: int, height: int) -> None:
        """Clears a specific rectangular region of the screen with spaces."""
        space_str = " " * width
        output = []
        for row in range(top, top + height):
            output.append(ATControlSequences.generate_coordinates(row, left))
            output.append(space_str)
        sys.stdout.write("".join(output))

    @staticmethod
    def write(text: str) -> None:
        sys.stdout.write(text)

    @staticmethod
    def flush() -> None:
        sys.stdout.flush()

    @classmethod
    def frame(cls, content: str) -> None:
        """
        Renders a complete frame using DEC Mode 2026 Synchronized Output for atomic, tear-free rendering.
        """
        sys.stdout.write(
            ATControlSequences.DrawOptimizeOn
            + content
            + ATControlSequences.DrawOptimizeOff
        )
        sys.stdout.flush()
