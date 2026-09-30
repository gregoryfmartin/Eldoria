"""
UICharacterStatusSummaryPanel: Character summary panel matching New New Engine specification.
"""

from __future__ import annotations
from typing import Optional
from ..panel import UIPanel
from ..elements.checkbox import UICheckbox
from ..elements.chevron import UIChevron, UIChevronOrientation
from ..elements.spinner import UICellSpinner
from ...terminal.ansi import ATCoordinates
from ...terminal.color import ColorLibrary


class UICharacterStatusSummaryPanel(UIPanel):
    """
    Status summary panel housing a checkbox, chevrons, and animated spinners.
    """

    WINDOW_LT_ROW = 1 * 4        # 4
    WINDOW_LT_COLUMN = 1 * 4     # 4
    WINDOW_RB_ROW = 10 * 2       # 20
    WINDOW_RB_COLUMN = 19 * 2    # 38

    def __init__(self) -> None:
        super().__init__(
            left_top=ATCoordinates(self.WINDOW_LT_ROW, self.WINDOW_LT_COLUMN),
            right_bottom=ATCoordinates(self.WINDOW_RB_ROW, self.WINDOW_RB_COLUMN),
            title="Char Name",
        )
        self.update_dimensions()
        self.setup_title("Char Name", ColorLibrary.TextColor)

        # UI elements inside panel
        self.ui_element_listing[0] = UICheckbox(
            "Sample Checkbox Label",
            ATCoordinates(self.WINDOW_LT_ROW + 1, self.WINDOW_LT_COLUMN + 1),  # (5, 5)
        )
        self.ui_element_listing[1] = UIChevron(
            UIChevronOrientation.LEFT,
            ATCoordinates(self.WINDOW_LT_ROW + 2, self.WINDOW_LT_COLUMN + 1),  # (6, 5)
        )
        self.ui_element_listing[2] = UIChevron(
            UIChevronOrientation.RIGHT,
            ATCoordinates(self.WINDOW_LT_ROW + 2, self.WINDOW_LT_COLUMN + 2),  # (6, 6)
        )
        self.ui_element_listing[3] = UICellSpinner(
            fps=5,
            fg_color=ColorLibrary.ApplePinkLight,
            coordinates=ATCoordinates(self.WINDOW_LT_ROW + 3, self.WINDOW_LT_COLUMN + 1),  # (7, 5)
        )
        self.ui_element_listing[4] = UICellSpinner(
            fps=35,
            fg_color=ColorLibrary.AppleMintLight,
            coordinates=ATCoordinates(self.WINDOW_LT_ROW + 4, self.WINDOW_LT_COLUMN + 1),  # (8, 5)
        )
