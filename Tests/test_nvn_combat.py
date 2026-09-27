"""Unit tests for NvN combat engine, mathematics, equipment, and screen state."""
from __future__ import annotations
import unittest
import random

from eldoria_py.combat.stats import (
    StatId,
    BattleActionType,
    BattleActionResultType,
    EquipmentSlot,
    TargetScope,
    AffinityEffect,
    BattleEntityProperty,
)
from eldoria_py.combat.actions import BattleAction, ActionCategory, ACTIONS
from eldoria_py.combat.damage import (
    calculate_damage,
    calculate_hit,
    calculate_crit,
    get_affinity_effect,
)
from eldoria_py.combat.equipment import BattleEquipment, EQUIPMENT_CATALOG
from eldoria_py.combat.entities import (
    Combatant,
    PartyMember,
    EnemyCombatant,
    Party,
    EnemySquad,
    create_default_party,
    create_bat_squad,
)
from eldoria_py.combat.engine import NvNCombatEngine, CombatPhase, QueuedAction
from eldoria_py.states.combat_screen import GSNvNCombatScreen
from eldoria_py.states.test_noise_map import GSNoiseMapTestScreen
from eldoria_py.core.context import Context
from eldoria_py.core.fsm import SMStateMachine, SMTransition
from eldoria_py.terminal.input import KeyCode, KeyEvent


class TestCombatMathematics(unittest.TestCase):
    """Verifies shored combat mathematics, non-negative damage, and elemental affinity."""

    def test_non_negative_defense_scaling(self):
        """Verifies that higher defense strictly reduces damage taken (never increases it via Math.Abs)."""
        attacker_stats = {StatId.ATTACK: 30, StatId.ACCURACY: 99, StatId.LUCK: 0}

        low_def_target = {StatId.DEFENSE: 10, StatId.SPEED: 0, StatId.LUCK: 0}
        mid_def_target = {StatId.DEFENSE: 40, StatId.SPEED: 0, StatId.LUCK: 0}
        ultra_high_def = {StatId.DEFENSE: 200, StatId.SPEED: 0, StatId.LUCK: 0}

        res_low = calculate_damage(
            attacker_stats=attacker_stats,
            target_stats=low_def_target,
            action_type=BattleActionType.PHYSICAL,
            power=20,
            accuracy=1.0,
            force_hit=True,
            force_crit=False,
            variance=1.0,
        )

        res_mid = calculate_damage(
            attacker_stats=attacker_stats,
            target_stats=mid_def_target,
            action_type=BattleActionType.PHYSICAL,
            power=20,
            accuracy=1.0,
            force_hit=True,
            force_crit=False,
            variance=1.0,
        )

        res_ultra = calculate_damage(
            attacker_stats=attacker_stats,
            target_stats=ultra_high_def,
            action_type=BattleActionType.PHYSICAL,
            power=20,
            accuracy=1.0,
            force_hit=True,
            force_crit=False,
            variance=1.0,
        )

        # Damage must decrease monotonically as target defense increases
        self.assertGreater(res_low.final_damage, res_mid.final_damage)
        self.assertGreaterEqual(res_mid.final_damage, res_ultra.final_damage)
        # Even with astronomical defense, hit connects with minimum 1 damage
        self.assertEqual(res_ultra.final_damage, 1)

    def test_elemental_affinity_multipliers(self):
        """Verifies elemental affinity effects: Weakness (1.75x), Resist (0.5x), Immune (0.0x), Absorb."""
        atk_stats = {StatId.MAGIC_ATTACK: 30, StatId.ACCURACY: 99, StatId.LUCK: 0}
        def_stats = {StatId.MAGIC_DEFENSE: 10, StatId.SPEED: 0, StatId.LUCK: 0}

        # Fire vs Ice -> Weakness (1.75x)
        res_weak = calculate_damage(
            attacker_stats=atk_stats,
            target_stats=def_stats,
            action_type=BattleActionType.ELEMENTAL_FIRE,
            power=20,
            accuracy=1.0,
            target_affinity=BattleActionType.ELEMENTAL_ICE,
            force_hit=True,
            force_crit=False,
            variance=1.0,
        )
        self.assertEqual(res_weak.affinity_effect, AffinityEffect.WEAK)
        self.assertEqual(res_weak.result_type, BattleActionResultType.SUCCESS_AFFINITY_BONUS)

        # Fire vs Fire -> Resist (0.5x)
        res_resist = calculate_damage(
            attacker_stats=atk_stats,
            target_stats=def_stats,
            action_type=BattleActionType.ELEMENTAL_FIRE,
            power=20,
            accuracy=1.0,
            target_affinity=BattleActionType.ELEMENTAL_FIRE,
            force_hit=True,
            force_crit=False,
            variance=1.0,
        )
        self.assertEqual(res_resist.affinity_effect, AffinityEffect.RESIST)
        self.assertGreater(res_weak.final_damage, res_resist.final_damage)

        # Explicit Immune
        res_immune = calculate_damage(
            attacker_stats=atk_stats,
            target_stats=def_stats,
            action_type=BattleActionType.ELEMENTAL_FIRE,
            power=20,
            accuracy=1.0,
            target_affinity=BattleActionType.ELEMENTAL_ICE,
            explicit_immunes={BattleActionType.ELEMENTAL_FIRE},
            force_hit=True,
            force_crit=False,
            variance=1.0,
        )
        self.assertEqual(res_immune.result_type, BattleActionResultType.IMMUNE)
        self.assertEqual(res_immune.final_damage, 0)

        # Explicit Absorb
        res_absorb = calculate_damage(
            attacker_stats=atk_stats,
            target_stats=def_stats,
            action_type=BattleActionType.ELEMENTAL_FIRE,
            power=20,
            accuracy=1.0,
            target_affinity=BattleActionType.ELEMENTAL_ICE,
            explicit_absorbs={BattleActionType.ELEMENTAL_FIRE},
            force_hit=True,
            force_crit=False,
            variance=1.0,
        )
        self.assertEqual(res_absorb.result_type, BattleActionResultType.ABSORBED)
        self.assertTrue(res_absorb.is_healing)
        self.assertLess(res_absorb.final_damage, 0)

    def test_critical_hit_ignores_thirty_percent_defense(self):
        """Verifies critical hits scale by 1.5x and ignore 30% of defense."""
        atk_stats = {StatId.ATTACK: 40, StatId.ACCURACY: 99, StatId.LUCK: 0}
        def_stats = {StatId.DEFENSE: 40, StatId.SPEED: 0, StatId.LUCK: 0}

        normal_hit = calculate_damage(
            attacker_stats=atk_stats,
            target_stats=def_stats,
            action_type=BattleActionType.PHYSICAL,
            power=20,
            accuracy=1.0,
            force_hit=True,
            force_crit=False,
            variance=1.0,
        )

        crit_hit = calculate_damage(
            attacker_stats=atk_stats,
            target_stats=def_stats,
            action_type=BattleActionType.PHYSICAL,
            power=20,
            accuracy=1.0,
            force_hit=True,
            force_crit=True,
            variance=1.0,
        )

        self.assertTrue(crit_hit.is_critical)
        self.assertEqual(crit_hit.result_type, BattleActionResultType.SUCCESS_CRITICAL)
        self.assertGreater(crit_hit.final_damage, int(normal_hit.final_damage * 1.5))

    def test_aoe_multi_target_damage_scaling(self):
        """Verifies AoE scaling: single = 1.0x, cleave (3) = 0.8x, squad (5+) = 0.65x."""
        atk_stats = {StatId.MAGIC_ATTACK: 30, StatId.ACCURACY: 99, StatId.LUCK: 0}
        def_stats = {StatId.MAGIC_DEFENSE: 10, StatId.SPEED: 0, StatId.LUCK: 0}

        single = calculate_damage(
            attacker_stats=atk_stats,
            target_stats=def_stats,
            action_type=BattleActionType.ELEMENTAL_FIRE,
            power=20,
            accuracy=1.0,
            target_count=1,
            force_hit=True,
            force_crit=False,
            variance=1.0,
        )

        cleave = calculate_damage(
            attacker_stats=atk_stats,
            target_stats=def_stats,
            action_type=BattleActionType.ELEMENTAL_FIRE,
            power=20,
            accuracy=1.0,
            target_count=3,
            force_hit=True,
            force_crit=False,
            variance=1.0,
        )

        full_squad = calculate_damage(
            attacker_stats=atk_stats,
            target_stats=def_stats,
            action_type=BattleActionType.ELEMENTAL_FIRE,
            power=20,
            accuracy=1.0,
            target_count=8,
            force_hit=True,
            force_crit=False,
            variance=1.0,
        )

        self.assertGreater(single.final_damage, cleave.final_damage)
        self.assertGreater(cleave.final_damage, full_squad.final_damage)


class TestEquipmentSystem(unittest.TestCase):
    """Verifies 10-slot equipment management and stat augmentations."""

    def test_all_ten_equipment_slots(self):
        """Verifies that all 10 slots can be equipped and augment total stats."""
        member = PartyMember(
            name="Arthur",
            job_class="Paladin",
            base_stats={
                StatId.HIT_POINTS: 100,
                StatId.MAGIC_POINTS: 50,
                StatId.ATTACK: 10,
                StatId.DEFENSE: 10,
                StatId.MAGIC_ATTACK: 10,
                StatId.MAGIC_DEFENSE: 10,
                StatId.SPEED: 10,
                StatId.LUCK: 10,
                StatId.ACCURACY: 80,
            },
        )
        base_atk = member.get_stat(StatId.ATTACK)
        base_def = member.get_stat(StatId.DEFENSE)

        # Equip 10 items
        items = [
            EQUIPMENT_CATALOG["Iron Longsword"],     # Weapon
            EQUIPMENT_CATALOG["Iron Greathelm"],     # Helmet
            EQUIPMENT_CATALOG["Plate Cuirass"],      # Armor
            EQUIPMENT_CATALOG["Steel Pauldrons"],    # Pauldron
            EQUIPMENT_CATALOG["Iron Gauntlets"],     # Gauntlets
            EQUIPMENT_CATALOG["Steel Greaves"],      # Greaves
            EQUIPMENT_CATALOG["Plated Sabatons"],    # Boots
            EQUIPMENT_CATALOG["Ring of Might"],      # JewelryA
            EQUIPMENT_CATALOG["Amulet of Health"],   # JewelryB
            EQUIPMENT_CATALOG["Cloak of Protection"],# Cape
        ]

        for item in items:
            member.equip(item)

        # Verify all 10 slots populated
        for slot in EquipmentSlot:
            self.assertIsNotNone(member.equipment[slot], f"Slot {slot} should not be empty")

        # Verify stat bonuses accumulated
        self.assertGreater(member.get_stat(StatId.ATTACK), base_atk)
        self.assertGreater(member.get_stat(StatId.DEFENSE), base_def)

        # Verify unlocked weapon action (Iron Longsword grants Flame Punch)
        action_names = [a.name for a in member.actions]
        self.assertIn("Flame Punch", action_names)

        # Unequip weapon
        member.unequip(EquipmentSlot.WEAPON)
        self.assertIsNone(member.equipment[EquipmentSlot.WEAPON])
        self.assertNotIn("Flame Punch", [a.name for a in member.actions])


class TestNvNCombatEngine(unittest.TestCase):
    """Verifies round planning, initiative sorting, smart retargeting, and victory/defeat."""

    def setUp(self):
        self.rng = random.Random(42)
        self.party = create_default_party()
        self.squad = create_bat_squad(size=6)
        self.engine = NvNCombatEngine(party=self.party, squad=self.squad, rng=self.rng)

    def test_party_and_squad_limits(self):
        """Verifies party max size 5 and enemy squad max size 10."""
        self.assertEqual(len(self.party.members), 5)
        extra_hero = PartyMember(name="Extra", job_class="Wanderer")
        self.assertFalse(self.party.add_member(extra_hero))

        full_squad = create_bat_squad(size=10)
        self.assertEqual(len(full_squad.enemies), 10)
        extra_bat = EnemyCombatant(name="Extra Bat")
        self.assertFalse(full_squad.add_enemy(extra_bat))

    def test_advance_round_planning_and_initiative(self):
        """Verifies that player plans all living heroes, initiative sorts actions, and execution resolves."""
        self.assertEqual(self.engine.phase, CombatPhase.COMMAND_PHASE)

        # Plan actions for all 5 party members
        target_bat = self.squad.enemies[0]
        for i, m in enumerate(self.party.members):
            self.engine.plan_member_action(i, m.actions[0], target_bat)

        self.assertTrue(self.engine.is_planning_complete())
        self.engine.finalize_planning()
        self.assertEqual(self.engine.phase, CombatPhase.EXECUTION_PHASE)

        # 5 party actions + 6 enemy actions = 11 queued actions
        self.assertEqual(len(self.engine.round_queue), 11)

        # Verify initiative descending order
        inits = [q.initiative for q in self.engine.round_queue]
        self.assertEqual(inits, sorted(inits, reverse=True))

    def test_smart_retargeting_when_target_dies_mid_round(self):
        """Verifies that if an enemy dies mid-round, subsequent heroes retarget to living enemies."""
        # Set Bat A HP to 1 so it dies to the first attack
        self.squad.enemies[0].hp = 1
        bat_a = self.squad.enemies[0]
        bat_b = self.squad.enemies[1]

        # Hero 0 has highest speed, Hero 1 second highest, others low
        self.party.members[0].stats[StatId.SPEED].base = 500
        self.party.members[1].stats[StatId.SPEED].base = 400
        for i in range(2, 5):
            self.party.members[i].stats[StatId.SPEED].base = 10

        # Heroes #0 and #1 both target Bat A with standard attack
        hero_0 = self.party.members[0]
        hero_1 = self.party.members[1]
        self.engine.plan_member_action(0, hero_0.actions[0], bat_a)
        self.engine.plan_member_action(1, hero_1.actions[0], bat_a)
        for i in range(2, 5):
            self.engine.plan_member_action(i, self.party.members[i].actions[0], bat_b)

        self.engine.finalize_planning()

        # Step 1: Hero 0 defeats Bat A
        q1 = self.engine.step_execution()
        self.assertEqual(q1.actor, hero_0)
        self.assertFalse(bat_a.is_alive)

        # Step 2: Hero 1's action should smart retarget to Bat B
        q2 = self.engine.step_execution()
        self.assertEqual(q2.actor, hero_1)
        self.assertEqual(q2.target, bat_b)
        self.assertTrue(any("retargets" in log for log in self.engine.combat_log))

    def test_squad_wipe_triggers_victory_and_rewards(self):
        """Verifies that killing all enemies triggers BATTLE_VICTORY and calculates XP/Gold."""
        for e in self.squad.enemies:
            e.hp = 0

        self.engine.phase = CombatPhase.EXECUTION_PHASE
        self.engine.step_execution()

        self.assertEqual(self.engine.phase, CombatPhase.BATTLE_VICTORY)
        self.assertGreater(self.engine.spoils_xp, 0)
        self.assertGreater(self.engine.spoils_gold, 0)


class TestCombatScreenState(unittest.TestCase):
    """Verifies GSNvNCombatScreen rendering, zero ASCII art in target inspector, and FSM integration."""

    def setUp(self):
        self.screen = GSNvNCombatScreen()
        self.screen.start_encounter(create_default_party(), create_bat_squad(size=6))

    def test_target_detail_has_zero_ascii_art(self):
        """Verifies that all rows in TARGET DETAIL are clean text stats with no ASCII art."""
        for row_idx in range(5):
            cell = self.screen._format_target_detail_row(row_idx)
            # Must not contain ascii art characters or slashes from the old wireframe
            self.assertNotIn("/---\\", cell)
            self.assertNotIn("| o.o |", cell)
            self.assertNotIn("\\===/", cell)
            self.assertNotIn("/|   |\\", cell)

        # Row 0: Name and Level
        row0 = self.screen._format_target_detail_row(0)
        self.assertIn("Name:", row0)
        self.assertIn("Bat A", row0)

        # Row 2: HP Bar
        row2 = self.screen._format_target_detail_row(2)
        self.assertIn("HP:", row2)
        self.assertIn("[", row2)
        self.assertIn("]", row2)

    def test_wireframe_column_alignment(self):
        """Verifies exact wireframe row lengths match the 80-column grid."""
        for row_idx in range(5):
            left_str = self.screen._format_enemy_row(row_idx)
            right_str = self.screen._format_target_detail_row(row_idx)
            row = f"│{left_str}│{right_str}│"
            vlen = len(self._strip_color(row))
            self.assertEqual(vlen, self.screen.TOTAL_WIDTH)

    def _strip_color(self, text: str) -> str:
        import re
        return re.sub(r"\033\[[0-9;]*[a-zA-Z]", "", text)

    def test_map_test_screen_b_key_disallowed(self):
        """Verifies that pressing [B] in GSNoiseMapTestScreen is disallowed and does not trigger 'ToCombat'."""
        map_screen = GSNoiseMapTestScreen()
        combat_screen = GSNvNCombatScreen()

        fsm = SMStateMachine("GSNoiseMapTestScreen")
        fsm.add_state(map_screen)
        fsm.add_state(combat_screen)
        fsm.add_transition(SMTransition("GSNoiseMapTestScreen", "ToCombat", "GSNvNCombatScreen"))
        fsm.add_transition(SMTransition("GSNvNCombatScreen", "FromCombat", "GSNoiseMapTestScreen"))

        class MockCore:
            def __init__(self, game_state):
                self.game_state = game_state

        mock_core = MockCore(fsm)
        context = Context([0.016, [KeyEvent(key=KeyCode.CHAR, char="b", raw="b")], mock_core])

        map_screen.update(context)
        # B key is removed, state remains GSNoiseMapTestScreen
        self.assertEqual(fsm.current_state, "GSNoiseMapTestScreen")


if __name__ == "__main__":
    unittest.main()
