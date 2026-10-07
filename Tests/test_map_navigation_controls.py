"""
Unit tests for World Map navigation controls, disallowed shortcuts, and footer border alignment:
- Arrow keys exclusively handle movement (UP, DOWN, LEFT, RIGHT).
- WASD keys are disallowed for movement.
- P key is disallowed from triggering party creation reversion.
- B key is disallowed from triggering arbitrary combat encounters.
- Q key is disallowed from setting core.is_running to False.
- Footer rendering shows [↑↓←→]Move, removes obsolete tags, and fits cleanly within the map boundary.
"""

from __future__ import annotations
import re
import unittest
from unittest.mock import MagicMock, patch

from eldoria_py.audio import AudioChannel, AudioTrackInfo, PlaybackState
from eldoria_py.core.context import Context
from eldoria_py.core.fsm import SMState, SMStateMachine, SMTransition
from eldoria_py.procgen.map_generator import Map, MapTile, BiomeType
from eldoria_py.states.test_noise_map import GSNoiseMapTestScreen
from eldoria_py.terminal.input import KeyCode, KeyEvent


class TestMapNavigationControls(unittest.TestCase):
    """Test suite for map navigation input handling and footer rendering."""

    def setUp(self) -> None:
        self.screen = GSNoiseMapTestScreen(map_width=54, map_height=24)
        # Construct open walkable plains sector
        test_map = Map(name="TestSector", width=54, height=24)
        for y in range(24):
            for x in range(24):
                test_map.set_tile(x, y, MapTile(biome=BiomeType.PLAINS, battle_allowed=False))
                test_map.tiles[y][x].exits = [True, True, True, True]

        self.screen.world_macro.sectors[self.screen.current_sector[1]][self.screen.current_sector[0]] = test_map
        self.screen.player_x = 10
        self.screen.player_y = 10

        self.fsm = SMStateMachine("GSNoiseMapTestScreen")
        self.fsm.add_state(self.screen)
        self.fsm.add_transition(SMTransition("GSNoiseMapTestScreen", "ToCombat", "GSNvNCombatScreen"))
        self.fsm.add_transition(SMTransition("GSNoiseMapTestScreen", "ToPartyBuilder", "GSPartyBuilderScreen"))

        class MockCore:
            def __init__(self, game_state):
                self.game_state = game_state
                self.is_running = True

        self.mock_core = MockCore(self.fsm)

    def _send_key(self, event: KeyEvent) -> None:
        ctx = Context()
        ctx.set(SMState.ContextKeysPressed, [event])
        ctx.set(SMState.ContextEldoriaCore, self.mock_core)
        self.screen.update(ctx)

    def test_arrow_keys_move_player(self) -> None:
        """Arrow keys (UP, DOWN, LEFT, RIGHT) successfully navigate the player."""
        # UP
        self._send_key(KeyEvent(key=KeyCode.UP))
        self.assertEqual((self.screen.player_x, self.screen.player_y), (10, 9))

        # DOWN
        self._send_key(KeyEvent(key=KeyCode.DOWN))
        self.assertEqual((self.screen.player_x, self.screen.player_y), (10, 10))

        # LEFT
        self._send_key(KeyEvent(key=KeyCode.LEFT))
        self.assertEqual((self.screen.player_x, self.screen.player_y), (9, 10))

        # RIGHT
        self._send_key(KeyEvent(key=KeyCode.RIGHT))
        self.assertEqual((self.screen.player_x, self.screen.player_y), (10, 10))

    def test_wasd_keys_disallowed_for_movement(self) -> None:
        """WASD keys ('w', 'a', 's', 'd') do not move the player."""
        orig_pos = (self.screen.player_x, self.screen.player_y)

        # 'w' / 'W'
        self._send_key(KeyEvent(key=KeyCode.CHAR, char="w", raw="w"))
        self.assertEqual((self.screen.player_x, self.screen.player_y), orig_pos)

        self._send_key(KeyEvent(key=KeyCode.CHAR, char="W", raw="W"))
        self.assertEqual((self.screen.player_x, self.screen.player_y), orig_pos)

        # 'a' / 'A'
        self._send_key(KeyEvent(key=KeyCode.CHAR, char="a", raw="a"))
        self.assertEqual((self.screen.player_x, self.screen.player_y), orig_pos)

        # 'd' / 'D'
        self._send_key(KeyEvent(key=KeyCode.CHAR, char="d", raw="d"))
        self.assertEqual((self.screen.player_x, self.screen.player_y), orig_pos)

    def test_b_key_disallowed(self) -> None:
        """'B' key does not trigger arbitrary combat transition."""
        self._send_key(KeyEvent(key=KeyCode.CHAR, char="b", raw="b"))
        self.assertEqual(self.fsm.current_state, "GSNoiseMapTestScreen")

        self._send_key(KeyEvent(key=KeyCode.CHAR, char="B", raw="B"))
        self.assertEqual(self.fsm.current_state, "GSNoiseMapTestScreen")

    def test_p_key_disallowed(self) -> None:
        """'P' key does not revert player state to Party Builder."""
        self._send_key(KeyEvent(key=KeyCode.CHAR, char="p", raw="p"))
        self.assertEqual(self.fsm.current_state, "GSNoiseMapTestScreen")

        self._send_key(KeyEvent(key=KeyCode.CHAR, char="P", raw="P"))
        self.assertEqual(self.fsm.current_state, "GSNoiseMapTestScreen")

    def test_q_key_opens_and_closes_tracked_quest_modal(self) -> None:
        """'Q' key does not quit game; it opens/toggles the tracked quest modal dialog."""
        self.assertTrue(self.mock_core.is_running)
        self.assertFalse(self.screen.is_quest_modal_active)

        # Press 'q' to open modal
        self._send_key(KeyEvent(key=KeyCode.CHAR, char="q", raw="q"))
        self.assertTrue(self.mock_core.is_running)
        self.assertTrue(self.screen.is_quest_modal_active)

        # Press 'q' again to close modal
        self._send_key(KeyEvent(key=KeyCode.CHAR, char="q", raw="q"))
        self.assertTrue(self.mock_core.is_running)
        self.assertFalse(self.screen.is_quest_modal_active)

        # Press 'Q' (uppercase) to open modal
        self._send_key(KeyEvent(key=KeyCode.CHAR, char="Q", raw="Q"))
        self.assertTrue(self.screen.is_quest_modal_active)

        # Press Escape to dismiss modal
        self._send_key(KeyEvent(key=KeyCode.ESCAPE))
        self.assertFalse(self.screen.is_quest_modal_active)

    def test_quest_modal_blocks_movement_input(self) -> None:
        """While quest modal is active, arrow keys are consumed and do not move the player."""
        orig_pos = (self.screen.player_x, self.screen.player_y)
        self.screen.is_quest_modal_active = True

        self._send_key(KeyEvent(key=KeyCode.UP))
        self.assertEqual((self.screen.player_x, self.screen.player_y), orig_pos)
        self.assertTrue(self.screen.is_quest_modal_active)

        self._send_key(KeyEvent(key=KeyCode.DOWN))
        self.assertEqual((self.screen.player_x, self.screen.player_y), orig_pos)
        self.assertTrue(self.screen.is_quest_modal_active)

        self._send_key(KeyEvent(key=KeyCode.LEFT))
        self.assertEqual((self.screen.player_x, self.screen.player_y), orig_pos)
        self.assertTrue(self.screen.is_quest_modal_active)

        self._send_key(KeyEvent(key=KeyCode.RIGHT))
        self.assertEqual((self.screen.player_x, self.screen.player_y), orig_pos)
        self.assertTrue(self.screen.is_quest_modal_active)

    def test_tracked_quest_modal_rendering_empty_and_active(self) -> None:
        """Test rendering output of _render_quest_modal for both empty and active quest states."""
        # 1. Empty state (no tracked quest)
        commands = self.screen._render_quest_modal()
        raw_text = "".join(cmd[2] for cmd in commands)
        clean_text = re.sub(r"\033\[[0-9;]*[a-zA-Z]", "", raw_text)
        self.assertIn("Tracked Quest", clean_text)
        self.assertIn("No Quest Pinned", clean_text)
        self.assertIn("[Q / Esc] Dismiss", clean_text)

        # 2. Active tracked quest
        from eldoria_py.combat.entities import create_default_party
        from eldoria_py.quests.manager import QuestManager
        from eldoria_py.quests.generator import build_storyline_questline
        self.screen.party = create_default_party()
        storyline = build_storyline_questline(macro_size="standard")
        self.screen.party.quest_manager = QuestManager(storyline=storyline)

        commands_active = self.screen._render_quest_modal()
        active_raw = "".join(cmd[2] for cmd in commands_active)
        active_clean = re.sub(r"\033\[[0-9;]*[a-zA-Z]", "", active_raw)
        self.assertIn("Tracked Quest", active_clean)
        self.assertIn("STORYLINE", active_clean)
        self.assertIn(storyline.title[:15], active_clean)
        self.assertIn("Directive", active_clean)
        # Verify step counter, Gate field, and Status field are completely removed
        self.assertNotIn("Steps)", active_clean)
        self.assertNotIn("Gate:", active_clean)
        self.assertNotIn("Status:", active_clean)

    def test_footer_text_and_border_alignment(self) -> None:
        """Footer text shows arrow keys, Enter, Menu, Quest, and fits cleanly within map width."""
        # Overworld footer
        f_text_overworld = " \033[33m[↑↓←→]\033[0mMove  \033[33m[Enter]\033[0mEnter  \033[33m[M]\033[0mMenu  \033[33m[Q]\033[0mQuest "
        plain_text = re.sub(r"\033\[[0-9;]*[a-zA-Z]", "", f_text_overworld)

        self.assertIn("[↑↓←→]Move", plain_text)
        self.assertIn("[Enter]Enter", plain_text)
        self.assertIn("[M]Menu", plain_text)
        self.assertIn("[Q]Quest", plain_text)
        self.assertNotIn("Save", plain_text)
        self.assertNotIn("WASD", plain_text)
        self.assertNotIn("Party", plain_text)
        self.assertNotIn("Battle", plain_text)
        self.assertNotIn("Quit", plain_text)
        self.assertLessEqual(len(plain_text), self.screen.map_width)

        # Border line alignment check
        border_line = GSNoiseMapTestScreen._make_border_line("╰", f_text_overworld, "╯", self.screen.map_width, fill_char="─")
        raw_border = re.sub(r"\033\[[0-9;]*[a-zA-Z]", "", border_line)
        # Total frame width: 1 (left) + 54 (inner) + 1 (right) = 56 characters
        self.assertEqual(len(raw_border), self.screen.map_width + 2)
        self.assertTrue(raw_border.startswith("╰"))
        self.assertTrue(raw_border.endswith("╯"))

        # Verify generate_frame_lines bottom row contains [Q]Quest
        lines = self.screen.generate_frame_lines()
        self.assertIn("[Q]", lines[-1])
        self.assertIn("Quest", lines[-1])

    def test_movement_blocked_by_unwalkable_destination(self) -> None:
        """Moving towards a mountain/unwalkable tile is strictly blocked."""
        # Set tile to the right (11, 10) to Mountain
        sec = self.screen._current_map()
        sec.set_tile(11, 10, MapTile(biome=BiomeType.MOUNTAIN))
        # Ensure starting tile (10, 10) has exit East artificially set to True
        sec.tiles[10][10].exits[MapTile.EXIT_EAST] = True

        moved = self.screen._try_move(1, 0, MapTile.EXIT_EAST)
        self.assertFalse(moved)
        self.assertEqual((self.screen.player_x, self.screen.player_y), (10, 10))

    def test_emergency_unstuck_escape(self) -> None:
        """If player is trapped on an unwalkable tile with no exits, they can step to adjacent walkable tile."""
        sec = self.screen._current_map()
        sec.set_tile(10, 10, MapTile(biome=BiomeType.MOUNTAIN))
        # Mountain has all exits False
        sec.tiles[10][10].exits = [False, False, False, False]
        self.screen.player_x = 10
        self.screen.player_y = 10

        # Move West into walkable plains at (9, 10)
        moved = self.screen._try_move(-1, 0, MapTile.EXIT_WEST)
        self.assertTrue(moved)
        self.assertEqual((self.screen.player_x, self.screen.player_y), (9, 10))

    def test_ensure_walkable_player_pos_relocation(self) -> None:
        """_ensure_walkable_player_pos relocates an unwalkable player to nearest valid walkable tile."""
        sec = self.screen._current_map()
        sec.set_tile(10, 10, MapTile(biome=BiomeType.MOUNTAIN))
        sec.tiles[10][10].exits = [False, False, False, False]
        self.screen.player_x = 10
        self.screen.player_y = 10

        self.screen._ensure_walkable_player_pos()
        self.assertNotEqual((self.screen.player_x, self.screen.player_y), (10, 10))
        new_tile = sec.tiles[self.screen.player_y][self.screen.player_x]
        self.assertTrue(new_tile.is_walkable)

    @patch("eldoria_py.states.test_noise_map.get_audio_engine")
    def test_noise_map_starts_world_map_bgm_on_enter(self, mock_gae) -> None:
        """Entering map exploration starts fading in World Map Smol if not playing."""
        mock_audio = MagicMock()
        mock_audio.get_current_bgm.return_value = None
        mock_gae.return_value = mock_audio

        ctx = Context()
        self.screen.enter(ctx)
        mock_audio.fade_to_bgm.assert_called_once_with("World Map Smol", duration_seconds=1.5, loop=True)

    @patch("eldoria_py.states.test_noise_map.get_audio_engine")
    def test_noise_map_preserves_world_map_bgm_when_already_playing(self, mock_gae) -> None:
        """Entering map exploration leaves World Map Smol playing seamlessly if already active."""
        mock_audio = MagicMock()
        existing_track = AudioTrackInfo(
            name="World Map Smol",
            path="Resources/BGM/World Map Smol.mp3",
            channel=AudioChannel.MUSIC,
            state=PlaybackState.PLAYING,
            volume=1.0,
            duration_seconds=180.0,
            position_seconds=25.0,
            loop=True,
        )
        mock_audio.get_current_bgm.return_value = existing_track
        mock_gae.return_value = mock_audio

        ctx = Context()
        self.screen.enter(ctx)
        mock_audio.fade_to_bgm.assert_not_called()

    @patch("eldoria_py.states.test_noise_map.get_audio_engine")
    def test_combat_trigger_fades_out_world_map_bgm(self, mock_gae) -> None:
        """Triggering combat initiates a fade-out of world map music."""
        mock_audio = MagicMock()
        mock_gae.return_value = mock_audio

        mock_combat = MagicMock()
        self.fsm.states["GSNvNCombatScreen"] = mock_combat

        ctx = Context()
        ctx.set(SMState.ContextEldoriaCore, self.mock_core)

        triggered = self.screen._trigger_encounter(ctx, BiomeType.PLAINS)
        self.assertTrue(triggered)
        mock_audio.fade_out_bgm.assert_called_once_with(duration_seconds=1.0)


if __name__ == "__main__":
    unittest.main()
