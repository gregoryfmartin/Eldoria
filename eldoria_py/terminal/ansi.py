"""
ANSI / VT100 control sequences, cursor positioning, DEC private modes, and text decorations.
"""

from __future__ import annotations
from dataclasses import dataclass
from typing import Optional
from .color import TrueColor


class ATControlSequences:
    """Standard VT100/ANSI escape codes and DEC private mode sequences."""

    ESC = "\033"
    CSI = "\033["

    # Direct 24-bit TrueColor prefixes
    ForegroundColor24Prefix = "\033[38;2;"
    BackgroundColor24Prefix = "\033[48;2;"

    # Text Decorations (SGR)
    DecorationBold = "\033[1m"
    DecorationDim = "\033[2m"
    DecorationItalic = "\033[3m"
    DecorationUnderline = "\033[4m"
    DecorationBlink = "\033[5m"
    DecorationInverse = "\033[7m"
    DecorationStrikethru = "\033[9m"
    ModifierReset = "\033[0m"
    SGR_RESET = ModifierReset


    # DEC Private Modes
    CursorHide = "\033[?25l"
    CursorShow = "\033[?25h"
    AlternateScreenEnable = "\033[?1049h"
    AlternateScreenDisable = "\033[?1049l"

    # DEC Mode 2026: Synchronized Output (Tear-free frame rendering)
    DrawOptimizeOn = "\033[?2026h"
    DrawOptimizeOff = "\033[?2026l"

    # Screen Clears
    ClearScreen = "\033[2J"
    ClearLine = "\033[2K"
    ClearScrollback = "\033[3J"
    CursorHome = "\033[H"
    DeleteAllKittyImages = "\033_Ga=d,d=A\033\\"

    @staticmethod
    def generate_fg24(color: TrueColor) -> str:
        return f"\033[38;2;{color.r};{color.g};{color.b}m"

    @staticmethod
    def generate_bg24(color: TrueColor) -> str:
        return f"\033[48;2;{color.r};{color.g};{color.b}m"

    @staticmethod
    def generate_coordinates(row: int, column: int) -> str:
        """Generates 1-indexed VT cursor positioning sequence (CSI row;col H)."""
        return f"\033[{row};{column}H"


@dataclass
class ATCoordinates:
    """1-indexed terminal coordinates (row, column)."""

    row: int = 1
    column: int = 1

    def to_ansi(self) -> str:
        return ATControlSequences.generate_coordinates(self.row, self.column)

    def offset(self, row_delta: int = 0, col_delta: int = 0) -> ATCoordinates:
        return ATCoordinates(self.row + row_delta, self.column + col_delta)


@dataclass
class ATDecoration:
    """Text styling attributes."""

    bold: bool = False
    italic: bool = False
    underline: bool = False
    blink: bool = False
    strikethru: bool = False

    def to_ansi(self) -> str:
        seqs = []
        if self.bold:
            seqs.append(ATControlSequences.DecorationBold)
        if self.italic:
            seqs.append(ATControlSequences.DecorationItalic)
        if self.underline:
            seqs.append(ATControlSequences.DecorationUnderline)
        if self.blink:
            seqs.append(ATControlSequences.DecorationBlink)
        if self.strikethru:
            seqs.append(ATControlSequences.DecorationStrikethru)
        return "".join(seqs)


class ATString:
    """
    Formatted terminal string composite containing coordinates, colors, decorations, and text.
    """

    def __init__(
        self,
        text: str = "",
        coordinates: Optional[ATCoordinates] = None,
        fg_color: Optional[TrueColor] = None,
        bg_color: Optional[TrueColor] = None,
        decorations: Optional[ATDecoration] = None,
    ) -> None:
        self.text = text
        self.coordinates = coordinates
        self.fg_color = fg_color
        self.bg_color = bg_color
        self.decorations: ATDecoration = decorations if decorations is not None else ATDecoration()

    def render(self) -> str:
        parts = []
        if self.coordinates:
            parts.append(self.coordinates.to_ansi())
        dec_ansi = self.decorations.to_ansi()
        if dec_ansi:
            parts.append(dec_ansi)
        if self.fg_color:
            parts.append(self.fg_color.to_fg_ansi())
        if self.bg_color:
            parts.append(self.bg_color.to_bg_ansi())

        parts.append(self.text)

        # Reset formatting if any formatting was applied
        if dec_ansi or self.fg_color or self.bg_color:
            parts.append(ATControlSequences.ModifierReset)

        return "".join(parts)

