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


if __name__ == "__main__":
    unittest.main()
