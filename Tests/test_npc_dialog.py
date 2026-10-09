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
    calculate_inn_fee,
    REGION_INN_FEES,
    create_king,
    create_service_owner,
    create_town_citizen,
)
from eldoria_py.combat import StatId, create_default_party
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
        self.assertEqual(equip_shop.dialogue, "Welcome to my forge! Care to examine my wares?")

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

    def test_calculate_inn_fee_regional_scaling(self):
        """Verify regional inn fee scaling from Region 1 (20g) to Region 9 (500g) with clamping."""
        expected_fees = {
            1: 20,
            2: 40,
            3: 70,
            4: 110,
            5: 160,
            6: 220,
            7: 300,
            8: 400,
            9: 500,
        }
        for region, expected in expected_fees.items():
            self.assertEqual(calculate_inn_fee(region), expected)
            self.assertEqual(REGION_INN_FEES[region], expected)

        # Clamping / boundary checks
        self.assertEqual(calculate_inn_fee(0), 20)
        self.assertEqual(calculate_inn_fee(-5), 20)
        self.assertEqual(calculate_inn_fee(10), 500)
        self.assertEqual(calculate_inn_fee(99), 500)

    def test_party_member_and_party_restore_full(self):
        """Verify restore_full resets HP/MP, defense state, stat augments, and clears status effects."""
        party = create_default_party()
        for member in party.members:
            # Deplete resources and add negative conditions
            member.stats[StatId.HIT_POINTS].current = 1
            member.stats[StatId.MAGIC_POINTS].current = 0
            member.is_defending = True
            member.stats[StatId.ATTACK].augment_value = 10
            member.stats[StatId.ATTACK].augment_turns = 3
            member.status_effects.extend(["Poison", "Burn"])

        # Execute full restoration
        party.restore_full()

        for member in party.members:
            self.assertEqual(member.hp, member.max_hp)
            self.assertEqual(member.mp, member.max_mp)
            self.assertFalse(member.is_defending)
            self.assertEqual(member.stats[StatId.ATTACK].augment_value, 0)
            self.assertEqual(member.stats[StatId.ATTACK].augment_turns, 0)
            self.assertEqual(member.status_effects, [])
            self.assertTrue(member.is_alive)

    def test_chained_dialogue_modal_transition(self):
        """Verify NPCDialogModal advance_or_act keeps modal open when choice action starts follow-up dialog."""
        modal = NPCDialogModal(screen_width=54, screen_height=27, chars_per_second=1000.0)
        npc = create_service_owner(role=NPCRole.INNKEEPER, name="Barnaby", pos=(3, 3), inn_fee=25)

        def follow_up_action():
            modal.start_dialog(npc, custom_text="Thanks! Enjoy your stay with us!", choices=None)

        choices = [DialogChoice(label="Yes", action=follow_up_action), DialogChoice(label="No", action=lambda: None)]
        modal.start_dialog(npc, choices=choices)
        modal.flush_page()

        self.assertEqual(modal.state, DialogState.CHOICE_WAITING)

        # Trigger "Yes" choice
        modal.advance_or_act()

        # Modal should NOT have closed; should be displaying follow-up text
        self.assertTrue(modal.is_active)
        self.assertIn("Thanks! Enjoy your stay with us!", modal.raw_text)
        self.assertEqual(modal.category, DialogCategory.STANDARD)
        self.assertEqual(modal.choices, [])

    def test_innkeeper_interaction_decline(self):
        """Verify declining the Inn prompt closes dialog and sets status message without charging gold."""
        screen = GSNoiseMapTestScreen(map_width=54, map_height=24)
        town_map = Map(name="Test Town", width=54, height=24)
        for y in range(24):
            for x in range(54):
                town_map.set_tile(x, y, MapTile(biome=BiomeType.ROAD))

        innkeeper = create_service_owner(role=NPCRole.INNKEEPER, name="Barnaby", pos=(10, 9), inn_fee=25)
        town_map.tiles[9][10].npc = innkeeper
        screen.active_submap = town_map
        screen.player_x, screen.player_y = 10, 10
        initial_gold = screen.party.gold

        # Open dialogue
        context = Context()
        context.set(SMState.ContextKeysPressed, [KeyEvent(key=KeyCode.ENTER, char="\r")])
        with patch("eldoria_py.terminal.screen.TerminalScreen.write"):
            screen.update(context)

        self.assertTrue(screen.npc_dialog.is_active)
        screen.npc_dialog.flush_page()
        self.assertEqual(screen.npc_dialog.state, DialogState.CHOICE_WAITING)

        # Move to "No" (index 1) and press Enter
        context.set(SMState.ContextKeysPressed, [KeyEvent(key=KeyCode.DOWN)])
        with patch("eldoria_py.terminal.screen.TerminalScreen.write"):
            screen.update(context)
        self.assertEqual(screen.npc_dialog.choice_cursor, 1)

        context.set(SMState.ContextKeysPressed, [KeyEvent(key=KeyCode.ENTER, char="\r")])
        with patch("eldoria_py.terminal.screen.TerminalScreen.write"):
            screen.update(context)

        self.assertFalse(screen.npc_dialog.is_active)
        self.assertEqual(screen.party.gold, initial_gold)
        self.assertIsNone(screen.inn_rest_phase)
        self.assertEqual(screen.last_status_msg, "Decided not to take a room.")

    def test_innkeeper_interaction_insufficient_gold(self):
        """Verify Innkeeper informs player of insufficient gold when party cannot afford room fee."""
        screen = GSNoiseMapTestScreen(map_width=54, map_height=24)
        town_map = Map(name="Test Town", width=54, height=24)
        for y in range(24):
            for x in range(54):
                town_map.set_tile(x, y, MapTile(biome=BiomeType.ROAD))

        innkeeper = create_service_owner(role=NPCRole.INNKEEPER, name="Barnaby", pos=(10, 9), inn_fee=150)
        town_map.tiles[9][10].npc = innkeeper
        screen.active_submap = town_map
        screen.player_x, screen.player_y = 10, 10
        screen.party.gold = 35  # Insufficient

        context = Context()
        context.set(SMState.ContextKeysPressed, [KeyEvent(key=KeyCode.ENTER, char="\r")])
        with patch("eldoria_py.terminal.screen.TerminalScreen.write"):
            screen.update(context)

        self.assertTrue(screen.npc_dialog.is_active)
        screen.npc_dialog.flush_page()
        self.assertEqual(screen.npc_dialog.state, DialogState.CHOICE_WAITING)

        # Select "Yes" (cursor at 0)
        context.set(SMState.ContextKeysPressed, [KeyEvent(key=KeyCode.ENTER, char="\r")])
        with patch("eldoria_py.terminal.screen.TerminalScreen.write"):
            screen.update(context)

        # Gold remains unchanged, modal stays open with refusal message, no rest phase started
        self.assertEqual(screen.party.gold, 35)
        self.assertIsNone(screen.inn_rest_phase)
        self.assertTrue(screen.npc_dialog.is_active)
        screen.npc_dialog.flush_page()
        self.assertIn("You don't have enough gold", screen.npc_dialog.raw_text)
        self.assertIn("35/150 G", screen.last_status_msg)

        # Verify category is STANDARD and choices is empty (no Yes/No prompt!)
        self.assertEqual(screen.npc_dialog.category, DialogCategory.STANDARD)
        self.assertEqual(screen.npc_dialog.choices, [])
        self.assertEqual(screen.npc_dialog.state, DialogState.FINISHED)

        # Only 7 text modal lines rendered (no 6-line choice box on top)
        overlay_cmds = screen.npc_dialog.render_overlay()
        self.assertEqual(len(overlay_cmds), 7)

        # Press Enter: dismisses refusal message and closes modal cleanly
        context.set(SMState.ContextKeysPressed, [KeyEvent(key=KeyCode.ENTER, char="\r")])
        with patch("eldoria_py.terminal.screen.TerminalScreen.write"):
            screen.update(context)
        self.assertFalse(screen.npc_dialog.is_active)

    def test_innkeeper_interaction_full_rest_sequence(self):
        """Verify complete Inn rest lifecycle: SFX, fade-out, Inn Theme, restore & save, fade-in, resume Town Theme."""
        screen = GSNoiseMapTestScreen(map_width=54, map_height=24)
        town_map = Map(name="Test Town", width=54, height=24)
        for y in range(24):
            for x in range(54):
                town_map.set_tile(x, y, MapTile(biome=BiomeType.ROAD))

        innkeeper = create_service_owner(role=NPCRole.INNKEEPER, name="Barnaby", pos=(10, 9), inn_fee=50)
        town_map.tiles[9][10].npc = innkeeper
        screen.active_submap = town_map
        screen.player_x, screen.player_y = 10, 10
        screen.party.gold = 200

        # Damage party and apply status effects
        for m in screen.party.members:
            m.stats[StatId.HIT_POINTS].current = 5
            m.stats[StatId.MAGIC_POINTS].current = 1
            m.status_effects.append("Poison")

        context = Context()
        context.set(SMState.ContextKeysPressed, [KeyEvent(key=KeyCode.ENTER, char="\r")])
        with patch("eldoria_py.terminal.screen.TerminalScreen.write"):
            screen.update(context)

        screen.npc_dialog.flush_page()
        self.assertEqual(screen.npc_dialog.state, DialogState.CHOICE_WAITING)

        mock_audio = MagicMock()
        mock_save = MagicMock()
        screen._save_to_slot = mock_save

        with patch("eldoria_py.states.test_noise_map.get_audio_engine", return_value=mock_audio):
            # Select "Yes" to stay
            context.set(SMState.ContextKeysPressed, [KeyEvent(key=KeyCode.ENTER, char="\r")])
            with patch("eldoria_py.terminal.screen.TerminalScreen.write"):
                screen.update(context)

            # Step 1: Gold deducted, SFX played, thank you message displayed, FADE_OUT not started yet
            self.assertEqual(screen.party.gold, 150)
            mock_audio.play_sfx.assert_called_with("Inn Coin")
            self.assertIn("Thanks! Enjoy your stay with us!", screen.npc_dialog.raw_text)
            self.assertTrue(screen.npc_dialog.is_active)
            self.assertIsNone(screen.inn_rest_phase)
            mock_audio.fade_out_bgm.assert_not_called()

            # Step 2: Player presses Enter to close the thank you dialog -> FADE_OUT initiated
            screen.npc_dialog.flush_page()
            context.set(SMState.ContextKeysPressed, [KeyEvent(key=KeyCode.ENTER, char="\r")])
            with patch("eldoria_py.terminal.screen.TerminalScreen.write"):
                screen.update(context)

            self.assertFalse(screen.npc_dialog.is_active)
            self.assertEqual(screen.inn_rest_phase, "FADE_OUT")
            mock_audio.fade_out_bgm.assert_called_with(duration_seconds=screen.inn_fade_duration)

            # Step 3: During FADE_OUT, buffer dims
            with patch("eldoria_py.terminal.screen.TerminalScreen.set_write_filter") as mock_filter:
                with patch("eldoria_py.terminal.screen.TerminalScreen.write"):
                    screen._render()
                self.assertTrue(mock_filter.called)

            # Advance FADE_OUT past duration (0.6s) -> transitions to SLEEP_BGM
            context.set(SMState.ContextKeysPressed, [])
            context.set(SMState.ContextDeltaTime, 0.65)
            with patch("eldoria_py.terminal.screen.TerminalScreen.write"):
                screen.update(context)

            self.assertEqual(screen.inn_rest_phase, "SLEEP_BGM")
            mock_audio.play_bgm.assert_any_call("Inn Theme", loop=False)
            mock_save.assert_called_once()
            self.assertFalse(screen.npc_dialog.is_active)

            # Check party is completely restored
            for m in screen.party.members:
                self.assertEqual(m.hp, m.max_hp)
                self.assertEqual(m.mp, m.max_mp)
                self.assertEqual(m.status_effects, [])

            # Check brightness is 0.0 in SLEEP_BGM
            with patch("eldoria_py.terminal.screen.TerminalScreen.set_write_filter") as mock_filter:
                with patch("eldoria_py.terminal.screen.TerminalScreen.write"):
                    screen._render()
                self.assertTrue(mock_filter.called)

            # Advance SLEEP_BGM past duration (1.85s) -> transitions to SLEEP_WAIT (1.5s pause)
            context.set(SMState.ContextDeltaTime, 1.9)
            with patch("eldoria_py.terminal.screen.TerminalScreen.write"):
                screen.update(context)

            self.assertEqual(screen.inn_rest_phase, "SLEEP_WAIT")

            # Check brightness is 0.0 during SLEEP_WAIT and Town Theme has not played yet
            with patch("eldoria_py.terminal.screen.TerminalScreen.set_write_filter") as mock_filter:
                with patch("eldoria_py.terminal.screen.TerminalScreen.write"):
                    screen._render()
                self.assertTrue(mock_filter.called)

            # Advance SLEEP_WAIT past 1.5 seconds -> transitions to FADE_IN
            context.set(SMState.ContextDeltaTime, 1.55)
            with patch("eldoria_py.terminal.screen.TerminalScreen.write"):
                screen.update(context)

            self.assertEqual(screen.inn_rest_phase, "FADE_IN")
            mock_audio.play_bgm.assert_any_call("Town Theme", loop=True)

            # Advance FADE_IN past duration (0.6s) -> completes sequence
            context.set(SMState.ContextDeltaTime, 0.65)
            with patch("eldoria_py.terminal.screen.TerminalScreen.write"):
                screen.update(context)

            self.assertIsNone(screen.inn_rest_phase)
            self.assertIn("Rested at the Inn!", screen.last_status_msg)

    def test_submap_inn_door_tile_interact(self):
        """Verify interacting with an MTOInn door tile routes directly to the town innkeeper's dialogue."""
        screen = GSNoiseMapTestScreen(map_width=54, map_height=24)
        town_map = Map(name="Test Town", width=54, height=24)
        for y in range(24):
            for x in range(54):
                town_map.set_tile(x, y, MapTile(biome=BiomeType.ROAD))

        # Place Inn door at (5, 5) with MTOInn object
        door_tile = town_map.tiles[5][5]
        door_tile.object_listing.append("MTOInn")

        # Place Innkeeper inside the inn at (8, 5)
        innkeeper = create_service_owner(role=NPCRole.INNKEEPER, name="Barnaby", pos=(8, 5), inn_fee=40)
        town_map.tiles[5][8].npc = innkeeper

        screen.active_submap = town_map
        screen.player_x, screen.player_y = 5, 5  # Player stands on door

        # Press Enter on door tile
        context = Context()
        context.set(SMState.ContextKeysPressed, [KeyEvent(key=KeyCode.ENTER, char="\r")])
        with patch("eldoria_py.terminal.screen.TerminalScreen.write"):
            screen.update(context)

        self.assertTrue(screen.npc_dialog.is_active)
        self.assertEqual(screen.npc_dialog.title, "Barnaby")
        self.assertIn("costs 40 gold", screen.npc_dialog.raw_text)

    def test_inn_rest_brightness_dimming_phases(self):
        """Verify brightness calculation across all Inn rest phases (FADE_OUT -> SLEEP_BGM -> FADE_IN -> None)."""
        screen = GSNoiseMapTestScreen(map_width=54, map_height=24)
        town_map = Map(name="Test Town", width=54, height=24)
        for y in range(24):
            for x in range(54):
                town_map.set_tile(x, y, MapTile(biome=BiomeType.ROAD))
        screen.active_submap = town_map

        captured_factors = []
        def fake_dim_buffer(ansi_str, factor, default_fg=None):
            captured_factors.append(factor)
            return ansi_str

        with patch("eldoria_py.states.test_noise_map.dim_buffer", side_effect=fake_dim_buffer), \
             patch("sys.stdout.write"):

            # 1. FADE_OUT phase at halfway (0.3s / 0.6s)
            screen.inn_rest_phase = "FADE_OUT"
            screen.inn_rest_elapsed = 0.3
            screen.inn_fade_duration = 0.6
            captured_factors.clear()
            screen._render()
            self.assertEqual(len(captured_factors), 1)
            self.assertAlmostEqual(captured_factors[0], 0.5, places=2)

            # 2. SLEEP_BGM phase (must be pitch black, 0.0)
            screen.inn_rest_phase = "SLEEP_BGM"
            screen.inn_rest_elapsed = 0.5
            captured_factors.clear()
            screen._render()
            self.assertEqual(len(captured_factors), 1)
            self.assertEqual(captured_factors[0], 0.0)

            # 2b. SLEEP_WAIT phase (1.5s silent pause, must also be pitch black, 0.0)
            screen.inn_rest_phase = "SLEEP_WAIT"
            screen.inn_rest_elapsed = 0.75
            captured_factors.clear()
            screen._render()
            self.assertEqual(len(captured_factors), 1)
            self.assertEqual(captured_factors[0], 0.0)

            # 3. FADE_IN phase at halfway (0.3s / 0.6s)
            screen.inn_rest_phase = "FADE_IN"
            screen.inn_rest_elapsed = 0.3
            captured_factors.clear()
            screen._render()
            self.assertEqual(len(captured_factors), 1)
            self.assertAlmostEqual(captured_factors[0], 0.5, places=2)

            # 4. Completed phase (None): brightness 1.0 (no dimming filter called)
            screen.inn_rest_phase = None
            captured_factors.clear()
            screen._render()
            self.assertEqual(len(captured_factors), 0)

    def test_armorer_dialog_renders_text_in_game_loop(self):
        """Regression test: verify NPC dialogue continues rendering during game loop update ticks."""
        from eldoria_py.core.fsm import SMStateMachine

        screen = GSNoiseMapTestScreen(map_width=54, map_height=24)
        town_map = Map(name="Test Town", width=54, height=24)
        for y in range(24):
            for x in range(54):
                town_map.set_tile(x, y, MapTile(biome=BiomeType.ROAD))
        screen.active_submap = town_map

        armorer = create_service_owner(role=NPCRole.EQUIP_SHOPKEEPER, name="Armorer Greta", pos=(10, 19))
        town_map.tiles[19][10].npc = armorer

        # FSM setup
        sm = SMStateMachine("GSNoiseMapTestScreen")
        sm.add_state(screen)

        class MockCore:
            def __init__(self, fsm):
                self.game_state = fsm

        core = MockCore(sm)

        # Player interacts with Armorer
        screen._start_npc_dialog(armorer)
        self.assertTrue(screen.npc_dialog.is_active)
        self.assertEqual(screen.npc_dialog.title, "Armorer Greta")

        # Track render calls during update ticks
        render_count = 0
        def fake_render():
            nonlocal render_count
            render_count += 1

        screen._render = fake_render

        # Simulate 5 game loop update ticks with no keys pressed
        for _ in range(5):
            ctx = Context([0.016, [], core])
            screen.update(ctx)

        # Must have called _render on all 5 frames (not skipped due to state check)
        self.assertEqual(render_count, 5)

        # Flush page and verify choices and prompt text are present
        screen.npc_dialog.flush_page()
        cmds = screen.npc_dialog.render_overlay()
        rendered_text = " ".join(strip_ansi(c[2]) for c in cmds)
        self.assertIn("Welcome to my forge!", rendered_text)
        self.assertIn("Yes", rendered_text)
        self.assertIn("No", rendered_text)

    def test_armorer_door_interaction(self):
        """Verify standing on MTOEquipShop door tile and pressing Enter triggers Armorer dialogue."""
        screen = GSNoiseMapTestScreen(map_width=54, map_height=24)
        town_map = Map(name="Test Town", width=54, height=24)
        for y in range(24):
            for x in range(54):
                town_map.set_tile(x, y, MapTile(biome=BiomeType.ROAD))

        door_tile = town_map.tiles[15][10]
        door_tile.object_listing.append("MTOEquipShop")

        armorer = create_service_owner(role=NPCRole.EQUIP_SHOPKEEPER, name="Armorer Greta", pos=(10, 16))
        town_map.tiles[16][10].npc = armorer

        screen.active_submap = town_map
        screen.player_x, screen.player_y = 10, 15

        context = Context()
        context.set(SMState.ContextKeysPressed, [KeyEvent(key=KeyCode.ENTER, char="\r")])
        with patch("eldoria_py.terminal.screen.TerminalScreen.write"):
            screen.update(context)

        self.assertTrue(screen.npc_dialog.is_active)
        self.assertEqual(screen.npc_dialog.title, "Armorer Greta")
        self.assertIn("forge", screen.npc_dialog.raw_text.lower())


if __name__ == "__main__":
    unittest.main()
