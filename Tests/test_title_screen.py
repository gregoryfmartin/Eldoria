"""
Unit tests for GSSplashScreen and GSTitleScreen.
Verifies production boot flow, 5 menu items, modal dialogs, and developer hotkeys.
"""

import unittest
from unittest.mock import MagicMock

from eldoria_py.core.context import Context
from eldoria_py.core.fsm import SMState
from eldoria_py.terminal.input import KeyCode, KeyEvent
from eldoria_py.states.splash_screen import GSSplashScreen
from eldoria_py.states.title_screen import GSTitleScreen
from eldoria_py.ui.panel import UIPanel
from eldoria_py.ui.elements.label import UILabel


class TestSplashScreen(unittest.TestCase):
    def setUp(self):
        self.splash = GSSplashScreen(screen_width=54, screen_height=24, duration=1.0)
        self.context = Context()
        self.mock_core = MagicMock()
        self.mock_game_state = MagicMock()
        self.mock_core.game_state = self.mock_game_state
        self.context.set(SMState.ContextEldoriaCore, self.mock_core)

    def test_splash_advances_on_duration(self):
        self.context.set(SMState.ContextDeltaTime, 1.1)
        self.context.set(SMState.ContextKeysPressed, [])

        self.splash.update(self.context)
        self.mock_game_state.trigger.assert_called_once_with("ToTitle", self.context)

    def test_splash_advances_on_keypress(self):
        self.context.set(SMState.ContextDeltaTime, 0.1)
        self.context.set(SMState.ContextKeysPressed, [KeyEvent(key=KeyCode.SPACE)])

        self.splash.update(self.context)
        self.mock_game_state.trigger.assert_called_once_with("ToTitle", self.context)

    def test_splash_panel_structure(self):
        self.assertIsInstance(self.splash.splash_panel, UIPanel)
        self.assertTrue(self.splash.splash_panel.is_active())
        self.assertEqual(len(self.splash.splash_panel.ui_element_listing), 6)
        for element in self.splash.splash_panel.ui_element_listing.values():
            self.assertIsInstance(element, UILabel)
            self.assertEqual(element.parent, self.splash.splash_panel)

        self.assertEqual(self.splash.title_label.text, "E L D O R I A")
        self.assertEqual(self.splash.divider_label.text, "────────────────────────────────────")
        self.assertEqual(self.splash.subtitle_label.text, "A Retro Tactical Virtual Terminal RPG")
        self.assertEqual(self.splash.engine_label.text, "Powered by Eldoria Python Engine")
        self.assertEqual(self.splash.prompt_label.text, "Press any key to start")

    def test_splash_panel_pulse_animation(self):
        # Initial elapsed is 0, pulse_phase 0
        # dt = 0.26s -> elapsed 0.26 -> int(0.26 * 4) % 4 = 1 -> pulses[1] = "✦"
        self.context.set(SMState.ContextDeltaTime, 0.26)
        self.context.set(SMState.ContextKeysPressed, [])
        self.splash.update(self.context)
        self.assertIn("✦", self.splash.stars_label.text)

        # dt = 0.26s -> elapsed 0.52 -> int(0.52 * 4) % 4 = 2 -> pulses[2] = "★"
        self.splash.update(self.context)
        self.assertIn("★", self.splash.stars_label.text)

    def test_splash_default_duration(self):
        default_splash = GSSplashScreen()
        self.assertAlmostEqual(default_splash.duration, 4.8)



class TestTitleScreen(unittest.TestCase):
    def setUp(self):
        self.title = GSTitleScreen(screen_width=54, screen_height=24, dev_mode=True)
        self.context = Context()
        self.mock_core = MagicMock()
        self.mock_game_state = MagicMock()
        self.mock_core.game_state = self.mock_game_state
        self.context.set(SMState.ContextEldoriaCore, self.mock_core)

    def test_menu_navigation(self):
        self.assertEqual(self.title.selected_idx, 0)  # New Game

        # W and S characters should NOT move menu
        self.title._handle_input(KeyEvent(key=KeyCode.CHAR, char="s"), self.context, self.mock_core)
        self.assertEqual(self.title.selected_idx, 0)
        self.title._handle_input(KeyEvent(key=KeyCode.CHAR, char="w"), self.context, self.mock_core)
        self.assertEqual(self.title.selected_idx, 0)

        # Down arrow moves to Load Game
        self.title._handle_input(KeyEvent(key=KeyCode.DOWN), self.context, self.mock_core)
        self.assertEqual(self.title.selected_idx, 1)

        # Up arrow moves back to New Game
        self.title._handle_input(KeyEvent(key=KeyCode.UP), self.context, self.mock_core)
        self.assertEqual(self.title.selected_idx, 0)

        # Up arrow from 0 wraps to Exit (index 4)
        self.title._handle_input(KeyEvent(key=KeyCode.UP), self.context, self.mock_core)
        self.assertEqual(self.title.selected_idx, 4)

    def test_new_game_selection_triggers_party_builder(self):
        self.title.selected_idx = 0
        self.title._handle_input(KeyEvent(key=KeyCode.ENTER, char="\r"), self.context, self.mock_core)
        self.mock_game_state.trigger.assert_called_once_with("ToPartyBuilder", self.context)

    def test_dialog_overlays(self):
        # Select Load Game (index 1)
        self.title.selected_idx = 1
        self.title._handle_input(KeyEvent(key=KeyCode.ENTER, char="\r"), self.context, self.mock_core)
        self.assertEqual(self.title.active_dialog, "LOAD")

        # Esc dismisses dialog
        self.title._handle_input(KeyEvent(key=KeyCode.ESCAPE), self.context, self.mock_core)
        self.assertIsNone(self.title.active_dialog)

        # Select Options (index 2)
        self.title.selected_idx = 2
        self.title._handle_input(KeyEvent(key=KeyCode.ENTER, char="\r"), self.context, self.mock_core)
        self.assertEqual(self.title.active_dialog, "OPTIONS")

    def test_developer_hotkeys(self):
        # M jumps to map
        self.title._handle_input(KeyEvent(key=KeyCode.CHAR, char="m"), self.context, self.mock_core)
        self.mock_game_state.trigger.assert_called_with("ToNoiseMap", self.context)

        # B jumps to combat
        self.title._handle_input(KeyEvent(key=KeyCode.CHAR, char="b"), self.context, self.mock_core)
        self.mock_game_state.trigger.assert_called_with("ToCombat", self.context)

    def test_title_screen_panel_structure(self):
        from eldoria_py.ui.panel import UIPanel
        from eldoria_py.ui.elements.menu import UIMenu

        self.assertIsInstance(self.title.title_panel, UIPanel)
        self.assertTrue(self.title.title_panel.is_active())
        self.assertIsInstance(self.title.menu, UIMenu)
        self.assertEqual(len(self.title.menu.items), 5)
        self.assertIsInstance(self.title.load_panel, UIPanel)
        self.assertIsInstance(self.title.options_panel, UIPanel)
        self.assertIsInstance(self.title.credits_panel, UIPanel)

    def test_title_screen_options_toggling(self):
        self.title.selected_idx = 2
        self.title._handle_input(KeyEvent(key=KeyCode.ENTER, char="\r"), self.context, self.mock_core)
        self.assertEqual(self.title.active_dialog, "OPTIONS")
        self.assertTrue(self.title.options_panel.is_active())

        # Toggle SFX with '1'
        orig_sfx = self.title.opt_sfx_enabled
        self.title._handle_input(KeyEvent(key=KeyCode.NONE, char="1"), self.context, self.mock_core)
        self.assertNotEqual(self.title.opt_sfx_enabled, orig_sfx)

        # Toggle Fast text with '2'
        orig_fast = self.title.opt_fast_text
        self.title._handle_input(KeyEvent(key=KeyCode.NONE, char="2"), self.context, self.mock_core)
        self.assertNotEqual(self.title.opt_fast_text, orig_fast)

        # Close with Esc
        self.title._handle_input(KeyEvent(key=KeyCode.ESCAPE), self.context, self.mock_core)
        self.assertIsNone(self.title.active_dialog)
        self.assertTrue(self.title.menu.is_active())

    def test_title_screen_credits_dialog(self):
        self.title.selected_idx = 3
        self.title._handle_input(KeyEvent(key=KeyCode.ENTER, char="\r"), self.context, self.mock_core)
        self.assertEqual(self.title.active_dialog, "CREDITS")
        self.assertTrue(self.title.credits_panel.is_active())

        self.title._handle_input(KeyEvent(key=KeyCode.SPACE, char=" "), self.context, self.mock_core)
        self.assertIsNone(self.title.active_dialog)


if __name__ == "__main__":
    unittest.main()
