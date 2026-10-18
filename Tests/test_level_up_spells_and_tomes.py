"""Unit tests for Class Level-Up Spell/Skill Unlocks and Spell Tomes & Skill Trainers."""
import unittest
import random

from eldoria_py.combat.stats import StatId, BattleActionType
from eldoria_py.combat.actions import ACTIONS
from eldoria_py.combat.entities import (
    PartyMember,
    Party,
    resolve_class_archetype,
    CLASS_LEVEL_UNLOCKS,
)
from eldoria_py.combat.items import (
    ITEM_CATALOG,
    ItemType,
    ItemEffectType,
    get_item,
    apply_item_effect,
)
from eldoria_py.procgen.npc import generate_item_shop_inventory
from eldoria_py.combat.encounters import create_boss_encounter
from eldoria_py.combat.engine import NvNCombatEngine, CombatPhase


class TestClassLevelUpSpellUnlocks(unittest.TestCase):
    """Verifies that party members unlock new class skills and spells upon leveling up."""

    def test_resolve_class_archetype_mappings(self):
        self.assertEqual(resolve_class_archetype("Knight"), "Knight")
        self.assertEqual(resolve_class_archetype("Earth Guardian"), "Knight")
        self.assertEqual(resolve_class_archetype("Paladin"), "Knight")
        self.assertEqual(resolve_class_archetype("Fire Mage"), "Mage")
        self.assertEqual(resolve_class_archetype("Grand Sorcerer"), "Mage")
        self.assertEqual(resolve_class_archetype("Shadow Rogue"), "Rogue")
        self.assertEqual(resolve_class_archetype("Infiltrator"), "Rogue")
        self.assertEqual(resolve_class_archetype("Holy Priest"), "Cleric")
        self.assertEqual(resolve_class_archetype("Cleric"), "Cleric")
        self.assertEqual(resolve_class_archetype("Berserker"), "Berserker")
        self.assertEqual(resolve_class_archetype("Fire Warrior"), "Berserker")

    def test_knight_unlocks_shield_bash_and_axe_cleave(self):
        knight = PartyMember(name="Galahad", job_class="Knight", level=1, xp=0)
        action_names = [a.name for a in knight.actions]
        self.assertNotIn("Shield Bash", action_names)

        # Level 1 -> Level 4
        summaries = knight.add_xp(500)
        self.assertGreaterEqual(knight.level, 4)
        action_names = [a.name for a in knight.actions]
        self.assertIn("Shield Bash", action_names)

        # Check unlocked_actions was reported in summary
        unlocked_in_summary = []
        for s in summaries:
            unlocked_in_summary.extend(s.get("unlocked_actions", []))
        self.assertIn("Shield Bash", unlocked_in_summary)

    def test_mage_unlocks_ice_bolt_and_fireball(self):
        mage = PartyMember(name="Lyra", job_class="Mage", level=1, xp=0)
        # Give minimal starting actions
        mage.base_actions = [ACTIONS["Attack"].copy(), ACTIONS["Defend"].copy()]
        mage.recalculate_equipment()

        # Level up to 3
        mage.add_xp(200)
        self.assertGreaterEqual(mage.level, 3)
        self.assertTrue(any(a.name == "Ice Bolt" for a in mage.actions))

        # Level up to 6
        mage.add_xp(1000)
        self.assertGreaterEqual(mage.level, 6)
        self.assertTrue(any(a.name == "Fireball" for a in mage.actions))

    def test_rogue_unlocks_double_scratch_and_drop_kick(self):
        rogue = PartyMember(name="Dirk", job_class="Rogue", level=1, xp=0)
        rogue.base_actions = [ACTIONS["Attack"].copy(), ACTIONS["Defend"].copy()]
        rogue.recalculate_equipment()

        # Level up to 7
        rogue.add_xp(1500)
        self.assertGreaterEqual(rogue.level, 7)
        names = [a.name for a in rogue.actions]
        self.assertIn("Double Scratch", names)
        self.assertIn("Drop Kick", names)

    def test_cleric_unlocks_heal_and_group_heal(self):
        cleric = PartyMember(name="Sarah", job_class="Cleric", level=1, xp=0)
        cleric.base_actions = [ACTIONS["Attack"].copy(), ACTIONS["Defend"].copy()]
        cleric.recalculate_equipment()

        # Level up to 2
        cleric.add_xp(100)
        self.assertGreaterEqual(cleric.level, 2)
        self.assertTrue(any(a.name == "Heal" for a in cleric.actions))

    def test_berserker_unlocks_axe_cleave_and_flame_punch(self):
        berserker = PartyMember(name="Vance", job_class="Berserker", level=1, xp=0)
        berserker.base_actions = [ACTIONS["Attack"].copy(), ACTIONS["Defend"].copy()]
        berserker.recalculate_equipment()

        # Level up to 7
        berserker.add_xp(1500)
        self.assertGreaterEqual(berserker.level, 7)
        names = [a.name for a in berserker.actions]
        self.assertIn("Axe Cleave", names)
        self.assertIn("Flame Punch", names)

    def test_deduplication_if_already_known_from_tome(self):
        knight = PartyMember(name="Galahad", job_class="Knight", level=1, xp=0)
        # Pre-learn Shield Bash
        knight.base_actions.append(ACTIONS["Shield Bash"].copy())
        knight.recalculate_equipment()
        initial_count = sum(1 for a in knight.actions if a.name == "Shield Bash")
        self.assertEqual(initial_count, 1)

        # Level up to 4
        knight.add_xp(500)
        self.assertGreaterEqual(knight.level, 4)
        after_count = sum(1 for a in knight.actions if a.name == "Shield Bash")
        self.assertEqual(after_count, 1)


class TestSpellTomesAndSkillTrainers(unittest.TestCase):
    """Verifies properties and usage of Spell Tomes and Skill Trainers."""

    def test_item_catalog_contains_tomes_and_trainers_with_high_prices(self):
        tomes = [
            "T: Fireball",
            "T: Ice Bolt",
            "T: Arctic Blast",
            "T: Tidal Crush",
            "T: Boulder Bash",
            "T: Galeflash",
            "T: Radiance",
            "T: Dark Surge",
            "T: Cataclysm",
            "T: Heal",
            "T: Group Heal",
        ]
        trainers = [
            "ST: Axe Cleave",
            "ST: Flame Punch",
            "ST: Drop Kick",
            "ST: Double Scratch",
            "ST: Shield Bash",
            "ST: Whirlwind",
            "ST: Shadow Strike",
        ]

        for item_name in tomes + trainers:
            item = get_item(item_name)
            self.assertIsNotNone(item, f"Item '{item_name}' missing from ITEM_CATALOG")
            self.assertEqual(item.effect_type, ItemEffectType.TEACH_ACTION)
            self.assertTrue(item.usable_in_field)
            self.assertFalse(item.usable_in_battle)
            self.assertIsNotNone(item.teaches_action_name)
            self.assertIn(item.teaches_action_name, ACTIONS)
            # Verify doubled high cost constraint: all tomes and trainers cost at least 5,000 G
            self.assertGreaterEqual(item.price, 5000, f"{item_name} price {item.price} is too low!")

        # Specific exact doubled prices
        self.assertEqual(get_item("ST: Axe Cleave").price, 5000)
        self.assertEqual(get_item("T: Ice Bolt").price, 5000)
        self.assertEqual(get_item("T: Fireball").price, 7000)
        self.assertEqual(get_item("ST: Whirlwind").price, 12000)
        self.assertEqual(get_item("T: Cataclysm").price, 18000)

    def test_alias_resolutions_for_legacy_and_flexible_names(self):
        # Tome of ... and T of ... aliases
        self.assertEqual(get_item("Tome of Fireball").name, "T: Fireball")
        self.assertEqual(get_item("T of Fireball").name, "T: Fireball")
        self.assertEqual(get_item("Tome of Ice Bolt").name, "T: Ice Bolt")
        self.assertEqual(get_item("T of Ice Bolt").name, "T: Ice Bolt")
        # Skill Trainer: ... and ST ... aliases
        self.assertEqual(get_item("Skill Trainer: Axe Cleave").name, "ST: Axe Cleave")
        self.assertEqual(get_item("ST Axe Cleave").name, "ST: Axe Cleave")

    def test_studying_tome_teaches_spell_and_consumes_item(self):
        hero = PartyMember(name="Aiden", job_class="Knight", level=5)
        hero.base_actions = [ACTIONS["Attack"].copy(), ACTIONS["Defend"].copy()]
        hero.recalculate_equipment()
        party = Party([hero])
        party.add_item("T: Heal", 1)

        tome = get_item("T: Heal")
        self.assertFalse(any(a.name == "Heal" for a in hero.actions))

        success, msg = apply_item_effect(tome, hero, party)
        self.assertTrue(success)
        self.assertIn("learned Heal", msg)
        self.assertTrue(any(a.name == "Heal" for a in hero.actions))
        self.assertEqual(party.get_item_count("T: Heal"), 0)

    def test_studying_trainer_already_known_fails_without_consuming(self):
        hero = PartyMember(name="Aiden", job_class="Knight", level=5)
        hero.base_actions = [ACTIONS["Attack"].copy(), ACTIONS["Axe Cleave"].copy()]
        hero.recalculate_equipment()
        party = Party([hero])
        party.add_item("ST: Axe Cleave", 2)

        trainer = get_item("ST: Axe Cleave")
        success, msg = apply_item_effect(trainer, hero, party)
        self.assertFalse(success)
        self.assertIn("already knows Axe Cleave", msg)
        # Quantity remains intact
        self.assertEqual(party.get_item_count("ST: Axe Cleave"), 2)

    def test_studying_tome_on_fallen_member_fails(self):
        hero = PartyMember(name="Aiden", job_class="Knight", level=5)
        hero.hp = 0
        self.assertFalse(hero.is_alive)
        party = Party([hero])
        party.add_item("T: Fireball", 1)

        tome = get_item("T: Fireball")
        success, msg = apply_item_effect(tome, hero, party)
        self.assertFalse(success)
        self.assertIn("fallen", msg)
        self.assertEqual(party.get_item_count("T: Fireball"), 1)


class TestHerbalistShopAndSpoilsIntegration(unittest.TestCase):
    """Verifies high-cost tomes and trainers in herbalist shops and boss spoils."""

    def test_herbalist_region_1_stocks_high_cost_trainer_and_tome(self):
        inventory = generate_item_shop_inventory(region_tier=1, seed=42)
        item_names = [it["name"] for it in inventory]
        self.assertIn("ST: Axe Cleave", item_names)
        self.assertIn("T: Ice Bolt", item_names)

        # Check prices are high (doubled floor of 5,000G)
        for it in inventory:
            if it["name"].startswith("ST:") or it["name"].startswith("T:"):
                self.assertGreaterEqual(it["price"], 5000)

    def test_herbalist_high_regions_stock_master_tomes(self):
        inventory = generate_item_shop_inventory(region_tier=9, seed=42)
        item_names = [it["name"] for it in inventory]
        self.assertIn("T: Cataclysm", item_names)
        self.assertIn("ST: Whirlwind", item_names)

    def test_boss_victory_spoils_awards_tome(self):
        hero = PartyMember(name="Aide", job_class="Knight", level=75)
        hero.base_actions = [ACTIONS["Attack"].copy(), ACTIONS["Defend"].copy()]
        hero.recalculate_equipment()
        party = Party([hero])
        party.inventory.clear()

        # Malakor guaranteed drops T: Cataclysm (1.0 chance)
        squad = create_boss_encounter("Malakor")
        engine = NvNCombatEngine(party=party, squad=squad, rng=random.Random(1337))

        for e in squad.enemies:
            e.hp = 0
        engine.phase = CombatPhase.EXECUTION_PHASE
        engine.step_execution()

        self.assertEqual(engine.phase, CombatPhase.BATTLE_VICTORY)
        self.assertGreater(party.get_item_count("T: Cataclysm"), 0)


if __name__ == "__main__":
    unittest.main()
