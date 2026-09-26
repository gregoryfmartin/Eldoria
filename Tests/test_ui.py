"""
Unit tests for Eldoria UI Component Framework.
"""

import unittest
from eldoria_py.core.context import Context
from eldoria_py.core.fsm import SMState
from eldoria_py.terminal.ansi import ATCoordinates
from eldoria_py.terminal.color import ColorLibrary
from eldoria_py.terminal.input import ConsoleKeyInfo, KeyCode
from eldoria_py.ui.container import UIContainer, WindowBorderPart
from eldoria_py.ui.panel import UIPanel
from eldoria_py.ui.elements.divider import UIDivider
from eldoria_py.ui.elements.menu_item import UIMenuItem
from eldoria_py.ui.elements.menu import UIMenu
from eldoria_py.ui.elements.checkbox import UICheckbox, UICheckboxState
from eldoria_py.ui.elements.spinner import UICellSpinner
from eldoria_py.ui.elements.chevron import UIChevron, UIChevronOrientation
from eldoria_py.ui.elements.text_input import UITextInput
from eldoria_py.ui.panels.char_status import UICharacterStatusSummaryPanel
from eldoria_py.states.test_ui import GSUiTestScreen


class TestUIFramework(unittest.TestCase):
    def test_ui_container_dimensions_and_title(self):
        container = UIContainer(
            left_top=ATCoordinates(4, 4),
            right_bottom=ATCoordinates(20, 38),
            title="Test Container",
        )
        self.assertEqual(container.width, 34)
        self.assertEqual(container.height, 16)
        self.assertTrue(container.use_title)
        self.assertEqual(container.title, "Test Container")
        self.assertTrue(container.border_draw_dirty[0])

    def test_ui_container_activate_deactivate(self):
        container = UIContainer(
            left_top=ATCoordinates(1, 1),
            right_bottom=ATCoordinates(10, 20),
        )
        self.assertFalse(container.is_active())

        container.activate()
        self.assertTrue(container.is_active())
        self.assertEqual(container.border_draw_colors[0], ColorLibrary.WindowBorderActiveColor)

        container.deactivate()
        self.assertFalse(container.is_active())
        self.assertEqual(container.border_draw_colors[0], ColorLibrary.WindowBorderInactiveColor)

    def test_ui_panel_tab_focus_cycle(self):
        elem0 = UICheckbox("Option 0", ATCoordinates(1, 1))
        elem1 = UICheckbox("Option 1", ATCoordinates(2, 1))
        elem2 = UICheckbox("Option 2", ATCoordinates(3, 1))

        panel = UIPanel(
            left_top=ATCoordinates(1, 1),
            right_bottom=ATCoordinates(10, 20),
            ui_element_listing={0: elem0, 1: elem1, 2: elem2},
        )
        panel.activate()

        # Initial active index is 0
        self.assertEqual(panel.active_index, 0)

        # Create context with a Tab key press
        tab_key = ConsoleKeyInfo(key=KeyCode.TAB, char="\t")
        keys = [tab_key]
        ctx = Context([0.016, keys, None])

        # Update panel - Tab key should be intercepted and consumed
        panel.update(ctx)

        # Active index should now be 1
        self.assertEqual(panel.active_index, 1)
        self.assertEqual(len(keys), 0)  # Tab key consumed!
        self.assertFalse(elem0.is_focused())
        self.assertTrue(elem1.is_focused())
        self.assertFalse(elem2.is_focused())

        # Second Tab key press
        keys.append(ConsoleKeyInfo(key=KeyCode.TAB, char="\t"))
        panel.update(ctx)
        self.assertEqual(panel.active_index, 2)
        self.assertTrue(elem2.is_focused())

        # Third Tab key press - wraps around to 0
        keys.append(ConsoleKeyInfo(key=KeyCode.TAB, char="\t"))
        panel.update(ctx)
        self.assertEqual(panel.active_index, 0)
        self.assertTrue(elem0.is_focused())

    def test_ui_checkbox_toggle(self):
        cb = UICheckbox("Accept Terms", ATCoordinates(5, 5))
        self.assertEqual(cb.state, UICheckboxState.UNCHECKED)
        self.assertIn("☐", cb.to_ansi_control_sequence_string())

        cb.toggle_checkbox()
        self.assertEqual(cb.state, UICheckboxState.CHECKED)
        self.assertIn("☑", cb.to_ansi_control_sequence_string())

        cb.toggle_checkbox()
        self.assertEqual(cb.state, UICheckboxState.UNCHECKED)

    def test_ui_spinner_animation(self):
        spinner = UICellSpinner(fps=10)
        self.assertEqual(spinner.user_data, "|")

        # Step by 0.1s (1 frame at 10 fps)
        ctx = Context([0.15, [], None])
        spinner.update(ctx)
        self.assertEqual(spinner.user_data, "\\")

        spinner.update(ctx)
        self.assertEqual(spinner.user_data, "-")

    def test_ui_chevron_render(self):
        left_ch = UIChevron(UIChevronOrientation.LEFT, ATCoordinates(1, 1))
        self.assertIn("❮", left_ch.to_ansi_control_sequence_string())

        right_ch = UIChevron(UIChevronOrientation.RIGHT, ATCoordinates(1, 2))
        self.assertIn("❯", right_ch.to_ansi_control_sequence_string())

    def test_char_status_summary_panel(self):
        panel = UICharacterStatusSummaryPanel()
        self.assertEqual(panel.width, 34)
        self.assertEqual(panel.height, 16)
        self.assertEqual(len(panel.ui_element_listing), 5)
        self.assertIsInstance(panel.ui_element_listing[0], UICheckbox)
        self.assertIsInstance(panel.ui_element_listing[1], UIChevron)
        self.assertIsInstance(panel.ui_element_listing[2], UIChevron)
        self.assertIsInstance(panel.ui_element_listing[3], UICellSpinner)
        self.assertIsInstance(panel.ui_element_listing[4], UICellSpinner)

    def test_gs_ui_test_screen(self):
        screen = GSUiTestScreen()
        self.assertEqual(screen.name, "GSUiTestScreen")
        self.assertIsInstance(screen.sample_panel, UICharacterStatusSummaryPanel)

        # Spacebar toggles panel active
        space_key = ConsoleKeyInfo(key=KeyCode.SPACE, char=" ")
        keys = [space_key]
        ctx = Context([0.016, keys, None])

        self.assertFalse(screen.sample_panel.is_active())
        screen.update(ctx)
        self.assertTrue(screen.sample_panel.is_active())

    def test_gs_animated_soda_can_test_screen(self):
        from eldoria_py.states.test_soda_can import GSAnimatedSodaCanTestScreen, AnimatedSodaCan

        screen = GSAnimatedSodaCanTestScreen()
        self.assertEqual(len(screen.soda_cans), 30)

        # Verify all 30 cans are unique classes
        class_types = {type(can) for can in screen.soda_cans}
        self.assertEqual(len(class_types), 30, "All 30 soda cans must be distinct classes!")

        # Verify rows and columns layout
        expected_rows = {5, 7, 9, 11}
        expected_cols = {5, 7, 9, 11, 13, 15, 17, 19}
        for can in screen.soda_cans:
            self.assertIn(can.draw_row, expected_rows)
            self.assertIn(can.draw_col, expected_cols)
            self.assertEqual(len(can.frames), 4)
            for frame in can.frames:
                self.assertGreater(len(frame.variants), 1)

        # Verify update lifecycle
        ctx = Context([0.016, [], None])
        screen.enter(ctx)
        screen.update(ctx)
        screen.exit(ctx)

    def test_screen_transitions_immediate_return(self):
        from eldoria_py.core.engine import EldoriaCore
        from eldoria_py.terminal.input import ConsoleKeyInfo, KeyCode

        core = EldoriaCore(target_fps=60, initial_state="GSUiTestScreen")
        core.initialize_states()

        # Step 1: Boot from GSInit to GSUiTestScreen
        ctx = Context([0.016, [], core])
        core.game_state.update(ctx)
        self.assertEqual(core.game_state.current_state, "GSUiTestScreen")

        # Step 2: Transition GSUiTestScreen -> GSNoiseMapTestScreen via 'M'
        key_m = ConsoleKeyInfo(key=KeyCode.NONE, char="m")
        keys = [key_m]
        ctx = Context([0.016, keys, core])
        core.game_state.update(ctx)
        self.assertEqual(core.game_state.current_state, "GSNoiseMapTestScreen")
        self.assertEqual(len(keys), 0, "Keys list must be cleared on transition")

        # Step 3: Transition GSNoiseMapTestScreen -> GSAnimatedSodaCanTestScreen via 'C'
        key_c = ConsoleKeyInfo(key=KeyCode.NONE, char="c")
        keys = [key_c]
        ctx = Context([0.016, keys, core])
        core.game_state.update(ctx)
        self.assertEqual(core.game_state.current_state, "GSAnimatedSodaCanTestScreen")
        self.assertEqual(len(keys), 0, "Keys list must be cleared on transition")

        # Step 4: Transition GSAnimatedSodaCanTestScreen -> GSUiTestScreen via 'U'
        key_u = ConsoleKeyInfo(key=KeyCode.NONE, char="u")
        keys = [key_u]
        ctx = Context([0.016, keys, core])
        core.game_state.update(ctx)
        self.assertEqual(core.game_state.current_state, "GSUiTestScreen")
        self.assertEqual(len(keys), 0, "Keys list must be cleared on transition")

    def test_ui_container_inner_bounds_math(self):
        container = UIContainer(
            left_top=ATCoordinates(1, 1),
            right_bottom=ATCoordinates(22, 80),
        )
        self.assertEqual(container.inner_left, 2)
        self.assertEqual(container.inner_right, 79)
        self.assertEqual(container.inner_top, 2)
        self.assertEqual(container.inner_bottom, 21)
        self.assertEqual(container.inner_width, 78)
        self.assertEqual(container.inner_height, 20)

    def test_ui_panel_add_label_alignment_and_registration(self):
        panel = UIPanel(
            left_top=ATCoordinates(1, 1),
            right_bottom=ATCoordinates(22, 80),
        )
        panel.activate()

        # Center alignment
        lbl_center = panel.add_label("E L D O R I A", row=9, align="center")
        self.assertEqual(lbl_center.coordinates.row, 9)
        # inner_left = 2, inner_width = 78, len = 13. col = 2 + (78 - 13)//2 = 2 + 32 = 34
        self.assertEqual(lbl_center.coordinates.column, 34)
        self.assertEqual(lbl_center.parent, panel)
        self.assertTrue(lbl_center.is_active())

        # Left alignment
        lbl_left = panel.add_label("Left Text", row=10, align="left")
        self.assertEqual(lbl_left.coordinates.column, 2)

        # Right alignment
        lbl_right = panel.add_label("Right", row=11, align="right")
        # inner_right = 79, len = 5. col = 79 - 5 + 1 = 75
        self.assertEqual(lbl_right.coordinates.column, 75)

    def test_ui_panel_add_label_bounds_strict_validation(self):
        panel = UIPanel(
            left_top=ATCoordinates(1, 1),
            right_bottom=ATCoordinates(10, 20),
        )
        # inner_left=2, inner_right=19, inner_width=18, inner_top=2, inner_bottom=9

        # Text exceeds inner_width: must raise ValueError (NO silent truncation!)
        too_long = "X" * 19
        with self.assertRaises(ValueError) as ctx:
            panel.add_label(too_long, row=5, align="center")
        self.assertIn("exceeds panel inner_width", str(ctx.exception))

        # Row outside vertical inner bounds: must raise ValueError
        with self.assertRaises(ValueError) as ctx:
            panel.add_label("Valid", row=1, align="left")  # row 1 is top border
        self.assertIn("outside panel vertical inner bounds", str(ctx.exception))

        with self.assertRaises(ValueError) as ctx:
            panel.add_label("Valid", row=10, align="left")  # row 10 is bottom border
        self.assertIn("outside panel vertical inner bounds", str(ctx.exception))

        # Explicit column outside left/right: must raise ValueError
        with self.assertRaises(ValueError) as ctx:
            panel.add_label("Valid", row=5, col=1, align="left")  # col 1 is left border
        self.assertIn("outside panel inner_left", str(ctx.exception))

        with self.assertRaises(ValueError) as ctx:
            panel.add_label("Valid", row=5, col=17, align="left")  # 17 + 5 - 1 = 21 > 19
        self.assertIn("exceeds panel right border", str(ctx.exception))

    def test_ui_label_set_user_data_strict_bounds_validation(self):
        panel = UIPanel(
            left_top=ATCoordinates(1, 1),
            right_bottom=ATCoordinates(10, 20),
        )
        lbl = panel.add_label("Short", row=5, col=5, align="left")
        self.assertEqual(lbl.text, "Short")

        # Updating with text that exceeds parent inner_width must raise ValueError
        with self.assertRaises(ValueError) as ctx:
            lbl.set_user_data("This text is way too long for inner width 18")
        self.assertIn("exceeds parent container inner_width", str(ctx.exception))

        # Updating with text that exceeds right border from col 5:
        # col=5, max allowed len is 19 - 5 + 1 = 15
        with self.assertRaises(ValueError) as ctx:
            lbl.set_user_data("A" * 16)
        self.assertIn("exceeds parent container right border", str(ctx.exception))

        # Valid update sets dirty and user data
        lbl.set_user_data("FitsFine")
        self.assertEqual(lbl.text, "FitsFine")
        self.assertTrue(lbl.dirty)

    def test_ui_panel_set_all_dirty(self):
        panel = UIPanel(
            left_top=ATCoordinates(1, 1),
            right_bottom=ATCoordinates(10, 20),
            title="Panel",
        )
        lbl1 = panel.add_label("One", row=3, align="left")
        lbl2 = panel.add_label("Two", row=4, align="left")
        lbl1.dirty = False
        lbl2.dirty = False
        panel.border_draw_dirty = [False, False, False, False]
        panel.title_dirty = False

        panel.set_all_dirty()
        self.assertTrue(all(panel.border_draw_dirty))
        self.assertTrue(panel.title_dirty)
        self.assertTrue(lbl1.dirty)
        self.assertTrue(lbl2.dirty)

    def test_ui_divider_render(self):
        container = UIContainer(left_top=ATCoordinates(1, 1), right_bottom=ATCoordinates(10, 20))
        # inner_width = 18. Divider at row 5
        div = container.add_divider(row=5)
        self.assertEqual(div.row, 5)
        self.assertEqual(div.parent, container)
        ansi_out = div.to_ansi_control_sequence_string()
        self.assertIn("├", ansi_out)
        self.assertIn("┤", ansi_out)
        self.assertIn("─" * 18, ansi_out)
        self.assertIn("\033[5;1H", ansi_out)

        # Divider with title
        div_title = container.add_divider(row=6, title="Section")
        title_out = div_title.to_ansi_control_sequence_string()
        self.assertIn("Section", title_out)

    def test_ui_menu_item_styling_and_bounds(self):
        container = UIContainer(left_top=ATCoordinates(1, 1), right_bottom=ATCoordinates(10, 40))
        # inner_width = 38
        called = []
        item = UIMenuItem(
            label="Play",
            index=1,
            coordinates=ATCoordinates(3, 5),
            action=lambda: called.append(True),
            parent=container,
            selected=False,
        )
        self.assertFalse(item.selected)
        unselected_str = item.text
        self.assertEqual(unselected_str, "      1. Play      ")

        # Symmetric width check
        item.set_selected(True)
        self.assertTrue(item.selected)
        selected_str = item.text
        self.assertEqual(selected_str, "❱   [ 1. Play ]   ❰")
        self.assertEqual(len(unselected_str), len(selected_str))
        self.assertTrue(item.dirty)

        # Execution check
        item.execute()
        self.assertEqual(len(called), 1)

        # Bounds validation error on overflow
        with self.assertRaises(ValueError) as ctx:
            UIMenuItem(label="X" * 35, index=1, coordinates=ATCoordinates(3, 5), parent=container)
        self.assertIn("exceeds parent inner_width", str(ctx.exception))

    def test_ui_menu_creation_and_navigation(self):
        panel = UIPanel(left_top=ATCoordinates(1, 1), right_bottom=ATCoordinates(22, 80))
        menu = UIMenu(parent=panel, start_row=8, row_spacing=2)

        actions_invoked = []
        item1 = menu.add_item("First", action=lambda: actions_invoked.append("First"))
        item2 = menu.add_item("Second", action=lambda: actions_invoked.append("Second"))
        item3 = menu.add_item("Third", action=lambda: actions_invoked.append("Third"))

        self.assertEqual(len(menu.items), 3)
        self.assertEqual(menu.selected_index, 0)
        self.assertTrue(item1.selected)
        self.assertFalse(item2.selected)
        self.assertFalse(item3.selected)

        # Clear dirty flags
        item1.dirty = False
        item2.dirty = False
        item3.dirty = False

        # Navigate Next (Down) -> item 2 selected
        menu.select_next()
        self.assertEqual(menu.selected_index, 1)
        self.assertFalse(item1.selected)
        self.assertTrue(item2.selected)
        self.assertFalse(item3.selected)
        # Selective dirty repaint: only item1 and item2 marked dirty!
        self.assertTrue(item1.dirty)
        self.assertTrue(item2.dirty)
        self.assertFalse(item3.dirty)

        # Navigate Next again -> item 3
        menu.select_next()
        self.assertEqual(menu.selected_index, 2)
        # Circular wrap -> item 1
        menu.select_next()
        self.assertEqual(menu.selected_index, 0)
        self.assertTrue(item1.selected)

        # Navigate Prev (Up) -> wraps to item 3
        menu.select_prev()
        self.assertEqual(menu.selected_index, 2)
        self.assertTrue(item3.selected)

        # Execute selected
        menu.execute_selected()
        self.assertEqual(actions_invoked, ["Third"])

        # Input handling via KeyCode
        down_key = ConsoleKeyInfo(key=KeyCode.DOWN)
        self.assertTrue(menu.handle_input(down_key))
        self.assertEqual(menu.selected_index, 0)

        # Input handling via number shortcut '2'
        num_key = ConsoleKeyInfo(key=KeyCode.NONE, char="2")
        self.assertTrue(menu.handle_input(num_key))
        self.assertEqual(menu.selected_index, 1)
        self.assertEqual(actions_invoked, ["Third", "Second"])

    def test_ui_container_borderless(self):
        container = UIContainer(
            left_top=ATCoordinates(7, 2),
            right_bottom=ATCoordinates(19, 79),
            has_border=False,
        )
        self.assertFalse(container.has_border)
        self.assertEqual(container.inner_left, 2)
        self.assertEqual(container.inner_right, 79)
        self.assertEqual(container.inner_top, 7)
        self.assertEqual(container.inner_bottom, 19)
        self.assertEqual(container.inner_width, 78)
        self.assertEqual(container.inner_height, 13)

    def test_ui_container_footer(self):
        container = UIContainer(
            left_top=ATCoordinates(1, 1),
            right_bottom=ATCoordinates(10, 40),
        )
        container.setup_footer("[Q] Quit")
        self.assertTrue(container.use_footer)
        self.assertEqual(container.footer, "[Q] Quit")

    def test_ui_container_title_seamless_border(self):
        from eldoria_py.terminal.box import strip_ansi

        container = UIContainer(
            left_top=ATCoordinates(1, 1),
            right_bottom=ATCoordinates(10, 40),
            title="── E L D O R I A ──",
        )
        # Mock terminal write to capture top border
        writes = []
        from eldoria_py.terminal.screen import TerminalScreen
        orig_write = TerminalScreen.write
        try:
            TerminalScreen.write = lambda s: writes.append(s)
            container.draw()
        finally:
            TerminalScreen.write = orig_write

        output = "".join(writes)
        # Extract the top row (starts at \033[1;1H)
        self.assertIn("\033[1;1H", output)
        top_segment = output.split("\033[10;1H")[0]  # before bottom border
        visible_top = strip_ansi(top_segment)
        # Must start with ╭, end with ╮, measure exactly 40 cols
        self.assertTrue(visible_top.startswith("╭"))
        self.assertTrue(visible_top.endswith("╮"))
        self.assertEqual(len(visible_top), 40)
        # Must contain E L D O R I A centered with clean solid border dashes and single space padding
        self.assertIn("─────────── E L D O R I A ────────────", visible_top)
        self.assertNotIn("─  ", visible_top)
        self.assertNotIn("  ─", visible_top)

    def test_ui_container_title_solid_border_color_no_bleed(self):
        """Verify border characters and corners are strictly rendered in border color with zero title color bleed."""
        container = UIContainer(
            left_top=ATCoordinates(1, 1),
            right_bottom=ATCoordinates(10, 54),
            title="Player Party Builder [0/5]",
        )
        # Set border color to White and title color to Cyan
        container.border_draw_colors = [ColorLibrary.White for _ in range(8)]
        container.setup_title("Player Party Builder [0/5]", ColorLibrary.AppleCyanLight)

        writes = []
        from eldoria_py.terminal.screen import TerminalScreen
        orig_write = TerminalScreen.write
        try:
            TerminalScreen.write = lambda s: writes.append(s)
            container.draw()
        finally:
            TerminalScreen.write = orig_write

        output = "".join(writes)
        top_segment = output.split("\033[10;1H")[0]

        white_ansi = ColorLibrary.White.to_ansi_fg()
        cyan_ansi = ColorLibrary.AppleCyanLight.to_ansi_fg()

        # The left corner ╭ and leading dashes MUST be in white border color
        self.assertIn(f"{white_ansi}╭", top_segment)
        self.assertIn(f"{white_ansi}──────────── ", top_segment)

        # The title text MUST be in cyan
        self.assertIn(f"{cyan_ansi}Player Party Builder [0/5]", top_segment)

        # The trailing dashes and right corner ╮ MUST be in white border color
        self.assertIn(f"{white_ansi} ────────────{white_ansi}╮", top_segment)

        # Cyan MUST NEVER wrap any border dash '─'
        self.assertNotIn(f"{cyan_ansi}─", top_segment)


if __name__ == "__main__":
    unittest.main()

