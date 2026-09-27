"""
Unit and integration tests for Save/Load UI workflows (Phase 4):
- Title Screen interactive 3-slot load picker and slot deletion.
- Party Builder embark modal for world size & save slot configuration.
- Overworld in-game [S]Save shortcut removed; saves routed via Main Menu.
- Inn rest and save integration.
"""

from __future__ import annotations
import os
import shutil
import tempfile
import unittest
from unittest.mock import MagicMock

from eldoria_py.combat.entities import Party, PartyMember, create_default_party
from eldoria_py.combat.portrait import Gender
from eldoria_py.combat.stats import BattleActionType, StatId
from eldoria_py.core.context import Context
from eldoria_py.core.fsm import SMState
from eldoria_py.core.save_manager import SaveManager
from eldoria_py.procgen.map_generator import MapTile
from eldoria_py.states.party_builder import GSPartyBuilderScreen
from eldoria_py.states.test_noise_map import GSNoiseMapTestScreen
from eldoria_py.states.title_screen import GSTitleScreen
from eldoria_py.terminal.input import KeyCode, KeyEvent


class TestSaveLoadUI(unittest.TestCase):
    """Test suite for Phase 4 UI workflows."""

    def setUp(self) -> None:
        self.temp_dir = tempfile.mkdtemp(prefix="eldoria_ui_test_saves_")
        self.context = Context()
        self.mock_core = MagicMock()
        self.mock_game_state = MagicMock()
        self.mock_core.game_state = self.mock_game_state
        self.mock_core.is_running = True
        self.context.set(SMState.ContextEldoriaCore, self.mock_core)

        # Custom SaveManager targeting temp directory
        self.save_manager = SaveManager(save_dir=self.temp_dir)

        # Create sample save in slot 1
        sample_member = PartyMember(
            name="Valerius",
            job_class="Paladin",
            level=3,
            gender=Gender.MALE,
            affinity=BattleActionType.ELEMENTAL_LIGHT,
        )
        sample_party = Party(members=[sample_member], gold=500)
        self.world_macro, self.exp_state = self.save_manager.create_new_game(
            slot_idx=1,
            party=sample_party,
            macro_size="small",
            seed=42,
        )

    def tearDown(self) -> None:
        shutil.rmtree(self.temp_dir, ignore_errors=True)

    def test_title_screen_load_game_ui(self) -> None:
        """Verify Title Screen Load Game modal navigates slots, loads game, and supports deletion."""
        title = GSTitleScreen(screen_width=80, screen_height=24)
        title.save_manager = self.save_manager

        # Open Load Game dialog
        title._execute_menu_action("Load Game")
        self.assertEqual(title.active_dialog, "LOAD")
        self.assertEqual(title.load_slot_idx, 0)
        self.assertIsNotNone(title.load_headers[0])
        self.assertIsNone(title.load_headers[1])
        self.assertIsNone(title.load_headers[2])

        # Navigate slots with Down arrow
        title._handle_input(KeyEvent(key=KeyCode.DOWN), self.context, self.mock_core)
        self.assertEqual(title.load_slot_idx, 1)

        # Direct selection with key '1'
        title._handle_input(KeyEvent(key=KeyCode.CHAR, char="1"), self.context, self.mock_core)
        self.assertEqual(title.load_slot_idx, 0)

        # Mock GSNoiseMapTestScreen in game_state
        mock_map_screen = MagicMock()
        self.mock_game_state.states = {"GSNoiseMapTestScreen": mock_map_screen}

        # Press Enter to load Slot 1
        title._handle_input(KeyEvent(key=KeyCode.ENTER, char="\r"), self.context, self.mock_core)
        self.assertIsNone(title.active_dialog)
        self.mock_game_state.trigger.assert_called_once_with("ToNoiseMap", self.context)
        self.assertEqual(self.context.get("active_slot"), 1)
        loaded_party = self.context.get("party")
        self.assertEqual(loaded_party.members[0].name, "Valerius")

    def test_title_screen_slot_deletion(self) -> None:
        """Verify slot deletion confirmation and execution on Title Screen."""
        title = GSTitleScreen(screen_width=80, screen_height=24)
        title.save_manager = self.save_manager
        title._execute_menu_action("Load Game")

        # Press D on Slot 1
        title._handle_input(KeyEvent(key=KeyCode.CHAR, char="d"), self.context, self.mock_core)
        self.assertEqual(title.delete_confirm_slot, 1)

        # Press N to cancel
        title._handle_input(KeyEvent(key=KeyCode.CHAR, char="n"), self.context, self.mock_core)
        self.assertIsNone(title.delete_confirm_slot)
        self.assertIsNotNone(title.load_headers[0])

        # Press D then Y to confirm delete
        title._handle_input(KeyEvent(key=KeyCode.CHAR, char="d"), self.context, self.mock_core)
        title._handle_input(KeyEvent(key=KeyCode.CHAR, char="y"), self.context, self.mock_core)
        self.assertIsNone(title.delete_confirm_slot)
        self.assertIsNone(title.load_headers[0])
        self.assertFalse(self.save_manager.get_slot_dir(1).exists())

    def test_party_builder_embark_modal_flow(self) -> None:
        """Verify Party Builder Embark modal: choosing size, slot, and creating save."""
        builder = GSPartyBuilderScreen(screen_width=80, screen_height=24)
        builder.save_manager = self.save_manager
        builder.auto_fill_templates()

        mock_map_screen = MagicMock()
        self.mock_game_state.states = {"GSNoiseMapTestScreen": mock_map_screen}

        # Press Space to initiate Embark
        builder._handle_input(KeyEvent(key=KeyCode.SPACE, char=" "), self.context, self.mock_core)
        self.assertEqual(builder.embark_modal_step, 1)

        # Step 1: Select Standard World (key '2')
        builder._handle_input(KeyEvent(key=KeyCode.CHAR, char="2"), self.context, self.mock_core)
        self.assertEqual(builder.selected_world_size, "standard")
        self.assertEqual(builder.embark_modal_step, 2)

        # Step 2: Select Slot 2 (key '2')
        builder._handle_input(KeyEvent(key=KeyCode.CHAR, char="2"), self.context, self.mock_core)
        self.assertIsNone(builder.embark_modal_step)
        self.mock_game_state.trigger.assert_called_once_with("ToNoiseMap", self.context)
        self.assertEqual(self.context.get("active_slot"), 2)

        # Check saved files exist on disk for slot 2
        slot2_dir = self.save_manager.get_slot_dir(2)
        self.assertTrue((slot2_dir / "world.map").is_file())
        self.assertTrue((slot2_dir / "state.sav").is_file())
        self.assertTrue((slot2_dir / "header.json").is_file())

    def test_overworld_save_shortcut_removed(self) -> None:
        """Verify [S]Save shortcut is removed from navigation screen and pressing S does not save."""
        map_screen = GSNoiseMapTestScreen(map_width=54, map_height=24)
        map_screen.save_manager = self.save_manager
        map_screen.world_macro = self.world_macro
        map_screen.active_slot = 1
        map_screen.current_sector = (1, 1)
        map_screen.player_x = 10
        map_screen.player_y = 12

        # Press S on navigation screen
        map_screen.update(self.context)  # Clear initial
        self.context.set(SMState.ContextKeysPressed, [KeyEvent(key=KeyCode.CHAR, char="s")])
        map_screen.update(self.context)

        # Confirm no save modal exists and no save was written
        self.assertFalse(hasattr(map_screen, "save_modal_open"))
        self.assertEqual(map_screen.last_status_msg, "")
        slot3_dir = self.save_manager.get_slot_dir(3)
        self.assertFalse((slot3_dir / "state.sav").is_file())

    def test_inn_rest_and_save(self) -> None:
        """Verify resting at an Inn fully heals party and auto-saves progress."""
        map_screen = GSNoiseMapTestScreen(map_width=54, map_height=24)
        map_screen.save_manager = self.save_manager
        map_screen.world_macro = self.world_macro
        map_screen.active_slot = 1

        # Injure party
        for m in map_screen.party.members:
            m.stats[StatId.HIT_POINTS].current = 10
            m.stats[StatId.MAGIC_POINTS].current = 5

        # Place player on an Inn tile
        curr_map = map_screen._current_map()
        curr_map.tiles[map_screen.player_y][map_screen.player_x].object_listing.append("MTOInn")

        # Interact (Press Enter)
        self.context.set(SMState.ContextKeysPressed, [KeyEvent(key=KeyCode.ENTER, char="\r")])
        map_screen.update(self.context)

        # Check full HP/MP
        for m in map_screen.party.members:
            self.assertEqual(m.hp, m.max_hp)
            self.assertEqual(m.mp, m.max_mp)

        self.assertIn("Rested at Oakhaven Inn", map_screen.last_status_msg)
        self.assertIn("saved to Slot 1", map_screen.last_status_msg)

    def test_loaded_game_player_movement(self) -> None:
        """Verify that loading any saved game correctly populates tile exits and allows movement."""
        loaded_party, loaded_macro, loaded_state = self.save_manager.load_game(1)
        map_screen = GSNoiseMapTestScreen(map_width=54, map_height=24)

        ctx = Context()
        ctx.set("party", loaded_party)
        ctx.set("world_macro", loaded_macro)
        ctx.set("exploration_state", loaded_state)
        ctx.set("active_slot", 1)

        map_screen.enter(ctx)

        curr_tile = map_screen._current_map().tiles[map_screen.player_y][map_screen.player_x]
        self.assertTrue(curr_tile.is_walkable)
        self.assertNotEqual(curr_tile.exits, [False, False, False, False], "Loaded tile must have valid cardinal exits.")

        # Find a valid exit direction
        start_x, start_y = map_screen.player_x, map_screen.player_y
        valid_key = None
        if curr_tile.exits[0]:  # North
            valid_key = KeyCode.UP
        elif curr_tile.exits[1]:  # South
            valid_key = KeyCode.DOWN
        elif curr_tile.exits[2]:  # East
            valid_key = KeyCode.RIGHT
        elif curr_tile.exits[3]:  # West
            valid_key = KeyCode.LEFT

        self.assertIsNotNone(valid_key, "Player must have at least one valid movement direction.")

        # Send movement key
        ctx.set(SMState.ContextKeysPressed, [KeyEvent(key=valid_key)])
        map_screen.update(ctx)

        new_pos = (map_screen.player_x, map_screen.player_y)
        self.assertNotEqual((start_x, start_y), new_pos, "Player position must update when moving on loaded game.")

    def test_loaded_game_submap_restoration_and_egress(self) -> None:
        """Verify saving inside a submap restores the submap on load and allows movement and egress."""
        # 1. Enter Oakhaven Town submap and save at Inn
        town_poi = self.world_macro.get_poi("Oakhaven Town")
        self.assertIsNotNone(town_poi)

        exp_state = {
            "current_sector": list(town_poi.sector_coord),
            "player_pos": [27, 19],
            "current_map_name": town_poi.name,
            "active_submap_poi": town_poi.name,
            "visited_sectors": [list(town_poi.sector_coord)],
            "flags": {},
        }
        self.save_manager.save_game(
            slot_idx=2,
            party=Party(members=[PartyMember(name="Hero", job_class="Warrior")]),
            exploration_state=exp_state,
            world_macro=self.world_macro,
        )

        # 2. Load Slot 2
        loaded_party, loaded_macro, loaded_state = self.save_manager.load_game(2)
        map_screen = GSNoiseMapTestScreen(map_width=54, map_height=24)

        ctx = Context()
        ctx.set("party", loaded_party)
        ctx.set("world_macro", loaded_macro)
        ctx.set("exploration_state", loaded_state)
        ctx.set("active_slot", 2)

        map_screen.enter(ctx)

        # Verify active_submap and active_poi are restored
        self.assertIsNotNone(map_screen.active_submap)
        self.assertIsNotNone(map_screen.active_poi)
        self.assertEqual(map_screen.active_poi.name, "Oakhaven Town")
        self.assertEqual((map_screen.player_x, map_screen.player_y), (27, 19))

        # Check movement inside submap
        sub_tile = map_screen.active_submap.tiles[19][27]
        self.assertTrue(sub_tile.is_walkable)
        self.assertNotEqual(sub_tile.exits, [False, False, False, False])

        # Walk to southern egress gate at (27, 23)
        map_screen.player_x = 27
        map_screen.player_y = 23
        map_screen._handle_interact()

        # Verify returned to Overworld at town coordinates
        self.assertIsNone(map_screen.active_submap)
        self.assertIsNone(map_screen.active_poi)
        self.assertEqual(map_screen.current_sector, town_poi.sector_coord)
        self.assertEqual((map_screen.player_x, map_screen.player_y), town_poi.local_pos)


if __name__ == "__main__":
    unittest.main()
