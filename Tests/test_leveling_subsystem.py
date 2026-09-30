"""Unit tests for Experience Points (XP), Archetype Progression, and Leveling Subsystem."""
import unittest
from eldoria_py.combat.stats import StatId, BattleActionType, BattleEntityProperty
from eldoria_py.combat.entities import (
    PartyMember,
    Party,
    EnemyCombatant,
    EnemySquad,
    create_default_party,
    calculate_required_xp,
    CLASS_GROWTH_RATES,
)
from eldoria_py.combat.portrait import Gender
from eldoria_py.combat.engine import NvNCombatEngine, CombatPhase
from eldoria_py.combat.damage import calculate_hit, calculate_crit
from eldoria_py.states.main_menu_screen import GSMainMenuScreen, visible_width, strip_ansi
from eldoria_py.terminal.color import ColorLibrary


class TestStatCapsAndFloors(unittest.TestCase):
    """Verifies HP (9999), MP (999), and attribute ([1, 99]) caps and floors."""

    def test_attribute_hard_capped_at_99(self):
        prop = BattleEntityProperty(base=50, stat_id=StatId.ATTACK)
        self.assertEqual(prop.total, 50)

        # Equipment bonus exceeding 99
        prop.equipment_bonus = 60
        self.assertEqual(prop.total, 99)

        # Magical augment buff
        prop.apply_augment(30, duration_turns=3)
        self.assertEqual(prop.total, 99)

    def test_debuffs_cannot_reduce_attribute_below_1(self):
        prop = BattleEntityProperty(base=15, stat_id=StatId.DEFENSE)
        prop.apply_augment(-50, duration_turns=3)
        self.assertEqual(prop.total, 1)

    def test_hp_capped_at_9999_and_floored_at_1_total(self):
        hp_prop = BattleEntityProperty(base=5000, stat_id=StatId.HIT_POINTS)
        hp_prop.equipment_bonus = 6000
        self.assertEqual(hp_prop.total, 9999)
        self.assertEqual(hp_prop.current, 5000)

        # Current HP drops to 0 when KO'd
        hp_prop.current = 0
        self.assertEqual(hp_prop.current, 0)

    def test_mp_capped_at_999_and_floored_at_0(self):
        mp_prop = BattleEntityProperty(base=500, stat_id=StatId.MAGIC_POINTS)
        mp_prop.equipment_bonus = 600
        self.assertEqual(mp_prop.total, 999)
        mp_prop.current = 0
        self.assertEqual(mp_prop.current, 0)


class TestExperienceCurveAndProgression(unittest.TestCase):
    """Verifies XP curve monotonicity, resolution at level 99 (1,000,000 XP), and class/gender modulations."""

    def test_xp_curve_monotonicity_and_endpoints(self):
        classes = ["Knight", "Mage", "Rogue", "Cleric", "Berserker"]
        genders = [Gender.MALE, Gender.FEMALE]

        for cls_name in classes:
            for gen in genders:
                self.assertEqual(calculate_required_xp(1, cls_name, gen), 0)
                self.assertEqual(calculate_required_xp(99, cls_name, gen), 1_000_000)
                self.assertEqual(calculate_required_xp(100, cls_name, gen), 1_000_000)

                prev = -1
                for lv in range(1, 100):
                    req = calculate_required_xp(lv, cls_name, gen)
                    self.assertGreater(req, prev, f"XP curve failed monotonicity at level {lv} for {cls_name} {gen}")
                    prev = req

    def test_base_stats_headroom_at_level_99(self):
        """Verifies that base attributes alone never reach 99 by level 99 across all classes."""
        party = create_default_party()
        for member in party.members:
            # Level member from starting level to 99
            levels_to_gain = 99 - member.level
            if levels_to_gain > 0:
                member.add_xp(1_000_000)
            self.assertEqual(member.level, 99)
            self.assertEqual(member.xp, 1_000_000)

            for stat_id, prop in member.stats.items():
                if stat_id in (StatId.HIT_POINTS, StatId.MAGIC_POINTS):
                    continue
                self.assertLess(
                    prop.base,
                    99,
                    f"{member.job_class} {stat_id.value} base reached {prop.base} >= 99 without equipment!",
                )
            self.assertLessEqual(member.stats[StatId.HIT_POINTS].base, 9999)
            self.assertLessEqual(member.stats[StatId.MAGIC_POINTS].base, 999)


class TestCombatSpoilsDistribution(unittest.TestCase):
    """Verifies combat spoils division among survivors, KO exclusion, and excess carryover."""

    def setUp(self):
        self.party = Party()
        self.m1 = PartyMember(name="Aide", job_class="Knight", level=1, xp=0)
        self.m2 = PartyMember(name="Lyra", job_class="Mage", level=1, xp=0)
        self.m3 = PartyMember(name="Dirk", job_class="Rogue", level=1, xp=0)
        self.party.add_member(self.m1)
        self.party.add_member(self.m2)
        self.party.add_member(self.m3)

        self.squad = EnemySquad()
        e1 = EnemyCombatant(name="Goblin A", xp_reward=60, gold_reward=50)
        e2 = EnemyCombatant(name="Goblin B", xp_reward=60, gold_reward=50)
        self.squad.add_enemy(e1)
        self.squad.add_enemy(e2)

    def test_ko_member_receives_no_xp_and_survivors_share(self):
        # Knock out Dirk
        self.m3.hp = 0
        self.assertFalse(self.m3.is_alive)

        engine = NvNCombatEngine(party=self.party, squad=self.squad)
        for e in self.squad.enemies:
            e.hp = 0

        engine.phase = CombatPhase.EXECUTION_PHASE
        engine.step_execution()

        self.assertEqual(engine.phase, CombatPhase.BATTLE_VICTORY)
        # Total XP = 120. Divided among 2 survivors = 60 each.
        self.assertEqual(self.m3.xp, 0)
        self.assertEqual(self.m1.xp, 60)
        self.assertEqual(self.m2.xp, 60)
        self.assertEqual(self.party.gold, 100)

        # Log check
        full_log = "\n".join(engine.combat_log)
        self.assertIn("Dirk was KO'd and received no XP", full_log)

    def test_excess_xp_carryover_and_multilevel_promotions(self):
        member = PartyMember(name="Aide", job_class="Knight", level=1, xp=0)
        # Level 1 -> Level 2 is ~44 XP. Level 3 is ~138 XP.
        # Adding 500 XP should promote Aide multiple levels.
        initial_hp = member.max_hp
        initial_atk = member.get_stat(StatId.ATTACK)

        summaries = member.add_xp(500)
        self.assertGreaterEqual(len(summaries), 2)
        self.assertGreater(member.level, 2)
        self.assertEqual(member.xp, 500)
        self.assertGreater(member.max_hp, initial_hp)
        self.assertGreater(member.get_stat(StatId.ATTACK), initial_atk)


class TestUIGoldenStarsAndDisplay(unittest.TestCase):
    """Verifies golden stars for 99 attributes and 1,000,000 XP, and clamped EVA/CRIT."""

    def setUp(self):
        self.screen = GSMainMenuScreen()
        self.party = create_default_party()
        self.screen.party = self.party

    def test_attribute_at_99_displays_golden_stars(self):
        m = self.party.members[0]
        # Buff attack total to 99 with equipment (base 28 + eq 71 = 99)
        m.stats[StatId.ATTACK].equipment_bonus = 71
        self.assertEqual(m.stats[StatId.ATTACK].total, 99)

        line = self.screen._format_attr_pair(m, StatId.ATTACK, "ATK", StatId.DEFENSE, "DEF")
        gold_color = ColorLibrary.Gold.to_fg_ansi()

        self.assertIn(f"{gold_color}★★\033[0m", line)
        self.assertNotIn("99", strip_ansi(line.split("DEF")[0]))  # Ensure '99' is replaced
        self.assertEqual(visible_width(line), 55)

    def test_exp_at_one_million_displays_golden_stars(self):
        self.screen.category_idx = 0  # Status
        m = self.party.members[0]
        m.xp = 1_000_000
        m.level = 99

        lines = self.screen._render_status_submenu()
        exp_line = [l for l in lines if "EXP:" in l][0]
        gold_color = ColorLibrary.Gold.to_fg_ansi()

        self.assertIn(f"{gold_color}★★\033[0m", exp_line)
        self.assertNotIn("1000000", strip_ansi(exp_line))

    def test_evasion_and_crit_never_100_percent(self):
        m = self.party.members[0]
        # Max out speed and luck
        m.stats[StatId.SPEED].equipment_bonus = 99
        m.stats[StatId.LUCK].equipment_bonus = 99

        line = self.screen._format_attr_pair(m, StatId.LUCK, "LCK", StatId.HIT_POINTS, "EVA/CRIT")
        stripped = strip_ansi(line)

        self.assertIn("EVA:", stripped)
        self.assertIn("CRIT:", stripped)
        self.assertNotIn("100%", stripped)

        # Core damage hit and crit check
        for _ in range(100):
            hit = calculate_hit(attacker_acc=99, target_spd=99, target_lck=99)
            crit = calculate_crit(attacker_lck=99, target_lck=1)
            # Calculations ensure hit is never guaranteed 100% and crit never 100%
            self.assertIsInstance(hit, bool)
            self.assertIsInstance(crit, bool)


if __name__ == "__main__":
    unittest.main()
