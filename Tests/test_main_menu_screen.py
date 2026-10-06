"""
Comprehensive unit and boundary regression tests for GSMainMenuScreen.
Verifies:
1. Exact mathematical column budget: row visible width == 80 across all submenus and modals.
2. Left rail width == 22, right pane width == 55.
3. 4-letter hero tabs calculation and bounds.
4. Category navigation and hero switching.
5. Item consumption, target healing, and discard safety.
6. Equipment drawer browsing, live stat comparison, and equip/unequip swaps.
7. Field magic casting with MP deduction.
8. Save slot telemetry and save execution.
9. Quit modal transitions.
"""
import unittest
from unittest.mock import MagicMock

from eldoria_py.core.context import Context
from eldoria_py.core.fsm import SMState
from eldoria_py.terminal.input import KeyCode, KeyEvent
from eldoria_py.terminal.box import visible_width, strip_ansi
from eldoria_py.combat.stats import StatId, EquipmentSlot, TargetScope
from eldoria_py.combat.actions import BattleAction, ActionCategory, ACTIONS
from eldoria_py.combat.equipment import BattleEquipment, EQUIPMENT_CATALOG
from eldoria_py.combat.entities import PartyMember, Party, create_default_party
from eldoria_py.combat.items import get_item
from eldoria_py.ui.panel import UIPanel
from eldoria_py.ui.elements.label import UILabel
from eldoria_py.states.main_menu_screen import GSMainMenuScreen, _pad_cell


class TestMainMenuScreen(unittest.TestCase):
    def setUp(self):
        self.party = create_default_party()
        self.screen = GSMainMenuScreen(party=self.party)
        self.context = Context()
        self.mock_core = MagicMock()
        self.mock_game_state = MagicMock()
        self.mock_noise_map = MagicMock()
        self.mock_game_state.states = {
            "GSNoiseMapTestScreen": self.mock_noise_map,
            "GSMainMenuScreen": self.screen,
        }
        self.mock_core.game_state = self.mock_game_state
        self.mock_core.is_running = True
        self.context.set(SMState.ContextEldoriaCore, self.mock_core)
        self.screen.configure_menu(self.party, self.mock_noise_map, sector_coords=(2, 1), playtime_seconds=3665)

    def test_column_and_row_boundary_invariants_all_submenus(self):
        """Mathematically verifies that every row across all 6 submenus measures exactly 80 columns."""
        for cat_idx in range(len(self.screen.CATEGORIES)):
            self.screen.category_idx = cat_idx
            for hero_idx in range(len(self.party.members)):
                self.screen.hero_idx = hero_idx

                left_lines = self.screen._render_left_rail()
                right_lines = self.screen._render_right_pane()

                self.assertEqual(len(left_lines), 37)
                self.assertEqual(len(right_lines), 37)

                for r_idx in range(37):
                    l_cell = _pad_cell(left_lines[r_idx], self.screen.LEFT_WIDTH)
                    r_cell = _pad_cell(right_lines[r_idx], self.screen.RIGHT_WIDTH)

                    self.assertEqual(
                        visible_width(l_cell),
                        22,
                        f"Left rail cell at row {r_idx} violates 22-column width: '{l_cell}'",
                    )
                    self.assertEqual(
                        visible_width(r_cell),
                        55,
                        f"Right pane cell at row {r_idx} violates 55-column width: '{r_cell}'",
                    )

                    row_str = f"│{l_cell}│{r_cell}│"
                    self.assertEqual(
                        visible_width(row_str),
                        80,
                        f"Master frame row {r_idx + 2} violates 80-column width in category {self.screen.CATEGORIES[cat_idx]}",
                    )

    def test_modal_cards_boundary_invariants(self):
        """Verifies that all modal cards and sub-dialogs strictly adhere to the 55-column right pane width."""
        # 1. Item Action Select Modal
        self.screen.category_idx = 1  # Items
        self.screen.focus_mode = "MODAL"
        for mode in ("ACTION_SELECT", "TARGET_SELECT", "DISCARD_CONFIRM"):
            self.screen.item_modal_mode = mode
            right_lines = self.screen._render_right_pane()
            for r_idx, line in enumerate(right_lines):
                cell = _pad_cell(line, 55)
                self.assertEqual(
                    visible_width(cell),
                    55,
                    f"Item modal {mode} line {r_idx} violates 55-column width: '{cell}'",
                )

        # 2. Equipment Drawer & Delta Card
        self.screen.category_idx = 2  # Equipment
        self.screen.equip_drawer_open = True
        self.screen.equip_drawer_items = [EQUIPMENT_CATALOG["Steel Broadsword"], None]
        right_lines = self.screen._render_right_pane()
        for r_idx, line in enumerate(right_lines):
            cell = _pad_cell(line, 55)
            self.assertEqual(
                visible_width(cell),
                55,
                f"Equipment drawer line {r_idx} violates 55-column width",
            )

        # 3. Magic Target Select Modal
        self.screen.category_idx = 3  # Magic
        self.screen.magic_modal_mode = "TARGET_SELECT"
        right_lines = self.screen._render_right_pane()
        for r_idx, line in enumerate(right_lines):
            cell = _pad_cell(line, 55)
            self.assertEqual(
                visible_width(cell),
                55,
                f"Magic target modal line {r_idx} violates 55-column width",
            )

        # 4. Quit Modal
        self.screen.category_idx = self.screen.CATEGORIES.index("Quit")
        right_lines = self.screen._render_right_pane()
        for r_idx, line in enumerate(right_lines):
            cell = _pad_cell(line, 55)
            self.assertEqual(
                visible_width(cell),
                55,
                f"Quit modal line {r_idx} violates 55-column width",
            )

    def test_hero_tabs_deterministic_width(self):
        """Verifies that the hero tab bar string visible width is <= 55 with 4-letter names."""
        for active_idx in range(len(self.party.members)):
            self.screen.hero_idx = active_idx
            tab_str = self.screen._format_hero_tabs()
            v_len = visible_width(tab_str)
            self.assertLessEqual(
                v_len,
                55,
                f"Hero tab bar with active hero {active_idx} exceeds 55 columns: length={v_len}",
            )

    def test_category_navigation_arrows(self):
        """Tests that up/down arrows cycle through all 6 menu categories."""
        self.screen.focus_mode = "CATEGORIES"
        self.assertEqual(self.screen.category_idx, 0)

        # Down arrow cycles forward
        self.screen._handle_input(KeyEvent(key=KeyCode.DOWN), self.context, self.mock_core)
        self.assertEqual(self.screen.category_idx, 1)

        # Up arrow cycles backward
        self.screen._handle_input(KeyEvent(key=KeyCode.UP), self.context, self.mock_core)
        self.assertEqual(self.screen.category_idx, 0)

        # Up arrow at 0 wraps to last category (Quit)
        self.screen._handle_input(KeyEvent(key=KeyCode.UP), self.context, self.mock_core)
        self.assertEqual(self.screen.category_idx, len(self.screen.CATEGORIES) - 1)

    def test_hero_cycling_arrows(self):
        """Tests that left/right arrows cycle through heroes in the party."""
        self.screen.focus_mode = "CATEGORIES"
        self.assertEqual(self.screen.hero_idx, 0)

        # Right arrow moves to Hero 1 (Lyra)
        self.screen._handle_input(KeyEvent(key=KeyCode.RIGHT), self.context, self.mock_core)
        self.assertEqual(self.screen.hero_idx, 1)

        # Left arrow moves back to Hero 0 (Aide)
        self.screen._handle_input(KeyEvent(key=KeyCode.LEFT), self.context, self.mock_core)
        self.assertEqual(self.screen.hero_idx, 0)

        # Left arrow at 0 wraps to 4 (Vane)
        self.screen._handle_input(KeyEvent(key=KeyCode.LEFT), self.context, self.mock_core)
        self.assertEqual(self.screen.hero_idx, 4)

    def test_status_category_cannot_be_selected(self):
        """Verifies that pressing Enter on Status category does not transition to SUBMENU and Left/Right switches heroes."""
        self.screen.category_idx = 0  # Status
        self.screen.focus_mode = "CATEGORIES"

        # Press Enter on Status -> remains in CATEGORIES
        self.screen._handle_input(KeyEvent(key=KeyCode.ENTER), self.context, self.mock_core)
        self.assertEqual(self.screen.focus_mode, "CATEGORIES")

        # Status hints omit [Enter] Confirm
        hints = self.screen._format_status_hints()
        self.assertNotIn("[Enter]", hints)
        self.assertIn("[◄►] Switch Hero", hints)

        # Left/Right arrow keys continue to cycle heroes freely
        self.screen._handle_input(KeyEvent(key=KeyCode.RIGHT), self.context, self.mock_core)
        self.assertEqual(self.screen.hero_idx, 1)
        self.assertEqual(self.screen.focus_mode, "CATEGORIES")

    def test_item_use_healing_flow(self):
        """Tests navigating items, opening action modal, and healing target hero."""
        self.screen.category_idx = 1  # Items
        self.screen.focus_mode = "SUBMENU"
        self.party.inventory = []
        self.party.add_item("Potion", 2)

        hero = self.party.members[0]
        hero.hp = hero.max_hp - 30

        # Press Enter on Potion -> opens action modal
        self.screen._handle_input(KeyEvent(key=KeyCode.ENTER), self.context, self.mock_core)
        self.assertEqual(self.screen.focus_mode, "MODAL")
        self.assertEqual(self.screen.item_modal_mode, "ACTION_SELECT")

        # Press Enter on 'Use Item' -> opens target select
        self.screen._handle_input(KeyEvent(key=KeyCode.ENTER), self.context, self.mock_core)
        self.assertEqual(self.screen.item_modal_mode, "TARGET_SELECT")

        # Press Enter on Target 0 (Hero) -> heals and decrements
        self.screen._handle_input(KeyEvent(key=KeyCode.ENTER), self.context, self.mock_core)
        self.assertEqual(hero.hp, hero.max_hp)
        self.assertEqual(self.party.get_item_count("Potion"), 1)
        self.assertEqual(self.screen.focus_mode, "SUBMENU")
        self.assertIn("recovered 30 HP", self.screen.banner_message)

    def test_item_discard_flow(self):
        """Tests discarding an item from inventory with confirmation."""
        self.screen.category_idx = 1  # Items
        self.screen.focus_mode = "SUBMENU"
        self.party.inventory = []
        self.party.add_item("Potion", 2)

        # Press Enter on item
        self.screen._handle_input(KeyEvent(key=KeyCode.ENTER), self.context, self.mock_core)

        # Move to 'Discard' (index 1) and press Enter -> enters DISCARD_CHOICE
        self.screen._handle_input(KeyEvent(key=KeyCode.RIGHT), self.context, self.mock_core)
        self.screen._handle_input(KeyEvent(key=KeyCode.ENTER), self.context, self.mock_core)
        self.assertEqual(self.screen.item_modal_mode, "DISCARD_CHOICE")

        # Select 'Discard 1' (index 0) and press Enter -> enters DISCARD_CONFIRM
        self.screen._handle_input(KeyEvent(key=KeyCode.ENTER), self.context, self.mock_core)
        self.assertEqual(self.screen.item_modal_mode, "DISCARD_CONFIRM")

        # Press 'Y' to confirm
        self.screen._handle_input(KeyEvent(key=KeyCode.CHAR, char="y"), self.context, self.mock_core)
        self.assertEqual(self.party.get_item_count("Potion"), 1)
        self.assertEqual(self.screen.focus_mode, "SUBMENU")
        self.assertIn("Discarded 1x Potion", self.screen.banner_message)

    def test_equipment_slot_browse_and_swap(self):
        """Tests browsing equipment slots, viewing drawer, and equipping gear."""
        self.screen.category_idx = 2  # Equipment
        self.screen.focus_mode = "SUBMENU"
        self.screen.equip_slot_cursor = 0  # Weapon
        hero = self.party.members[0]

        # Reset inventory and add replacement weapon
        self.party.inventory = []
        self.party.add_item("Steel Broadsword", 1, item_type="equipment")

        # Press Enter on Weapon slot -> opens drawer
        self.screen._handle_input(KeyEvent(key=KeyCode.ENTER), self.context, self.mock_core)
        self.assertTrue(self.screen.equip_drawer_open)
        self.assertGreater(len(self.screen.equip_drawer_items), 0)

        # First item in drawer is Steel Broadsword -> press Enter to equip
        old_weapon = hero.equipment[EquipmentSlot.WEAPON]
        self.screen._handle_input(KeyEvent(key=KeyCode.ENTER), self.context, self.mock_core)
        self.assertFalse(self.screen.equip_drawer_open)

        # Verify new weapon equipped and old weapon returned to bag
        self.assertEqual(hero.equipment[EquipmentSlot.WEAPON].name, "Steel Broadsword")
        self.assertTrue(self.party.has_item(old_weapon.name))
        self.assertFalse(self.party.has_item("Steel Broadsword"))

    def test_equipment_unequip_slot(self):
        """Tests unequipping an item from a slot back to the shared bag."""
        self.screen.category_idx = 2  # Equipment
        self.screen.focus_mode = "SUBMENU"
        self.screen.equip_slot_cursor = 0  # Weapon
        hero = self.party.members[0]
        cur_weapon = hero.equipment[EquipmentSlot.WEAPON]
        self.assertIsNotNone(cur_weapon)

        # Open drawer
        self.screen._handle_input(KeyEvent(key=KeyCode.ENTER), self.context, self.mock_core)

        # Select (Unequip Slot) which is the last entry (None)
        self.screen.equip_drawer_cursor = len(self.screen.equip_drawer_items) - 1
        self.assertIsNone(self.screen.equip_drawer_items[self.screen.equip_drawer_cursor])

        self.screen._handle_input(KeyEvent(key=KeyCode.ENTER), self.context, self.mock_core)
        self.assertIsNone(hero.equipment[EquipmentSlot.WEAPON])
        self.assertTrue(self.party.has_item(cur_weapon.name))

    def test_equipment_submenu_line_highlighting(self):
        """Verifies full-width blue line highlighting on active equipped slot and drawer items."""
        self.screen.category_idx = 2  # Equipment
        self.screen.focus_mode = "SUBMENU"
        self.screen.equip_slot_cursor = 0  # Weapon slot active
        self.screen.equip_drawer_open = False

        eq_lines = self.screen._render_equipment_submenu()
        # Row 1 is Weapon slot
        weapon_line = eq_lines[1]
        self.assertIn("\033[48;2;25;55;85m", weapon_line)
        self.assertIn("Weapon", weapon_line)
        self.assertIn("❱", weapon_line)
        self.assertEqual(visible_width(weapon_line), 55)

        # Row 2 is Helmet slot (inactive)
        helmet_line = eq_lines[2]
        self.assertNotIn("\033[48;2;25;55;85m", helmet_line)
        self.assertIn("Helmet", helmet_line)
        self.assertNotIn("❱", helmet_line)

        # Now open drawer
        self.screen.equip_drawer_open = True
        self.screen.equip_drawer_items = [EQUIPMENT_CATALOG["Iron Longsword"], None]
        self.screen.equip_drawer_cursor = 0

        drawer_lines = self.screen._render_equipment_submenu()
        # In EQUIPPED SLOTS, weapon slot should no longer have bg highlight, but has active indicator
        self.assertNotIn("\033[48;2;25;55;85m", drawer_lines[1])
        self.assertIn("›", drawer_lines[1])

        # In AVAILABLE GEAR IN BAG, line 12 is first gear option (active)
        active_gear_line = drawer_lines[12]
        self.assertIn("\033[48;2;25;55;85m", active_gear_line)
        self.assertIn("Iron Longsword", active_gear_line)
        self.assertIn("❱", active_gear_line)
        self.assertEqual(visible_width(active_gear_line), 55)

        # Line 13 is unequip option (inactive)
        unequip_line = drawer_lines[13]
        self.assertNotIn("\033[48;2;25;55;85m", unequip_line)
        self.assertIn("Unequip Current Gear", unequip_line)

    def test_magic_field_casting(self):
        """Tests casting a healing spell from the Magic submenu in the field."""
        self.screen.category_idx = 3  # Magic
        self.screen.hero_idx = 3  # Sara (Cleric with Heal spell)
        self.screen.focus_mode = "SUBMENU"

        cleric = self.party.members[3]
        target = self.party.members[0]
        target.hp = target.max_hp - 50

        # Heal index in Sara's known spells
        spells = [a for a in cleric.actions if a.category in (ActionCategory.SPELL, ActionCategory.SKILL)]
        heal_idx = next(i for i, a in enumerate(spells) if a.name == "Heal")
        self.screen.magic_cursor = heal_idx

        # Press Enter on Heal -> opens target modal
        self.screen._handle_input(KeyEvent(key=KeyCode.ENTER), self.context, self.mock_core)
        self.assertEqual(self.screen.focus_mode, "MODAL")
        self.assertEqual(self.screen.magic_modal_mode, "TARGET_SELECT")

        # Target Aide (index 0)
        self.screen.magic_target_cursor = 0
        old_cleric_mp = cleric.mp
        self.screen._handle_input(KeyEvent(key=KeyCode.ENTER), self.context, self.mock_core)

        # Verify MP deducted and HP healed
        self.assertLess(cleric.mp, old_cleric_mp)
        self.assertGreater(target.hp, target.max_hp - 50)
        self.assertIn("cast Heal", self.screen.banner_message)

    def test_magic_submenu_line_highlighting(self):
        """Verifies full-width blue line highlighting on active spell in Magic submenu."""
        self.screen.category_idx = 3  # Magic
        self.screen.hero_idx = 1  # Lyra (has Fireball, Ice Bolt, Arctic Blast)
        self.screen.focus_mode = "SUBMENU"
        self.screen.magic_cursor = 0

        magic_lines = self.screen._render_magic_submenu()
        # Line 0 is header, line 1 is divider, line 2 is first spell (Fireball, active)
        active_spell_line = magic_lines[2]
        self.assertIn("\033[48;2;25;55;85m", active_spell_line)
        self.assertIn("❱", active_spell_line)
        self.assertIn("Fireball", active_spell_line)
        self.assertIn("AOE", active_spell_line)
        self.assertNotIn("ALL_ENEMIES", active_spell_line)
        self.assertEqual(visible_width(active_spell_line), 55)

        # Line 3 is second spell (Ice Bolt, inactive)
        inactive_spell_line = magic_lines[3]
        self.assertNotIn("\033[48;2;25;55;85m", inactive_spell_line)
        self.assertNotIn("❱", inactive_spell_line)
        self.assertIn("Ice Bolt", inactive_spell_line)
        self.assertIn("Single", inactive_spell_line)
        self.assertNotIn("SINGLE_ENEMY", inactive_spell_line)

        # When moving cursor to 1 (Ice Bolt)
        self.screen.magic_cursor = 1
        magic_lines_cur1 = self.screen._render_magic_submenu()
        self.assertNotIn("\033[48;2;25;55;85m", magic_lines_cur1[2])
        self.assertIn("\033[48;2;25;55;85m", magic_lines_cur1[3])
        self.assertIn("❱", magic_lines_cur1[3])
        self.assertIn("Ice Bolt", magic_lines_cur1[3])
        self.assertEqual(visible_width(magic_lines_cur1[3]), 55)

        # When in CATEGORIES mode, neither has active highlight
        self.screen.focus_mode = "CATEGORIES"
        cat_lines = self.screen._render_magic_submenu()
        self.assertNotIn("\033[48;2;25;55;85m", cat_lines[2])
        self.assertNotIn("\033[48;2;25;55;85m", cat_lines[3])

    def test_target_scope_friendly_display_names(self):
        """Verifies TargetScope enum returns friendly display names instead of ALL_CAPS."""
        from eldoria_py.combat.stats import TargetScope
        self.assertEqual(TargetScope.SINGLE_ENEMY.display_name, "Single")
        self.assertEqual(TargetScope.ALL_ENEMIES.display_name, "AOE")
        self.assertEqual(TargetScope.CLEAVE_ENEMIES.display_name, "Cleave")
        self.assertEqual(TargetScope.SINGLE_ALLY.display_name, "Ally")
        self.assertEqual(TargetScope.ALL_ALLIES.display_name, "Party")
        self.assertEqual(TargetScope.SELF.display_name, "Self")
        self.assertEqual(TargetScope.NONE.display_name, "None")

    def test_save_slot_selection_and_execution(self):
        """Tests selecting a save slot and executing game state save."""
        self.screen.category_idx = self.screen.CATEGORIES.index("Save")
        self.screen.focus_mode = "SUBMENU"
        self.screen.save_slot_cursor = 0  # Slot 1

        self.screen._handle_input(KeyEvent(key=KeyCode.ENTER), self.context, self.mock_core)
        self.mock_noise_map._save_to_slot.assert_called_once_with(1)
        self.assertIn("Progress saved to Slot 1", self.screen.banner_message)

    def test_quit_modal_options(self):
        """Tests quit modal choices: Return to Title and Quit Desktop."""
        self.screen.category_idx = self.screen.CATEGORIES.index("Quit")
        self.screen.focus_mode = "CATEGORIES"

        # Press Enter to open Quit modal
        self.screen._handle_input(KeyEvent(key=KeyCode.ENTER), self.context, self.mock_core)
        self.assertEqual(self.screen.focus_mode, "MODAL")

        # Option 0: Return to Title
        self.screen.quit_option_cursor = 0
        self.screen._handle_input(KeyEvent(key=KeyCode.ENTER), self.context, self.mock_core)
        self.mock_game_state.trigger.assert_called_once_with("ToTitle", self.context)

        # Option 1: Quit Desktop sets is_running = False
        self.mock_core.is_running = True
        self.screen.focus_mode = "MODAL"
        self.screen.quit_option_cursor = 1
        self.screen._handle_input(KeyEvent(key=KeyCode.ENTER), self.context, self.mock_core)
        self.assertFalse(self.mock_core.is_running)

    def test_quit_modal_line_highlighting(self):
        """Verifies full-width blue line highlighting on active choice in Quit modal."""
        self.screen.category_idx = self.screen.CATEGORIES.index("Quit")
        self.screen.focus_mode = "MODAL"
        self.screen.quit_option_cursor = 0

        quit_lines = self.screen._render_quit_modal()
        # Row 5 is option 0 (Return to Title Screen, active)
        active_line = quit_lines[5]
        self.assertIn("\033[48;2;25;55;85m", active_line)
        self.assertIn("❱", active_line)
        self.assertIn("Return to Title Screen", active_line)
        self.assertEqual(visible_width(active_line), 55)

        # Row 6 is option 1 (Quit to Desktop, inactive)
        inactive_line = quit_lines[6]
        self.assertNotIn("\033[48;2;25;55;85m", inactive_line)
        self.assertNotIn("❱", inactive_line)
        self.assertIn("Quit to Desktop", inactive_line)

        # Move cursor to option 1
        self.screen.quit_option_cursor = 1
        quit_lines_cur1 = self.screen._render_quit_modal()
        self.assertNotIn("\033[48;2;25;55;85m", quit_lines_cur1[5])
        self.assertIn("\033[48;2;25;55;85m", quit_lines_cur1[6])
        self.assertIn("❱", quit_lines_cur1[6])
        self.assertEqual(visible_width(quit_lines_cur1[6]), 55)

        # When in CATEGORIES mode, neither has active highlight
        self.screen.focus_mode = "CATEGORIES"
        cat_lines = self.screen._render_quit_modal()
        self.assertNotIn("\033[48;2;25;55;85m", cat_lines[5])
        self.assertNotIn("\033[48;2;25;55;85m", cat_lines[6])

    def test_resume_exploration_via_escape(self):
        """Tests that pressing Escape from Categories returns to World Map via ToNoiseMap."""
        self.screen.focus_mode = "CATEGORIES"
        self.screen._handle_input(KeyEvent(key=KeyCode.ESCAPE), self.context, self.mock_core)
        self.mock_game_state.trigger.assert_called_once_with("ToNoiseMap", self.context)

    def test_party_vitals_no_empty_slot_placeholder(self):
        """Verifies that parties with < 5 members do not render an (Empty Slot) placeholder in Party Vitals."""
        # Test with 1, 2, 3, and 4 member parties
        for count in (1, 2, 3, 4):
            small_party = create_default_party()
            small_party.members = small_party.members[:count]
            test_screen = GSMainMenuScreen(party=small_party)
            left_lines = test_screen._render_left_rail()
            for line_idx, line in enumerate(left_lines):
                clean_text = strip_ansi(line)
                self.assertNotIn(
                    "Empty Slot",
                    clean_text,
                    f"Line {line_idx} contains '(Empty Slot)' placeholder for a {count}-member party: '{clean_text}'",
                )

    def test_save_slot_windows_use_uipanel_components(self):
        """Verifies that all Save Game slot windows are formal UIPanel instances with child UILabels and exact dimensions."""
        self.assertEqual(len(self.screen.save_slot_panels), 3)
        for idx, panel in enumerate(self.screen.save_slot_panels):
            self.assertIsInstance(panel, UIPanel, f"Save slot {idx} is not an instance of UIPanel")
            self.assertEqual(panel.width, 50)
            self.assertEqual(panel.inner_width, 49)
            self.assertEqual(panel.inner_height, 3)
            self.assertTrue(panel.has_border)
            self.assertEqual(panel.title, f"SLOT {idx + 1}")

        # Render save submenu and inspect lines
        self.screen.category_idx = self.screen.CATEGORIES.index("Save")
        right_lines = self.screen._render_save_submenu()
        self.assertGreater(len(right_lines), 0)

        # Verify each slot panel renders child UILabels
        for idx, panel in enumerate(self.screen.save_slot_panels):
            self.assertGreater(
                len(panel.ui_element_listing),
                0,
                f"Save slot panel {idx} has no child UI elements registered in ui_element_listing",
            )
            for elem_id, elem in panel.ui_element_listing.items():
                self.assertIsInstance(
                    elem,
                    UILabel,
                    f"Child element {elem_id} in save slot {idx} is not an instance of UILabel",
                )

    def test_modal_dialogs_use_uipanel_components(self):
        """Verifies that Quit, Item, Magic, and Stat Delta modals are all formal UIPanel instances."""
        self.assertIsInstance(self.screen.quit_modal_panel, UIPanel)
        self.assertIsInstance(self.screen.item_modal_panel, UIPanel)
        self.assertIsInstance(self.screen.stat_delta_panel, UIPanel)
        self.assertIsInstance(self.screen.magic_modal_panel, UIPanel)

    def test_menu_exit_clears_terminal_and_disables_rendering(self):
        """Verifies that exiting the menu disables rendering and stops active frame updates."""
        self.screen.enter(self.context)
        self.assertTrue(self.screen._is_active)

        # Trigger exit via Escape
        self.screen._handle_input(KeyEvent(key=KeyCode.ESCAPE), self.context, self.mock_core)
        self.assertFalse(self.screen._is_active)

        # If update is called when inactive, _render must not be called
        self.screen._render = MagicMock()
        self.screen.update(self.context)
        self.screen._render.assert_not_called()

    def test_noise_map_render_clears_trailing_columns_and_tail_rows(self):
        """Verifies that GSNoiseMapTestScreen._render emits ClearLineToEnd and tail clearing up to row 40."""
        from eldoria_py.states.test_noise_map import GSNoiseMapTestScreen
        from eldoria_py.terminal.ansi import ATControlSequences
        import io
        from unittest.mock import patch

        nm = GSNoiseMapTestScreen(map_width=54, map_height=24)
        nm.party = self.party

        with patch("sys.stdout", new=io.StringIO()) as fake_stdout:
            nm._render()
            output = fake_stdout.getvalue()

        # Must contain ClearLineToEnd (\033[K) to clear extra columns to the right of the map
        self.assertIn(ATControlSequences.ClearLineToEnd, output)
        # Must clear tail rows up to 40 (\033[28;1H\033[2K ... \033[40;1H\033[2K)
        self.assertIn("\033[28;1H\033[2K", output)
        self.assertIn("\033[40;1H\033[2K", output)

    def test_end_to_end_menu_transition_buffer_clearing(self):
        """End-to-end test verifying FSM transition from GSNoiseMapTestScreen to GSMainMenuScreen and back."""
        from eldoria_py.states.test_noise_map import GSNoiseMapTestScreen
        from eldoria_py.core.fsm import SMStateMachine, SMTransition
        from unittest.mock import patch
        import io

        fsm = SMStateMachine("GSNoiseMapTestScreen")
        nm = GSNoiseMapTestScreen(map_width=54, map_height=24)
        nm.party = self.party
        fsm.add_state(nm)
        fsm.add_state(self.screen)
        fsm.add_transition(SMTransition("GSNoiseMapTestScreen", "ToMenu", "GSMainMenuScreen"))
        fsm.add_transition(SMTransition("GSMainMenuScreen", "ToNoiseMap", "GSNoiseMapTestScreen"))

        self.mock_game_state.states = {"GSNoiseMapTestScreen": nm, "GSMainMenuScreen": self.screen}
        self.mock_game_state.trigger.side_effect = lambda ev, ctx: fsm.trigger(ev, ctx)

        # 1. Transition to menu
        fsm.trigger("ToMenu", self.context)
        self.assertEqual(fsm.current_state, "GSMainMenuScreen")
        self.assertTrue(self.screen._is_active)

        # 2. In menu, user presses [Esc] to resume exploration
        self.context.set(SMState.ContextKeysPressed, [KeyEvent(key=KeyCode.ESCAPE)])
        with patch("sys.stdout", new=io.StringIO()) as fake_stdout:
            self.screen.update(self.context)
            menu_exit_output = fake_stdout.getvalue()

        # FSM should be back on GSNoiseMapTestScreen
        self.assertEqual(fsm.current_state, "GSNoiseMapTestScreen")
        self.assertFalse(self.screen._is_active)

        # 3. Next game loop tick on GSNoiseMapTestScreen
        with patch("sys.stdout", new=io.StringIO()) as fake_stdout:
            nm.update(self.context)
            nm_render_output = fake_stdout.getvalue()

        # Verifies GSNoiseMapTestScreen cleared trailing columns and rows 28-40
        self.assertIn("\033[28;1H\033[2K", nm_render_output)
        self.assertIn("\033[40;1H\033[2K", nm_render_output)

    def test_status_submenu_element_unicode_glyph_display(self):
        """Verifies that the Status submenu renders Unicode glyphs and clean element names, not ELEMENTAL_*."""
        self.screen.category_idx = 0  # Status
        for h_idx in range(len(self.party.members)):
            self.screen.hero_idx = h_idx
            lines = self.screen._render_status_submenu()
            element_line = [strip_ansi(l) for l in lines if "Element:" in strip_ansi(l)][0]
            # Must not contain raw ELEMENTAL_* literal
            self.assertNotIn("ELEMENTAL_", element_line)

            member = self.party.members[h_idx]
            from eldoria_py.combat.stats import get_element_info
            info = get_element_info(member.affinity)
            self.assertIsNotNone(info)
            self.assertIn(info.glyph, element_line)
            self.assertIn(info.name, element_line)

    def test_status_submenu_health_and_mana_bar_colored_stages(self):
        """Verifies that Status submenu HP bars reflect 3-stage colored indicators and MP bars reflect mana cyan."""
        from eldoria_py.terminal.color import ColorLibrary
        self.screen.category_idx = 0  # Status
        m = self.party.members[0]

        # Normal (> 60%): Green
        m.hp = m.max_hp
        lines = self.screen._render_status_submenu()
        hp_line = [l for l in lines if "HP:" in strip_ansi(l)][0]
        self.assertIn(ColorLibrary.AppleGreenLight.to_ansi_fg(), hp_line)

        # Caution (30% - 60%): Yellow
        m.hp = int(m.max_hp * 0.5)
        lines = self.screen._render_status_submenu()
        hp_line = [l for l in lines if "HP:" in strip_ansi(l)][0]
        self.assertIn(ColorLibrary.AppleYellowLight.to_ansi_fg(), hp_line)

        # Danger (<= 30%): Red
        m.hp = int(m.max_hp * 0.2)
        lines = self.screen._render_status_submenu()
        hp_line = [l for l in lines if "HP:" in strip_ansi(l)][0]
        self.assertIn(ColorLibrary.AppleRedLight.to_ansi_fg(), hp_line)

        # Mana bar: Cyan
        mp_line = [l for l in lines if "MP:" in strip_ansi(l)][0]
        self.assertIn(ColorLibrary.AppleCyanLight.to_ansi_fg(), mp_line)

    def test_status_submenu_attributes_stat_augment_colors(self):
        """Verifies that positive stat augments are emerald green, negative are ruby red, and zero is uncolored."""
        from eldoria_py.terminal.color import ColorLibrary
        self.screen.category_idx = 0  # Status
        m = self.party.members[0]

        # In default party, Hero 0 (Aide) has:
        # ATK equipment_bonus = +31 (positive -> EmeraldGreen)
        # SPD equipment_bonus = -1 (negative -> RubyRed)
        # LCK equipment_bonus = 0 (zero -> uncolored)
        lines = self.screen._render_status_submenu()

        atk_line = [l for l in lines if "ATK:" in strip_ansi(l)][0]
        spd_line = [l for l in lines if "SPD:" in strip_ansi(l)][0]
        lck_line = [l for l in lines if "LCK:" in strip_ansi(l)][0]

        # Positive augment (+31) rendered in EmeraldGreen
        emerald_fg = ColorLibrary.EmeraldGreen.to_fg_ansi()
        self.assertIn(emerald_fg, atk_line)
        self.assertIn(f"{emerald_fg}31\033[0m", atk_line)

        # Negative augment (-1) rendered in RubyRed
        ruby_fg = ColorLibrary.RubyRed.to_fg_ansi()
        self.assertIn(ruby_fg, spd_line)
        self.assertIn(f"{ruby_fg}-1\033[0m", spd_line)

        # Zero augment remains uncolored
        self.assertIn("+  0", lck_line)
        self.assertNotIn(f"{emerald_fg} 0", lck_line)
        self.assertNotIn(f"{ruby_fg} 0", lck_line)

        # Dynamic combat/gear augment test:
        m.stats[StatId.LUCK].augment_value = 5
        lines2 = self.screen._render_status_submenu()
        lck_line2 = [l for l in lines2 if "LCK:" in strip_ansi(l)][0]
        self.assertIn(f"{emerald_fg}5\033[0m", lck_line2)

    def test_party_vitals_no_class_declaration(self):
        """Verifies that the Class declaration under the MP bar is removed in PARTY VITALS left rail."""
        left_lines = self.screen._render_left_rail()
        self.assertEqual(len(left_lines), 37)

        # Confirm PARTY VITALS section exists
        vitals_idx = [i for i, l in enumerate(left_lines) if "PARTY VITALS:" in strip_ansi(l)]
        self.assertTrue(vitals_idx, "PARTY VITALS header missing from left rail")

        # Verify no line in the left rail contains "Class:"
        for line in left_lines:
            self.assertNotIn("Class:", strip_ansi(line))

        # Verify HP and MP bars are present for members
        raw_left = "\n".join(strip_ansi(l) for l in left_lines)
        self.assertIn("HP:", raw_left)
        self.assertIn("MP:", raw_left)

        # Verify every line respects the 22-column budget
        for r_idx, line in enumerate(left_lines):
            cell = _pad_cell(line, self.screen.LEFT_WIDTH)
            self.assertEqual(visible_width(cell), 22, f"Left rail line {r_idx} violates 22-column width: '{cell}'")

    def test_status_submenu_hp_mp_gauges_moved_up_and_exp_numeric_display(self):
        """Verifies HP and MP gauges moved up one row each, and EXP is displayed without a stat bar where MP was."""
        self.screen.category_idx = 0  # Status
        m = self.party.members[0]
        m.current_xp = 45
        m.next_level_xp = 100

        lines = self.screen._render_status_submenu()
        stripped = [strip_ansi(l) for l in lines]

        # Row 0: Archetype
        self.assertIn("Archetype:", stripped[0])
        # Row 1: Element
        self.assertIn("Element:", stripped[1])
        # Row 2: HP gauge (moved up from row 3)
        self.assertIn("HP:", stripped[2])
        self.assertIn("[", stripped[2])  # contains stat bar
        # Row 3: MP gauge (moved up from row 4)
        self.assertIn("MP:", stripped[3])
        self.assertIn("[", stripped[3])  # contains stat bar
        # Row 4: EXP numeric display (in place of former MP gauge row)
        self.assertIn("EXP:", stripped[4])
        self.assertIn("45 / 100", stripped[4])
        self.assertNotIn("[", stripped[4])  # purely numeric, no stat bar
        self.assertNotIn("]", stripped[4])
        # Row 5: ATTRIBUTES divider
        self.assertIn("ATTRIBUTES", stripped[5])

    def test_stat_bars_right_aligned_in_containers(self):
        """Verifies that HP and MP stat bars are aligned to the right of their containers in both Left Rail and Status Submenu."""
        def set_stats(member, hp, max_hp, mp, max_mp):
            member.stats[StatId.HIT_POINTS].base = max_hp
            member.stats[StatId.HIT_POINTS].equipment_bonus = 0
            member.stats[StatId.HIT_POINTS].augment_value = 0
            member.stats[StatId.HIT_POINTS].current = hp
            member.stats[StatId.MAGIC_POINTS].base = max_mp
            member.stats[StatId.MAGIC_POINTS].equipment_bonus = 0
            member.stats[StatId.MAGIC_POINTS].augment_value = 0
            member.stats[StatId.MAGIC_POINTS].current = mp

        # 1. Test Left Rail (Party Vitals, LEFT_WIDTH = 22)
        set_stats(self.party.members[0], 5, 25, 8, 10)
        set_stats(self.party.members[1], 350, 400, 45, 60)
        set_stats(self.party.members[2], 4242, 4272, 148, 148)

        left_lines = self.screen._render_left_rail()
        hp_lines = [l for l in left_lines if "HP:" in strip_ansi(l)]
        mp_lines = [l for l in left_lines if "MP:" in strip_ansi(l)]

        for l in hp_lines + mp_lines:
            self.assertEqual(visible_width(l), 21)
            self.assertTrue(strip_ansi(l).endswith("]"))
            padded = _pad_cell(l, self.screen.LEFT_WIDTH)
            self.assertEqual(strip_ansi(padded).rfind("]"), 20)

        # 2. Test Status Submenu (RIGHT_WIDTH = 55)
        for hp, max_hp, mp, max_mp in [
            (5, 25, 8, 10),
            (350, 400, 45, 60),
            (4242, 4272, 148, 148),
        ]:
            set_stats(self.party.members[0], hp, max_hp, mp, max_mp)

            status_lines = self.screen._render_status_submenu()
            status_hp = [l for l in status_lines if "HP:" in strip_ansi(l)][0]
            status_mp = [l for l in status_lines if "MP:" in strip_ansi(l)][0]

            self.assertEqual(visible_width(status_hp), 54)
            self.assertEqual(visible_width(status_mp), 54)
            self.assertTrue(strip_ansi(status_hp).endswith("]"))
            self.assertTrue(strip_ansi(status_mp).endswith("]"))

            padded_hp = _pad_cell(status_hp, self.screen.RIGHT_WIDTH)
            padded_mp = _pad_cell(status_mp, self.screen.RIGHT_WIDTH)
            self.assertEqual(strip_ansi(padded_hp).rfind("]"), 53)
            self.assertEqual(strip_ansi(padded_mp).rfind("]"), 53)


if __name__ == "__main__":
    unittest.main()


