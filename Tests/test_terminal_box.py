"""
Unit tests for eldoria_py/terminal/box.py
Validates ANSI-safe line measurement, safe truncation, box formatting, and 80-column compliance.
"""

import unittest
from eldoria_py.terminal.box import (
    strip_ansi,
    truncate_ansi,
    make_box_row,
    make_border_row,
    clear_buffer_tail,
)


class TestTerminalBox(unittest.TestCase):
    """Test suite for terminal box formatting and ANSI string handling."""

    def test_strip_ansi(self):
        colored = "\033[1;33mBold Yellow\033[0m \033[38;2;255;100;50mRGB Color\033[0m"
        self.assertEqual(strip_ansi(colored), "Bold Yellow RGB Color")
        self.assertEqual(strip_ansi(""), "")
        self.assertEqual(strip_ansi("Plain text"), "Plain text")

    def test_truncate_ansi_preserves_codes(self):
        text = "\033[1;32mGreen\033[0m \033[34mBlueberry\033[0m"
        # Visible text: "Green Blueberry" (15 chars)
        truncated = truncate_ansi(text, 10)
        self.assertEqual(len(strip_ansi(truncated)), 10)
        self.assertEqual(strip_ansi(truncated), "Green Blue")
        self.assertTrue(truncated.endswith("\033[0m"))

    def test_truncate_ansi_with_ellipsis(self):
        text = "\033[1;37mLong character title\033[0m"
        truncated = truncate_ansi(text, 12, ellipsis="…")
        self.assertEqual(len(strip_ansi(truncated)), 12)
        self.assertEqual(strip_ansi(truncated), "Long charac…")

    def test_make_border_row_exact_widths(self):
        for width in (54, 80):
            top = make_border_row("Title", width=width, left="╭", fill="─", right="╮")
            sep = make_border_row("", width=width, left="├", fill="─", right="┤")
            bot = make_border_row("Footer", width=width, left="╰", fill="─", right="╯")

            self.assertEqual(len(strip_ansi(top)), width)
            self.assertEqual(len(strip_ansi(sep)), width)
            self.assertEqual(len(strip_ansi(bot)), width)
            self.assertTrue(top.startswith("╭"))
            self.assertTrue(top.endswith("╮\033[K"))

    def test_make_box_row_exact_widths_with_ansi(self):
        for width in (54, 80):
            colored_content = "\033[1;33m★ Leader\033[0m \033[1;32mAiden\033[0m (HP: \033[36m290\033[0m)"
            row = make_box_row(colored_content, width=width)
            self.assertEqual(len(strip_ansi(row)), width)
            self.assertTrue(row.startswith("│ "))
            self.assertTrue(row.endswith(" │\033[K"))

    def test_make_box_row_overflow_protection(self):
        # Even if content is longer than the inner width, row is strictly constrained to width
        width = 80
        inner_width = 80 - 4  # 76
        super_long = "X" * 120
        row = make_box_row(super_long, width=width)
        self.assertEqual(len(strip_ansi(row)), width)

    def test_clear_buffer_tail(self):
        tail = clear_buffer_tail(25, 27)
        expected = "\033[25;1H\033[2K\033[26;1H\033[2K\033[27;1H\033[2K"
        self.assertEqual(tail, expected)

    def test_char_width_and_visible_width(self):
        from eldoria_py.terminal.box import char_width, visible_width

        # ASCII characters: width 1
        self.assertEqual(char_width("A"), 1)
        self.assertEqual(char_width(" "), 1)

        # Standard symbols: width 1
        self.assertEqual(char_width("◄"), 1)
        self.assertEqual(char_width("►"), 1)
        self.assertEqual(char_width("★"), 1)

        # Wide emojis / pictographs: width 2
        self.assertEqual(char_width("🏹"), 2)
        self.assertEqual(char_width("🔮"), 2)
        self.assertEqual(char_width("🪓"), 2)
        self.assertEqual(char_width("⚡"), 2)

        # Visible width with ANSI styling and wide characters
        # "Wilds Ranger 🏹" = 12 (ascii) + 1 (space) + 2 (bow) = 15 visible columns
        colored_ranger = "\033[1;32mWilds Ranger\033[0m \033[33m🏹\033[0m"
        self.assertEqual(visible_width(colored_ranger), 15)

    def test_make_box_row_with_wide_characters_preserves_right_pane(self):
        from eldoria_py.terminal.box import visible_width

        # Row containing wide characters like Wilds Ranger 🏹
        content = "   [◄]   │    🏹     │   [►]   Wilds Ranger  [5/6]"
        for width in (54, 80):
            row = make_box_row(content, width=width)
            self.assertEqual(visible_width(row), width)
            self.assertTrue(row.endswith(" │\033[K"))

    def test_truncate_ansi_with_wide_characters(self):
        from eldoria_py.terminal.box import visible_width

        # "Hero 🏹 Ranger" = 5 (Hero ) + 2 (🏹) + 7 ( Ranger) = 14 cols
        text = "Hero 🏹 Ranger"
        # Truncating to 6 should only include "Hero " (5 cols), not half of 🏹
        t6 = truncate_ansi(text, 6)
        self.assertEqual(visible_width(t6), 5)
        self.assertEqual(strip_ansi(t6), "Hero ")

        # Truncating to 7 can include the full 🏹 (7 cols)
        t7 = truncate_ansi(text, 7)
        self.assertEqual(visible_width(t7), 7)
        self.assertEqual(strip_ansi(t7), "Hero 🏹")


if __name__ == "__main__":
    unittest.main()
