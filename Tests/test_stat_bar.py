"""
Unit and regression tests for UIStatBar, StatNumberState, and elemental Unicode badges.
Verifies:
1. 3-stage colored health bar threshold calculation (Normal > 60%, Caution 30%-60%, Danger <= 30%).
2. ANSI true color sequences for Normal (AppleGreenLight), Caution (AppleYellowLight), Danger (AppleRedLight), and Mana (AppleCyanLight).
3. Exact visible width preservation across all bar lengths.
4. UIStatBar lifecycle and integration within UIPanel.
5. Elemental affinity Unicode glyphs and badge formatting.
"""

import unittest
from eldoria_py.ui.elements.stat_bar import UIStatBar, StatNumberState, StatBarType
from eldoria_py.ui.panel import UIPanel
from eldoria_py.terminal.ansi import ATCoordinates
from eldoria_py.terminal.color import ColorLibrary
from eldoria_py.terminal.box import visible_width, strip_ansi
from eldoria_py.combat.stats import (
    BattleActionType,
    ELEMENT_AFFINITIES,
    get_element_info,
    get_element_glyph,
    format_element_badge,
)


class TestStatBar(unittest.TestCase):
    def test_stage_threshold_logic(self):
        """Verifies Normal > 0.6, Caution 0.3 < ratio <= 0.6, Danger <= 0.3."""
        # 100 max HP
        self.assertEqual(UIStatBar.get_stage(100, 100), StatNumberState.NORMAL)
        self.assertEqual(UIStatBar.get_stage(61, 100), StatNumberState.NORMAL)
        self.assertEqual(UIStatBar.get_stage(60, 100), StatNumberState.CAUTION)
        self.assertEqual(UIStatBar.get_stage(31, 100), StatNumberState.CAUTION)
        self.assertEqual(UIStatBar.get_stage(30, 100), StatNumberState.DANGER)
        self.assertEqual(UIStatBar.get_stage(1, 100), StatNumberState.DANGER)
        self.assertEqual(UIStatBar.get_stage(0, 100), StatNumberState.DANGER)

        # Edge cases
        self.assertEqual(UIStatBar.get_stage(-5, 100), StatNumberState.DANGER)
        self.assertEqual(UIStatBar.get_stage(50, 0), StatNumberState.DANGER)
        self.assertEqual(UIStatBar.get_stage(50, -10), StatNumberState.DANGER)

    def test_color_stages(self):
        """Verifies correct true color escape codes are applied for each stage."""
        green_fg = ColorLibrary.AppleGreenLight.to_ansi_fg()
        yellow_fg = ColorLibrary.AppleYellowLight.to_ansi_fg()
        red_fg = ColorLibrary.AppleRedLight.to_ansi_fg()
        cyan_fg = ColorLibrary.AppleCyanLight.to_ansi_fg()
        grey_fg = ColorLibrary.DarkGrey.to_ansi_fg()

        # Normal (Green)
        normal_bar = UIStatBar.format_bar(80, 100, length=8, bar_type=StatBarType.HEALTH)
        self.assertIn(green_fg, normal_bar)
        self.assertNotIn(yellow_fg, normal_bar)
        self.assertNotIn(red_fg, normal_bar)
        self.assertIn(grey_fg, normal_bar)

        # Caution (Yellow)
        caution_bar = UIStatBar.format_bar(50, 100, length=8, bar_type=StatBarType.HEALTH)
        self.assertIn(yellow_fg, caution_bar)
        self.assertNotIn(green_fg, caution_bar)
        self.assertNotIn(red_fg, caution_bar)

        # Danger (Red)
        danger_bar = UIStatBar.format_bar(20, 100, length=8, bar_type=StatBarType.HEALTH)
        self.assertIn(red_fg, danger_bar)
        self.assertNotIn(green_fg, danger_bar)
        self.assertNotIn(yellow_fg, danger_bar)

        # Mana (Cyan)
        mana_bar = UIStatBar.format_bar(100, 100, length=8, bar_type=StatBarType.MANA)
        self.assertIn(cyan_fg, mana_bar)
        self.assertNotIn(green_fg, mana_bar)

    def test_segment_counts_and_visible_widths(self):
        """Verifies visible width == length + 2 and exact fill / empty character proportions."""
        for length in (4, 8, 10, 20):
            # 100% full
            bar_full = UIStatBar.format_bar(100, 100, length=length)
            stripped_full = strip_ansi(bar_full)
            self.assertEqual(visible_width(bar_full), length + 2)
            self.assertEqual(stripped_full, f"[{'█' * length}]")

            # 50% full
            bar_half = UIStatBar.format_bar(50, 100, length=length)
            stripped_half = strip_ansi(bar_half)
            half_fill = length // 2
            half_empty = length - half_fill
            self.assertEqual(visible_width(bar_half), length + 2)
            self.assertEqual(stripped_half, f"[{'█' * half_fill}{'░' * half_empty}]")

            # 0% full
            bar_empty = UIStatBar.format_bar(0, 100, length=length)
            stripped_empty = strip_ansi(bar_empty)
            self.assertEqual(visible_width(bar_empty), length + 2)
            self.assertEqual(stripped_empty, f"[{'░' * length}]")

    def test_ui_stat_bar_in_panel_component(self):
        """Verifies UIStatBar instantiation, panel child registration, and bounds validation."""
        panel = UIPanel(
            left_top=ATCoordinates(1, 1),
            right_bottom=ATCoordinates(10, 30),
            has_border=True,
        )
        # Inner width is 28 (30 - 1 - 1)
        bar = panel.add_stat_bar(
            current_value=85,
            max_value=100,
            row=3,
            col=5,
            length=10,
            bar_type=StatBarType.HEALTH,
        )
        self.assertIsInstance(bar, UIStatBar)
        self.assertEqual(bar.stage, StatNumberState.NORMAL)
        self.assertEqual(visible_width(bar.text), 12)
        self.assertIn(0, panel.ui_element_listing)

        # Update values
        bar.set_values(25, 100)
        self.assertEqual(bar.stage, StatNumberState.DANGER)
        self.assertIn(ColorLibrary.AppleRedLight.to_ansi_fg(), bar.text)

        # Verify bounds violation raises ValueError
        with self.assertRaises(ValueError):
            panel.add_stat_bar(
                current_value=50,
                max_value=100,
                row=3,
                col=5,
                length=30,  # 32 visible width > 28 inner width
            )

    def test_elemental_affinities_and_unicode_glyphs(self):
        """Verifies that all elemental affinities map to their correct Unicode glyphs and colors."""
        expected_glyphs = {
            BattleActionType.ELEMENTAL_FIRE: ("Fire", "♨", ColorLibrary.AppleRedLight),
            BattleActionType.ELEMENTAL_WATER: ("Water", "≈", ColorLibrary.AppleBlueLight),
            BattleActionType.ELEMENTAL_EARTH: ("Earth", "▲", ColorLibrary.AppleOrangeLight),
            BattleActionType.ELEMENTAL_WIND: ("Wind", "≋", ColorLibrary.AppleGreenLight),
            BattleActionType.ELEMENTAL_LIGHT: ("Light", "✦", ColorLibrary.AppleYellowLight),
            BattleActionType.ELEMENTAL_DARK: ("Dark", "◆", ColorLibrary.ApplePurpleLight),
            BattleActionType.ELEMENTAL_ICE: ("Ice", "❄", ColorLibrary.AppleTealLight),
        }

        for aff, (name, glyph, color) in expected_glyphs.items():
            info = get_element_info(aff)
            self.assertIsNotNone(info)
            self.assertEqual(info.name, name)
            self.assertEqual(info.glyph, glyph)
            self.assertEqual(info.color, color)

            self.assertEqual(get_element_glyph(aff), glyph)

            badge = format_element_badge(aff)
            clean_badge = strip_ansi(badge)
            self.assertEqual(clean_badge, f"{glyph} {name}")
            self.assertIn(color.to_ansi_fg(), badge)
            self.assertEqual(visible_width(clean_badge), 1 + 1 + len(name))


if __name__ == "__main__":
    unittest.main()
