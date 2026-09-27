"""
Unit tests for the GSCharacterBuilderScreen.
Verifies the 6-substate character creation wizard, attribute rolls, gender innate modifiers,
bonus point allocations, dynamic Max HP/MP formulas, and PartyMember construction.
"""

import unittest
from unittest.mock import MagicMock

from eldoria_py.core.context import Context
from eldoria_py.core.fsm import SMState
from eldoria_py.terminal.input import KeyCode, KeyEvent
from eldoria_py.combat.stats import StatId, BattleActionType
from eldoria_py.combat.entities import PartyMember
from eldoria_py.combat.portrait import Gender
from eldoria_py.states.character_builder import (
    GSCharacterBuilderScreen,
    CharacterBuilderSubstate,
)
from eldoria_py.ui import UIPanel, UILabel, UIDivider


class TestCharacterBuilder(unittest.TestCase):
    def setUp(self):
        self.screen = GSCharacterBuilderScreen(screen_width=54, screen_height=24)
        self.context = Context()
        self.mock_core = MagicMock()
        self.mock_game_state = MagicMock()
        self.mock_party_builder = MagicMock()
        self.mock_game_state.states = {"GSPartyBuilderScreen": self.mock_party_builder}
        self.mock_core.game_state = self.mock_game_state
        self.context.set(SMState.ContextEldoriaCore, self.mock_core)

    def test_initial_substate_is_name_entry(self):
        self.assertEqual(self.screen.substate, CharacterBuilderSubstate.NAME_ENTRY)

    def test_male_gender_modifiers(self):
        self.screen.gender = Gender.MALE
        self.screen._roll_base_stats()
        # In a raw roll, stats are 3..14. Male gets +3 ATK (min 6) and +2 DEF (min 5).
        self.assertTrue(self.screen.base_stats[StatId.ATTACK] >= 6)
        self.assertTrue(self.screen.base_stats[StatId.DEFENSE] >= 5)

    def test_female_gender_modifiers(self):
        self.screen.gender = Gender.FEMALE
        self.screen._roll_base_stats()
        # Female gets +2 MAT (min 5), +1 MDF (min 4), +2 SPD (min 5).
        self.assertTrue(self.screen.base_stats[StatId.MAGIC_ATTACK] >= 5)
        self.assertTrue(self.screen.base_stats[StatId.MAGIC_DEFENSE] >= 4)
        self.assertTrue(self.screen.base_stats[StatId.SPEED] >= 5)

    def test_gender_selection_navigation_arrows(self):
        self.screen.substate = CharacterBuilderSubstate.GENDER_SELECTION
        self.assertEqual(self.screen.gender, Gender.MALE)

        # Down arrow moves to Female
        key_down = KeyEvent(key=KeyCode.DOWN)
        self.screen._handle_input(key_down, self.context, self.mock_core)
        self.assertEqual(self.screen.gender, Gender.FEMALE)

        # Up arrow moves back to Male
        key_up = KeyEvent(key=KeyCode.UP)
        self.screen._handle_input(key_up, self.context, self.mock_core)
        self.assertEqual(self.screen.gender, Gender.MALE)

        # WASD keys should NOT change gender (pure arrow key menu navigation)
        for char_key in ("w", "W", "s", "S", "a", "A", "d", "D"):
            self.screen._handle_input(KeyEvent(key=KeyCode.CHAR, char=char_key), self.context, self.mock_core)
            self.assertEqual(self.screen.gender, Gender.MALE)

        # Number shortcuts
        key_2 = KeyEvent(key=KeyCode.CHAR, char="2")
        self.screen._handle_input(key_2, self.context, self.mock_core)
        self.assertEqual(self.screen.gender, Gender.FEMALE)

        key_1 = KeyEvent(key=KeyCode.CHAR, char="1")
        self.screen._handle_input(key_1, self.context, self.mock_core)
        self.assertEqual(self.screen.gender, Gender.MALE)

    def test_bonus_point_pool_allocation_and_refund(self):
        self.screen.substate = CharacterBuilderSubstate.POINT_ALLOCATION
        self.assertEqual(self.screen.points_pool, 10)

        # 'd' character should NOT allocate points (WASD removed from menu navigation)
        self.screen.selected_stat_idx = 0
        self.screen._handle_input(KeyEvent(key=KeyCode.CHAR, char="d"), self.context, self.mock_core)
        self.assertEqual(self.screen.mod_stats[StatId.ATTACK], 0)
        self.assertEqual(self.screen.points_pool, 10)

        # Right arrow allocates 1 point into ATK (selected_stat_idx 0)
        key_right = KeyEvent(key=KeyCode.RIGHT)
        self.screen._handle_input(key_right, self.context, self.mock_core)
        self.assertEqual(self.screen.mod_stats[StatId.ATTACK], 1)
        self.assertEqual(self.screen.points_pool, 9)

        # 'a' character should NOT refund points
        self.screen._handle_input(KeyEvent(key=KeyCode.CHAR, char="a"), self.context, self.mock_core)
        self.assertEqual(self.screen.mod_stats[StatId.ATTACK], 1)
        self.assertEqual(self.screen.points_pool, 9)

        # Left arrow refunds 1 point from ATK
        key_left = KeyEvent(key=KeyCode.LEFT)
        self.screen._handle_input(key_left, self.context, self.mock_core)
        self.assertEqual(self.screen.mod_stats[StatId.ATTACK], 0)
        self.assertEqual(self.screen.points_pool, 10)

        # Cannot refund below 0
        self.screen._handle_input(key_left, self.context, self.mock_core)
        self.assertEqual(self.screen.mod_stats[StatId.ATTACK], 0)
        self.assertEqual(self.screen.points_pool, 10)

    def test_reroll_resets_bonus_pool_and_allocated_points(self):
        self.screen.substate = CharacterBuilderSubstate.POINT_ALLOCATION
        self.screen.mod_stats[StatId.ATTACK] = 5
        self.screen.points_pool = 5

        key_r = KeyEvent(key=KeyCode.CHAR, char="r")
        self.screen._handle_input(key_r, self.context, self.mock_core)

        self.assertEqual(self.screen.points_pool, 10)
        self.assertEqual(self.screen.mod_stats[StatId.ATTACK], 0)

    def test_points_pool_zero_digits_color_red(self):
        self.screen.substate = CharacterBuilderSubstate.POINT_ALLOCATION
        self.screen.points_pool = 10
        text_nonzero = self.screen._stats_pool_text()
        self.assertIn("\033[1;32m", text_nonzero)  # Green when points remain
        self.assertNotIn("\033[1;31m", text_nonzero)

        self.screen.points_pool = 0
        text_zero = self.screen._stats_pool_text()
        self.assertIn("\033[1;31m", text_zero)  # Red when points exhausted
        self.assertNotIn("\033[90m[ 00 ]", text_zero)

    def test_dynamic_hp_mp_derivation(self):
        # Set controlled stats: DEF=15, ATK=20, MAT=10, MDF=8
        self.screen.base_stats[StatId.DEFENSE] = 15
        self.screen.mod_stats[StatId.DEFENSE] = 0
        self.screen.base_stats[StatId.ATTACK] = 20
        self.screen.mod_stats[StatId.ATTACK] = 0
        self.screen.base_stats[StatId.MAGIC_ATTACK] = 10
        self.screen.mod_stats[StatId.MAGIC_ATTACK] = 0
        self.screen.base_stats[StatId.MAGIC_DEFENSE] = 8
        self.screen.mod_stats[StatId.MAGIC_DEFENSE] = 0

        # Max HP = 160 + (15 * 8) + (20 * 2) = 160 + 120 + 40 = 320
        # Max MP = 30 + (10 * 8) + (8 * 3) = 30 + 80 + 24 = 134
        hp, mp = self.screen._derive_hp_mp()
        self.assertEqual(hp, 320)
        self.assertEqual(mp, 134)

    def test_confirmation_substate_commits_to_party_builder(self):
        self.screen.target_slot = 1
        self.screen.char_name = "Lyra"
        self.screen.gender = Gender.FEMALE
        self.screen.substate = CharacterBuilderSubstate.CONFIRMATION

        key_enter = KeyEvent(key=KeyCode.ENTER, char="\r")
        self.screen._handle_input(key_enter, self.context, self.mock_core)

        self.assertIsNotNone(self.screen.created_member)
        self.assertEqual(self.screen.created_member.name, "Lyra")
        self.assertEqual(self.screen.created_member.gender, Gender.FEMALE)

        # Verified that party_builder.set_member_slot was called
        self.mock_party_builder.set_member_slot.assert_called_once_with(
            1, self.screen.created_member
        )
        self.mock_game_state.trigger.assert_called_once_with("ToPartyBuilder", self.context)

    def test_substate_navigation_cycle(self):
        # Name -> Gender
        self.screen.substate = CharacterBuilderSubstate.NAME_ENTRY
        self.screen._handle_input(KeyEvent(key=KeyCode.ENTER), self.context, self.mock_core)
        self.assertEqual(self.screen.substate, CharacterBuilderSubstate.GENDER_SELECTION)

        # Gender -> Stats
        self.screen._handle_input(KeyEvent(key=KeyCode.ENTER), self.context, self.mock_core)
        self.assertEqual(self.screen.substate, CharacterBuilderSubstate.POINT_ALLOCATION)

        # Stats -> Affinity
        self.screen._handle_input(KeyEvent(key=KeyCode.ENTER), self.context, self.mock_core)
        self.assertEqual(self.screen.substate, CharacterBuilderSubstate.AFFINITY_SELECTION)

        # Affinity -> Profile
        self.screen._handle_input(KeyEvent(key=KeyCode.ENTER), self.context, self.mock_core)
        self.assertEqual(self.screen.substate, CharacterBuilderSubstate.PROFILE_SELECTION)

        # Profile -> Confirm
        self.screen._handle_input(KeyEvent(key=KeyCode.ENTER), self.context, self.mock_core)
        self.assertEqual(self.screen.substate, CharacterBuilderSubstate.CONFIRMATION)

        # Confirm Esc -> Profile
        self.screen._handle_input(KeyEvent(key=KeyCode.ESCAPE), self.context, self.mock_core)
        self.assertEqual(self.screen.substate, CharacterBuilderSubstate.PROFILE_SELECTION)

    def test_character_builder_panel_structure(self):
        """Verify main_panel is a UIPanel with correct dimensions, divider, and substate panels."""
        self.assertIsInstance(self.screen.main_panel, UIPanel)
        self.assertTrue(self.screen.main_panel.has_border)
        self.assertTrue(self.screen.main_panel.is_active())
        self.assertIsInstance(self.screen.breadcrumbs_label, UILabel)
        self.assertIsInstance(self.screen.divider_header, UIDivider)
        self.assertIsInstance(self.screen.portrait_card, UIPanel)
        self.assertTrue(self.screen.portrait_card.has_border)

        for substate in CharacterBuilderSubstate:
            panel = self.screen._substate_panels.get(substate)
            self.assertIsNotNone(panel, f"Substate panel for {substate} is missing")
            self.assertIsInstance(panel, UIPanel)

    def test_all_portrait_archetypes_render_both_resolutions(self):
        """Verifies that every archetype across male and female catalogs renders without bounds violations in 54 and 80 col modes."""
        from eldoria_py.combat.portrait import get_portraits_for_gender

        for width in (54, 80):
            screen = GSCharacterBuilderScreen(screen_width=width, screen_height=24)
            screen.substate = CharacterBuilderSubstate.PROFILE_SELECTION

            for gender in [Gender.MALE, Gender.FEMALE]:
                screen.gender = gender
                catalog = get_portraits_for_gender(gender)
                for p_idx in range(len(catalog)):
                    screen.profile_idx = p_idx
                    screen._switch_substate(CharacterBuilderSubstate.PROFILE_SELECTION)
                    screen._render()
                    self.assertIsNotNone(screen.portrait_glyph_label)
                    self.assertIsNotNone(screen.portrait_card)

    def test_all_substates_render_both_resolutions(self):
        """Verifies that all 6 wizard substates render cleanly without bounds violations in both 54 and 80 col modes."""
        for width in (54, 80):
            screen = GSCharacterBuilderScreen(screen_width=width, screen_height=24)
            ctx = Context([screen])
            for substate in CharacterBuilderSubstate:
                screen._switch_substate(substate)
                screen._render()

    def test_name_entry_length_limit_to_4_chars(self):
        """Verifies that name input strictly caps at 4 characters."""
        self.screen.substate = CharacterBuilderSubstate.NAME_ENTRY
        self.screen.char_name = ""
        for char in "ALEXANDER":
            self.screen._handle_input(KeyEvent(key=KeyCode.CHAR, char=char), self.context, self.mock_core)
        self.assertEqual(self.screen.char_name, "ALEX")
        self.assertEqual(len(self.screen.char_name), 4)


if __name__ == "__main__":
    unittest.main()
