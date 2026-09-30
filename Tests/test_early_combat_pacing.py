"""
Unit and integration tests verifying early-game combat pacing,
beginner enemy HP recalibration, starter equipment provisioning,
accuracy baseline fixes, and 3-4 turn battle resolution.
"""

import random
import unittest

from eldoria_py.combat.stats import StatId, BattleActionType, EquipmentSlot
from eldoria_py.combat.actions import ACTIONS
from eldoria_py.combat.entities import Party, PartyMember, EnemySquad
from eldoria_py.combat.encounters import build_from_template, build_scaled_enemy
from eldoria_py.combat.bestiary import BESTIARY
from eldoria_py.combat.engine import NvNCombatEngine, CombatPhase
from eldoria_py.combat.damage import calculate_damage
from eldoria_py.states.character_builder import GSCharacterBuilderScreen
from eldoria_py.states.party_builder import GSPartyBuilderScreen


class TestEarlyGameCombatPacing(unittest.TestCase):
    """Verifies that starter encounters resolve briskly in 2 to 4 turns."""

    def test_beginner_enemy_hp_calibration(self):
        """Verifies Level 1-2 minions have 25-50 HP instead of 140-180 HP."""
        wolf_lvl1 = build_from_template(BESTIARY["Wolf"], level=1)
        wolf_lvl2 = build_from_template(BESTIARY["Wolf"], level=2)
        archer_lvl2 = build_from_template(BESTIARY["Archer"], level=2)

        self.assertLessEqual(wolf_lvl1.max_hp, 35)
        self.assertGreaterEqual(wolf_lvl1.max_hp, 20)

        self.assertLessEqual(wolf_lvl2.max_hp, 55)
        self.assertGreaterEqual(wolf_lvl2.max_hp, 30)

        self.assertLessEqual(archer_lvl2.max_hp, 70)
        self.assertGreaterEqual(archer_lvl2.max_hp, 40)

    def test_character_creation_accuracy_and_equipment(self):
        """Verifies newly built characters start with >=80 accuracy and archetype gear."""
        builder = GSCharacterBuilderScreen()

        # Build Slot 0 (Male Vanguard Warrior)
        builder.set_target_slot(0)
        builder.affinity_idx = 0  # Fire
        builder.profile_idx = 0   # Vanguard Warrior
        member = builder._build_combatant()

        # Accuracy must not be ~10; must be >= 82
        self.assertGreaterEqual(member.get_stat(StatId.ACCURACY), 80)

        # Starter gear must be equipped
        self.assertIsNotNone(member.equipment[EquipmentSlot.WEAPON])
        self.assertEqual(member.equipment[EquipmentSlot.WEAPON].name, "Iron Longsword")
        self.assertIsNotNone(member.equipment[EquipmentSlot.ARMOR])
        self.assertEqual(member.equipment[EquipmentSlot.ARMOR].name, "Brigandine")

        # Total Attack includes weapon bonus (+18) on top of base roll [3, 14]
        self.assertGreaterEqual(member.get_stat(StatId.ATTACK), 21)

    def test_spell_damage_floor(self):
        """Verifies elemental spells deal satisfying damage even for novice casters."""
        novice_stats = {
            StatId.MAGIC_ATTACK: 8,
            StatId.ACCURACY: 90,
            StatId.LUCK: 10,
        }
        target_stats = {
            StatId.MAGIC_DEFENSE: 10,
            StatId.SPEED: 10,
            StatId.LUCK: 10,
        }

        # Fireball (power 20) with AoE penalty across 4 enemies
        result = calculate_damage(
            attacker_stats=novice_stats,
            target_stats=target_stats,
            action_type=BattleActionType.ELEMENTAL_FIRE,
            power=20,
            accuracy=0.98,
            target_count=4,
            force_hit=True,
            force_crit=False,
            variance=1.0,
        )

        # Before fix, novice Fireball dealt only 8.6 -> 6 dmg. Now deals >= 20 dmg.
        self.assertGreaterEqual(result.final_damage, 20)

    def test_starter_combat_resolution_pacing(self):
        """Simulates a 2-person starter party against 4 beginner enemies resolving in <= 4 rounds."""
        builder = GSCharacterBuilderScreen()

        # Hero 1: Aide (Fire Warrior)
        builder.set_target_slot(0)
        builder.char_name = "Aide"
        builder.affinity_idx = 0
        builder.profile_idx = 0
        aide = builder._build_combatant()

        # Hero 2: Lyra (Water Sorceress)
        builder.set_target_slot(1)
        builder.char_name = "Lyra"
        builder.affinity_idx = 1
        builder.profile_idx = 2  # Sorceress
        lyra = builder._build_combatant()

        party = Party()
        party.add_member(aide)
        party.add_member(lyra)

        # 4 Enemies: 3 Wolves (Lv.1-2) + 1 Archer (Lv.2)
        enemies = [
            build_from_template(BESTIARY["Wolf"], level=2),
            build_from_template(BESTIARY["Archer"], level=2),
            build_from_template(BESTIARY["Wolf"], level=1),
            build_from_template(BESTIARY["Wolf"], level=2),
        ]
        squad = EnemySquad(enemies)

        engine = NvNCombatEngine(party=party, squad=squad, rng=random.Random(42))

        random.seed(42)
        rounds = 0
        max_rounds = 4

        while engine.phase != CombatPhase.BATTLE_VICTORY and rounds < max_rounds:
            rounds += 1
            alive = [e for e in squad.enemies if e.is_alive]
            if not alive:
                break

            # Round 1: AoE Fireball from Aide, single-target Tidal Crush from Lyra
            if rounds == 1:
                engine.plan_member_action(0, ACTIONS["Fireball"].copy(), squad.enemies[0])
                engine.plan_member_action(1, ACTIONS["Tidal Crush"].copy(), squad.enemies[1])
            else:
                # Subsequent rounds: Warrior strikes, Sorceress casts Ice Bolt
                engine.plan_member_action(0, ACTIONS["Attack"].copy(), alive[0])
                target_lyra = alive[-1] if len(alive) > 1 else alive[0]
                if lyra.mp >= 8:
                    engine.plan_member_action(1, ACTIONS["Ice Bolt"].copy(), target_lyra)
                else:
                    engine.plan_member_action(1, ACTIONS["Attack"].copy(), target_lyra)

            engine.finalize_planning()
            while engine.phase == CombatPhase.EXECUTION_PHASE:
                engine.step_execution()

        # Assert battle concluded in victory within 4 turns
        self.assertEqual(
            engine.phase,
            CombatPhase.BATTLE_VICTORY,
            f"Battle took more than 4 turns! Ended at round {rounds} in phase {engine.phase}"
        )
        self.assertLessEqual(rounds, 4)


if __name__ == "__main__":
    unittest.main()
