"""
Unit tests for the GSPartyBuilderScreen.
Verifies 5-slot party management, embark requirements, auto-fill templates, and state transitions.
"""

from pathlib import Path
import tempfile
import unittest
from unittest.mock import MagicMock

from eldoria_py.core.context import Context
from eldoria_py.core.fsm import SMState
from eldoria_py.core.save_manager import SaveManager
from eldoria_py.terminal.input import KeyCode, KeyEvent
from eldoria_py.combat.stats import StatId, BattleActionType
from eldoria_py.combat.entities import PartyMember, Party
from eldoria_py.combat.portrait import Gender
from eldoria_py.states.party_builder import GSPartyBuilderScreen
from eldoria_py.ui.panel import UIPanel
from eldoria_py.ui.elements.label import UILabel
from eldoria_py.ui.elements.divider import UIDivider
from eldoria_py.ui.elements.party_slot import UIPartySlotList, UIPartySlotItem
from eldoria_py.terminal.screen import TerminalScreen


class TestPartyBuilder(unittest.TestCase):
    def setUp(self):
        self.temp_dir = tempfile.TemporaryDirectory()
        self.screen = GSPartyBuilderScreen(screen_width=54, screen_height=24)
        self.screen.save_manager = SaveManager(save_dir=Path(self.temp_dir.name))
        self.context = Context()
        self.mock_core = MagicMock()
        self.mock_game_state = MagicMock()
        self.mock_game_state.states = {}
        self.mock_core.game_state = self.mock_game_state
        self.context.set(SMState.ContextEldoriaCore, self.mock_core)

    def tearDown(self):
        self.temp_dir.cleanup()

    def test_initial_party_slots_empty(self):
        self.assertEqual(len(self.screen.party_slots), 5)
        self.assertTrue(all(slot is None for slot in self.screen.party_slots))
        self.assertFalse(self.screen.can_embark(), "Cannot embark with an empty party")

    def test_embark_requires_leader(self):
        # Setting member in slot 1 (companion) without leader should still fail
        companion = PartyMember(name="Lyra", job_class="Mage", gender=Gender.FEMALE)
        self.screen.set_member_slot(1, companion)
        self.assertFalse(self.screen.can_embark())

        # Setting leader in slot 0 enables embark
        leader = PartyMember(name="Aiden", job_class="Warrior", gender=Gender.MALE)
        self.screen.set_member_slot(0, leader)
        self.assertTrue(self.screen.can_embark())

    def test_auto_fill_templates_fills_empty_slots(self):
        # Manually configure slot 0
        leader = PartyMember(name="CustomLeader", job_class="Paladin", gender=Gender.MALE)
        self.screen.set_member_slot(0, leader)

        self.screen.auto_fill_templates()

        # Slot 0 should not be overwritten
        self.assertEqual(self.screen.party_slots[0].name, "CustomLeader")

        # Slots 1 to 4 should now be filled with valid PartyMembers
        for idx in range(1, 5):
            member = self.screen.party_slots[idx]
            self.assertIsNotNone(member, f"Slot {idx} should be filled by auto-fill")
            self.assertIsInstance(member, PartyMember)
            self.assertTrue(member.hp > 0)
            self.assertTrue(member.max_hp > 0)

    def test_build_party_packages_active_members(self):
        leader = PartyMember(name="Aiden", job_class="Warrior")
        self.screen.set_member_slot(0, leader)
        self.screen.set_member_slot(2, PartyMember(name="Garrick", job_class="Guardian"))

        party = self.screen.build_party()
        self.assertIsInstance(party, Party)
        self.assertEqual(len(party.members), 2)
        self.assertEqual(party.members[0].name, "Aiden")
        self.assertEqual(party.members[1].name, "Garrick")

    def test_clear_slot(self):
        member = PartyMember(name="Aiden", job_class="Warrior")
        self.screen.set_member_slot(0, member)
        self.assertIsNotNone(self.screen.party_slots[0])

        self.screen.clear_slot(0)
        self.assertIsNone(self.screen.party_slots[0])
        self.assertIn("Cleared", self.screen.status_message)

    def test_enter_key_triggers_character_builder(self):
        mock_builder = MagicMock()
        self.mock_game_state.states["GSCharacterBuilderScreen"] = mock_builder

        # Initially slot 0 is unlocked
        key = KeyEvent(key=KeyCode.ENTER, char="\r")
        self.screen._handle_input(key, self.context, self.mock_core)

        mock_builder.set_target_slot.assert_called_once_with(0, None)
        self.mock_game_state.trigger.assert_called_once_with("ToCharacterBuilder", self.context)

        # Now configure slots 0 and 1; slot 2 unlocks and can be targeted
        mock_builder.reset_mock()
        self.mock_game_state.trigger.reset_mock()
        self.screen.set_member_slot(0, PartyMember(name="Aiden", job_class="Warrior"))
        self.screen.set_member_slot(1, PartyMember(name="Lyra", job_class="Mage"))
        self.screen.selected_slot_idx = 2
        self.screen._handle_input(key, self.context, self.mock_core)
        mock_builder.set_target_slot.assert_called_once_with(2, None)
        self.mock_game_state.trigger.assert_called_once_with("ToCharacterBuilder", self.context)

    def test_embark_key_triggers_to_noise_map(self):
        mock_map = MagicMock()
        self.mock_game_state.states["GSNoiseMapTestScreen"] = mock_map

        leader = PartyMember(name="Aiden", job_class="Warrior")
        self.screen.set_member_slot(0, leader)

        key = KeyEvent(key=KeyCode.SPACE, char=" ")
        self.screen._handle_input(key, self.context, self.mock_core)
        self.assertEqual(self.screen.embark_modal_step, 1)

        # Step 1: Select World Size (2 for Medium)
        self.screen._handle_input(KeyEvent(key=KeyCode.CHAR, char="2"), self.context, self.mock_core)
        self.assertEqual(self.screen.embark_modal_step, 2)

        # Step 2: Select Save Slot (1 for Slot 1)
        self.screen._handle_input(KeyEvent(key=KeyCode.CHAR, char="1"), self.context, self.mock_core)

        self.mock_game_state.trigger.assert_called_once_with("ToNoiseMap", self.context)
        self.assertIsInstance(self.context.get("party"), Party)
        self.assertEqual(mock_map.party.members[0].name, "Aiden")

    def test_party_builder_panel_structure(self):
        """Verify party_panel is a UIPanel with correct dimensions, dividers, and slot components."""
        self.assertIsInstance(self.screen.party_panel, UIPanel)
        self.assertTrue(self.screen.party_panel.has_border)
        self.assertTrue(self.screen.party_panel.is_active())
        self.assertIsInstance(self.screen.status_label, UILabel)
        self.assertIsInstance(self.screen.divider_header, UIDivider)
        self.assertIsInstance(self.screen.slot_list, UIPartySlotList)
        self.assertEqual(len(self.screen.slot_list.slots), 5)
        for slot in self.screen.slot_list.slots:
            self.assertIsInstance(slot, UIPartySlotItem)
            self.assertIsInstance(slot.line1_label, UILabel)
            self.assertIsInstance(slot.line2_label, UILabel)

    def test_party_builder_slot_list_navigation(self):
        """Verify circular selection navigation within unlocked slots and selective dirty-rect marking."""
        self.assertEqual(self.screen.selected_slot_idx, 0)
        self.assertTrue(self.screen.slot_list.slots[0].selected)
        self.assertFalse(self.screen.slot_list.slots[1].selected)

        # Clear dirty flags
        for slot in self.screen.slot_list.slots:
            slot.line1_label.dirty = False
            slot.line2_label.dirty = False

        # W and S characters should NOT move slot selection
        self.screen._handle_input(KeyEvent(key=KeyCode.CHAR, char="s"), self.context, self.mock_core)
        self.assertEqual(self.screen.selected_slot_idx, 0)
        self.screen._handle_input(KeyEvent(key=KeyCode.CHAR, char="w"), self.context, self.mock_core)
        self.assertEqual(self.screen.selected_slot_idx, 0)

        # Initially when only Slot 0 is unlocked, Down and Up stay on Slot 0
        down_key = KeyEvent(key=KeyCode.DOWN)
        self.screen._handle_input(down_key, self.context, self.mock_core)
        self.assertEqual(self.screen.selected_slot_idx, 0)

        up_key = KeyEvent(key=KeyCode.UP)
        self.screen._handle_input(up_key, self.context, self.mock_core)
        self.assertEqual(self.screen.selected_slot_idx, 0)

        # Configure Leader in Slot 0 -> Slot 1 unlocks
        leader = PartyMember(name="Aiden", job_class="Warrior")
        self.screen.set_member_slot(0, leader)

        for slot in self.screen.slot_list.slots:
            slot.line1_label.dirty = False
            slot.line2_label.dirty = False

        # Move Down via Down Arrow to Slot 1
        self.screen._handle_input(down_key, self.context, self.mock_core)
        self.assertEqual(self.screen.selected_slot_idx, 1)
        self.assertFalse(self.screen.slot_list.slots[0].selected)
        self.assertTrue(self.screen.slot_list.slots[1].selected)

        # Only slot 0 and slot 1 should be dirty
        self.assertTrue(self.screen.slot_list.slots[0].line1_label.dirty)
        self.assertTrue(self.screen.slot_list.slots[1].line1_label.dirty)
        self.assertFalse(self.screen.slot_list.slots[2].line1_label.dirty)
        self.assertFalse(self.screen.slot_list.slots[3].line1_label.dirty)
        self.assertFalse(self.screen.slot_list.slots[4].line1_label.dirty)

        # Move Up from 1 -> back to 0 via Up Arrow
        self.screen._handle_input(up_key, self.context, self.mock_core)
        self.assertEqual(self.screen.selected_slot_idx, 0)

        # Move Up from 0 -> wraps to highest unlocked slot (1)
        self.screen._handle_input(up_key, self.context, self.mock_core)
        self.assertEqual(self.screen.selected_slot_idx, 1)
        self.assertTrue(self.screen.slot_list.slots[1].selected)

    def test_party_builder_bounds_validation_both_resolutions(self):
        """Verify full rendering in both 54 and 80 column modes produces no bounds violations."""
        for width in (54, 80):
            screen = GSPartyBuilderScreen(screen_width=width, screen_height=24)
            ctx = Context([screen])
            screen.enter(ctx)

            # Draw empty state
            screen._render()

            # Fill with templates and draw filled state
            screen.auto_fill_templates()
            screen._render()

            # Clear a slot and draw partially-filled state
            screen.clear_slot(2)
            screen._render()

    def test_party_builder_title_member_count(self):
        """Verify dynamic title accurately reflects the count of configured party members."""
        self.assertIn("[0/5]", self.screen.party_panel.title)

        # Add leader
        leader = PartyMember(name="Aiden", job_class="Warrior")
        self.screen.set_member_slot(0, leader)
        self.assertIn("[1/5]", self.screen.party_panel.title)

        # Auto-fill remaining
        self.screen.auto_fill_templates()
        self.assertIn("[5/5]", self.screen.party_panel.title)

        # Clear 1 slot
        self.screen.clear_slot(1)
        self.assertIn("[4/5]", self.screen.party_panel.title)

    def test_party_builder_direct_number_selection(self):
        """Verify pressing '1'..'5' respects slot locking when empty, and selects directly when unlocked."""
        self.assertEqual(self.screen.selected_slot_idx, 0)

        # While slots 2..5 are locked, pressing 2..5 fails, cursor stays on 0, and status displays warning
        for num_str in ("2", "3", "4", "5"):
            key = KeyEvent(key=KeyCode.CHAR, char=num_str)
            self.screen._handle_input(key, self.context, self.mock_core)
            self.assertEqual(self.screen.selected_slot_idx, 0)
            self.assertIn("locked", self.screen.status_message.lower())

        # Auto-fill unlocks all 5 slots
        self.screen.auto_fill_templates()
        for num_str in ("3", "5", "2", "1", "4"):
            expected_idx = int(num_str) - 1
            key = KeyEvent(key=KeyCode.CHAR, char=num_str)
            self.screen._handle_input(key, self.context, self.mock_core)
            self.assertEqual(self.screen.selected_slot_idx, expected_idx)

    def test_party_builder_arrow_keys_navigate_without_triggering_title(self):
        """Verify Up and Down arrow keys navigate slots and NEVER trigger ToTitle."""
        self.assertEqual(self.screen.selected_slot_idx, 0)
        # Unlock slot 1 by configuring leader
        self.screen.set_member_slot(0, PartyMember(name="Aiden", job_class="Warrior"))

        down_key = KeyEvent(key=KeyCode.DOWN, raw="\x1b[B")
        self.screen._handle_input(down_key, self.context, self.mock_core)
        self.assertEqual(self.screen.selected_slot_idx, 1)
        self.mock_game_state.trigger.assert_not_called()

        up_key = KeyEvent(key=KeyCode.UP, raw="\x1b[A")
        self.screen._handle_input(up_key, self.context, self.mock_core)
        self.assertEqual(self.screen.selected_slot_idx, 0)
        self.mock_game_state.trigger.assert_not_called()

    def test_party_builder_escape_triggers_title(self):
        """Verify only explicit Escape key triggers ToTitle."""
        esc_key = KeyEvent(key=KeyCode.ESCAPE, raw="\033")
        self.screen._handle_input(esc_key, self.context, self.mock_core)
        self.mock_game_state.trigger.assert_called_once_with("ToTitle", self.context)

    def test_party_builder_sequential_locking_and_visuals(self):
        """Verify slot lock statuses, dimmed text, and progression unlocking."""
        # Slot 0 is unlocked initially; slots 1..4 are locked
        self.assertFalse(self.screen.slot_list.slots[0].locked)
        for i in range(1, 5):
            self.assertTrue(self.screen.slot_list.slots[i].locked)
            self.assertIn("Locked", self.screen.slot_list.slots[i].line1_label.text)
            self.assertIn("Locked", self.screen.slot_list.slots[i].line2_label.text)

        # Set leader in Slot 0 -> Slot 1 unlocks, Slots 2..4 remain locked
        leader = PartyMember(name="Aiden", job_class="Warrior")
        self.screen.set_member_slot(0, leader)
        self.assertFalse(self.screen.slot_list.slots[0].locked)
        self.assertFalse(self.screen.slot_list.slots[1].locked)
        self.assertIn("Empty Slot", self.screen.slot_list.slots[1].line1_label.text)
        for i in range(2, 5):
            self.assertTrue(self.screen.slot_list.slots[i].locked)

        # Set companion in Slot 1 -> Slot 2 unlocks, Slots 3..4 remain locked
        comp1 = PartyMember(name="Lyra", job_class="Mage")
        self.screen.set_member_slot(1, comp1)
        self.assertFalse(self.screen.slot_list.slots[2].locked)
        self.assertTrue(self.screen.slot_list.slots[3].locked)
        self.assertTrue(self.screen.slot_list.slots[4].locked)

    def test_party_builder_clear_slot_shifts_contiguous(self):
        """Verify clearing a slot shifts subsequent members forward to preserve contiguous party."""
        m0 = PartyMember(name="Aiden", job_class="Warrior")
        m1 = PartyMember(name="Lyra", job_class="Mage")
        m2 = PartyMember(name="Vesper", job_class="Rogue")
        self.screen.set_member_slot(0, m0)
        self.screen.set_member_slot(1, m1)
        self.screen.set_member_slot(2, m2)

        # Max unlocked slot should be 3
        self.assertEqual(self.screen.slot_list.max_unlocked_idx, 3)

        # Clear slot 1 (Lyra)
        self.screen.clear_slot(1)

        # Party should shift: slot 0 is Aiden, slot 1 is Vesper, slot 2 is None, slot 3 is None
        self.assertEqual(self.screen.party_slots[0].name, "Aiden")
        self.assertEqual(self.screen.party_slots[1].name, "Vesper")
        self.assertIsNone(self.screen.party_slots[2])
        self.assertIsNone(self.screen.party_slots[3])

        # Max unlocked slot is now 2 (Slot 3)
        self.assertEqual(self.screen.slot_list.max_unlocked_idx, 2)
        self.assertFalse(self.screen.slot_list.slots[2].locked)
        self.assertTrue(self.screen.slot_list.slots[3].locked)
        self.assertTrue(self.screen.slot_list.slots[4].locked)

    def test_party_builder_footer_reflects_arrow_keys(self):
        """Verify footer help display explicitly displays [↑/↓] arrow keys for menu navigation."""
        self.assertIn("[↑/↓]", self.screen._footer_text())
        self.assertIn("[↑/↓]", self.screen.party_panel.footer)

        screen_80 = GSPartyBuilderScreen(screen_width=80, screen_height=24)
        self.assertIn("[↑/↓]", screen_80._footer_text())
        self.assertIn("[↑/↓]", screen_80.party_panel.footer)


if __name__ == "__main__":
    unittest.main()
