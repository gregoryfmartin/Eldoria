"""
UIDialFaceplate and UIDialFaceplateDigit: Dial display elements.
"""

from __future__ import annotations
from typing import Optional
from ..base import UIBase
from ...terminal.ansi import ATCoordinates
from ...terminal.color import TrueColor


class UIDialFaceplate(UIBase):
    """Displays the numbers of a dial faceplate (1 to 4 digits)."""
    pass


class UIDialFaceplateDigit(UIBase):
    """Displays a single digit on a dial faceplate."""
    pass
