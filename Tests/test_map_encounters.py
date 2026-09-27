"""
Unit tests for the Random Encounter system:
- Regional encounter tables and squad builders
- Tile metadata calibration (BIOME_CONFIGS, SubMapGenerator)
- Encounter grace period and step tracking
- Persistent party damage retention and Town Inn restoration
- Death and revival handling
"""

from pathlib import Path
import tempfile
import unittest
from unittest.mock import MagicMock

from eldoria_py.core.context import Context
from eldoria_py.core.fsm import SMState
from eldoria_py.core.save_manager import SaveManager
from eldoria_py.combat.encounters import (
    RegionCode,
    create_plains_encounter,
    create_forest_encounter,
    create_cave_encounter,
    generate_encounter,
)
from eldoria_py.combat import StatId, Party, create_default_party
from eldoria_py.procgen.map_generator import BIOME_CONFIGS, BiomeType, ProceduralMapGenerator
from eldoria_py.procgen.submap_generator import SubMapGenerator
from eldoria_py.procgen.poi import POIType
from eldoria_py.states.test_noise_map import GSNoiseMapTestScreen


class TestRegionalEncounterTables(unittest.TestCase):
    """Verifies that regional encounter factories produce correctly balanced squads."""

    def test_region_safe_returns_none(self):
        self.assertIsNone(generate_encounter(RegionCode.SAFE))
        self.assertIsNone(generate_encounter(0))

    def test_region_plains_squad(self):
        for _ in range(10):
            squad = generate_encounter(RegionCode.OVERWORLD_PLAINS)
            self.assertIsNotNone(squad)
            self.assertTrue(3 <= len(squad.enemies) <= 5)
            # Members should be brawlers, archers, scouts, wolves, bats, or highwaymen
            names = [m.name for m in squad.enemies]
            self.assertTrue(any(k in n for n in names for k in ("Brawler", "Archer", "Scout", "Wolf", "Bat", "Highwayman", "Bandit")))

    def test_region_forest_squad(self):
        for _ in range(10):
            squad = generate_encounter(RegionCode.OVERWORLD_FOREST)
            self.assertIsNotNone(squad)
            self.assertTrue(4 <= len(squad.enemies) <= 7)

    def test_region_cave_squad(self):
        for _ in range(10):
            squad = generate_encounter(RegionCode.SUBTERRANEAN_CAVE)
            self.assertIsNotNone(squad)
            self.assertTrue(6 <= len(squad.enemies) <= 10)
            names = [m.name for m in squad.enemies]
            self.assertTrue(any("Bat" in n or "Golem" in n for n in names))


class TestTileMetadataCalibration(unittest.TestCase):
    """Verifies tile battle settings across procedural biomes and sub-maps."""

    def test_overworld_biome_configs(self):
        # Deep Water, Water, Mountains, Snow should be safe
        self.assertFalse(BIOME_CONFIGS[BiomeType.WATER].battle_allowed)
        self.assertEqual(BIOME_CONFIGS[BiomeType.WATER].encounter_rate, 0.0)
        self.assertEqual(BIOME_CONFIGS[BiomeType.WATER].region_code, 0)

        self.assertFalse(BIOME_CONFIGS[BiomeType.DEEP_WATER].battle_allowed)
        self.assertEqual(BIOME_CONFIGS[BiomeType.DEEP_WATER].encounter_rate, 0.0)

        self.assertFalse(BIOME_CONFIGS[BiomeType.MOUNTAIN].battle_allowed)
        self.assertEqual(BIOME_CONFIGS[BiomeType.MOUNTAIN].encounter_rate, 0.0)

        self.assertFalse(BIOME_CONFIGS[BiomeType.SNOW].battle_allowed)
        self.assertEqual(BIOME_CONFIGS[BiomeType.SNOW].encounter_rate, 0.0)

        # Plains and Roads: Region 1
        self.assertTrue(BIOME_CONFIGS[BiomeType.PLAINS].battle_allowed)
        self.assertAlmostEqual(BIOME_CONFIGS[BiomeType.PLAINS].encounter_rate, 0.10)
        self.assertEqual(BIOME_CONFIGS[BiomeType.PLAINS].region_code, 1)

        self.assertTrue(BIOME_CONFIGS[BiomeType.ROAD].battle_allowed)
        self.assertAlmostEqual(BIOME_CONFIGS[BiomeType.ROAD].encounter_rate, 0.04)
        self.assertEqual(BIOME_CONFIGS[BiomeType.ROAD].region_code, 1)

        # Forest: Region 2
        self.assertTrue(BIOME_CONFIGS[BiomeType.FOREST].battle_allowed)
        self.assertAlmostEqual(BIOME_CONFIGS[BiomeType.FOREST].encounter_rate, 0.16)
        self.assertEqual(BIOME_CONFIGS[BiomeType.FOREST].region_code, 2)

    def test_submap_town_and_castle_are_safe(self):
        town_map, _ = SubMapGenerator.generate_town("Oakhaven Town", 1337)
        for row in town_map.tiles:
            for tile in row:
                self.assertFalse(tile.battle_allowed)
                self.assertEqual(tile.encounter_rate, 0.0)
                self.assertEqual(tile.region_code, 0)

        castle_map, _ = SubMapGenerator.generate_castle("Highwatch Keep", 1337)
        for row in castle_map.tiles:
            for tile in row:
                self.assertFalse(tile.battle_allowed)
                self.assertEqual(tile.encounter_rate, 0.0)
                self.assertEqual(tile.region_code, 0)

    def test_submap_cave_has_encounters(self):
        cave_map, _ = SubMapGenerator.generate_cave("Whispering Depths", 1337)
        walkable_tiles = [t for row in cave_map.tiles for t in row if t.is_walkable]
        self.assertTrue(len(walkable_tiles) > 0)
        for tile in walkable_tiles:
            self.assertTrue(tile.battle_allowed)
            self.assertAlmostEqual(tile.encounter_rate, 0.20)
            self.assertEqual(tile.region_code, 3)


class TestNoiseMapEncounterScreenIntegration(unittest.TestCase):
    """Verifies encounter triggering, grace period, party persistence, and resting in GSNoiseMapTestScreen."""

    def setUp(self):
        self.temp_dir = tempfile.TemporaryDirectory()
        self.screen = GSNoiseMapTestScreen(map_width=20, map_height=10)
        self.screen.save_manager = SaveManager(save_dir=Path(self.temp_dir.name))
        self.context = Context()
        self.mock_core = MagicMock()
        self.mock_game_state = MagicMock()
        self.mock_combat_screen = MagicMock()
        self.mock_game_state.states = {"GSNvNCombatScreen": self.mock_combat_screen}
        self.mock_core.game_state = self.mock_game_state
        self.context.set(SMState.ContextEldoriaCore, self.mock_core)

    def tearDown(self):
        self.temp_dir.cleanup()

    def test_grace_period_prevents_immediate_encounters(self):
        # Set steps since battle to 0
        self.screen.steps_since_battle = 0
        self.screen.min_grace_steps = 5

        # Place player on an aggressive battle tile
        curr_map = self.screen._current_map()
        tile = curr_map.tiles[self.screen.player_y][self.screen.player_x]
        tile.battle_allowed = True
        tile.encounter_rate = 1.0  # 100% chance
        tile.region_code = 1
        tile.warp_target = None

        # Check steps 1 to 4: should never trigger encounter
        for step in range(1, 5):
            triggered = self.screen._check_step_encounter(self.context)
            self.assertFalse(triggered, f"Step {step} should be protected by grace period")
            self.assertEqual(self.screen.steps_since_battle, step)

        # Step 5: grace period met, should trigger encounter
        triggered = self.screen._check_step_encounter(self.context)
        self.assertTrue(triggered)
        self.assertEqual(self.screen.steps_since_battle, 0)
        self.mock_game_state.trigger.assert_called_with("ToCombat", self.context)
        self.mock_combat_screen.start_encounter.assert_called_once()

    def test_warp_tile_never_triggers_encounter(self):
        self.screen.steps_since_battle = 10
        curr_map = self.screen._current_map()
        tile = curr_map.tiles[self.screen.player_y][self.screen.player_x]
        tile.battle_allowed = True
        tile.encounter_rate = 1.0
        tile.region_code = 1
        tile.warp_target = MagicMock()

        triggered = self.screen._check_step_encounter(self.context)
        self.assertFalse(triggered)

    def test_inn_restores_damaged_party(self):
        # Damage the party
        for m in self.screen.party.members:
            m.stats[StatId.HIT_POINTS].current = 10
            m.stats[StatId.MAGIC_POINTS].current = 5

        # Place player on Inn tile
        curr_map = self.screen._current_map()
        tile = curr_map.tiles[self.screen.player_y][self.screen.player_x]
        tile.object_listing = ["MTOInn"]

        # Interact
        self.screen._handle_interact()

        # Check full restoration
        for m in self.screen.party.members:
            self.assertEqual(m.hp, m.max_hp)
            self.assertEqual(m.mp, m.max_mp)
        self.assertIn("Rested", self.screen.last_status_msg)

    def test_party_revival_on_defeat(self):
        # Wipe the party
        for m in self.screen.party.members:
            m.stats[StatId.HIT_POINTS].current = 0

        self.assertTrue(self.screen.party.is_wiped)

        # Enter screen as if returning from battle defeat
        self.screen.enter(self.context)

        # Party should be revived to 50% HP/MP
        self.assertFalse(self.screen.party.is_wiped)
        for m in self.screen.party.members:
            self.assertEqual(m.hp, max(1, m.max_hp // 2))
            self.assertEqual(m.mp, max(1, m.max_mp // 2))
        self.assertEqual(self.screen.last_status_msg, "Revived!")

        # Verify that rendered header line stays strictly within window boundaries (map_width + 2)
        alive_count = sum(1 for m in self.screen.party.members if m.is_alive)
        total_hp = sum(m.hp for m in self.screen.party.members)
        total_max_hp = sum(m.max_hp for m in self.screen.party.members)
        hp_pct = int((total_hp / total_max_hp) * 100) if total_max_hp > 0 else 0
        party_badge = f"Party:{alive_count}/{len(self.screen.party.members)} [{hp_pct}%]"
        t_text = f" {party_badge} \033[1;36m{self.screen.last_status_msg}\033[0m"
        rendered_line = self.screen._make_border_line("│", t_text, "│", self.screen.map_width, fill_char=" ")
        from eldoria_py.terminal.box import visible_width
        self.assertEqual(visible_width(rendered_line), self.screen.map_width + 2)


if __name__ == "__main__":
    unittest.main()
