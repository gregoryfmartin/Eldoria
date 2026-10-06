"""
Unit tests for Eldoria's Additional Biomes:
- Badlands, Tundra, and Swamp configuration and metadata.
- Compact map serialization and round-trip fidelity.
- Geographic zoning invariants (Tundra North, Swamp South, Badlands Single Flank).
- World Macro multi-sector distribution.
- Bestiary catalog constraints (single word, <=10 characters, elemental affinity).
- Biome-specific combat encounter generation and universal routing.
"""

import random
import unittest

from eldoria_py.procgen.map_generator import (
    BiomeType,
    BIOME_CONFIGS,
    BIOME_TO_CHAR,
    CHAR_TO_BIOME,
    ProceduralMapGenerator,
    Map,
    MapTile,
    TrueColor,
)
from eldoria_py.procgen.world_macro import WorldMacroMap
from eldoria_py.combat.stats import BattleActionType
from eldoria_py.combat.actions import ACTIONS, ActionCategory
from eldoria_py.combat.bestiary import BESTIARY, BOSS_CATALOG
from eldoria_py.combat.encounters import (
    create_badlands_encounter,
    create_tundra_encounter,
    create_swamp_encounter,
    generate_encounter,
    RegionCode,
)


class TestBiomeConfigurations(unittest.TestCase):
    """Verifies tile metadata and aesthetics for Badlands, Tundra, and Swamp."""

    def test_badlands_configuration(self):
        config = BIOME_CONFIGS[BiomeType.BADLANDS]
        self.assertTrue(config.walkable)
        self.assertTrue(config.battle_allowed)
        self.assertAlmostEqual(config.encounter_rate, 0.16)
        self.assertEqual(config.region_code, 2)
        self.assertEqual(config.glyph, "x")
        self.assertEqual(config.fg_color, TrueColor(0xD9, 0x77, 0x36))
        self.assertEqual(config.bg_color, TrueColor(0x3E, 0x20, 0x14))

    def test_tundra_configuration(self):
        config = BIOME_CONFIGS[BiomeType.TUNDRA]
        self.assertTrue(config.walkable)
        self.assertTrue(config.battle_allowed)
        self.assertAlmostEqual(config.encounter_rate, 0.10)
        self.assertEqual(config.region_code, 1)
        self.assertEqual(config.glyph, ",")
        self.assertEqual(config.fg_color, TrueColor(0xBA, 0xE6, 0xFD))
        self.assertEqual(config.bg_color, TrueColor(0x16, 0x4E, 0x63))

    def test_swamp_configuration(self):
        config = BIOME_CONFIGS[BiomeType.SWAMP]
        self.assertTrue(config.walkable)
        self.assertTrue(config.battle_allowed)
        self.assertAlmostEqual(config.encounter_rate, 0.16)
        self.assertEqual(config.region_code, 2)
        self.assertEqual(config.glyph, "§")
        self.assertEqual(config.fg_color, TrueColor(0x84, 0xCC, 0x16))
        self.assertEqual(config.bg_color, TrueColor(0x1A, 0x2E, 0x16))

    def test_compact_serialization_tokens(self):
        self.assertEqual(BIOME_TO_CHAR[BiomeType.BADLANDS], "B")
        self.assertEqual(BIOME_TO_CHAR[BiomeType.TUNDRA], "T")
        self.assertEqual(BIOME_TO_CHAR[BiomeType.SWAMP], "S")

        self.assertEqual(CHAR_TO_BIOME["B"], BiomeType.BADLANDS)
        self.assertEqual(CHAR_TO_BIOME["T"], BiomeType.TUNDRA)
        self.assertEqual(CHAR_TO_BIOME["S"], BiomeType.SWAMP)

    def test_compact_map_roundtrip(self):
        m = Map(name="TestBiomeMap", width=4, height=3)
        m.tiles[0][0].biome = BiomeType.TUNDRA
        m.tiles[1][0].biome = BiomeType.BADLANDS
        m.tiles[2][0].biome = BiomeType.SWAMP
        m.tiles[1][1].biome = BiomeType.PLAINS
        m.tiles[1][2].biome = BiomeType.FOREST

        compact_dict = m.to_compact_dict()
        rows_str = "".join(compact_dict["rows"])
        self.assertIn("T", rows_str)
        self.assertIn("B", rows_str)
        self.assertIn("S", rows_str)

        restored_map = Map.from_compact_dict(compact_dict)
        self.assertEqual(restored_map.tiles[0][0].biome, BiomeType.TUNDRA)
        self.assertEqual(restored_map.tiles[1][0].biome, BiomeType.BADLANDS)
        self.assertEqual(restored_map.tiles[2][0].biome, BiomeType.SWAMP)
        self.assertEqual(restored_map.tiles[1][1].biome, BiomeType.PLAINS)
        self.assertEqual(restored_map.tiles[1][2].biome, BiomeType.FOREST)


class TestGeographicPlacementInvariants(unittest.TestCase):
    """Verifies directional placement rules: Tundra North, Swamp South, Badlands Single Flank."""

    def test_single_map_geographic_zones(self):
        # Test across multiple seeds to ensure invariant stability
        for seed in [42, 100, 2026, 9999]:
            generator = ProceduralMapGenerator(seed=seed)
            world_map = generator.generate_map(width=54, height=24)

            tundra_y = []
            swamp_y = []
            badlands_x = []

            for y in range(world_map.height):
                for x in range(world_map.width):
                    b = world_map.tiles[y][x].biome
                    if b == BiomeType.TUNDRA:
                        tundra_y.append(y)
                    elif b == BiomeType.SWAMP:
                        swamp_y.append(y)
                    elif b == BiomeType.BADLANDS:
                        badlands_x.append(x)

            # Tundra must strictly be in the northern portion (y <= 7 in 24-height map)
            if tundra_y:
                self.assertLessEqual(max(tundra_y), 7, f"Tundra found too far south (y={max(tundra_y)}) on seed {seed}")

            # Swamp must strictly be in the southern portion (y >= 16 in 24-height map)
            if swamp_y:
                self.assertGreaterEqual(min(swamp_y), 16, f"Swamp found too far north (y={min(swamp_y)}) on seed {seed}")

            # Badlands must only appear on one flank (never both)
            if badlands_x:
                has_west = any(x < 15 for x in badlands_x)
                has_east = any(x > 38 for x in badlands_x)
                self.assertFalse(has_west and has_east, f"Badlands found on BOTH flanks on seed {seed}")

    def test_world_macro_spatial_continuity(self):
        macro = WorldMacroMap(seed=2026, macro_width=4, macro_height=4)
        macro.generate()

        tundra_gy = []
        swamp_gy = []
        badlands_gx = []

        total_w = 4 * 54

        for sy in range(macro.macro_height):
            for sx in range(macro.macro_width):
                sector = macro.sectors[sy][sx]
                for ly in range(24):
                    gy = sy * 24 + ly
                    for lx in range(54):
                        gx = sx * 54 + lx
                        b = sector.tiles[ly][lx].biome
                        if b == BiomeType.TUNDRA:
                            tundra_gy.append(gy)
                        elif b == BiomeType.SWAMP:
                            swamp_gy.append(gy)
                        elif b == BiomeType.BADLANDS:
                            badlands_gx.append(gx)

        # In macro map of height 96, Tundra must be northern (gy <= 28)
        if tundra_gy:
            self.assertLessEqual(max(tundra_gy), 28)

        # Swamp must be southern (gy >= 68)
        if swamp_gy:
            self.assertGreaterEqual(min(swamp_gy), 68)

        # Badlands must be on only one flank of the macro world
        if badlands_gx:
            has_west = any(gx < total_w * 0.25 for gx in badlands_gx)
            has_east = any(gx > total_w * 0.75 for gx in badlands_gx)
            self.assertFalse(has_west and has_east, "Macro world has Badlands on both East and West flanks!")


class TestBiomeBestiaryCatalog(unittest.TestCase):
    """Verifies bestiary requirements for new biomes."""

    def test_enemy_name_and_character_limits(self):
        new_biomes = {"Badlands", "Tundra", "Swamp"}
        elemental_types = {
            BattleActionType.ELEMENTAL_FIRE, BattleActionType.ELEMENTAL_WATER,
            BattleActionType.ELEMENTAL_EARTH, BattleActionType.ELEMENTAL_WIND,
            BattleActionType.ELEMENTAL_LIGHT, BattleActionType.ELEMENTAL_DARK,
            BattleActionType.ELEMENTAL_ICE,
        }

        biome_enemy_count = {b: 0 for b in new_biomes}
        all_enemies = {**BOSS_CATALOG, **BESTIARY}

        for name, template in all_enemies.items():
            # Check length and single-word constraint
            self.assertNotIn(" ", name)
            self.assertLessEqual(len(name), 10)

            # Check elemental spells match template affinity
            for act_name in template.actions:
                act = ACTIONS[act_name]
                if act.category == ActionCategory.SPELL and act.action_type in elemental_types:
                    self.assertEqual(
                        act.action_type, template.affinity,
                        f"Enemy '{name}' with affinity {template.affinity} has mismatched spell '{act_name}' ({act.action_type})"
                    )

            for b in new_biomes:
                if b in template.biomes:
                    biome_enemy_count[b] += 1

        # Each new biome should have at least 10 enemies across tiers
        for b, count in biome_enemy_count.items():
            self.assertGreaterEqual(count, 10, f"Biome '{b}' has only {count} enemies; expected >= 10.")


class TestBiomeEncounterGeneration(unittest.TestCase):
    """Verifies squad generation for Badlands, Tundra, and Swamp."""

    def test_badlands_encounter_generation(self):
        rng = random.Random(42)
        for reg in range(1, 10):
            squad = create_badlands_encounter(region_code=reg, rng=rng)
            self.assertIsNotNone(squad)
            self.assertTrue(4 <= len(squad.enemies) <= 7)
            for enemy in squad.enemies:
                self.assertIsNotNone(enemy.name)
                self.assertGreater(enemy.max_hp, 0)
                self.assertGreater(enemy.hp, 0)

    def test_tundra_encounter_generation(self):
        rng = random.Random(42)
        for reg in range(1, 10):
            squad = create_tundra_encounter(region_code=reg, rng=rng)
            self.assertIsNotNone(squad)
            self.assertTrue(3 <= len(squad.enemies) <= 5)
            for enemy in squad.enemies:
                self.assertIsNotNone(enemy.name)
                self.assertGreater(enemy.max_hp, 0)
                self.assertGreater(enemy.hp, 0)

    def test_swamp_encounter_generation(self):
        rng = random.Random(42)
        for reg in range(1, 10):
            squad = create_swamp_encounter(region_code=reg, rng=rng)
            self.assertIsNotNone(squad)
            self.assertTrue(4 <= len(squad.enemies) <= 7)
            for enemy in squad.enemies:
                self.assertIsNotNone(enemy.name)
                self.assertGreater(enemy.max_hp, 0)
                self.assertGreater(enemy.hp, 0)

    def test_universal_encounter_dispatcher_with_biome(self):
        rng = random.Random(1337)
        # Test routing with enum and string
        badlands_squad = generate_encounter(region_code=2, rng=rng, biome=BiomeType.BADLANDS)
        self.assertIsNotNone(badlands_squad)
        self.assertTrue(4 <= len(badlands_squad.enemies) <= 7)

        tundra_squad = generate_encounter(region_code=1, rng=rng, biome="Tundra")
        self.assertIsNotNone(tundra_squad)
        self.assertTrue(3 <= len(tundra_squad.enemies) <= 5)

        swamp_squad = generate_encounter(region_code=2, rng=rng, biome=BiomeType.SWAMP)
        self.assertIsNotNone(swamp_squad)
        self.assertTrue(4 <= len(swamp_squad.enemies) <= 7)


if __name__ == "__main__":
    unittest.main()
