import unittest
import random

from eldoria_py.combat.stats import StatId
from eldoria_py.combat.actions import ACTIONS, ActionCategory, TargetScope, BattleActionType
from eldoria_py.combat.entities import (
    PartyMember,
    Party,
    resolve_class_growth_rates,
    CLASS_GROWTH_RATES,
    DEFAULT_GROWTH_RATES,
    create_default_party,
)
from eldoria_py.combat.encounters import BESTIARY, EnemySquad, build_from_template
from eldoria_py.combat.engine import NvNCombatEngine, CombatPhase
from eldoria_py.states.character_builder import GSCharacterBuilderScreen
from eldoria_py.states.party_builder import GSPartyBuilderScreen


class TestMPAndMagicRebalance(unittest.TestCase):
    """Verifies starting MP calibration, spell MP costs, archetype growth resolution, and combat mana economy."""

    def test_spell_and_skill_mp_costs(self):
        """Verifies updated MP costs for all physical skills and magic spells."""
        # Physical Skills
        self.assertEqual(ACTIONS["Double Scratch"].mp_cost, 5)
        self.assertEqual(ACTIONS["Flame Punch"].mp_cost, 7)
        self.assertEqual(ACTIONS["Axe Cleave"].mp_cost, 9)
        self.assertEqual(ACTIONS["Drop Kick"].mp_cost, 12)

        # Single-Target Spells (Tier 1 & 2)
        self.assertEqual(ACTIONS["Ice Bolt"].mp_cost, 7)
        self.assertEqual(ACTIONS["Galeflash"].mp_cost, 7)
        self.assertEqual(ACTIONS["Tidal Crush"].mp_cost, 8)
        self.assertEqual(ACTIONS["Boulder Bash"].mp_cost, 9)
        self.assertEqual(ACTIONS["Dark Surge"].mp_cost, 11)

        # Multi-Target AOE Spells
        self.assertEqual(ACTIONS["Fireball"].mp_cost, 20)
        self.assertEqual(ACTIONS["Fireball"].target_scope, TargetScope.ALL_ENEMIES)
        self.assertEqual(ACTIONS["Radiance"].mp_cost, 22)
        self.assertEqual(ACTIONS["Radiance"].target_scope, TargetScope.ALL_ENEMIES)
        self.assertEqual(ACTIONS["Arctic Blast"].mp_cost, 24)
        self.assertEqual(ACTIONS["Arctic Blast"].target_scope, TargetScope.ALL_ENEMIES)
        self.assertEqual(ACTIONS["Cataclysm"].mp_cost, 36)
        self.assertEqual(ACTIONS["Cataclysm"].target_scope, TargetScope.ALL_ENEMIES)

        # Healing Spells
        self.assertEqual(ACTIONS["Heal"].mp_cost, 8)
        self.assertEqual(ACTIONS["Heal"].target_scope, TargetScope.SINGLE_ALLY)
        self.assertEqual(ACTIONS["Group Heal"].mp_cost, 22)
        self.assertEqual(ACTIONS["Group Heal"].target_scope, TargetScope.ALL_ALLIES)

        # Enemy Skill
        self.assertEqual(ACTIONS["Screech"].mp_cost, 8)

    def test_character_builder_mp_derivation_range(self):
        """Verifies CharacterBuilderScreen._derive_hp_mp produces 24 to 65 MP across all stat combinations."""
        screen = GSCharacterBuilderScreen()

        # Minimum roll (MAT=3, MDF=3) -> 16 + 6 + 2 = 24
        screen.base_stats = {StatId.DEFENSE: 10, StatId.ATTACK: 10, StatId.MAGIC_ATTACK: 3, StatId.MAGIC_DEFENSE: 3}
        screen.mod_stats = {StatId.DEFENSE: 0, StatId.ATTACK: 0, StatId.MAGIC_ATTACK: 0, StatId.MAGIC_DEFENSE: 0}
        _, min_mp = screen._derive_hp_mp()
        self.assertEqual(min_mp, 24)

        # Average balanced (MAT=10, MDF=10) -> 16 + 20 + 7 = 43
        screen.base_stats[StatId.MAGIC_ATTACK] = 10
        screen.base_stats[StatId.MAGIC_DEFENSE] = 10
        _, avg_mp = screen._derive_hp_mp()
        self.assertEqual(avg_mp, 43)

        # Dedicated Mage (MAT=18, MDF=12) -> 16 + 36 + 9 = 61
        screen.base_stats[StatId.MAGIC_ATTACK] = 18
        screen.base_stats[StatId.MAGIC_DEFENSE] = 12
        _, mage_mp = screen._derive_hp_mp()
        self.assertEqual(mage_mp, 61)

        # Maximum possible roll (MAT=18, MDF=18) -> 16 + 36 + 13 = 65
        screen.base_stats[StatId.MAGIC_ATTACK] = 18
        screen.base_stats[StatId.MAGIC_DEFENSE] = 18
        _, max_mp = screen._derive_hp_mp()
        self.assertEqual(max_mp, 65)

    def test_party_builder_templates_balanced_mp(self):
        """Verifies party builder templates have calibrated MP and Brand has appropriate martial skills."""
        screen = GSPartyBuilderScreen()
        screen.party_slots = [None] * 5
        screen.auto_fill_templates()

        guardian = screen.party_slots[0]
        sorceress = screen.party_slots[1]
        rogue = screen.party_slots[2]
        priestess = screen.party_slots[3]
        berserker = screen.party_slots[4]

        self.assertEqual(guardian.stats[StatId.MAGIC_POINTS].base, 30)
        self.assertEqual(sorceress.stats[StatId.MAGIC_POINTS].base, 60)
        self.assertEqual(rogue.stats[StatId.MAGIC_POINTS].base, 34)
        self.assertEqual(priestess.stats[StatId.MAGIC_POINTS].base, 52)
        self.assertEqual(berserker.stats[StatId.MAGIC_POINTS].base, 22)

        # Brand must not have Fireball (he is a Berserker, not a Mage)
        brand_action_names = [a.name for a in berserker.actions]
        self.assertNotIn("Fireball", brand_action_names)
        self.assertIn("Flame Punch", brand_action_names)
        self.assertIn("Axe Cleave", brand_action_names)

    def test_default_party_mp_calibration(self):
        """Verifies create_default_party has calibrated base MP for level 3 heroes."""
        party = create_default_party()
        # Verify base MP
        self.assertEqual(party.members[0].stats[StatId.MAGIC_POINTS].base, 36)  # Aide (Knight)
        self.assertEqual(party.members[1].stats[StatId.MAGIC_POINTS].base, 75)  # Lyra (Mage)
        self.assertEqual(party.members[2].stats[StatId.MAGIC_POINTS].base, 41)  # Dirk (Rogue)
        self.assertEqual(party.members[3].stats[StatId.MAGIC_POINTS].base, 66)  # Sara (Cleric)
        self.assertEqual(party.members[4].stats[StatId.MAGIC_POINTS].base, 27)  # Vane (Berserker)

    def test_resolve_class_growth_rates(self):
        """Verifies resolve_class_growth_rates matches multi-word job classes to their archetypes."""
        self.assertEqual(resolve_class_growth_rates("Water Sorceress"), CLASS_GROWTH_RATES["Mage"])
        self.assertEqual(resolve_class_growth_rates("Fire Mage"), CLASS_GROWTH_RATES["Mage"])
        self.assertEqual(resolve_class_growth_rates("Light Priestess"), CLASS_GROWTH_RATES["Cleric"])
        self.assertEqual(resolve_class_growth_rates("Cleric"), CLASS_GROWTH_RATES["Cleric"])
        self.assertEqual(resolve_class_growth_rates("Earth Guardian"), CLASS_GROWTH_RATES["Knight"])
        self.assertEqual(resolve_class_growth_rates("Paladin"), CLASS_GROWTH_RATES["Knight"])
        self.assertEqual(resolve_class_growth_rates("Wind Rogue"), CLASS_GROWTH_RATES["Rogue"])
        self.assertEqual(resolve_class_growth_rates("Shadow Thief"), CLASS_GROWTH_RATES["Rogue"])
        self.assertEqual(resolve_class_growth_rates("Fire Berserker"), CLASS_GROWTH_RATES["Berserker"])
        self.assertEqual(resolve_class_growth_rates("Warrior"), CLASS_GROWTH_RATES["Berserker"])
        self.assertEqual(resolve_class_growth_rates("Unknown Adventurer"), DEFAULT_GROWTH_RATES)

    def test_mage_growth_trajectory_and_999_cap(self):
        """Verifies Water Sorceress gains 7.5 MP per level and remains below the 999 hard cap at level 99."""
        mage = PartyMember(
            name="Lyra",
            job_class="Water Sorceress",
            level=1,
            affinity=BattleActionType.ELEMENTAL_FIRE,
            base_stats={
                StatId.HIT_POINTS: 200,
                StatId.MAGIC_POINTS: 60,
                StatId.ATTACK: 8,
                StatId.DEFENSE: 8,
                StatId.MAGIC_ATTACK: 20,
                StatId.MAGIC_DEFENSE: 15,
                StatId.SPEED: 15,
                StatId.LUCK: 12,
                StatId.ACCURACY: 90,
            },
        )
        self.assertEqual(mage.max_mp, 60)

        # Level up to 99
        mage.add_xp(1_000_000)
        self.assertEqual(mage.level, 99)
        self.assertLessEqual(mage.max_mp, 999)
        # 60 + round(7.5 * 99) - round(7.5 * 1) = 60 + 742 - 8 = 794
        self.assertGreaterEqual(mage.max_mp, 750)
        self.assertLessEqual(mage.max_mp, 820)

    def test_combat_mana_scarcity_prevents_endless_fireball(self):
        """Verifies a Level 1 hero with 30 MP can cast 1 Fireball (20 MP), but cannot cast a second without recovering MP."""
        hero = PartyMember(
            name="Aide",
            job_class="Knight",
            level=1,
            affinity=BattleActionType.ELEMENTAL_FIRE,
            base_stats={
                StatId.HIT_POINTS: 300,
                StatId.MAGIC_POINTS: 30,
                StatId.ATTACK: 15,
                StatId.DEFENSE: 15,
                StatId.MAGIC_ATTACK: 10,
                StatId.MAGIC_DEFENSE: 10,
                StatId.SPEED: 12,
                StatId.LUCK: 10,
                StatId.ACCURACY: 85,
            },
        )
        party = Party([hero])
        enemy = build_from_template(BESTIARY["Wolf"], level=1)
        # Give enemy high HP so it survives turn 1 to test turn 2 mana shortage
        enemy.stats[StatId.HIT_POINTS].base = 500
        enemy.stats[StatId.HIT_POINTS].current = 500
        squad = EnemySquad([enemy])

        engine = NvNCombatEngine(party=party, squad=squad, rng=random.Random(1))

        # Turn 1: Fireball costs 20 MP. Hero has 30 MP.
        engine.plan_member_action(0, ACTIONS["Fireball"].copy(), enemy)
        engine.finalize_planning()
        guard1 = 0
        while engine.phase == CombatPhase.EXECUTION_PHASE:
            guard1 += 1
            if guard1 > 100:
                self.fail("Infinite loop in combat execution phase")
            engine.step_execution()

        self.assertEqual(hero.mp, 10)  # 30 - 20 = 10
        self.assertEqual(engine.phase, CombatPhase.COMMAND_PHASE)

        # Turn 2: Attempting Fireball again with only 10 MP should fail
        engine.plan_member_action(0, ACTIONS["Fireball"].copy(), enemy)
        engine.finalize_planning()
        guard2 = 0
        while engine.phase == CombatPhase.EXECUTION_PHASE:
            guard2 += 1
            if guard2 > 100:
                self.fail("Infinite loop in combat execution phase")
            engine.step_execution()

        # Engine logs lack of MP and hero still has 10 MP (no spell was cast)
        self.assertEqual(hero.mp, 10)
        self.assertTrue(any("lacked MP" in log for log in engine.combat_log))


if __name__ == "__main__":
    unittest.main()
