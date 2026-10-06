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

        # Row 0: Name without position brackets
        row0 = self.screen._format_target_detail_row(0)
        self.assertIn("Name: Bat A", row0)
        self.assertNotIn("[1]", row0)

        # Row 1: Type without experience level
        row1 = self.screen._format_target_detail_row(1)
        self.assertIn("Type: Beast", row1)
        self.assertNotIn("Lv.", row1)

        # Row 2: HP Bar without numeric values
        row2 = self.screen._format_target_detail_row(2)
        self.assertIn("HP:", row2)
        self.assertIn("[", row2)
        self.assertIn("]", row2)
        self.assertNotIn("/", row2)

    def test_player_party_member_row_formatting(self):
        """Verifies party row omits parenthetical class, displays only current HP/MP, and maintains 78 chars."""
        for m_idx in range(len(self.screen.party.members)):
            m = self.screen.party.members[m_idx]
            row = self.screen._format_party_member_row(m_idx)
            stripped = self._strip_color(row)

            # 78 character width
            self.assertEqual(len(stripped), 78)

            # Name displayed without parenthetical class
            self.assertIn(m.name, stripped)
            self.assertNotIn(f"({m.job_class})", stripped)

            # Only current HP, no max HP
            self.assertIn(f"HP:{m.hp}", stripped)
            self.assertNotIn(f"HP:{m.hp}/{m.max_hp}", stripped)

            # Only current MP, no max MP
            self.assertIn(f"MP:{m.mp}", stripped)
            self.assertNotIn(f"MP:{m.mp}/{m.max_mp}", stripped)

    def test_level_disparity_penalty_not_logged(self):
        """Verifies that level disparity penalty is not logged in the combat log."""
        from eldoria_py.combat.engine import NvNCombatEngine
        from eldoria_py.combat.entities import Party, PartyMember, EnemySquad
        from eldoria_py.combat.encounters import build_from_template
        from eldoria_py.combat.bestiary import BESTIARY

        # High level hero (Level 30) vs Level 1 Wolf (gap = 29 > 10, 5% multiplier)
        hero = PartyMember(name="Archmage", job_class="Wizard", level=30)
        party = Party(members=[hero])
        wolf = build_from_template(BESTIARY["Wolf"], level=1)
        wolf.hp = 0  # Pre-slain to trigger victory
        squad = EnemySquad(enemies=[wolf])

        engine = NvNCombatEngine(party, squad)
        engine._trigger_victory()

        # Victory is logged, but disparity penalty is NOT logged
        self.assertTrue(any("VICTORY" in msg for msg in engine.combat_log))
        self.assertTrue(any("Gained" in msg for msg in engine.combat_log))
        self.assertFalse(any("Level disparity penalty" in msg for msg in engine.combat_log))

    def test_wireframe_column_alignment(self):
        """Verifies exact wireframe row lengths match the 80-column grid."""
        for row_idx in range(5):
            left_str = self.screen._format_enemy_row(row_idx)
            right_str = self.screen._format_target_detail_row(row_idx)
            row = f"│{left_str}│{right_str}│"
            vlen = len(self._strip_color(row))
            self.assertEqual(vlen, self.screen.TOTAL_WIDTH)

    def test_enemy_squad_omits_hp_and_affinity(self):
        """Verifies ENEMY SQUAD window displays only enemy names without HP numbers or affinity codes."""
        for row_idx in range(5):
            left_str = self.screen._format_enemy_row(row_idx)
            plain = self._strip_color(left_str)
            # Should not contain HP slashes or affinity labels like Dar/Fir/Wat
            self.assertNotIn("/", plain)
            for aff in ("Dar", "Fir", "Wat", "Ear", "Win", "Lig", "Neu"):
                self.assertNotIn(f" {aff}", plain)
            # If enemies are present in that row, their names should be present
            if row_idx < len(self.screen.squad.enemies):
                e = self.screen.squad.enemies[row_idx]
                self.assertIn(e.name[:10], plain)

    def _strip_color(self, text: str) -> str:
        import re
        return re.sub(r"\033\[[0-9;]*[a-zA-Z]", "", text)

    def test_section_headers_no_parentheticals(self):
        """Verifies ENEMY SQUAD and PLAYER PARTY headers omit parenthetical capacities while maintaining 80 columns."""
        lines = self.screen.generate_frame_lines()
        top_header = lines[0]
        self.assertIn("ENEMY SQUAD", top_header)
        self.assertNotIn("(Up to 10 Enemies)", top_header)
        self.assertEqual(len(self._strip_color(top_header)), self.screen.TOTAL_WIDTH)

        party_header = lines[7]
        self.assertIn("PLAYER PARTY", party_header)
        self.assertNotIn("(Up to 5 Heroes)", party_header)
        self.assertEqual(len(self._strip_color(party_header)), self.screen.TOTAL_WIDTH)

        self.assertEqual(len(lines), 24)
        for idx, line in enumerate(lines):
            self.assertEqual(len(self._strip_color(line)), self.screen.TOTAL_WIDTH, f"Line {idx} width mismatch: {line}")

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

    def test_cheat_win_command_phase(self):
        """Verifies that pressing [K] in COMMAND_PHASE immediately defeats enemies and triggers victory."""
        context = Context([0.016, [KeyEvent(key=KeyCode.CHAR, char="k", raw="k")], None])
        self.assertEqual(self.screen.engine.phase, CombatPhase.COMMAND_PHASE)
        self.screen.update(context)
        self.assertEqual(self.screen.engine.phase, CombatPhase.BATTLE_VICTORY)
        self.assertTrue(self.screen.squad.is_wiped)
        self.assertGreater(self.screen.engine.spoils_xp, 0)
        self.assertIn("VICTORY! Enemy squad eliminated!", self.screen.engine.combat_log[-2])

    def test_cheat_win_execution_phase(self):
        """Verifies that pressing [K] during EXECUTION_PHASE triggers victory."""
        self.screen.engine.phase = CombatPhase.EXECUTION_PHASE
        context = Context([0.016, [KeyEvent(key=KeyCode.CHAR, char="k", raw="k")], None])
        self.screen.update(context)
        self.assertEqual(self.screen.engine.phase, CombatPhase.BATTLE_VICTORY)
        self.assertTrue(self.screen.squad.is_wiped)

    def test_status_hints_arrows_and_contextual_back(self):
        """Verifies status hints use [Arrows], disallow WASD, and contextualize [B] Back."""
        # Member 0 (first hero): No previous hero, so [B] Back must NOT be displayed
        self.screen.active_member_idx = 0
        hints_hero1 = self.screen._format_status_hints()
        self.assertIn("[Arrows] Choose Action", hints_hero1)
        self.assertNotIn("WASD", hints_hero1)
        self.assertNotIn("[B]", hints_hero1)

        # Member 1 (second hero): [B] Back must now appear
        self.screen.active_member_idx = 1
        hints_hero2 = self.screen._format_status_hints()
        self.assertIn("[Arrows] Choose Action", hints_hero2)
        self.assertIn("[B] Back", hints_hero2)

    def test_chevron_navigation_arrows_and_wasd_ignored(self):
        """Verifies that arrow keys navigate chevrons, WASD keys are disallowed, and Backspace/B returns to prior hero."""
        self.assertEqual(self.screen.main_menu_cursor, 0)

        # WASD keys must not navigate chevron
        for char in ("w", "a", "s", "d", "W", "A", "S", "D"):
            ctx = Context([0.016, [KeyEvent(key=KeyCode.CHAR, char=char, raw=char)], None])
            self.screen.update(ctx)
            self.assertEqual(self.screen.main_menu_cursor, 0)

        # Arrow down moves cursor
        ctx = Context([0.016, [KeyEvent(key=KeyCode.DOWN, char="", raw="")], None])
        self.screen.update(ctx)
        self.assertEqual(self.screen.main_menu_cursor, 1)

        # Arrow up moves cursor back
        ctx = Context([0.016, [KeyEvent(key=KeyCode.UP, char="", raw="")], None])
        self.screen.update(ctx)
        self.assertEqual(self.screen.main_menu_cursor, 0)

        # Advance to hero 1
        self.screen.active_member_idx = 1
        # Backspace steps back to hero 0
        ctx = Context([0.016, [KeyEvent(key=KeyCode.BACKSPACE, char="", raw="")], None])
        self.screen.update(ctx)
        self.assertEqual(self.screen.active_member_idx, 0)

    def test_auto_turn_execution_cadence(self):
        """Verifies that actions execute on timer cadence and update log/display."""
        # Plan actions for all heroes sequentially
        for i in range(len(self.screen.party.alive_members)):
            self.screen.active_member_idx = i
            self.screen.engine.plan_member_action(i, ACTIONS["Attack"].copy(), self.screen.squad.enemies[0])
            self.screen._advance_to_next_member()

        self.assertEqual(self.screen.engine.phase, CombatPhase.EXECUTION_PHASE)
        self.assertEqual(self.screen.engine.execution_index, 0)

        # Delta time smaller than step_delay does not execute
        ctx_small = Context([0.016, [], None])
        self.screen.update(ctx_small)
        self.assertEqual(self.screen.engine.execution_index, 0)

        # Delta time >= step_delay triggers execution of step 1
        ctx_step = Context([self.screen.step_delay, [], None])
        self.screen.update(ctx_step)
        self.assertEqual(self.screen.engine.execution_index, 1)

        # Status hints and command cells reflect automated execution
        hints = self.screen._format_status_hints()
        self.assertIn("Resolving combat actions...", hints)
        cmd_cell = self.screen._format_command_cell(1)
        self.assertIn("Resolving turns...", cmd_cell)

    def test_auto_turn_execution_completes_round_and_returns_control(self):
        """Verifies that once all turns execute, control returns to player at Hero 1 in COMMAND_PHASE."""
        # Give enemies high base HP so round doesn't end in victory
        for e in self.screen.squad.enemies:
            e.stats[StatId.HIT_POINTS].base = 9999
            e.hp = 9999

        for i in range(len(self.screen.party.alive_members)):
            self.screen.active_member_idx = i
            self.screen.engine.plan_member_action(i, ACTIONS["Attack"].copy(), self.screen.squad.enemies[0])
            self.screen._advance_to_next_member()
        self.assertEqual(self.screen.engine.phase, CombatPhase.EXECUTION_PHASE)

        # Run frames until round completes
        ctx_step = Context([self.screen.step_delay, [], None])
        for _ in range(50):
            if self.screen.engine.phase != CombatPhase.EXECUTION_PHASE:
                break
            self.screen.update(ctx_step)

        self.assertEqual(self.screen.engine.phase, CombatPhase.COMMAND_PHASE)
        self.assertEqual(self.screen.active_member_idx, 0)
        self.assertEqual(self.screen.menu_mode, "MAIN")

    def test_auto_turn_execution_stops_on_victory(self):
        """Verifies that turn execution terminates immediately upon achieving victory."""
        # Use a small 2-enemy squad so 5 party attacks easily eliminate the squad in round 1
        self.screen.start_encounter(create_default_party(), create_bat_squad(size=2))
        for e in self.screen.squad.enemies:
            e.hp = 1

        for i in range(len(self.screen.party.alive_members)):
            self.screen.active_member_idx = i
            self.screen.engine.plan_member_action(i, ACTIONS["Attack"].copy(), self.screen.squad.enemies[0])
            self.screen._advance_to_next_member()

        ctx_step = Context([self.screen.step_delay, [], None])
        for _ in range(50):
            if self.screen.engine.phase != CombatPhase.EXECUTION_PHASE:
                break
            self.screen.update(ctx_step)

        self.assertEqual(self.screen.engine.phase, CombatPhase.BATTLE_VICTORY)
        self.assertTrue(self.screen.squad.is_wiped)

    def test_combat_log_word_wrapping(self):
        """Verifies that long combat log messages wrap across lines at nearest whole words instead of truncating."""
        long_msg = "⚔ Archer B uses Attack on Aiden [★ CRIT]: 28 dmg (10/262)"
        self.screen.engine.combat_log = [long_msg]

        wrapped_lines = self.screen._get_wrapped_log_lines(max_width=52)
        self.assertEqual(len(wrapped_lines), 2)
        self.assertEqual(wrapped_lines[0], "⚔ Archer B uses Attack on Aiden [★ CRIT]: 28 dmg")
        self.assertEqual(wrapped_lines[1], "  (10/262)")

        # Render rows 1 and 2
        row1 = self.screen._format_log_cell(1)
        row2 = self.screen._format_log_cell(2)

        self.assertIn("28 dmg", row1)
        self.assertIn("(10/262)", row2)
        from eldoria_py.terminal.box import visible_width
        self.assertEqual(visible_width(row1), 53)
        self.assertEqual(visible_width(row2), 53)

    def test_combat_log_no_hp_numbers_on_damage_or_heal(self):
        """Verifies that damage and healing log messages state the damage or HP change without appending target HP numbers."""
        enemy = self.screen.squad.enemies[0]
        for i in range(len(self.screen.party.alive_members)):
            self.screen.engine.plan_member_action(i, ACTIONS["Attack"].copy(), enemy)
        self.assertTrue(self.screen.engine.finalize_planning())
        guard = 0
        while self.screen.engine.phase == CombatPhase.EXECUTION_PHASE:
            guard += 1
            if guard > 100:
                self.fail("Infinite loop in combat execution phase")
            self.screen.engine.step_execution()

        dmg_logs = [log for log in self.screen.engine.combat_log if "uses Attack on" in log]
        self.assertTrue(len(dmg_logs) > 0)
        for log in dmg_logs:
            # Must end with damage value and not contain (curr/max) HP
            self.assertRegex(log, r"\d+ dmg$")
            self.assertNotIn(f"/{enemy.max_hp}", log)


if __name__ == "__main__":
    unittest.main()
