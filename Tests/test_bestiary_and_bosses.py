"""
Unit and integration tests for Eldoria's Bestiary, 16 Regional Bosses,
Final Boss Malakor, Solo Boss Squads, Affinity Governance, Defensive AI, and Tiered Spoils.
"""

import random
import unittest
from eldoria_py.combat.stats import StatId, BattleActionType
from eldoria_py.combat.actions import ACTIONS, ActionCategory
from eldoria_py.combat.items import is_key_item, ITEM_CATALOG
from eldoria_py.combat.entities import Party, PartyMember, EnemyCombatant, EnemySquad
from eldoria_py.combat.bestiary import (
    BOSS_CATALOG,
    BESTIARY,
    BestiaryTemplate,
    get_template,
    get_boss_by_region,
)
from eldoria_py.combat.encounters import (
    build_scaled_enemy,
    build_from_template,
    build_boss_enemy,
    create_boss_encounter,
    generate_encounter,
    create_plains_encounter,
    create_forest_encounter,
    create_cave_encounter,
    create_mountain_encounter,
)
from eldoria_py.combat.engine import NvNCombatEngine, CombatPhase
from eldoria_py.combat.damage import calculate_damage
from eldoria_py.procgen.submap_generator import SubMapGenerator


class TestBestiaryNamingAndStructure(unittest.TestCase):
    """Verifies single-word <= 10 character naming rule and taxonomy."""

    def test_all_enemy_names_are_single_word_and_max_10_chars(self):
        all_enemies = {**BOSS_CATALOG, **BESTIARY}
        self.assertGreaterEqual(len(all_enemies), 50)

        for name, template in all_enemies.items():
            self.assertEqual(name, template.name)
            self.assertLessEqual(
                len(name), 10,
                f"Enemy name '{name}' exceeds 10 characters!"
            )
            self.assertNotIn(
                " ", name,
                f"Enemy name '{name}' must be a single word!"
            )

    def test_normal_vs_boss_distinction(self):
        # At least 15 bosses in the catalog
        self.assertGreaterEqual(len(BOSS_CATALOG), 15)
        for b_name, b_tmpl in BOSS_CATALOG.items():
            self.assertTrue(b_tmpl.is_boss, f"Boss '{b_name}' must have is_boss=True")

        # All regular enemies must have is_boss=False
        for r_name, r_tmpl in BESTIARY.items():
            self.assertFalse(r_tmpl.is_boss, f"Regular enemy '{r_name}' must have is_boss=False")


class TestFinalBossMalakor(unittest.TestCase):
    """Verifies final boss Malakor specifications and high-stat profile."""

    def test_malakor_specifications(self):
        malakor = BOSS_CATALOG.get("Malakor")
        self.assertIsNotNone(malakor)
        self.assertEqual(malakor.name, "Malakor")
        self.assertTrue(malakor.is_boss)
        self.assertEqual(malakor.default_level, 75)
        self.assertEqual(malakor.min_region, 9)
        self.assertEqual(malakor.max_region, 9)
        self.assertEqual(malakor.affinity, BattleActionType.ELEMENTAL_DARK)

        # Actions include AOE Dark magic (Cataclysm) and Dark Surge
        self.assertIn("Cataclysm", malakor.actions)
        self.assertIn("Dark Surge", malakor.actions)

        # Defense mechanics
        self.assertAlmostEqual(malakor.defend_chance, 0.20)
        self.assertAlmostEqual(malakor.defend_multiplier, 0.25)
        self.assertTrue(malakor.negate_crits_when_defending)

        # High HP pool override
        self.assertGreaterEqual(malakor.base_hp_override, 8000)

    def test_malakor_built_combatant_stats_and_bounds(self):
        boss = build_boss_enemy("Malakor")
        self.assertEqual(boss.name, "Malakor")
        self.assertEqual(boss.level, 75)
        self.assertTrue(boss.is_boss)
        self.assertGreaterEqual(boss.max_hp, 8000)
        self.assertLessEqual(boss.max_hp, 9999)
        self.assertLessEqual(boss.max_mp, 999)

        # Stats must not exceed 99 cap
        for stat_id in [
            StatId.ATTACK, StatId.DEFENSE, StatId.MAGIC_ATTACK,
            StatId.MAGIC_DEFENSE, StatId.SPEED, StatId.LUCK, StatId.ACCURACY
        ]:
            self.assertLessEqual(boss.get_stat(stat_id), 99)

    def test_malakor_defensive_mitigation_and_crit_negation(self):
        boss = build_boss_enemy("Malakor")
        boss.is_defending = True

        # Malakor takes only 25% damage when defending (75% cut)
        raw_damage = 400
        actual_delta = boss.take_damage(raw_damage)
        self.assertEqual(actual_delta, 100)  # 400 * 0.25 = 100

        # Normal enemy with 0.50 cut
        normal = build_scaled_enemy(name="Orc", family="Beast", level=10, defend_multiplier=0.50)
        normal.is_defending = True
        self.assertEqual(normal.take_damage(400), 200)

    def test_boss_squad_is_strictly_solo(self):
        squad = create_boss_encounter("Malakor")
        self.assertEqual(len(squad.enemies), 1)
        self.assertEqual(squad.enemies[0].name, "Malakor")

        rattus_squad = create_boss_encounter("Rattus")
        self.assertEqual(len(rattus_squad.enemies), 1)
        self.assertEqual(rattus_squad.enemies[0].name, "Rattus")


class TestElementalAffinityAndCombatAI(unittest.TestCase):
    """Verifies that enemies never cast spells outside their assigned elemental affinity."""

    def test_affinity_aligned_spells(self):
        elemental_types = {
            BattleActionType.ELEMENTAL_FIRE, BattleActionType.ELEMENTAL_WATER,
            BattleActionType.ELEMENTAL_EARTH, BattleActionType.ELEMENTAL_WIND,
            BattleActionType.ELEMENTAL_LIGHT, BattleActionType.ELEMENTAL_DARK,
            BattleActionType.ELEMENTAL_ICE,
        }

        all_enemies = {**BOSS_CATALOG, **BESTIARY}
        for name, template in all_enemies.items():
            for act_name in template.actions:
                act = ACTIONS[act_name]
                if act.category == ActionCategory.SPELL and act.action_type in elemental_types:
                    self.assertEqual(
                        act.action_type, template.affinity,
                        f"Enemy '{name}' with affinity {template.affinity} has mismatched spell '{act_name}' ({act.action_type})"
                    )

    def test_choose_action_runtime_affinity_guard(self):
        # Create a Fire enemy that inadvertently has a Water spell in its marble bag
        fire_enemy = build_scaled_enemy(
            name="FireImp",
            family="Demon",
            level=10,
            affinity=BattleActionType.ELEMENTAL_FIRE,
            actions=[ACTIONS["Attack"].copy(), ACTIONS["Tidal Crush"].copy()],
        )
        party_hero = PartyMember(name="Aide", job_class="Knight", level=10)
        party_hero.hp = 100

        rng = random.Random(42)
        # In 50 action choices, Tidal Crush must NEVER be chosen
        for _ in range(50):
            chosen_act, _ = fire_enemy.choose_action(
                party_targets=[party_hero],
                ally_targets=[fire_enemy],
                rng=rng,
            )
            self.assertNotEqual(chosen_act.name, "Tidal Crush")


class TestSpoilsAndLootInvariants(unittest.TestCase):
    """Verifies enemies never drop key items and drop tier-appropriate spoils upon victory."""

    def test_no_key_items_in_any_drop_table(self):
        all_enemies = {**BOSS_CATALOG, **BESTIARY}
        for name, template in all_enemies.items():
            for drop in template.drop_table:
                self.assertFalse(
                    is_key_item(drop.item_id),
                    f"Enemy '{name}' has key item '{drop.item_id}' in drop table!"
                )

    def test_boss_guaranteed_loot_drops_into_party_inventory(self):
        hero = PartyMember(name="Aide", job_class="Knight", level=10)
        party = Party([hero])
        party.inventory.clear()

        # Rattus drops Potion and Twin Daggers with 100% guarantee
        squad = create_boss_encounter("Rattus")
        engine = NvNCombatEngine(party=party, squad=squad, rng=random.Random(1337))

        # Defeat boss
        for e in squad.enemies:
            e.hp = 0
        engine.phase = CombatPhase.EXECUTION_PHASE
        engine.step_execution()

        self.assertEqual(engine.phase, CombatPhase.BATTLE_VICTORY)
        self.assertGreater(party.get_item_count("Potion"), 0)
        self.assertGreater(party.get_item_count("Twin Daggers"), 0)
        self.assertTrue(any("Spoils: Obtained" in log for log in engine.combat_log))


class TestBossPOISubmapPlacement(unittest.TestCase):
    """Verifies cave generation stamps boss chamber altar tile on lowest floor."""

    def test_generate_cave_places_boss_altar_tile(self):
        cave_map, spawn = SubMapGenerator.generate_cave(
            name="Shadow Cavern",
            seed=42,
            floor_level=0,
            base_region=3,
            boss_name="Broodfang",
        )
        center_x = cave_map.width // 2
        boss_tile = cave_map.tiles[3][center_x]

        self.assertEqual(boss_tile.custom_glyph, "Ω")
        self.assertIn("Boss:Broodfang", boss_tile.object_listing)
        self.assertTrue(boss_tile.battle_allowed)
        self.assertEqual(boss_tile.region_code, 3)



class TestTieredWorldMacroBossCaveGeneration(unittest.TestCase):
    """Verifies tiered campaign POI generation, boss distribution, and distinct sector assignments."""

    def test_classic_4x4_prologue_scope(self):
        from eldoria_py.procgen.world_macro import WorldMacroMap
        from eldoria_py.procgen.poi import POIType
        macro = WorldMacroMap(seed=1337, macro_width=4, macro_height=4)
        macro.generate()

        self.assertEqual(macro.max_region, 3)
        cave_pois = [p for p in macro.all_pois if p.poi_type == POIType.CAVE]
        # Exactly 3 boss caves in 4x4 (1 per region tier: R1, R2, R3)
        self.assertEqual(len(cave_pois), 3)

        cave_names = {p.name for p in cave_pois}
        expected_names = {"Shadowfen Cavern", "Blackstone Deep", "Whispering Depths"}
        self.assertEqual(cave_names, expected_names)

        # Each cave must reside in a distinct danger region tier
        cave_regions = {p.sub_map.tiles[3][p.sub_map.width // 2].region_code for p in cave_pois}
        self.assertEqual(cave_regions, {1, 2, 3})

        # All POIs (Town, Castle, 3 Caves) must be in distinct sectors
        poi_sectors = [p.sector_coord for p in macro.all_pois]
        self.assertEqual(len(poi_sectors), len(set(poi_sectors)))
        self.assertEqual(len(poi_sectors), 5)

    def test_quick_campaign_6x6_scope(self):
        from eldoria_py.procgen.world_macro import WorldMacroMap
        from eldoria_py.procgen.poi import POIType
        macro = WorldMacroMap(seed=1337, macro_width=6, macro_height=6)
        macro.generate()

        self.assertEqual(macro.max_region, 6)
        cave_pois = [p for p in macro.all_pois if p.poi_type == POIType.CAVE]
        # Exactly 11 boss caves in 6x6
        self.assertEqual(len(cave_pois), 11)

        # All 21 POIs (8 Towns, 2 Castles, 11 Caves) in distinct sectors
        poi_sectors = [p.sector_coord for p in macro.all_pois]
        self.assertEqual(len(poi_sectors), len(set(poi_sectors)))
        self.assertEqual(len(poi_sectors), 21)

    def test_standard_12x12_full_campaign_malakor(self):
        from eldoria_py.procgen.world_macro import WorldMacroMap
        from eldoria_py.procgen.poi import POIType
        macro = WorldMacroMap(seed=1337, macro_width=12, macro_height=12)
        macro.generate()

        self.assertEqual(macro.max_region, 9)
        cave_pois = [p for p in macro.all_pois if p.poi_type == POIType.CAVE]
        # All 16 bosses present
        self.assertEqual(len(cave_pois), 16)

        # Malakor's cave: Oblivion Citadel
        malakor_poi = macro.pois.get("Oblivion Citadel")
        self.assertIsNotNone(malakor_poi)
        self.assertIn("Malakor", malakor_poi.description)

        # Entrance tile has region 9
        sec = macro.sectors[malakor_poi.sector_coord[1]][malakor_poi.sector_coord[0]]
        malakor_tile = sec.tiles[malakor_poi.local_pos[1]][malakor_poi.local_pos[0]]
        self.assertEqual(malakor_tile.region_code, 9)

        # All POIs in distinct sectors
        poi_sectors = [p.sector_coord for p in macro.all_pois]
        self.assertEqual(len(poi_sectors), len(set(poi_sectors)))
        self.assertGreaterEqual(len(poi_sectors), 18)


if __name__ == "__main__":
    unittest.main()

