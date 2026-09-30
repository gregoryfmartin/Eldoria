"""
Janitor subsystem for terminal diagnostics, dimension verification, and environment checks.
"""

from __future__ import annotations
import platform
import shutil
import sys
from typing import Optional
from .context import Context, ContextBroadcaster


class SystemCheckError(Exception):
    """Raised when environment or terminal preconditions are violated."""
    pass


class Janitor:
    """Validates terminal dimensions, Python version, and system requirements."""

    MIN_COLUMNS: int = 90
    MIN_ROWS: int = 40
    MIN_PYTHON_VERSION: tuple = (3, 10)

    def __init__(self) -> None:
        self.os_name: str = platform.system()
        self.python_version: tuple = sys.version_info[:2]

    def perform_system_checks(self, broadcaster: Optional[ContextBroadcaster] = None) -> bool:
        """Verifies Python version and platform support."""
        if self.python_version < self.MIN_PYTHON_VERSION:
            msg = f"Python {self.MIN_PYTHON_VERSION[0]}.{self.MIN_PYTHON_VERSION[1]}+ required. Found {sys.version}."
            if broadcaster:
                broadcaster.broadcast("BadPythonVersion", self, Context([msg]))
            return False
        return True

    def check_buffer_dimensions(self, broadcaster: Optional[ContextBroadcaster] = None) -> bool:
        """Verifies that terminal window size meets the 90x40 minimum."""
        cols, rows = shutil.get_terminal_size((80, 24))
        valid = True

        if cols < self.MIN_COLUMNS:
            valid = False
            if broadcaster:
                broadcaster.broadcast("BufferWidthTooSmall", self, Context([cols, self.MIN_COLUMNS]))

        if rows < self.MIN_ROWS:
            valid = False
            if broadcaster:
                broadcaster.broadcast("BufferHeightTooSmall", self, Context([rows, self.MIN_ROWS]))

        return valid
