"""
Unit and Integration Tests for NPC Speech Teletype SFX:
- Verifies looping playback of Resources/SFX/Tty.mp3 during DialogState.TELETYPING
- Verifies immediate stopping upon natural page completion
- Verifies immediate stopping upon Enter skip (flush_page)
- Verifies immediate stopping upon dialog close or Escape
- Verifies multi-page teletype audio lifecycle
- Verifies empty dialogues do not trigger SFX
- Verifies volume and asset parameterization

CRITICAL RULE: NEVER run Tests/test_audio_subsystem.py.
"""
import unittest
from unittest.mock import MagicMock, patch

from eldoria_py.procgen.npc import NPC, NPCRole, DialogCategory
from eldoria_py.terminal.color import TrueColor
from eldoria_py.terminal.input import KeyEvent, KeyCode
from eldoria_py.ui.npc_dialog import NPCDialogModal, DialogState


class TestNPCSpeechSFX(unittest.TestCase):
    def setUp(self):
        self.mock_audio = MagicMock()
        self.mock_audio.play_sfx.return_value = 999  # Mock handle ID

        self.npc = NPC(
            npc_id="elder_elric",
            name="Elder Elric",
            role=NPCRole.CITIZEN,
            glyph="e",
            fg_color=TrueColor(255, 255, 255),
            bg_color=TrueColor(0, 0, 0),
            dialogue="Beware the shadow that crawls beneath the western peaks.",
            category=DialogCategory.STANDARD,
        )

    def test_teletype_starts_looping_sfx(self):
        """Starting dialogue must begin looping the teletype SFX with default 0.40 volume."""
        modal = NPCDialogModal(
            screen_width=54,
            screen_height=27,
            chars_per_second=1.0,  # Slow so it stays in TELETYPING
            audio_engine=self.mock_audio,
        )

        modal.start_dialog(self.npc)

        self.assertEqual(modal.state, DialogState.TELETYPING)
        self.mock_audio.play_sfx.assert_called_once_with(
            name_or_path="Resources/SFX/Tty.mp3",
            loop=True,
            volume=0.40,
        )
        self.assertEqual(modal._tty_handle, 999)

    def test_teletype_stops_sfx_on_natural_completion(self):
        """When text finishes rendering naturally, the SFX loop must immediately halt."""
        modal = NPCDialogModal(
            screen_width=54,
            screen_height=27,
            chars_per_second=1.0,
            audio_engine=self.mock_audio,
        )

        modal.start_dialog(self.npc)
        self.assertEqual(modal._tty_handle, 999)
        self.mock_audio.stop_sfx.assert_not_called()

        # Advance elapsed time to reveal all characters
        modal.page_start_time = 0.0  # Force elapsed time to be large
        modal._update_teletype()

        self.assertIn(modal.state, (DialogState.PAGE_WAITING, DialogState.FINISHED))
        self.mock_audio.stop_sfx.assert_called_once_with(999)
        self.assertIsNone(modal._tty_handle)

    def test_teletype_stops_sfx_on_skip_enter(self):
        """Pressing Enter during teletyping flushes the page and immediately halts the SFX loop."""
        modal = NPCDialogModal(
            screen_width=54,
            screen_height=27,
            chars_per_second=1.0,
            audio_engine=self.mock_audio,
        )

        modal.start_dialog(self.npc)
        self.assertEqual(modal.state, DialogState.TELETYPING)
        self.assertEqual(modal._tty_handle, 999)

        # User presses Enter to skip
        modal.advance_or_act()

        self.mock_audio.stop_sfx.assert_called_once_with(999)
        self.assertIsNone(modal._tty_handle)
        self.assertEqual(modal.chars_revealed, modal.total_page_chars)
        self.assertNotEqual(modal.state, DialogState.TELETYPING)

    def test_teletype_stops_sfx_on_close_or_escape(self):
        """Closing the dialog or pressing Escape during teletype stops the SFX loop."""
        modal = NPCDialogModal(
            screen_width=54,
            screen_height=27,
            chars_per_second=1.0,
            audio_engine=self.mock_audio,
        )

        modal.start_dialog(self.npc)
        self.assertEqual(modal._tty_handle, 999)

        # Press Escape
        modal.handle_key(KeyEvent(key=KeyCode.ESCAPE, char=""))

        self.mock_audio.stop_sfx.assert_called_once_with(999)
        self.assertIsNone(modal._tty_handle)
        self.assertEqual(modal.state, DialogState.CLOSED)

    def test_multi_page_teletype_sfx_lifecycle(self):
        """Verifies SFX plays on Page 1, pauses when waiting, plays on Page 2, and stops on completion."""
        long_text = "The ancient kingdom of Eldoria has suffered many hardships over the centuries. " * 3
        self.npc.dialogue = long_text

        modal = NPCDialogModal(
            screen_width=54,
            screen_height=27,
            chars_per_second=1.0,
            audio_engine=self.mock_audio,
        )

        # Page 1 starts
        modal.start_dialog(self.npc)
        self.assertEqual(len(modal.pages), 2)
        self.assertEqual(modal.current_page_idx, 0)
        self.assertEqual(self.mock_audio.play_sfx.call_count, 1)

        # Page 1 natural completion
        modal.page_start_time = 0.0
        modal._update_teletype()
        self.assertEqual(modal.state, DialogState.PAGE_WAITING)
        self.assertEqual(self.mock_audio.stop_sfx.call_count, 1)
        self.assertIsNone(modal._tty_handle)

        # Advance to Page 2
        modal.advance_or_act()
        self.assertEqual(modal.current_page_idx, 1)
        self.assertEqual(modal.state, DialogState.TELETYPING)
        self.assertEqual(self.mock_audio.play_sfx.call_count, 2)
        self.assertIsNotNone(modal._tty_handle)

        # Skip Page 2 with Enter
        modal.advance_or_act()
        self.assertEqual(self.mock_audio.stop_sfx.call_count, 2)
        self.assertIsNone(modal._tty_handle)
        self.assertEqual(modal.state, DialogState.FINISHED)

    def test_empty_dialogue_does_not_play_sfx(self):
        """An empty dialogue string must not start the SFX loop."""
        self.npc.dialogue = ""
        modal = NPCDialogModal(
            screen_width=54,
            screen_height=27,
            audio_engine=self.mock_audio,
        )

        modal.start_dialog(self.npc)
        self.mock_audio.play_sfx.assert_not_called()
        self.assertIsNone(modal._tty_handle)

    def test_custom_sfx_asset_and_volume(self):
        """Custom asset and volume settings must be passed directly to play_sfx."""
        modal = NPCDialogModal(
            screen_width=54,
            screen_height=27,
            chars_per_second=1.0,
            audio_engine=self.mock_audio,
            sfx_asset="Resources/SFX/CustomTty.mp3",
            sfx_volume=0.25,
        )

        modal.start_dialog(self.npc)
        self.mock_audio.play_sfx.assert_called_once_with(
            name_or_path="Resources/SFX/CustomTty.mp3",
            loop=True,
            volume=0.25,
        )


if __name__ == "__main__":
    unittest.main()
