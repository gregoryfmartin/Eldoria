"""
Unit tests for terminal ANSI, TrueColor, Context, and FSM.
"""

import unittest
from unittest.mock import patch
from eldoria_py.terminal.color import TrueColor, ColorChannel, ColorLibrary
from eldoria_py.terminal.ansi import ATControlSequences, ATCoordinates, ATDecoration, ATString
from eldoria_py.terminal.screen import TerminalScreen
from eldoria_py.core.context import Context, ContextBroadcaster
from eldoria_py.core.fsm import SMState, SMTransition, SMStateMachine


class TestColor(unittest.TestCase):
    def test_color_channel_clamping(self):
        ch = ColorChannel(300)
        self.assertEqual(ch.value, 255)
        ch.value = -50
        self.assertEqual(ch.value, 0)
        ch.value = 128
        self.assertEqual(ch.value, 128)

    def test_true_color_hex(self):
        c = TrueColor.from_hex(0xCD5C5C)
        self.assertEqual(c.r, 0xCD)
        self.assertEqual(c.g, 0x5C)
        self.assertEqual(c.b, 0x5C)

    def test_true_color_ansi(self):
        c = TrueColor(10, 20, 30)
        self.assertEqual(c.to_fg_ansi(), "\033[38;2;10;20;30m")
        self.assertEqual(c.to_bg_ansi(), "\033[48;2;10;20;30m")


class TestANSI(unittest.TestCase):
    def test_coordinates_ansi(self):
        coord = ATCoordinates(12, 34)
        self.assertEqual(coord.to_ansi(), "\033[12;34H")

    def test_decoration_ansi(self):
        dec = ATDecoration(bold=True, italic=True)
        self.assertIn("\033[1m", dec.to_ansi())
        self.assertIn("\033[3m", dec.to_ansi())

    def test_at_string_render(self):
        s = ATString(
            text="Hello",
            coordinates=ATCoordinates(1, 1),
            fg_color=ColorLibrary.AppleMintLight,
            decorations=ATDecoration(bold=True),
        )
        rendered = s.render()
        self.assertTrue(rendered.startswith("\033[1;1H"))
        self.assertIn("Hello", rendered)
        self.assertTrue(rendered.endswith(ATControlSequences.ModifierReset))


class TestFSM(unittest.TestCase):
    def test_fsm_transitions(self):
        events = []

        state_a = SMState("A", on_enter=lambda ctx: events.append("Enter_A"), on_exit=lambda ctx: events.append("Exit_A"))
        state_b = SMState("B", on_enter=lambda ctx: events.append("Enter_B"), on_exit=lambda ctx: events.append("Exit_B"))

        fsm = SMStateMachine("A")
        fsm.add_states([state_a, state_b])
        fsm.add_transition(SMTransition("A", "Go", "B"))

        ctx = Context()
        fsm.update(ctx)
        self.assertEqual(fsm.current_state, "A")
        self.assertIn("Enter_A", events)

        success = fsm.trigger("Go", ctx)
        self.assertTrue(success)
        self.assertEqual(fsm.current_state, "B")
        self.assertIn("Exit_A", events)
        self.assertIn("Enter_B", events)


class TestTerminalScreen(unittest.TestCase):
    def setUp(self):
        TerminalScreen._initialized = False

    def tearDown(self):
        TerminalScreen._initialized = False

    def test_alternate_screen_scroll_constants(self):
        self.assertEqual(ATControlSequences.AlternateScreenScrollEnable, "\033[?1007h")
        self.assertEqual(ATControlSequences.AlternateScreenScrollDisable, "\033[?1007l")

    def test_terminal_screen_enter_and_exit_alternate_scroll(self):
        with patch("sys.stdout.write") as mock_write, patch("sys.stdout.flush"), patch("atexit.register"):
            TerminalScreen.enter()
            enter_output = "".join(call.args[0] for call in mock_write.call_args_list)
            self.assertIn("\033[?1049h", enter_output)
            self.assertIn("\033[?1007l", enter_output)

        with patch("sys.stdout.write") as mock_write, patch("sys.stdout.flush"):
            TerminalScreen.exit()
            exit_output = "".join(call.args[0] for call in mock_write.call_args_list)
            self.assertIn("\033[?1007h", exit_output)
            self.assertIn("\033[?1049l", exit_output)


if __name__ == "__main__":
    unittest.main()
