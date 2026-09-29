"""
Unit tests for Map and Tile Serialization Completeness:
- Combat attributes (battle_allowed, region_code, encounter_rate) across biomes and sub-maps
- Background image asset persistence and overrides (e.g. FieldRoad)
- Authoritative exit state persistence: locked doors, one-way ledges, gate barriers
- POI object listing deduplication across save/load cycles
- Active step encounter triggering on loaded games
"""

from __future__ import annotations
import gzip
import json
from pathlib import Path
import shutil
import tempfile
import unittest

from eldoria_py.combat.entities import Party, PartyMember
from eldoria_py.combat.portrait import Gender
from eldoria_py.combat.stats import BattleActionType
from eldoria_py.core.context import Context
from eldoria_py.core.fsm import SMState
from eldoria_py.core.save_manager import SaveManager
from eldoria_py.procgen.map_generator import Map, MapTile, BiomeType, BIOME_CONFIGS
from eldoria_py.procgen.poi import POIType
from eldoria_py.procgen.submap_generator import SubMapGenerator
from eldoria_py.procgen.world_macro import WorldMacroMap
from eldoria_py.states.test_noise_map import GSNoiseMapTestScreen


class TestMapSerializationCompleteness(unittest.TestCase):
    """Test suite for comprehensive map and tile serialization/deserialization."""

    def setUp(self) -> None:
        self.temp_dir = tempfile.mkdtemp(prefix="eldoria_map_test_")
        self.save_manager = SaveManager(save_dir=self.temp_dir)
        self.member = PartyMember(
            name="Valen",
            job_class="Guardian",
            gender=Gender.MALE,
            affinity=BattleActionType.ELEMENTAL_LIGHT,
        )
        self.party = Party(members=[self.member], gold=500)

    def tearDown(self) -> None:
        shutil.rmtree(self.temp_dir, ignore_errors=True)

    def test_overworld_biome_combat_and_asset_roundtrip(self) -> None:
        """Verify that overworld sectors preserve combat properties and background textures."""
        world_macro, _ = self.save_manager.create_new_game(
            slot_idx=1,
            party=self.party,
            macro_size="quick",
            seed=1337,
        )

        _, loaded_macro, _ = self.save_manager.load_game(1)
        sx, sy = loaded_macro.starter_sector
        orig_sec = world_macro.sectors[sy][sx]
        loaded_sec = loaded_macro.sectors[sy][sx]

        # Verify all tiles in starter sector
        for y in range(loaded_sec.height):
            for x in range(loaded_sec.width):
                orig_t = orig_sec.tiles[y][x]
                load_t = loaded_sec.tiles[y][x]

                self.assertEqual(load_t.biome, orig_t.biome)
                self.assertEqual(load_t.battle_allowed, orig_t.battle_allowed)
                self.assertEqual(load_t.region_code, orig_t.region_code)
                self.assertAlmostEqual(load_t.encounter_rate, orig_t.encounter_rate, places=4)
                self.assertEqual(load_t.background_image, orig_t.background_image)

    def test_submap_cave_and_town_combat_overrides(self) -> None:
        """Verify that cave floors retain high danger (region 3) and town buildings retain safe status."""
        world_macro, _ = self.save_manager.create_new_game(
            slot_idx=2,
            party=self.party,
            macro_size="quick",
            seed=42,
        )
        _, loaded_macro, _ = self.save_manager.load_game(2)

        # 1. Cave Submap
        cave_poi = loaded_macro.get_poi(POIType.CAVE)
        self.assertIsNotNone(cave_poi)
        self.assertIsNotNone(cave_poi.sub_map)
        cave_floors = [
            t for row in cave_poi.sub_map.tiles
            for t in row if t.is_walkable and t.warp_target is None
        ]
        self.assertGreater(len(cave_floors), 0)
        orig_cave = world_macro.get_poi(POIType.CAVE)
        self.assertIsNotNone(orig_cave)
        orig_floors = [
            t for row in orig_cave.sub_map.tiles
            for t in row if t.is_walkable and t.warp_target is None
        ]
        expected_cave_region = orig_floors[0].region_code
        self.assertGreaterEqual(expected_cave_region, 1)
        for tile in cave_floors:
            self.assertTrue(tile.battle_allowed)
            self.assertEqual(tile.region_code, expected_cave_region)
            self.assertAlmostEqual(tile.encounter_rate, 0.20, places=4)

        # 2. Town Submap
        town_poi = loaded_macro.get_poi(POIType.TOWN)
        self.assertIsNotNone(town_poi)
        self.assertIsNotNone(town_poi.sub_map)
        for row in town_poi.sub_map.tiles:
            for tile in row:
                self.assertFalse(tile.battle_allowed)
                self.assertEqual(tile.encounter_rate, 0.0)
                self.assertEqual(tile.region_code, 0)

    def test_locked_door_and_one_way_exit_retention(self) -> None:
        """Verify locked doors, one-way ledges, and gate barriers remain strictly intact after loading."""
        test_map = Map(name="DungeonLevel1", width=10, height=10)
        for y in range(10):
            for x in range(10):
                test_map.set_tile(x, y, MapTile(biome=BiomeType.ROAD, battle_allowed=True))

        # Tile (3, 3): Locked door (all exits blocked)
        test_map.tiles[3][3].exits = [False, False, False, False]

        # Tile (5, 5): One-way ledge (can only jump South)
        test_map.tiles[5][5].exits = [False, True, False, False]

        # Tile (5, 6): Directly beneath ledge (cannot climb North back up)
        test_map.tiles[6][5].exits = [False, True, True, True]

        # Compact round-trip
        data = test_map.to_compact_dict()
        hydrated_map = Map.from_compact_dict(data)

        # Verify locked door
        locked_tile = hydrated_map.tiles[3][3]
        self.assertEqual(locked_tile.exits, [False, False, False, False])

        # Verify one-way ledge
        ledge_tile = hydrated_map.tiles[5][5]
        self.assertEqual(ledge_tile.exits, [False, True, False, False])

        # Verify lower tile cannot exit North
        lower_tile = hydrated_map.tiles[6][5]
        self.assertFalse(lower_tile.exits[MapTile.EXIT_NORTH])
        self.assertTrue(lower_tile.exits[MapTile.EXIT_SOUTH])

    def test_poi_object_listing_deduplication_across_cycles(self) -> None:
        """Verify repeated save/load cycles do not duplicate POI tags in object_listing."""
        world_macro, exp_state = self.save_manager.create_new_game(
            slot_idx=3,
            party=self.party,
            macro_size="quick",
            seed=999,
        )

        poi = world_macro.get_poi(POIType.TOWN)
        tx, ty = poi.local_pos
        sx, sy = poi.sector_coord

        for cycle in range(5):
            loaded_party, loaded_macro, loaded_exp = self.save_manager.load_game(3)
            sec = loaded_macro.sectors[sy][sx]
            poi_tags = [o for o in sec.tiles[ty][tx].object_listing if o.startswith("POI:")]
            self.assertEqual(len(poi_tags), 1, f"Cycle {cycle + 1} produced duplicate tags: {poi_tags}")

            # Re-save to the same slot
            self.save_manager.save_game(
                slot_idx=3,
                party=loaded_party,
                exploration_state=loaded_exp,
                world_macro=loaded_macro,
            )

    def test_random_encounters_trigger_on_loaded_game(self) -> None:
        """Verify that a game loaded from disk actively rolls random combat encounters."""
        world_macro, exp_state = self.save_manager.create_new_game(
            slot_idx=4,
            party=self.party,
            macro_size="quick",
            seed=2024,
        )
        loaded_party, loaded_macro, loaded_exp = self.save_manager.load_game(4)

        screen = GSNoiseMapTestScreen()
        screen.world_macro = loaded_macro
        screen.current_sector = tuple(loaded_exp["current_sector"])
        screen.party = loaded_party

        # Ensure player is on a non-warp walkable battle tile
        sx, sy = screen.current_sector
        sec = loaded_macro.sectors[sy][sx]
        target_pos = None
        for y in range(sec.height):
            for x in range(sec.width):
                t = sec.tiles[y][x]
                if t.is_walkable and t.warp_target is None and t.battle_allowed:
                    target_pos = (x, y)
                    break
            if target_pos:
                break
        self.assertIsNotNone(target_pos)
        screen.player_x, screen.player_y = target_pos

        class DummyCombatState:
            def __init__(self):
                self.calls = 0

            def start_encounter(self, party, squad):
                self.calls += 1

        combat_state = DummyCombatState()

        class DummyGameState:
            def __init__(self, cs):
                self.states = {"GSNvNCombatScreen": cs}

            def trigger(self, event, context):
                pass

        class DummyCore:
            def __init__(self, cs):
                self.game_state = DummyGameState(cs)

        ctx = Context()
        ctx.set(SMState.ContextEldoriaCore, DummyCore(combat_state))

        # Simulate 100 steps on loaded map beyond grace period
        encounters = 0
        for _ in range(100):
            screen.steps_since_battle = 10
            if screen._check_step_encounter(ctx):
                encounters += 1

        self.assertGreater(encounters, 0, "Zero encounters triggered on loaded map!")
        self.assertEqual(combat_state.calls, encounters)


if __name__ == "__main__":
    unittest.main()
