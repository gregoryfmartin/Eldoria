"""Unit tests for Regional Enemy Scaling, Biome Rosters, and Spoils Balancing."""
import unittest
import math
from eldoria_py.combat.stats import StatId, BattleActionType
from eldoria_py.combat.entities import PartyMember, Party, EnemyCombatant, EnemySquad
from eldoria_py.combat.encounters import (
    RegionCode,
    REGION_LEVEL_RANGES,
    calculate_enemy_xp_reward,
    calculate_enemy_gold_reward,
    build_scaled_enemy,
    build_bandit_archer,
    build_bandit_brawler,
    build_wild_wolf,
    build_cave_bat,
    create_plains_encounter,
    create_forest_encounter,
    create_cave_encounter,
    create_mountain_encounter,
    generate_encounter,
)
from eldoria_py.procgen.map_generator import BiomeType
from eldoria_py.procgen.world_macro import calculate_concentric_region_code, WorldMacroMap
from eldoria_py.procgen.submap_generator import SubMapGenerator
from eldoria_py.combat.engine import NvNCombatEngine, CombatPhase


class TestConcentricRegionAssignment(unittest.TestCase):
    """Verifies non-equidistant concentric distance rings radiating from spawn point."""

    def test_non_equidistant_radii_thresholds(self):
        spawn_x, spawn_y = 50, 50
        # Directly at spawn
        self.assertEqual(calculate_concentric_region_code(50, 50, spawn_x, spawn_y), 1)

        # Ring 1: D < 18
        self.assertEqual(calculate_concentric_region_code(60, 50, spawn_x, spawn_y), 1)
        # Ring 2: 18 <= D < 32
        self.assertEqual(calculate_concentric_region_code(70, 50, spawn_x, spawn_y), 2)
        # Ring 3: 32 <= D < 56
        self.assertEqual(calculate_concentric_region_code(90, 50, spawn_x, spawn_y), 3)
        # Ring 4: 56 <= D < 76
        self.assertEqual(calculate_concentric_region_code(110, 50, spawn_x, spawn_y), 4)
        # Ring 5: 76 <= D < 94
        self.assertEqual(calculate_concentric_region_code(130, 50, spawn_x, spawn_y), 5)
        # Ring 6: 94 <= D < 114
        self.assertEqual(calculate_concentric_region_code(150, 50, spawn_x, spawn_y), 6)
        # Ring 7: 114 <= D < 138
        self.assertEqual(calculate_concentric_region_code(170, 50, spawn_x, spawn_y), 7)
        # Ring 8: 138 <= D < 160
        self.assertEqual(calculate_concentric_region_code(195, 50, spawn_x, spawn_y), 8)
        # Ring 9: D >= 160
        self.assertEqual(calculate_concentric_region_code(220, 50, spawn_x, spawn_y), 9)

    def test_overworld_macro_assigns_concentric_regions(self):
        macro = WorldMacroMap(seed=42, macro_width=4, macro_height=4)
        macro.generate()

        spawn_sec = macro.starter_sector
        spawn_pos = macro.starter_player_pos
        spawn_map = macro.sectors[spawn_sec[1]][spawn_sec[0]]

        town_pos = macro.pois["Oakhaven Town"].local_pos if "Oakhaven Town" in macro.pois else list(macro.pois.values())[0].local_pos
        # Starting town tile is safe (region 0)
        self.assertEqual(spawn_map.tiles[town_pos[1]][town_pos[0]].region_code, 0)
        # Player start position adjacent to town is in Region 1
        self.assertEqual(spawn_map.tiles[spawn_pos[1]][spawn_pos[0]].region_code, 1)

        # Adjacent battle tiles right near spawn are Region 1
        adj_tile = spawn_map.tiles[spawn_pos[1]][spawn_pos[0] + 1]
        if adj_tile.battle_allowed and adj_tile.encounter_rate > 0:
            self.assertEqual(adj_tile.region_code, 1)

        # Distant sector (3, 3) on 4x4 Prologue map is capped at Region 3
        far_map = macro.sectors[3][3]
        far_regions = [t.region_code for row in far_map.tiles for t in row if t.battle_allowed]
        self.assertTrue(any(r == 3 for r in far_regions))
        self.assertTrue(all(r <= 3 for r in far_regions))

        # Larger world (6x6) scales into higher danger regions (>= 6)
        macro_6x6 = WorldMacroMap(seed=42, macro_width=6, macro_height=6)
        macro_6x6.generate()
        far_6x6_map = macro_6x6.sectors[5][5]
        far_6x6_regions = [t.region_code for row in far_6x6_map.tiles for t in row if t.battle_allowed]
        self.assertTrue(any(r >= 6 for r in far_6x6_regions))


class TestCaveFloorRegionProgression(unittest.TestCase):
    """Verifies floor-by-floor danger tier progression in submaps."""

    def test_cave_floors_scale_region_codes(self):
        # Floor 0: base region (e.g. 2)
        cave_f0, _ = SubMapGenerator.generate_cave(seed=101, floor_level=0, base_region=2)
        f0_regions = {t.region_code for row in cave_f0.tiles for t in row if t.battle_allowed}
        self.assertEqual(f0_regions, {2})

        # Floors 1-2: base_region + 1
        cave_f1, _ = SubMapGenerator.generate_cave(seed=102, floor_level=1, base_region=2)
        f1_regions = {t.region_code for row in cave_f1.tiles for t in row if t.battle_allowed}
        self.assertEqual(f1_regions, {3})

        # Floors 3-4: base_region + 2
        cave_f3, _ = SubMapGenerator.generate_cave(seed=103, floor_level=3, base_region=2)
        f3_regions = {t.region_code for row in cave_f3.tiles for t in row if t.battle_allowed}
        self.assertEqual(f3_regions, {4})

        # Floor 5+: base_region + 3 (capped at 9)
        cave_f5, _ = SubMapGenerator.generate_cave(seed=104, floor_level=5, base_region=2)
        f5_regions = {t.region_code for row in cave_f5.tiles for t in row if t.battle_allowed}
        self.assertEqual(f5_regions, {5})


class TestEnemyScalingAndSpoils(unittest.TestCase):
    """Verifies stat scaling, caps, and XP yield distributions."""

    def test_scaled_enemy_attributes_adhere_to_caps(self):
        # Build Level 95 Boss
        boss = build_scaled_enemy(
            name="Ancient Wyrm",
            family="Dragon",
            level=95,
            threat_rank="S",
            role="tank",
        )
        self.assertEqual(boss.level, 95)
        self.assertLessEqual(boss.max_hp, 9999)
        self.assertLessEqual(boss.max_mp, 999)
        for stat_id in (
            StatId.ATTACK,
            StatId.DEFENSE,
            StatId.MAGIC_ATTACK,
            StatId.MAGIC_DEFENSE,
            StatId.SPEED,
            StatId.LUCK,
            StatId.ACCURACY,
        ):
            self.assertLessEqual(boss.get_stat(stat_id), 99)
            self.assertGreaterEqual(boss.get_stat(stat_id), 1)

    def test_xp_yield_prevents_single_enemy_power_leveling(self):
        """Verifies that no single enemy yields enough XP to power-level a character anywhere near 99."""
        # Max level 95 S-rank boss
        max_boss_xp = calculate_enemy_xp_reward(level=95, threat_rank="S")
        self.assertLess(max_boss_xp, 20_000)
        # Only ~1.2% of the 1,000,000 XP cap for a solo combatant, or ~0.24% for a party of 5
        self.assertLess(max_boss_xp / 1_000_000.0, 0.02)

        # Low level mob yields appropriate starter XP
        lv1_xp = calculate_enemy_xp_reward(level=1, threat_rank="D")
        self.assertGreaterEqual(lv1_xp, 15)
        self.assertLessEqual(lv1_xp, 25)

    def test_generate_encounter_biome_and_region_dispatch(self):
        # Safe returns None
        self.assertIsNone(generate_encounter(BiomeType.PLAINS, 0))
        self.assertIsNone(generate_encounter(0))
        self.assertIsNone(generate_encounter(RegionCode.SAFE))

        # Forest Region 1 vs Forest Region 7
        squad_r1 = generate_encounter(BiomeType.FOREST, 1)
        self.assertIsNotNone(squad_r1)
        for e in squad_r1.enemies:
            self.assertTrue(1 <= e.level <= 5)

        squad_r7 = generate_encounter(BiomeType.FOREST, 7)
        self.assertIsNotNone(squad_r7)
        for e in squad_r7.enemies:
            self.assertTrue(56 <= e.level <= 72)

        # Legacy backward compatibility check
        legacy_squad = generate_encounter(RegionCode.OVERWORLD_FOREST)
        self.assertIsNotNone(legacy_squad)


class TestAntiFarmingLevelGapPenalty(unittest.TestCase):
    """Verifies tiered level gap penalties (100%, 60%, 25%, 5%)."""

    def setUp(self):
        self.party = Party()
        self.m1 = PartyMember(name="Aide", job_class="Knight", level=1, xp=0)
        self.m2 = PartyMember(name="Lyra", job_class="Mage", level=1, xp=0)
        self.party.add_member(self.m1)
        self.party.add_member(self.m2)

        self.squad = EnemySquad()
        e1 = EnemyCombatant(name="Goblin A", level=1, xp_reward=100, gold_reward=50)
        e2 = EnemyCombatant(name="Goblin B", level=1, xp_reward=100, gold_reward=50)
        self.squad.add_enemy(e1)
        self.squad.add_enemy(e2)

    def test_gap_under_3_receives_100_percent_xp(self):
        # Party Lv 1, Enemies Lv 1: gap = 0 <= 3 -> 100%
        engine = NvNCombatEngine(party=self.party, squad=self.squad)
        for e in self.squad.enemies:
            e.hp = 0
        engine.phase = CombatPhase.EXECUTION_PHASE
        engine.step_execution()

        self.assertEqual(engine.phase, CombatPhase.BATTLE_VICTORY)
        self.assertEqual(engine.spoils_xp, 200)

    def test_gap_4_to_6_receives_60_percent_xp(self):
        # Set party level to 6 (gap = 5)
        self.m1.level = 6
        self.m2.level = 6

        engine = NvNCombatEngine(party=self.party, squad=self.squad)
        for e in self.squad.enemies:
            e.hp = 0
        engine.phase = CombatPhase.EXECUTION_PHASE
        engine.step_execution()

        self.assertEqual(engine.phase, CombatPhase.BATTLE_VICTORY)
        # 200 * 0.60 = 120 XP
        self.assertEqual(engine.spoils_xp, 120)
        self.assertFalse(any("Level disparity penalty" in l for l in engine.combat_log))

    def test_gap_7_to_10_receives_25_percent_xp(self):
        # Set party level to 9 (gap = 8)
        self.m1.level = 9
        self.m2.level = 9

        engine = NvNCombatEngine(party=self.party, squad=self.squad)
        for e in self.squad.enemies:
            e.hp = 0
        engine.phase = CombatPhase.EXECUTION_PHASE
        engine.step_execution()

        self.assertEqual(engine.phase, CombatPhase.BATTLE_VICTORY)
        # 200 * 0.25 = 50 XP
        self.assertEqual(engine.spoils_xp, 50)
        self.assertFalse(any("Level disparity penalty" in l for l in engine.combat_log))

    def test_gap_over_10_receives_5_percent_xp(self):
        # Set party level to 20 (gap = 19)
        self.m1.level = 20
        self.m2.level = 20

        engine = NvNCombatEngine(party=self.party, squad=self.squad)
        for e in self.squad.enemies:
            e.hp = 0
        engine.phase = CombatPhase.EXECUTION_PHASE
        engine.step_execution()

        self.assertEqual(engine.phase, CombatPhase.BATTLE_VICTORY)
        # 200 * 0.05 = 10 XP
        self.assertEqual(engine.spoils_xp, 10)
        self.assertFalse(any("Level disparity penalty" in l for l in engine.combat_log))


if __name__ == "__main__":
    unittest.main()
