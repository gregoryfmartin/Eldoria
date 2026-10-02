"""
Unit tests for the NPC Dialogue and Interaction System.
Tests DialogCategory, 7-row text modal geometry, padding, teletype rendering,
paging with down arrow, completion checkmark, right-aligned choice modal,
and adjacent NPC target disambiguation on the map.
"""

from pathlib import Path
import tempfile
import unittest
from unittest.mock import MagicMock, patch

from eldoria_py.core.context import Context
from eldoria_py.core.fsm import SMState
from eldoria_py.procgen.npc import (
    DialogCategory,
    NPCRole,
    NPC,
    create_king,
    create_service_owner,
    create_town_citizen,
)
from eldoria_py.procgen.map_generator import Map, MapTile, BiomeType
from eldoria_py.states.test_noise_map import GSNoiseMapTestScreen
from eldoria_py.terminal.box import strip_ansi, visible_width
from eldoria_py.terminal.color import TrueColor
from eldoria_py.terminal.input import KeyCode, KeyEvent
from eldoria_py.ui.npc_dialog import DialogChoice, DialogState, NPCDialogModal


class TestNPCDialogSystem(unittest.TestCase):
    def setUp(self):
        self.modal_54 = NPCDialogModal(screen_width=54, screen_height=27, chars_per_second=1000.0)
        self.modal_80 = NPCDialogModal(screen_width=80, screen_height=27, chars_per_second=1000.0)

    def test_npc_data_model_and_factories(self):
        """Verify role classifications, dialog categories, and standardized prompt templates."""
        # 1. Innkeeper
        innkeeper = create_service_owner(role=NPCRole.INNKEEPER, name="Barnaby", pos=(5, 5), inn_fee=25)
        self.assertEqual(innkeeper.category, DialogCategory.CHOICE)
        self.assertEqual(innkeeper.choice_options, ["Yes", "No"])
        self.assertEqual(innkeeper.dialogue, "Welcome! It costs 25 gold to stay for the night. Do you want a room?")

        # 2. Item Shopkeeper
        item_shop = create_service_owner(role=NPCRole.ITEM_SHOPKEEPER, name="Silas", pos=(10, 10))
        self.assertEqual(item_shop.category, DialogCategory.CHOICE)
        self.assertEqual(item_shop.choice_options, ["Yes", "No"])
        self.assertEqual(item_shop.dialogue, "Welcome! Would you like to buy something today?")

        # 3. Equip Shopkeeper
        equip_shop = create_service_owner(role=NPCRole.EQUIP_SHOPKEEPER, name="Torvald", pos=(15, 15))
        self.assertEqual(equip_shop.category, DialogCategory.CHOICE)
        self.assertEqual(equip_shop.choice_options, ["Yes", "No"])
        self.assertEqual(equip_shop.dialogue, "Welcome! Would you like to buy something today?")

        # 4. King
        king = create_king(name="King Aldous", pos=(27, 4), bounties=["Bone Golem", "Wyrm"])
        self.assertEqual(king.category, DialogCategory.STANDARD)
        self.assertIn("Bone Golem", king.dialogue)
        self.assertIn("Wyrm", king.dialogue)

        # 5. Citizen
        citizen = create_town_citizen(name="Farmer Giles", pos=(2, 2))
        self.assertEqual(citizen.category, DialogCategory.STANDARD)
        self.assertEqual(citizen.choice_options, [])

        # 6. Serialization round-trip
        data = innkeeper.to_dict()
        self.assertEqual(data["category"], "Choice")
        self.assertEqual(data["choice_options"], ["Yes", "No"])
        self.assertEqual(data["inn_fee"], 25)

        restored = NPC.from_dict(data)
        self.assertEqual(restored.category, DialogCategory.CHOICE)
        self.assertEqual(restored.choice_options, ["Yes", "No"])
        self.assertEqual(restored.inn_fee, 25)
        self.assertEqual(restored.dialogue, innkeeper.dialogue)

    def test_text_modal_geometry_and_padding(self):
        """Verify 7-row height, 2-cell horizontal padding, and 1-cell vertical padding."""
        citizen = create_town_citizen(name="Old Pete", pos=(1, 1))
        citizen.dialogue = "The wheat is golden and ripe for harvest."
        self.modal_54.start_dialog(citizen)
        self.modal_54.flush_page()

        cmds = self.modal_54.render_overlay()
        self.assertEqual(len(cmds), 7)

        # Bottom 7 rows on 27-row screen are rows 21..27
        rows = [c[0] for c in cmds]
        self.assertEqual(rows, [21, 22, 23, 24, 25, 26, 27])

        # Verify all lines measure exactly 54 visible columns
        for row_idx, col, text in cmds:
            self.assertEqual(col, 1)
            v_len = visible_width(text)
            self.assertEqual(v_len, 54, f"Row {row_idx} width {v_len} != 54")

        # Row 1 (21): Top border with title
        self.assertIn("Old Pete", cmds[0][2])
        self.assertTrue(cmds[0][2].startswith("╭"))
        self.assertTrue(cmds[0][2].endswith("╮"))

        # Row 2 (22): Vertical padding (empty inside)
        clean_pad_top = strip_ansi(cmds[1][2])
        self.assertEqual(clean_pad_top, "│" + " " * 52 + "│")

        # Row 3 (23): Text row with 2 spaces horizontal padding
        clean_text_row = strip_ansi(cmds[2][2])
        self.assertTrue(clean_text_row.startswith("│  The wheat"))
        self.assertTrue(clean_text_row.endswith("  │"))

        # Row 6 (26): Vertical padding (empty inside)
        clean_pad_bottom = strip_ansi(cmds[5][2])
        self.assertEqual(clean_pad_bottom, "│" + " " * 52 + "│")

        # Row 7 (27): Bottom border with emerald green checkmark on completion
        self.assertTrue(cmds[6][2].startswith("╰"))
        self.assertTrue(cmds[6][2].endswith("╯"))
        self.assertIn("✔", cmds[6][2])
        self.assertIn("\033[1;32m", cmds[6][2])  # Emerald Green ANSI

    def test_text_pagination_multi_page_with_down_arrow(self):
        """Verify long dialogue (> 3 lines) paginates into multiple pages and renders yellow down arrow."""
        npc = NPC(
            npc_id="npc_orator",
            name="Sage Corvus",
            role=NPCRole.COURT_ADVISOR,
            glyph="A",
            fg_color=TrueColor(255, 255, 255),
            bg_color=TrueColor(0, 0, 0),
            dialogue=(
                "First line of ancient prophecy detailing the fall of empires. "
                "Second line revealing the hidden sigil beneath the forgotten tower. "
                "Third line warning of rising shadows in the deep mountain passes. "
                "Fourth line proclaiming the dawn of an unstoppable champion."
            ),
            category=DialogCategory.STANDARD,
        )

        self.modal_54.start_dialog(npc)
        # Should split across at least 2 pages (page 1 has 3 lines, page 2 has remainder)
        self.assertGreaterEqual(len(self.modal_54.pages), 2)
        self.assertEqual(len(self.modal_54.pages[0]), 3)

        # Flush page 1
        self.modal_54.flush_page()
        self.assertEqual(self.modal_54.state, DialogState.PAGE_WAITING)

        # Verify yellow down arrow (▼) rendered on bottom border
        cmds = self.modal_54.render_overlay()
        bottom_border = cmds[6][2]
        self.assertIn("▼", bottom_border)
        self.assertIn("\033[1;33m", bottom_border)  # Yellow ANSI

        # Press Enter: advances to page 2
        self.modal_54.advance_or_act()
        self.assertEqual(self.modal_54.current_page_idx, 1)

        # Flush page 2 (final page): should transition to FINISHED with green checkmark
        self.modal_54.flush_page()
        self.assertEqual(self.modal_54.state, DialogState.FINISHED)

        cmds_p2 = self.modal_54.render_overlay()
        bottom_border_p2 = cmds_p2[6][2]
        self.assertIn("✔", bottom_border_p2)
        self.assertIn("\033[1;32m", bottom_border_p2)

        # Press Enter: closes modal
        self.modal_54.advance_or_act()
        self.assertEqual(self.modal_54.state, DialogState.CLOSED)
        self.assertFalse(self.modal_54.is_active)

    def test_teletype_rendering_and_skip_flush(self):
        """Verify characters teletype at a set pace and Enter immediately reveals the full page."""
        # Use slow teletype (1 char/sec) to inspect intermediate state
        modal = NPCDialogModal(screen_width=54, screen_height=27, chars_per_second=1.0)
        citizen = create_town_citizen(name="Miller Bram", pos=(1, 1))
        citizen.dialogue = "Fresh flour daily."

        modal.start_dialog(citizen)
        self.assertEqual(modal.state, DialogState.TELETYPING)
        self.assertLess(modal.chars_revealed, modal.total_page_chars)

        # Press Enter mid-teletype: should flush characters on current page without advancing page
        modal.handle_key(KeyEvent(key=KeyCode.ENTER, char="\r"))
        self.assertEqual(modal.chars_revealed, modal.total_page_chars)
        self.assertEqual(modal.current_page_idx, 0)
        self.assertEqual(modal.state, DialogState.FINISHED)

        # Press Enter again: closes the completed conversation
        modal.handle_key(KeyEvent(key=KeyCode.ENTER, char="\r"))
        self.assertEqual(modal.state, DialogState.CLOSED)

    def test_choice_modal_right_aligned_geometry_and_navigation(self):
        """Verify Choice category renders miniature modal above text modal on right with dynamic height N+4."""
        innkeeper = create_service_owner(role=NPCRole.INNKEEPER, name="Barnaby", pos=(3, 3), inn_fee=20)
        choice_executed = []

        def on_yes():
            choice_executed.append("yes")

        def on_no():
            choice_executed.append("no")

        choices = [DialogChoice(label="Yes", action=on_yes), DialogChoice(label="No", action=on_no)]
        self.modal_54.start_dialog(innkeeper, choices=choices)
        self.modal_54.flush_page()

        # Final page reached for Choice category: enters CHOICE_WAITING
        self.assertEqual(self.modal_54.state, DialogState.CHOICE_WAITING)

        cmds = self.modal_54.render_overlay()
        # Main text modal (7 cmds) + Choice modal (N + 4 = 6 cmds) = 13 total commands
        self.assertEqual(len(cmds), 13)

        # Choice modal commands are cmds[7..12]
        choice_cmds = cmds[7:]
        self.assertEqual(len(choice_cmds), 6)  # N=2 -> 2 + 4 = 6 rows

        # Height check: rows 15..20 (immediately above row 21)
        choice_rows = [c[0] for c in choice_cmds]
        self.assertEqual(choice_rows, [15, 16, 17, 18, 19, 20])

        # Right-aligned check: col + width - 1 == 54
        for r, c, txt in choice_cmds:
            v_len = visible_width(txt)
            self.assertEqual(c + v_len - 1, 54, f"Choice row {r} not right-aligned to 54")

        # Initial cursor is at 0 ("Yes")
        self.assertEqual(self.modal_54.choice_cursor, 0)
        self.assertIn("►", choice_cmds[2][2])  # Row 17 (choice 0) has chevron
        self.assertNotIn("►", choice_cmds[3][2])  # Row 18 (choice 1) has no chevron

        # Navigate Down
        self.modal_54.handle_key(KeyEvent(key=KeyCode.DOWN))
        self.assertEqual(self.modal_54.choice_cursor, 1)

        # Press Enter: triggers choice 1 ("No") and closes modal
        self.modal_54.handle_key(KeyEvent(key=KeyCode.ENTER, char="\r"))
        self.assertEqual(choice_executed, ["no"])
        self.assertEqual(self.modal_54.state, DialogState.CLOSED)

    def test_target_selection_modal_disambiguates_multiple_npcs(self):
        """Verify adjacent target selection lists all neighboring NPCs by name and cardinal direction."""
        npc1 = create_town_citizen(name="Sir Gareth", pos=(5, 4))
        npc2 = create_town_citizen(name="Farmer Giles", pos=(4, 5))
        adjacent = [(npc1, "North"), (npc2, "West")]

        selected_target = []

        def on_target_selected(chosen_npc):
            selected_target.append(chosen_npc.name)

        self.modal_54.start_target_selection(adjacent, on_select=on_target_selected)
        self.modal_54.flush_page()

        self.assertEqual(self.modal_54.state, DialogState.CHOICE_WAITING)
        self.assertEqual(len(self.modal_54.choices), 2)
        self.assertEqual(self.modal_54.choices[0].label, "Sir Gareth (North)")
        self.assertEqual(self.modal_54.choices[1].label, "Farmer Giles (West)")

        # Move to second choice and select
        self.modal_54.handle_key(KeyEvent(key=KeyCode.DOWN))
        self.modal_54.handle_key(KeyEvent(key=KeyCode.ENTER, char="\r"))

        self.assertEqual(selected_target, ["Farmer Giles"])

    def test_noise_map_screen_adjacent_npc_interaction_flow(self):
        """Verify GSNoiseMapTestScreen detects adjacent NPCs, prompts via HUD, and handles dialogue."""
        screen = GSNoiseMapTestScreen(map_width=54, map_height=24)
        town_map = Map(name="Test Town", width=54, height=24)
        for y in range(24):
            for x in range(54):
                town_map.set_tile(x, y, MapTile(biome=BiomeType.ROAD))

        # Place player at (10, 10)
        screen.active_submap = town_map
        screen.player_x, screen.player_y = 10, 10

        # No NPCs adjacent
        self.assertEqual(screen._get_adjacent_npcs(), [])

        # Add 1 NPC to North (10, 9)
        npc_north = create_town_citizen(name="Weaver Lisa", pos=(10, 9))
        town_map.tiles[9][10].npc = npc_north

        adjacent = screen._get_adjacent_npcs()
        self.assertEqual(len(adjacent), 1)
        self.assertEqual(adjacent[0][0].name, "Weaver Lisa")
        self.assertEqual(adjacent[0][1], "North")

        # Telemetry line prompts to talk
        lines = screen.generate_frame_lines()
        self.assertIn("Talk to Weaver Lisa", lines[1])
        self.assertIn("[Enter]Talk", strip_ansi(lines[-1]))

        # Press Enter: triggers dialogue modal
        context = Context()
        context.set(SMState.ContextKeysPressed, [KeyEvent(key=KeyCode.ENTER, char="\r")])
        with patch("eldoria_py.terminal.screen.TerminalScreen.write"):
            screen.update(context)

        self.assertTrue(screen.npc_dialog.is_active)
        self.assertEqual(screen.npc_dialog.title, "Weaver Lisa")

        # While modal is active, arrow key input is intercepted and player does not move
        context.set(SMState.ContextKeysPressed, [KeyEvent(key=KeyCode.LEFT)])
        with patch("eldoria_py.terminal.screen.TerminalScreen.write"):
            screen.update(context)
        self.assertEqual((screen.player_x, screen.player_y), (10, 10))

        # Close dialogue modal via Escape
        context.set(SMState.ContextKeysPressed, [KeyEvent(key=KeyCode.ESCAPE)])
        with patch("eldoria_py.terminal.screen.TerminalScreen.write"):
            screen.update(context)
        self.assertFalse(screen.npc_dialog.is_active)

        # Now add second NPC to East (11, 10)
        npc_east = create_service_owner(role=NPCRole.INNKEEPER, name="Barnaby", pos=(11, 10))
        town_map.tiles[10][11].npc = npc_east

        adjacent_2 = screen._get_adjacent_npcs()
        self.assertEqual(len(adjacent_2), 2)

        # Telemetry updates to plural
        lines_2 = screen.generate_frame_lines()
        self.assertIn("Talk to NPCs (2)", lines_2[1])

        # Press Enter: opens target selection modal
        context.set(SMState.ContextKeysPressed, [KeyEvent(key=KeyCode.ENTER, char="\r")])
        with patch("eldoria_py.terminal.screen.TerminalScreen.write"):
            screen.update(context)

        self.assertTrue(screen.npc_dialog.is_active)
        self.assertTrue(screen.npc_dialog.is_target_selection)
        self.assertEqual(len(screen.npc_dialog.choices), 2)


if __name__ == "__main__":
    unittest.main()
