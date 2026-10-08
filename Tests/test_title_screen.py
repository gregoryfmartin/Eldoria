"""
Unit tests for GSSplashScreen and GSTitleScreen.
Verifies production boot flow, 5 menu items, modal dialogs, and developer hotkeys.
"""

import unittest
from unittest.mock import MagicMock

from eldoria_py.audio import AudioChannel, AudioTrackInfo, PlaybackState
from eldoria_py.core.context import Context
from eldoria_py.core.fsm import SMState
from eldoria_py.terminal.color import ColorLibrary, TrueColor, dim_ansi, scale_color
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
        # Duration expires, triggers FADING_OUT phase
        self.context.set(SMState.ContextDeltaTime, 1.1)
        self.context.set(SMState.ContextKeysPressed, [])

        self.splash.update(self.context)
        self.assertEqual(self.splash.phase, "FADING_OUT")
        self.mock_game_state.trigger.assert_not_called()

        # Fade-out duration elapses, triggering ToTitle transition
        self.context.set(SMState.ContextDeltaTime, self.splash.fade_out_duration)
        self.splash.update(self.context)
        self.assertEqual(self.splash.phase, "FINISHED")
        self.mock_game_state.trigger.assert_called_once_with("ToTitle", self.context)

    def test_splash_advances_on_keypress(self):
        self.context.set(SMState.ContextDeltaTime, 0.1)
        self.context.set(SMState.ContextKeysPressed, [KeyEvent(key=KeyCode.SPACE)])

        self.splash.update(self.context)
        self.assertEqual(self.splash.phase, "FADING_OUT")
        self.mock_game_state.trigger.assert_not_called()

        # Subsequent keypress skips fade-out directly to finished
        self.context.set(SMState.ContextKeysPressed, [KeyEvent(key=KeyCode.SPACE)])
        self.splash.update(self.context)
        self.assertEqual(self.splash.phase, "FINISHED")
        self.mock_game_state.trigger.assert_called_once_with("ToTitle", self.context)

    def test_splash_instant_transition_when_fade_zero(self):
        splash = GSSplashScreen(screen_width=54, screen_height=24, duration=1.0, fade_out_duration=0.0)
        self.context.set(SMState.ContextDeltaTime, 1.1)
        self.context.set(SMState.ContextKeysPressed, [])

        splash.update(self.context)
        self.assertEqual(splash.phase, "FINISHED")
        self.mock_game_state.trigger.assert_called_once_with("ToTitle", self.context)

    def test_splash_panel_structure(self):
        self.assertIsInstance(self.splash.splash_panel, UIPanel)
        self.assertTrue(self.splash.splash_panel.is_active())
        self.assertEqual(len(self.splash.splash_panel.ui_element_listing), 5)
        for element in self.splash.splash_panel.ui_element_listing.values():
            self.assertIsInstance(element, UILabel)
            self.assertEqual(element.parent, self.splash.splash_panel)

        self.assertEqual(self.splash.title_label.text, "E L D O R I A")
        self.assertEqual(self.splash.divider_label.text, "────────────────────────────────────")
        self.assertEqual(self.splash.subtitle_label.text, "A Retro VT RPG")
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
        self.assertAlmostEqual(default_splash.fade_in_duration, 0.45)
        self.assertAlmostEqual(default_splash.fade_out_duration, 0.45)
        self.assertEqual(default_splash.phase, "FADING_IN")
        self.assertTrue(default_splash.is_fading_in)
        self.assertFalse(default_splash.is_fading_out)

    def test_splash_fade_in_progression_and_transition(self):
        splash = GSSplashScreen(screen_width=54, screen_height=24, duration=3.0, fade_in_duration=0.5)
        self.assertEqual(splash.phase, "FADING_IN")
        self.assertTrue(splash.is_fading_in)

        # First half of fade-in
        self.context.set(SMState.ContextDeltaTime, 0.25)
        self.context.set(SMState.ContextKeysPressed, [])
        splash.update(self.context)
        self.assertEqual(splash.phase, "FADING_IN")
        self.assertTrue(splash.is_fading_in)
        self.assertAlmostEqual(splash.fade_in_elapsed, 0.25)

        # Complete fade-in
        splash.update(self.context)
        self.assertEqual(splash.phase, "SHOWING")
        self.assertFalse(splash.is_fading_in)
        self.assertFalse(splash.is_fading_out)

    def test_splash_fade_in_zero_duration(self):
        splash = GSSplashScreen(screen_width=54, screen_height=24, duration=2.0, fade_in_duration=0.0)
        self.assertEqual(splash.phase, "SHOWING")
        self.assertFalse(splash.is_fading_in)

        splash.enter(self.context)
        self.assertEqual(splash.phase, "SHOWING")
        self.assertFalse(splash.is_fading_in)

    def test_splash_keypress_during_fade_in_skips(self):
        splash = GSSplashScreen(screen_width=54, screen_height=24, duration=3.0, fade_in_duration=0.5, fade_out_duration=0.45)
        self.context.set(SMState.ContextDeltaTime, 0.1)
        self.context.set(SMState.ContextKeysPressed, [KeyEvent(key=KeyCode.ENTER)])

        splash.update(self.context)
        self.assertEqual(splash.phase, "FADING_OUT")
        self.assertTrue(splash.is_fading_out)
        self.assertFalse(splash.is_fading_in)

    def test_splash_render_filter_during_fade_in(self):
        from eldoria_py.terminal.screen import TerminalScreen
        from unittest.mock import patch
        self.mock_game_state.current_state = "GSSplashScreen"
        splash = GSSplashScreen(screen_width=54, screen_height=24, duration=3.0, fade_in_duration=0.5)
        self.context.set(SMState.ContextDeltaTime, 0.25)
        self.context.set(SMState.ContextKeysPressed, [])

        recorded_filters = []
        original_set_filter = TerminalScreen.set_write_filter

        def spy_set_filter(fn):
            recorded_filters.append(fn)
            original_set_filter(fn)

        TerminalScreen.set_write_filter = spy_set_filter
        with patch.object(TerminalScreen, "flush"), patch("sys.stdout.write"):
            try:
                splash.update(self.context)
            finally:
                TerminalScreen.set_write_filter = original_set_filter

        # Should have set a dimming filter (callable) during draw, then reset to None
        self.assertTrue(any(callable(f) for f in recorded_filters))
        self.assertIsNone(TerminalScreen._write_filter)



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

    def test_title_fade_in_on_enter(self):
        self.title.enter(self.context)
        self.assertTrue(self.title.is_fading_in)
        self.assertEqual(self.title.fade_in_elapsed, 0.0)

    def test_title_fade_in_advances_and_completes(self):
        self.title.enter(self.context)
        self.context.set(SMState.ContextDeltaTime, 0.2)
        self.context.set(SMState.ContextKeysPressed, [])

        self.title.update(self.context)
        self.assertTrue(self.title.is_fading_in)
        self.assertAlmostEqual(self.title.fade_in_elapsed, 0.2)

        # Advance past fade_in_duration (0.45s)
        self.context.set(SMState.ContextDeltaTime, 0.3)
        self.title.update(self.context)
        self.assertFalse(self.title.is_fading_in)

    def test_title_fade_in_skipped_on_keypress(self):
        self.title.enter(self.context)
        self.assertTrue(self.title.is_fading_in)

        # Keypress during fade-in snaps immediately to full brightness and swallows key
        keys = [KeyEvent(key=KeyCode.ENTER, char="\r")]
        self.context.set(SMState.ContextDeltaTime, 0.05)
        self.context.set(SMState.ContextKeysPressed, keys)

        self.title.update(self.context)
        self.assertFalse(self.title.is_fading_in)
        self.assertEqual(len(keys), 0)
        # Menu item was NOT activated because key was consumed by fade skip
        self.assertIsNone(self.title.active_dialog)

    def test_title_screen_exit_menu_shuts_down(self):
        self.mock_core.is_running = True
        self.title.audio_engine.cleanup = MagicMock()
        self.title._current_core = self.mock_core
        self.title._execute_menu_action("Exit")
        self.assertFalse(self.mock_core.is_running)
        self.title.audio_engine.cleanup.assert_called_once()

    def test_title_screen_q_shuts_down(self):
        self.mock_core.is_running = True
        self.title.audio_engine.cleanup = MagicMock()
        self.title._handle_input(KeyEvent(key=KeyCode.CHAR, char="q"), self.context, self.mock_core)
        self.assertFalse(self.mock_core.is_running)
        self.title.audio_engine.cleanup.assert_called_once()

    def test_title_screen_starts_bgm_on_enter(self):
        self.title.audio_engine.play_bgm = MagicMock()
        self.title.audio_engine.get_current_bgm = MagicMock(return_value=None)
        self.title.enter(self.context)
        self.title.audio_engine.play_bgm.assert_called_once_with("Title", loop=True)

    def test_title_screen_seamless_bgm_persistence(self):
        self.title.audio_engine.play_bgm = MagicMock()
        existing_track = AudioTrackInfo(
            name="Title",
            path="Resources/BGM/Title.mp3",
            channel=AudioChannel.MUSIC,
            state=PlaybackState.PLAYING,
            volume=1.0,
            duration_seconds=120.0,
            position_seconds=15.0,
            loop=True,
        )
        self.title.audio_engine.get_current_bgm = MagicMock(return_value=existing_track)
        self.title.enter(self.context)
        self.title.audio_engine.play_bgm.assert_not_called()

    def test_title_screen_load_game_stops_bgm(self):
        self.title.active_dialog = "LOAD"
        self.title.load_slot_idx = 0
        self.title.load_headers = [MagicMock()]
        loaded_state = {"current_sector": (0, 0), "player_pos": (5, 5)}
        self.title.save_manager.load_game = MagicMock(return_value=(MagicMock(), MagicMock(), loaded_state))
        self.title.audio_engine.stop_bgm = MagicMock()

        self.title._handle_input(KeyEvent(key=KeyCode.ENTER, char="\r"), self.context, self.mock_core)
        self.title.audio_engine.stop_bgm.assert_called_once()
        self.assertTrue(self.title.is_fading_out)
        self.mock_game_state.trigger.assert_not_called()

        # Advance fade-out duration
        self.context.set(SMState.ContextDeltaTime, self.title.fade_out_duration)
        self.title.update(self.context)
        self.assertFalse(self.title.is_fading_out)
        self.mock_game_state.trigger.assert_called_once_with("ToNoiseMap", self.context)

    def test_title_screen_dev_map_hotkey_stops_bgm(self):
        self.title.audio_engine.stop_bgm = MagicMock()
        self.title._handle_input(KeyEvent(key=KeyCode.CHAR, char="m"), self.context, self.mock_core)
        self.title.audio_engine.stop_bgm.assert_called_once()
        self.mock_game_state.trigger.assert_called_once_with("ToNoiseMap", self.context)

    def test_title_screen_load_game_fade_out_dimming(self):
        """Verifies that while fading out from Load Game screen, dimming write filter is active."""
        from eldoria_py.terminal.screen import TerminalScreen
        from unittest.mock import patch
        self.mock_game_state.current_state = "GSTitleScreen"
        self.title.active_dialog = "LOAD"
        self.title.load_slot_idx = 0
        self.title.load_headers = [MagicMock()]
        loaded_state = {"current_sector": (0, 0), "player_pos": (5, 5)}
        self.title.save_manager.load_game = MagicMock(return_value=(MagicMock(), MagicMock(), loaded_state))

        # Select slot 1 to start fade-out
        self.title._handle_input(KeyEvent(key=KeyCode.ENTER, char="\r"), self.context, self.mock_core)
        self.assertTrue(self.title.is_fading_out)

        # Advance partially (50%)
        self.context.set(SMState.ContextDeltaTime, 0.225)
        self.context.set(SMState.ContextKeysPressed, [])

        recorded_filters = []
        original_set_filter = TerminalScreen.set_write_filter

        def spy_set_filter(fn):
            recorded_filters.append(fn)
            original_set_filter(fn)

        TerminalScreen.set_write_filter = spy_set_filter
        with patch.object(TerminalScreen, "flush"), patch("sys.stdout.write"):
            try:
                self.title.update(self.context)
            finally:
                TerminalScreen.set_write_filter = original_set_filter

        self.assertTrue(any(callable(f) for f in recorded_filters))
        self.assertIsNone(TerminalScreen._write_filter)

    def test_title_screen_load_game_fade_out_keypress_skips(self):
        """Verifies pressing a key during Load Game fade-out immediately finishes the transition."""
        self.title.active_dialog = "LOAD"
        self.title.load_slot_idx = 0
        self.title.load_headers = [MagicMock()]
        loaded_state = {"current_sector": (0, 0), "player_pos": (5, 5)}
        self.title.save_manager.load_game = MagicMock(return_value=(MagicMock(), MagicMock(), loaded_state))

        self.title._handle_input(KeyEvent(key=KeyCode.ENTER, char="\r"), self.context, self.mock_core)
        self.assertTrue(self.title.is_fading_out)

        # Keypress during fade-out
        self.context.set(SMState.ContextDeltaTime, 0.05)
        self.context.set(SMState.ContextKeysPressed, [KeyEvent(key=KeyCode.SPACE)])
        self.title.update(self.context)

        self.assertFalse(self.title.is_fading_out)
        self.mock_game_state.trigger.assert_called_once_with("ToNoiseMap", self.context)

    def test_title_screen_load_game_fade_out_zero_duration(self):
        """Verifies that when fade_out_duration=0, load completes immediately upon slot selection."""
        title = GSTitleScreen(screen_width=54, screen_height=24, fade_out_duration=0.0)
        title.active_dialog = "LOAD"
        title.load_slot_idx = 0
        title.load_headers = [MagicMock()]
        loaded_state = {"current_sector": (0, 0), "player_pos": (5, 5)}
        title.save_manager.load_game = MagicMock(return_value=(MagicMock(), MagicMock(), loaded_state))

        title._handle_input(KeyEvent(key=KeyCode.ENTER, char="\r"), self.context, self.mock_core)
        self.assertFalse(title.is_fading_out)
        self.mock_game_state.trigger.assert_called_once_with("ToNoiseMap", self.context)


class TestColorDimming(unittest.TestCase):
    """Verifies ANSI TrueColor brightness scaling and escape sequence filtering."""

    def test_scale_color(self):
        color = TrueColor(100, 200, 50)
        scaled = scale_color(color, 0.5)
        self.assertEqual(scaled.r, 50)
        self.assertEqual(scaled.g, 100)
        self.assertEqual(scaled.b, 25)

        # Zero and 1.0 boundary tests
        self.assertEqual(scale_color(color, 0.0).r, 0)
        self.assertEqual(scale_color(color, 1.0).r, 100)

    def test_dim_ansi(self):
        ansi_text = "\033[38;2;100;200;50mHello\033[0m"
        dimmed = dim_ansi(ansi_text, 0.5)
        self.assertEqual(dimmed, "\033[38;2;50;100;25mHello\033[0m")

        # Fast path returns string unchanged
        self.assertEqual(dim_ansi(ansi_text, 1.0), ansi_text)
        self.assertEqual(dim_ansi("Plain text", 0.5), "Plain text")

        # 16-color ANSI code dimming
        ansi_16 = "\033[1;33mGold\033[0m"
        dimmed_16 = dim_ansi(ansi_16, 0.5)
        self.assertIn("\033[1;38;2;114;114;8mGold\033[0m", dimmed_16)

        # 256-color ANSI code dimming
        ansi_256 = "\033[38;5;196mRed\033[0m"
        dimmed_256 = dim_ansi(ansi_256, 0.5)
        self.assertIn("\033[38;2;127;0;0mRed\033[0m", dimmed_256)

        # Buffer-wide dimming includes unstyled text and resets
        from eldoria_py.terminal.color import dim_buffer
        frame = "┌─┐\033[1;33mGold\033[0m Border\033[?2026h"
        dimmed_bw = dim_buffer(frame, 0.0)
        self.assertTrue(dimmed_bw.startswith("\033[38;2;0;0;0m┌─┐"))
        self.assertIn("\033[1;38;2;0;0;0mGold\033[0m\033[38;2;0;0;0m Border", dimmed_bw)
        self.assertIn("\033[?2026h", dimmed_bw)


if __name__ == "__main__":
    unittest.main()
