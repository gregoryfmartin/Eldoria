"""
Unit tests for SaveManager: slot isolation, atomic writes, immutable map caching, and loading.
"""

from __future__ import annotations
import os
from pathlib import Path
import shutil
import tempfile
import time
import unittest

from eldoria_py.combat.entities import Party, PartyMember
from eldoria_py.combat.portrait import Gender
from eldoria_py.combat.stats import BattleActionType
from eldoria_py.core.save_manager import SaveManager, SaveSlotHeader
from eldoria_py.procgen.world_macro import WorldMacroMap


class TestSaveManager(unittest.TestCase):
    """Test suite for SaveManager service."""

    def setUp(self) -> None:
        self.temp_dir = tempfile.mkdtemp(prefix="eldoria_saves_test_")
        self.save_manager = SaveManager(save_dir=self.temp_dir)

        # Create a sample party
        self.member1 = PartyMember(
            name="Aiden",
            job_class="Guardian",
            gender=Gender.MALE,
            affinity=BattleActionType.ELEMENTAL_LIGHT,
        )
        self.party = Party(members=[self.member1], gold=250)

    def tearDown(self) -> None:
        shutil.rmtree(self.temp_dir, ignore_errors=True)

    def test_list_empty_slots(self) -> None:
        """Verify listing slots on fresh folder returns all None."""
        slots = self.save_manager.list_save_slots(max_slots=3)
        self.assertEqual(len(slots), 3)
        self.assertIsNone(slots[0])
        self.assertIsNone(slots[1])
        self.assertIsNone(slots[2])

    def test_create_new_game_and_load(self) -> None:
        """Verify creating a new game writes all 3 files and loads back accurately."""
        world_macro, exploration_state = self.save_manager.create_new_game(
            slot_idx=1,
            party=self.party,
            macro_size="small",
            seed=42,
        )

        slot_dir = self.save_manager.get_slot_dir(1)
        self.assertTrue((slot_dir / "header.json").is_file())
        self.assertTrue((slot_dir / "state.sav").is_file())
        self.assertTrue((slot_dir / "world.map").is_file())

        # Inspect headers
        slots = self.save_manager.list_save_slots(3)
        header1 = slots[0]
        self.assertIsNotNone(header1)
        self.assertEqual(header1.party_leader_name, "Aiden")
        self.assertEqual(header1.world_size_label, "Quick")
        self.assertEqual(header1.macro_width, 6)

        # Load game
        loaded_party, loaded_macro, loaded_state = self.save_manager.load_game(1)
        self.assertEqual(loaded_party.gold, 250)
        self.assertEqual(len(loaded_party.members), 1)
        self.assertEqual(loaded_party.members[0].name, "Aiden")

        self.assertEqual(loaded_macro.macro_width, 6)
        self.assertEqual(loaded_macro.macro_height, 6)
        self.assertEqual(loaded_macro.starter_sector, world_macro.starter_sector)
        self.assertEqual(loaded_state["current_sector"], list(world_macro.starter_sector))

    def test_save_game_immutability_of_world_map(self) -> None:
        """Verify routine save updates state and header but leaves world.map untouched."""
        world_macro, exp_state = self.save_manager.create_new_game(
            slot_idx=2,
            party=self.party,
            macro_size="small",
            seed=1337,
        )

        slot_dir = self.save_manager.get_slot_dir(2)
        world_map_path = slot_dir / "world.map"
        world_map_mtime = world_map_path.stat().st_mtime

        time.sleep(0.05)  # Ensure time advance

        # Modify state
        self.party.gold = 999
        exp_state["current_sector"] = [2, 3]
        exp_state["current_map_name"] = "Overworld"

        self.save_manager.save_game(
            slot_idx=2,
            party=self.party,
            exploration_state=exp_state,
            playtime_seconds=125,
            world_macro=world_macro,
        )

        # World map mtime should be strictly unchanged
        self.assertEqual(world_map_path.stat().st_mtime, world_map_mtime)

        # Check updated header and state
        header = self.save_manager.list_save_slots(3)[1]
        self.assertIsNotNone(header)
        self.assertEqual(header.playtime_seconds, 125)
        self.assertEqual(header.current_location, "Overworld (2, 3)")

        loaded_party, _, loaded_state = self.save_manager.load_game(2)
        self.assertEqual(loaded_party.gold, 999)
        self.assertEqual(loaded_state["current_sector"], [2, 3])

    def test_delete_slot(self) -> None:
        """Verify deleting slot clears directory and resets slot header to None."""
        self.save_manager.create_new_game(
            slot_idx=3,
            party=self.party,
            macro_size="small",
            seed=999,
        )
        self.assertIsNotNone(self.save_manager.list_save_slots(3)[2])

        deleted = self.save_manager.delete_slot(3)
        self.assertTrue(deleted)
        self.assertIsNone(self.save_manager.list_save_slots(3)[2])
        self.assertFalse(self.save_manager.get_slot_dir(3).exists())

    def test_save_game_copies_from_source_slot(self) -> None:
        """Verify saving to another slot with source_slot_idx copies world.map instantaneously."""
        world_macro, exp_state = self.save_manager.create_new_game(
            slot_idx=1,
            party=self.party,
            macro_size="small",
            seed=42,
        )

        slot1_map = self.save_manager.get_slot_dir(1) / "world.map"
        slot2_map = self.save_manager.get_slot_dir(2) / "world.map"
        self.assertTrue(slot1_map.is_file())
        self.assertFalse(slot2_map.is_file())

        t0 = time.perf_counter()
        self.save_manager.save_game(
            slot_idx=2,
            party=self.party,
            exploration_state=exp_state,
            playtime_seconds=60,
            world_macro=world_macro,
            source_slot_idx=1,
        )
        elapsed = time.perf_counter() - t0

        self.assertTrue(slot2_map.is_file())
        self.assertEqual(slot1_map.read_bytes(), slot2_map.read_bytes())
        # Copying should be well under 100ms
        self.assertLess(elapsed, 0.1)

    def test_save_game_copies_from_other_slot_fallback(self) -> None:
        """Verify saving to an empty slot without source_slot_idx discovers matching world.map in another slot."""
        world_macro, exp_state = self.save_manager.create_new_game(
            slot_idx=1,
            party=self.party,
            macro_size="small",
            seed=42,
        )

        slot1_map = self.save_manager.get_slot_dir(1) / "world.map"
        slot3_map = self.save_manager.get_slot_dir(3) / "world.map"
        self.assertTrue(slot1_map.is_file())
        self.assertFalse(slot3_map.is_file())

        self.save_manager.save_game(
            slot_idx=3,
            party=self.party,
            exploration_state=exp_state,
            playtime_seconds=90,
            world_macro=world_macro,
            source_slot_idx=None,
        )

        self.assertTrue(slot3_map.is_file())
        self.assertEqual(slot1_map.read_bytes(), slot3_map.read_bytes())

    def test_save_game_dimension_mismatch_overwrites_world_map(self) -> None:
        """Verify saving a world of different dimensions overwrites existing mismatched world.map."""
        # 1. Create a 4x4 game in slot 1
        wm_classic, exp_classic = self.save_manager.create_new_game(
            slot_idx=1,
            party=self.party,
            macro_size="classic",
            seed=101,
        )
        hdr1 = self.save_manager.list_save_slots(3)[0]
        self.assertEqual(hdr1.macro_width, 4)
        self.assertEqual(hdr1.world_size_label, "Classic")

        # 2. Create a 6x6 game in slot 2
        wm_quick, exp_quick = self.save_manager.create_new_game(
            slot_idx=2,
            party=self.party,
            macro_size="small",
            seed=202,
        )
        hdr2 = self.save_manager.list_save_slots(3)[1]
        self.assertEqual(hdr2.macro_width, 6)
        self.assertEqual(hdr2.world_size_label, "Quick")

        # 3. Save the 6x6 game over slot 1 (which previously had 4x4)
        self.save_manager.save_game(
            slot_idx=1,
            party=self.party,
            exploration_state=exp_quick,
            playtime_seconds=150,
            world_macro=wm_quick,
            source_slot_idx=2,
        )

        # 4. Slot 1 should now have 6x6 map and updated header
        hdr1_updated = self.save_manager.list_save_slots(3)[0]
        self.assertEqual(hdr1_updated.macro_width, 6)
        self.assertEqual(hdr1_updated.macro_height, 6)
        self.assertEqual(hdr1_updated.world_size_label, "Quick")
        _, loaded_macro, _ = self.save_manager.load_game(1)
        self.assertEqual(loaded_macro.macro_width, 6)


if __name__ == "__main__":
    unittest.main()
