"""
UIStatBar: 3-stage colored health, mana, and progress bar component for Eldoria.
Based on the legacy Eldoria specifications from BattleEntityProperty.ps1 and StatNumberState.ps1:
- Normal (ratio > 0.60): AppleGreenLight
- Caution (0.30 < ratio <= 0.60): AppleYellowLight
- Danger (ratio <= 0.30): AppleRedLight
- Mana: AppleCyanLight
- Empty segments and brackets: DarkGrey
"""

from __future__ import annotations
from enum import Enum
from typing import Optional, TYPE_CHECKING, Union

from ..base import UIBase
from ...terminal.ansi import ATCoordinates, ATDecoration
from ...terminal.color import ColorLibrary, TrueColor
from ...terminal.box import visible_width

if TYPE_CHECKING:
    from ..container import UIContainer


class StatNumberState(str, Enum):
    """Health/stat number tolerance state matching legacy Eldoria."""
    NORMAL = "Normal"
    CAUTION = "Caution"
    DANGER = "Danger"


class StatBarType(str, Enum):
    """Bar classification determining color stage behavior."""
    HEALTH = "Health"
    MANA = "Mana"
    CUSTOM = "Custom"


class UIStatBar(UIBase):
    """
    Progress/stat bar component rendering segmented gauges with colored stage indicators.
    Can be used as a standalone string formatter or registered as a child component inside UIPanel.
    """

    # Legacy Eldoria thresholds
    THRESHOLD_CAUTION: float = 0.6
    THRESHOLD_DANGER: float = 0.3

    # Colors
    COLOR_NORMAL: TrueColor = ColorLibrary.AppleGreenLight
    COLOR_CAUTION: TrueColor = ColorLibrary.AppleYellowLight
    COLOR_DANGER: TrueColor = ColorLibrary.AppleRedLight
    COLOR_MANA: TrueColor = ColorLibrary.AppleCyanLight
    COLOR_EMPTY: TrueColor = ColorLibrary.DarkGrey
    COLOR_BRACKET: TrueColor = ColorLibrary.DarkGrey

    # Glyphs
    CHAR_FILL: str = "█"
    CHAR_EMPTY: str = "░"
    CHAR_BRACKET_LEFT: str = "["
    CHAR_BRACKET_RIGHT: str = "]"

    def __init__(
        self,
        current_value: int = 0,
        max_value: int = 0,
        length: int = 8,
        bar_type: Union[StatBarType, str] = StatBarType.HEALTH,
        coordinates: Optional[ATCoordinates] = None,
        decorations: Optional[ATDecoration] = None,
        parent: Optional[UIContainer] = None,
    ) -> None:
        self.current_value: int = current_value
        self.max_value: int = max_value
        self.length: int = length
        self.bar_type: StatBarType = (
            bar_type if isinstance(bar_type, StatBarType) else StatBarType(bar_type.capitalize())
        )
        self.parent: Optional[UIContainer] = parent

        formatted = self.format_bar(
            current=self.current_value,
            maximum=self.max_value,
            length=self.length,
            bar_type=self.bar_type,
        )
        super().__init__(
            text=formatted,
            coordinates=coordinates,
            decorations=decorations,
        )

        vlen = visible_width(self.text)
        if self.parent and self.coordinates:
            max_avail = max(0, self.parent.inner_right - self.coordinates.column + 1)
            self.set_blank_size(min(vlen, max_avail))
            self.validate_bounds()
        else:
            self.set_blank_size(vlen)

    @property
    def stage(self) -> StatNumberState:
        """Returns the current tolerance stage of the bar."""
        return self.get_stage(self.current_value, self.max_value)

    @classmethod
    def get_stage(cls, current: int, maximum: int) -> StatNumberState:
        """Computes the legacy 3-stage tolerance state."""
        if maximum <= 0:
            return StatNumberState.DANGER
        ratio = current / maximum
        if ratio > cls.THRESHOLD_CAUTION:
            return StatNumberState.NORMAL
        elif ratio > cls.THRESHOLD_DANGER:
            return StatNumberState.CAUTION
        else:
            return StatNumberState.DANGER

    @classmethod
    def format_bar(
        cls,
        current: int,
        maximum: int,
        length: int = 8,
        bar_type: Union[StatBarType, str] = StatBarType.HEALTH,
        custom_color: Optional[TrueColor] = None,
    ) -> str:
        """
        Builds a colored bracketed bar string (e.g. [████░░░░]) with ANSI true color codes.
        Visible length is always length + 2 (the brackets).
        """
        if maximum <= 0:
            pct = 0.0
        else:
            pct = max(0.0, min(1.0, current / maximum))

        fill_len = int(round(pct * length))
        empty_len = max(0, length - fill_len)

        # Normalize bar type
        b_type = (
            bar_type if isinstance(bar_type, StatBarType) else StatBarType(str(bar_type).capitalize())
        )

        # Determine fill color
        if b_type == StatBarType.HEALTH:
            st = cls.get_stage(current, maximum)
            if st == StatNumberState.NORMAL:
                fill_col = cls.COLOR_NORMAL
            elif st == StatNumberState.CAUTION:
                fill_col = cls.COLOR_CAUTION
            else:
                fill_col = cls.COLOR_DANGER
        elif b_type == StatBarType.MANA:
            fill_col = cls.COLOR_MANA
        else:
            fill_col = custom_color or cls.COLOR_NORMAL

        b_color = cls.COLOR_BRACKET.to_ansi_fg()
        e_color = cls.COLOR_EMPTY.to_ansi_fg()
        f_color = fill_col.to_ansi_fg()
        reset = "\033[0m"

        return (
            f"{b_color}{cls.CHAR_BRACKET_LEFT}"
            f"{f_color}{cls.CHAR_FILL * fill_len}"
            f"{e_color}{cls.CHAR_EMPTY * empty_len}"
            f"{b_color}{cls.CHAR_BRACKET_RIGHT}"
            f"{reset}"
        )

    def set_values(self, current: int, maximum: int) -> None:
        """Updates numeric values, re-formats display text, and marks component dirty."""
        self.current_value = current
        self.max_value = maximum
        formatted = self.format_bar(
            current=self.current_value,
            maximum=self.max_value,
            length=self.length,
            bar_type=self.bar_type,
        )
        self.set_user_data(formatted)

    def validate_bounds(self) -> None:
        """Validates that the bar's visible width fits within parent container bounds."""
        if not self.parent or not self.coordinates:
            return

        vlen = visible_width(self.text)
        if vlen > self.parent.inner_width:
            raise ValueError(
                f"Stat bar (visible width {vlen}) exceeds parent container inner_width ({self.parent.inner_width})"
            )

        row = self.coordinates.row
        col = self.coordinates.column

        if not (self.parent.inner_top <= row <= self.parent.inner_bottom):
            raise ValueError(
                f"Stat bar row {row} is outside parent container vertical inner bounds [{self.parent.inner_top}..{self.parent.inner_bottom}]"
            )

        if col < self.parent.inner_left:
            raise ValueError(
                f"Stat bar column {col} starts outside parent inner_left ({self.parent.inner_left})"
            )
        if col + vlen - 1 > self.parent.inner_right:
            exceeded = (col + vlen - 1) - self.parent.inner_right
            raise ValueError(
                f"Stat bar exceeds parent right border by {exceeded} column(s). Allowed inner_right is {self.parent.inner_right}."
            )
