"""
Unit tests for Combat Rebalance Model A (Classic JRPG Scaling).
Validates:
- Starting HP derivation in character builder
- Starter archetype template HP in party builder
- Archetype growth curves across Levels 1-99
- Default combatant and test party fixtures
- Combat survivability and potion economy balance
"""

import unittest
from eldoria_py.combat.stats import StatId, BattleActionType
from eldoria_py.combat.entities import (
    Combatant,
    PartyMember,
    CLASS_GROWTH_RATES,
    DEFAULT_GROWTH_RATES,
    resolve_class_growth_rates,
    create_default_party,
)
from eldoria_py.combat.damage import calculate_damage
from eldoria_py.combat.encounters import build_scaled_enemy
from eldoria_py.combat.items import ITEM_CATALOG
from eldoria_py.states.character_builder import GSCharacterBuilderScreen
from eldoria_py.states.party_builder import GSPartyBuilderScreen


class TestCombatRebalanceModelA(unittest.TestCase):
    """Verifies all Model A recalibrations across Eldoria's party progression subsystems."""

    def test_starter_template_hp_hierarchy(self):
        """Verifies party builder default member HP values follow Model A archetype hierarchy."""
        screen = GSPartyBuilderScreen()
        screen.auto_fill_templates()

        templates = screen.party_slots
        self.assertEqual(len(templates), 5)

        # Slot 0: Earth Guardian (Knight) - 58 HP
        self.assertEqual(templates[0].stats[StatId.HIT_POINTS].base, 58)
        # Slot 1: Water Sorceress (Mage) - 32 HP
        self.assertEqual(templates[1].stats[StatId.HIT_POINTS].base, 32)
        # Slot 2: Wind Rogue (Rogue) - 42 HP
        self.assertEqual(templates[2].stats[StatId.HIT_POINTS].base, 42)
        # Slot 3: Light Priestess (Cleric) - 36 HP
        self.assertEqual(templates[3].stats[StatId.HIT_POINTS].base, 36)
        # Slot 4: Fire Berserker (Berserker) - 60 HP
        self.assertEqual(templates[4].stats[StatId.HIT_POINTS].base, 60)

        # Hierarchy check: Berserker > Knight > Rogue > Cleric > Mage
        self.assertGreater(templates[4].stats[StatId.HIT_POINTS].base, templates[0].stats[StatId.HIT_POINTS].base)
        self.assertGreater(templates[0].stats[StatId.HIT_POINTS].base, templates[2].stats[StatId.HIT_POINTS].base)
        self.assertGreater(templates[2].stats[StatId.HIT_POINTS].base, templates[3].stats[StatId.HIT_POINTS].base)
        self.assertGreater(templates[3].stats[StatId.HIT_POINTS].base, templates[1].stats[StatId.HIT_POINTS].base)

    def test_character_builder_dynamic_hp_derivation(self):
        """Verifies character builder derives starting HP between 32 and 65 HP based on stats."""
        screen = GSCharacterBuilderScreen()

        # Frail caster: DEF 8, ATK 8 -> 20 + int(8*1.5) + int(8*0.5) = 20 + 12 + 4 = 36
        screen.base_stats[StatId.DEFENSE] = 8
        screen.mod_stats[StatId.DEFENSE] = 0
        screen.base_stats[StatId.ATTACK] = 8
        screen.mod_stats[StatId.ATTACK] = 0
        hp, _ = screen._derive_hp_mp()
        self.assertEqual(hp, 36)

        # Balanced skirmisher: DEF 10, ATK 19 -> 20 + int(10*1.5) + int(19*0.5) = 20 + 15 + 9 = 44
        screen.base_stats[StatId.DEFENSE] = 10
        screen.base_stats[StatId.ATTACK] = 19
        hp, _ = screen._derive_hp_mp()
        self.assertEqual(hp, 44)

        # Sturdy tank: DEF 18, ATK 18 -> 20 + int(18*1.5) + int(18*0.5) = 20 + 27 + 9 = 56
        screen.base_stats[StatId.DEFENSE] = 18
        screen.base_stats[StatId.ATTACK] = 18
        hp, _ = screen._derive_hp_mp()
        self.assertEqual(hp, 56)

        # Heavy berserker: DEF 14, ATK 24 -> 20 + int(14*1.5) + int(24*0.5) = 20 + 21 + 12 = 53
        screen.base_stats[StatId.DEFENSE] = 14
        screen.base_stats[StatId.ATTACK] = 24
        hp, _ = screen._derive_hp_mp()
        self.assertEqual(hp, 53)

    def test_archetype_hp_growth_rates(self):
        """Verifies calibrated growth rates in CLASS_GROWTH_RATES."""
        self.assertEqual(CLASS_GROWTH_RATES["Berserker"][StatId.HIT_POINTS], 22.0)
        self.assertEqual(CLASS_GROWTH_RATES["Knight"][StatId.HIT_POINTS], 20.0)
        self.assertEqual(CLASS_GROWTH_RATES["Rogue"][StatId.HIT_POINTS], 15.0)
        self.assertEqual(CLASS_GROWTH_RATES["Cleric"][StatId.HIT_POINTS], 14.0)
        self.assertEqual(CLASS_GROWTH_RATES["Mage"][StatId.HIT_POINTS], 11.0)
        self.assertEqual(DEFAULT_GROWTH_RATES[StatId.HIT_POINTS], 16.0)

        # Keyword mapping verification
        self.assertEqual(resolve_class_growth_rates("Paladin")[StatId.HIT_POINTS], 20.0)
        self.assertEqual(resolve_class_growth_rates("Earth Guardian")[StatId.HIT_POINTS], 20.0)
        self.assertEqual(resolve_class_growth_rates("Water Sorceress")[StatId.HIT_POINTS], 11.0)
        self.assertEqual(resolve_class_growth_rates("Wind Rogue")[StatId.HIT_POINTS], 15.0)
        self.assertEqual(resolve_class_growth_rates("Light Priestess")[StatId.HIT_POINTS], 14.0)
        self.assertEqual(resolve_class_growth_rates("Fire Berserker")[StatId.HIT_POINTS], 22.0)

    def test_level_up_progression_headroom_and_milestones(self):
        """Verifies party members scale cleanly to Level 99 without exceeding 2,500 base HP."""
        knight = PartyMember(
            name="Aide",
            job_class="Knight",
            level=1,
            base_stats={StatId.HIT_POINTS: 58, StatId.DEFENSE: 18, StatId.ATTACK: 18},
        )
        mage = PartyMember(
            name="Lyra",
            job_class="Mage",
            level=1,
            base_stats={StatId.HIT_POINTS: 32, StatId.DEFENSE: 8, StatId.ATTACK: 8},
        )

        # Level 1 checks
        self.assertEqual(knight.max_hp, 58)
        self.assertEqual(mage.max_hp, 32)

        # Level 4 checks (Region 1 boss tier)
        knight.level = 1
        knight.add_xp(259)  # XP for Lv 4
        self.assertEqual(knight.level, 4)
        # 58 + round(20 * 4) - round(20 * 1) = 58 + 80 - 20 = 118
        self.assertEqual(knight.stats[StatId.HIT_POINTS].base, 118)

        mage.level = 1
        mage.add_xp(182)  # XP for Lv 4
        self.assertEqual(mage.level, 4)
        # 32 + round(11 * 4) - round(11 * 1) = 32 + 44 - 11 = 65
        self.assertEqual(mage.stats[StatId.HIT_POINTS].base, 65)

        # Level 99 checks (Endgame)
        knight.add_xp(1_000_000)
        self.assertEqual(knight.level, 99)
        # 58 + round(20 * 99) - round(20 * 1) = 58 + 1980 - 20 = 2018
        self.assertEqual(knight.stats[StatId.HIT_POINTS].base, 2018)
        self.assertLessEqual(knight.stats[StatId.HIT_POINTS].base, 2500)

        mage.add_xp(1_000_000)
        self.assertEqual(mage.level, 99)
        # 32 + round(11 * 99) - round(11 * 1) = 32 + 1089 - 11 = 1110
        self.assertEqual(mage.stats[StatId.HIT_POINTS].base, 1110)
        self.assertLessEqual(mage.stats[StatId.HIT_POINTS].base, 1500)

    def test_engine_combatant_and_party_defaults(self):
        """Verifies default combatant baseline is 50 HP and create_default_party is calibrated for Lv 3."""
        c = Combatant(name="Dummy")
        self.assertEqual(c.stats[StatId.HIT_POINTS].base, 50)

        party = create_default_party()
        self.assertEqual(party.members[0].stats[StatId.HIT_POINTS].base, 98)   # Aide (Knight Lv 3)
        self.assertEqual(party.members[1].stats[StatId.HIT_POINTS].base, 54)   # Lyra (Mage Lv 3)
        self.assertEqual(party.members[2].stats[StatId.HIT_POINTS].base, 72)   # Dirk (Rogue Lv 3)
        self.assertEqual(party.members[3].stats[StatId.HIT_POINTS].base, 64)   # Sara (Cleric Lv 3)
        self.assertEqual(party.members[4].stats[StatId.HIT_POINTS].base, 104)  # Vane (Berserker Lv 3)

    def test_combat_survivability_and_potion_economy(self):
        """Verifies Region 1 mobs deal threatening damage and standard Potions provide significant healing."""
        goblin = build_scaled_enemy("Goblin", "Humanoid", level=1, role="balanced")
        wolf = build_scaled_enemy("Wolf", "Beast", level=1, role="dps")

        knight_stats = {StatId.DEFENSE: 30, StatId.SPEED: 10, StatId.LUCK: 10, StatId.ACCURACY: 90}
        mage_stats = {StatId.DEFENSE: 12, StatId.SPEED: 10, StatId.LUCK: 10, StatId.ACCURACY: 90}

        # Damage from Goblin to Knight (58 HP)
        dmg_k = calculate_damage(
            goblin.get_all_stat_totals(), knight_stats, BattleActionType.PHYSICAL,
            power=12, accuracy=0.95, variance=1.0, force_hit=True, force_crit=False
        ).final_damage
        self.assertEqual(dmg_k, 8)
        hits_to_ko_knight = 58 / dmg_k
        self.assertGreaterEqual(hits_to_ko_knight, 5.0)
        self.assertLessEqual(hits_to_ko_knight, 8.0)

        # Damage from Wolf to Mage (32 HP)
        dmg_m = calculate_damage(
            wolf.get_all_stat_totals(), mage_stats, BattleActionType.PHYSICAL,
            power=12, accuracy=0.95, variance=1.0, force_hit=True, force_crit=False
        ).final_damage
        self.assertEqual(dmg_m, 15)
        hits_to_ko_mage = 32 / dmg_m
        self.assertGreaterEqual(hits_to_ko_mage, 2.0)
        self.assertLessEqual(hits_to_ko_mage, 3.0)

        # Potion Economy check: standard Potion (+50 HP) restores >= 85% of Knight, >= 100% of Mage
        potion = ITEM_CATALOG["Potion"]
        self.assertEqual(potion.power, 50)
        self.assertGreaterEqual(potion.power / 58.0, 0.85)
        self.assertGreaterEqual(potion.power / 32.0, 1.0)


if __name__ == "__main__":
    unittest.main()
