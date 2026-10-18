"""
Unit and Integration Tests for the Item / Herbalist NPC and Shop Subsystem.
Tests:
- generate_item_shop_inventory regional scaling and strict exclusion of equipment & key items
- Resale prices fixed at 20%
- GSItemShopScreen configuration, BUY mode, and SELL mode
- Single purchase and bulk purchase modal logic (gold deduction, inventory add, 99 cap)
- Single sale and bulk sale modal logic (20% payout, inventory deduction)
- PURCHASED vs LOOKED result reporting
- Frame line dimensions (80x28) and rendering without exceptions
- NPC POI dialogue choices and post-shop exit feedback
"""

import unittest
from unittest.mock import MagicMock, patch

from eldoria_py.terminal.ansi import ATControlSequences
from eldoria_py.combat.entities import Party, create_default_party
from eldoria_py.combat.items import ConsumableItem, ItemType, ItemEffectType, ITEM_CATALOG, get_item
from eldoria_py.procgen.npc import (
    NPC,
    NPCRole,
    DialogCategory,
    create_service_owner,
    generate_item_shop_inventory,
)
from eldoria_py.states.item_shop import GSItemShopScreen
from eldoria_py.states.test_noise_map import GSNoiseMapTestScreen
from eldoria_py.terminal.box import strip_ansi, visible_width
from eldoria_py.terminal.input import KeyCode, KeyEvent
from eldoria_py.core.context import Context


class TestItemShopSubsystem(unittest.TestCase):
    def setUp(self):
        self.party = create_default_party()
        self.party.gold = 500
        self.npc = create_service_owner(
            role=NPCRole.ITEM_SHOPKEEPER,
            name="Maeve",
            pos=(10, 10),
            region=1,
        )

    # -------------------------------------------------------------------------
    # 1. Inventory Generation & Regional Scaling
    # -------------------------------------------------------------------------
    def test_inventory_generation_excludes_equipment_and_key_items(self):
        """All regions strictly exclude equipment and key items."""
        for reg in range(1, 10):
            inv = generate_item_shop_inventory(region_tier=reg)
            self.assertGreater(len(inv), 0)
            for entry in inv:
                item_id = entry["item_id"]
                c_item = get_item(item_id)
                self.assertIsNotNone(c_item, f"Item {item_id} should exist in catalog")
                self.assertNotEqual(c_item.item_type, ItemType.KEY_ITEM)
                self.assertNotEqual(c_item.item_type, ItemType.EQUIPMENT)
                self.assertEqual(entry["type"], "consumable")

    def test_inventory_resale_fixed_at_twenty_percent(self):
        """Item sell prices in inventory are fixed at 20% of base price."""
        for reg in (1, 3, 5, 8):
            inv = generate_item_shop_inventory(region_tier=reg)
            for entry in inv:
                expected_sell = max(1, int(entry["price"] * 0.20))
                self.assertEqual(entry["sell_price"], expected_sell)

    def test_inventory_regional_scaling(self):
        """Region 1 stocks Tier 1 with mid-tier smattering; Region 8 stocks all tiers."""
        inv_r1 = generate_item_shop_inventory(region_tier=1, seed=42)
        names_r1 = [e["name"] for e in inv_r1]

        # Region 1 staples
        self.assertIn("Potion", names_r1)
        self.assertIn("Antidote", names_r1)
        # Region 1 smattering contains mid-tier (e.g., Hi-Potion or Ether)
        has_mid_tier = any(e["tier"] == 2 for e in inv_r1)
        self.assertTrue(has_mid_tier)
        # Region 1 does not stock Elixir (Tier 4)
        self.assertNotIn("Elixir", names_r1)

        # Region 8 stocks high-tier items including Elixir
        inv_r8 = generate_item_shop_inventory(region_tier=8, seed=42)
        names_r8 = [e["name"] for e in inv_r8]
        self.assertIn("Elixir", names_r8)
        self.assertIn("Mega Potion", names_r8)
        self.assertIn("Panacea", names_r8)
        self.assertGreater(len(inv_r8), len(inv_r1))

    # -------------------------------------------------------------------------
    # 2. Item Shop Screen Configuration & Rendering
    # -------------------------------------------------------------------------
    def test_configure_shop_initialization(self):
        """configure_shop sets up state variables, modes, and default inventories."""
        screen = GSItemShopScreen()
        screen.configure_shop(
            party=self.party,
            shopkeeper_npc=self.npc,
            region_code=1,
        )
        self.assertEqual(screen.mode, "BUY")
        self.assertEqual(screen.party, self.party)
        self.assertEqual(screen.shopkeeper_npc, self.npc)
        self.assertEqual(screen.region_code, 1)
        self.assertEqual(screen.items_bought_count, 0)
        self.assertFalse(screen.bulk_modal_active)
        self.assertGreater(len(screen.current_items), 0)

    def test_frame_lines_geometry_and_dimensions(self):
        """generate_frame_lines outputs exactly 28 rows, each having visible width 80."""
        screen = GSItemShopScreen()
        screen.configure_shop(party=self.party, shopkeeper_npc=self.npc, region_code=1)
        lines = screen.generate_frame_lines()
        self.assertEqual(len(lines), 28)
        self.assertNotIn("[ESC] Leave", strip_ansi(lines[1]))
        for idx, line in enumerate(lines):
            v_width = visible_width(line)
            self.assertEqual(v_width, 80, f"Row {idx} visible width is {v_width}, expected 80")

    def test_right_pane_displays_item_details_without_party_members(self):
        """Right pane displays item description, badges, and properties, but no party members."""
        screen = GSItemShopScreen()
        screen.configure_shop(party=self.party, shopkeeper_npc=self.npc, region_code=1)
        potion_idx = next(i for i, it in enumerate(screen.current_items) if it["name"] == "Potion")
        screen.active_cursor = potion_idx
        right_lines = screen._render_right_pane()
        right_text = "\n".join(strip_ansi(l) for l in right_lines)

        # Right pane must show item properties
        self.assertIn("Potion", right_text)
        self.assertIn("Price:", right_text)
        self.assertIn("Resale:", right_text)
        self.assertNotIn("(20%)", right_text)
        self.assertIn("In Bag:", right_text)
        self.assertIn("Target:", right_text)
        self.assertIn("Usable:", right_text)
        self.assertIn("Description:", right_text)
        self.assertIn("Herbalist's Field Tip", right_text)

        # Party members should NOT be displayed on this screen
        for member in self.party.members:
            self.assertNotIn(f"[{member.name}]", right_text)

    def test_tip_panel_uses_uipanel_with_fixed_right_border(self):
        """Herbalist's Field Tip is rendered via a formal UIPanel with fixed vertical right borders."""
        from eldoria_py.ui.panel import UIPanel
        screen = GSItemShopScreen()
        screen.configure_shop(party=self.party, shopkeeper_npc=self.npc, region_code=1)
        self.assertIsInstance(screen.tip_panel, UIPanel)

        # Test across all items in shop stock to verify border column alignment never shifts
        for item_idx in range(len(screen.current_items)):
            screen.active_cursor = item_idx
            right_lines = screen._render_right_pane()
            tip_box_lines = [
                strip_ansi(l) for l in right_lines
                if any(ch in l for ch in ("┌", "│", "└")) and ("Herbalist's Field Tip" in l or "│" in l or "└" in l)
            ]
            # Must have top border, 2 content lines, and bottom border
            self.assertGreaterEqual(len(tip_box_lines), 4)
            # Check that the rightmost non-space character is at the exact same column for all 4 lines
            rightmost_cols = [len(l.rstrip()) for l in tip_box_lines[:4]]
            self.assertEqual(
                len(set(rightmost_cols)),
                1,
                f"Right border shifted for item {item_idx}: columns={rightmost_cols}, lines={tip_box_lines[:4]}",
            )

    # -------------------------------------------------------------------------
    # 3. Single Item Transactions (Buy & Sell)
    # -------------------------------------------------------------------------
    def test_single_item_purchase(self):
        """Pressing Enter in BUY mode purchases 1 item, deducts gold, and adds to inventory."""
        screen = GSItemShopScreen()
        screen.configure_shop(party=self.party, shopkeeper_npc=self.npc, region_code=1)
        initial_gold = self.party.gold
        initial_potions = self.party.get_item_count("Potion")

        # Select Potion (index 0, price 20 G)
        potion_idx = next(i for i, it in enumerate(screen.current_items) if it["name"] == "Potion")
        screen.active_cursor = potion_idx
        screen._buy_item(qty=1)

        self.assertEqual(self.party.gold, initial_gold - 20)
        self.assertEqual(self.party.get_item_count("Potion"), initial_potions + 1)
        self.assertEqual(screen.items_bought_count, 1)
        self.assertIn("Purchased 1x Potion", screen.feedback_msg)

    def test_single_item_purchase_insufficient_gold(self):
        """Purchase fails gracefully when party cannot afford the item."""
        screen = GSItemShopScreen()
        self.party.gold = 5  # Too poor for a 20 G potion
        screen.configure_shop(party=self.party, shopkeeper_npc=self.npc, region_code=1)
        potion_idx = next(i for i, it in enumerate(screen.current_items) if it["name"] == "Potion")
        screen.active_cursor = potion_idx
        screen._buy_item(qty=1)

        self.assertEqual(self.party.gold, 5)
        self.assertEqual(screen.items_bought_count, 0)
        self.assertEqual(screen.feedback_msg, "Not enough gold! Needs 20 G.")
        self.assertNotIn("You have", screen.feedback_msg)

    def test_price_consistency_across_panes_and_prompts(self):
        """Validates that left pane, right pane, bulk modal, and insufficient gold error all reflect canonical catalog prices."""
        screen = GSItemShopScreen()
        self.party.gold = 10  # Insufficient for 20 G Potion
        # Intentionally give NPC legacy inventory with incorrect prices to test robustness
        legacy_npc = create_service_owner(role=NPCRole.ITEM_SHOPKEEPER, name="Merchant Silas", pos=(10, 10))
        legacy_npc.shop_inventory = [{"item_id": "Potion", "price": 50, "qty": 99}]
        screen.configure_shop(party=self.party, shopkeeper_npc=legacy_npc, region_code=1)
        potion_idx = next(i for i, it in enumerate(screen.current_items) if it["name"] == "Potion")
        screen.active_cursor = potion_idx

        # 1. Left pane shows canonical 20 G (NOT 50 G)
        left_text = "\n".join(strip_ansi(l) for l in screen._render_left_pane())
        potion_line = next(l for l in left_text.splitlines() if "Potion" in l and "Hi-Potion" not in l)
        self.assertIn("Potion", potion_line)
        self.assertIn("20 G", potion_line)
        self.assertNotIn("50 G", potion_line)

        # 2. Right pane shows Price: 20 G
        right_text = "\n".join(strip_ansi(l) for l in screen._render_right_pane())
        self.assertIn("Price: 20 G", right_text)
        self.assertNotIn("Price: 50 G", right_text)

        # 3. Insufficient gold error prompt declares Needs 20 G
        screen._buy_item(qty=1)
        self.assertEqual(screen.feedback_msg, "Not enough gold! Needs 20 G.")

        # 4. Bulk modal displays 20 G each
        screen.bulk_modal_active = True
        modal_lines = "\n".join(strip_ansi(l) for l in screen._overlay_bulk_modal(screen.generate_frame_lines()))
        self.assertIn("Potion (20 G each)", modal_lines)
        self.assertNotIn("50 G each", modal_lines)

    def test_legacy_inventory_migration_on_configure_shop(self):
        """NPCs loaded with legacy 4-item inventory without tier are automatically upgraded to full regional inventory."""
        screen = GSItemShopScreen()
        legacy_npc = create_service_owner(role=NPCRole.ITEM_SHOPKEEPER, name="Merchant Silas", pos=(10, 10))
        legacy_npc.shop_inventory = [
            {"item_id": "Potion", "price": 50, "qty": 99},
            {"item_id": "Ether", "price": 150, "qty": 99},
            {"item_id": "Antidote", "price": 30, "qty": 99},
            {"item_id": "Revive Herb", "price": 250, "qty": 99},
        ]
        screen.configure_shop(party=self.party, shopkeeper_npc=legacy_npc, region_code=1)
        # Should be replaced by full regional stock with tiers
        self.assertTrue(all("tier" in entry for entry in legacy_npc.shop_inventory))
        potion_entry = next(e for e in legacy_npc.shop_inventory if e["item_id"] == "Potion")
        self.assertEqual(potion_entry["price"], 20)
        self.assertGreater(len(legacy_npc.shop_inventory), 4)

    def test_single_item_resale_twenty_percent(self):
        """Selling an item awards 20% resale value and removes 1 item from inventory."""
        screen = GSItemShopScreen()
        self.party.add_item("Antidote", 3, item_type="consumable")
        screen.configure_shop(party=self.party, shopkeeper_npc=self.npc, region_code=1)
        screen.mode = "SELL"
        initial_gold = self.party.gold

        antidote_item = get_item("Antidote")
        expected_sell_price = antidote_item.sell_price  # 20% of 15 = 3 G

        antidote_idx = next(i for i, it in enumerate(screen.current_items) if it["name"] == "Antidote")
        screen.active_cursor = antidote_idx

        left_text = "\n".join(strip_ansi(l) for l in screen._render_left_pane())
        self.assertIn("SATCHEL ITEMS", left_text)
        self.assertNotIn("(20% RESALE)", left_text)

        screen._sell_item(qty=1)

        self.assertEqual(self.party.gold, initial_gold + expected_sell_price)
        self.assertEqual(self.party.get_item_count("Antidote"), 2)
        self.assertIn("Sold 1x Antidote", screen.feedback_msg)

    # -------------------------------------------------------------------------
    # 4. Bulk Transactions Modal
    # -------------------------------------------------------------------------
    def test_bulk_purchase_modal_workflow(self):
        """Opens bulk modal, increments quantity, and confirms purchase."""
        screen = GSItemShopScreen()
        self.party.gold = 1000
        screen.configure_shop(party=self.party, shopkeeper_npc=self.npc, region_code=1)
        potion_idx = next(i for i, it in enumerate(screen.current_items) if it["name"] == "Potion")
        screen.active_cursor = potion_idx

        # Open bulk modal via 'B' key
        b_event = KeyEvent(key=KeyCode.NONE, char="b")
        screen._handle_normal_input(b_event, Context(), None)
        self.assertTrue(screen.bulk_modal_active)
        self.assertEqual(screen.bulk_qty, 1)

        # Increase quantity by 10 (Up arrow)
        up_event = KeyEvent(key=KeyCode.UP)
        screen._handle_bulk_input(up_event)
        self.assertEqual(screen.bulk_qty, 11)

        # Increase quantity by 1 (Right arrow)
        right_event = KeyEvent(key=KeyCode.RIGHT)
        screen._handle_bulk_input(right_event)
        self.assertEqual(screen.bulk_qty, 12)

        # Confirm purchase with Enter
        initial_potions = self.party.get_item_count("Potion")
        enter_event = KeyEvent(key=KeyCode.ENTER)
        screen._handle_bulk_input(enter_event)

        self.assertFalse(screen.bulk_modal_active)
        self.assertEqual(self.party.get_item_count("Potion"), initial_potions + 12)
        self.assertEqual(self.party.gold, 1000 - (20 * 12))
        self.assertEqual(screen.items_bought_count, 12)

    def test_bulk_modal_caps_at_ninety_nine(self):
        """Bulk buying cannot exceed inventory slot maximum of 99."""
        screen = GSItemShopScreen()
        self.party.gold = 50000
        cur_potions = self.party.get_item_count("Potion")
        to_add = 90 - cur_potions
        if to_add > 0:
            self.party.add_item("Potion", to_add, item_type="consumable")
        self.assertEqual(self.party.get_item_count("Potion"), 90)

        screen.configure_shop(party=self.party, shopkeeper_npc=self.npc, region_code=1)
        potion_idx = next(i for i, it in enumerate(screen.current_items) if it["name"] == "Potion")
        screen.active_cursor = potion_idx

        screen._handle_normal_input(KeyEvent(key=KeyCode.NONE, char="b"), Context(), None)
        self.assertTrue(screen.bulk_modal_active)

        # Press 'M' for max
        m_event = KeyEvent(key=KeyCode.NONE, char="m")
        screen._handle_bulk_input(m_event)

        # Max should be 99 - 90 = 9
        self.assertEqual(screen.bulk_qty, 9)

    # -------------------------------------------------------------------------
    # 5. POI Dialog & Exit Callback Handling
    # -------------------------------------------------------------------------
    def test_poi_dialog_no_response(self):
        """Selecting 'No' when interacting with Herbalist POI declines politely."""
        map_screen = GSNoiseMapTestScreen(map_width=80, map_height=30)
        map_screen.party = self.party
        map_screen.npc_dialog.screen_width = 80
        map_screen.npc_dialog.screen_height = 33

        # Trigger interaction
        map_screen._start_npc_dialog(self.npc)
        self.assertTrue(map_screen.npc_dialog.is_active)
        self.assertEqual(len(map_screen.npc_dialog.choices), 2)
        self.assertEqual(map_screen.npc_dialog.choices[1].label, "No")

        # Select No
        map_screen.npc_dialog.choices[1].action()
        self.assertIn("Some other time then! Stay healthy out there.", map_screen.npc_dialog.raw_text)

    def test_handle_shop_exit_dialogue(self):
        """handle_shop_exit displays contextual dialog for PURCHASED vs LOOKED."""
        map_screen = GSNoiseMapTestScreen(map_width=80, map_height=30)
        map_screen.party = self.party

        # 1. Exit after purchasing
        map_screen.handle_shop_exit(npc=self.npc, result="PURCHASED")
        self.assertTrue(map_screen.npc_dialog.is_active)
        self.assertIn("Thank you for your patronage! May these remedies keep you in good health.", map_screen.npc_dialog.raw_text)

        # 2. Exit after just looking
        map_screen.handle_shop_exit(npc=self.npc, result="LOOKED")
        self.assertTrue(map_screen.npc_dialog.is_active)
        self.assertIn("Didn't find the remedies you need? Stop by anytime!", map_screen.npc_dialog.raw_text)

    # -------------------------------------------------------------------------
    # 6. Cursor Visibility
    # -------------------------------------------------------------------------
    def test_item_shop_enter_hides_cursor(self):
        """Entering GSItemShopScreen explicitly emits CursorHide."""
        screen = GSItemShopScreen()
        screen.configure_shop(party=self.party, shopkeeper_npc=self.npc, region_code=1)
        with patch("eldoria_py.states.item_shop.TerminalScreen.write") as mock_write:
            screen.enter(Context())
            writes = [call.args[0] for call in mock_write.call_args_list]
            self.assertIn(ATControlSequences.CursorHide, writes)

    def test_noise_map_exit_does_not_show_cursor(self):
        """Exiting GSNoiseMapTestScreen to another state does NOT emit CursorShow."""
        map_screen = GSNoiseMapTestScreen(map_width=80, map_height=30)
        with patch("eldoria_py.states.test_noise_map.TerminalScreen.write") as mock_write:
            map_screen.exit(Context())
            writes = [call.args[0] for call in mock_write.call_args_list]
            self.assertNotIn(ATControlSequences.CursorShow, writes)

    # -------------------------------------------------------------------------
    # 7. Audio SFX on Purchase
    # -------------------------------------------------------------------------
    def test_item_purchase_plays_inn_coin_sfx(self):
        """Purchasing an item from the Item Shop plays Resources/SFX/Inn Coin.mp3 once."""
        screen = GSItemShopScreen()
        screen.configure_shop(party=self.party, shopkeeper_npc=self.npc, region_code=1)
        potion_idx = next(i for i, it in enumerate(screen.current_items) if it["name"] == "Potion")
        screen.active_cursor = potion_idx

        with patch("eldoria_py.states.item_shop.get_audio_engine") as mock_get_audio:
            mock_audio = MagicMock()
            mock_get_audio.return_value = mock_audio
            screen._buy_item(qty=1)
            mock_audio.play_sfx.assert_called_once_with("Resources/SFX/Inn Coin.mp3")

    def test_item_purchase_failure_does_not_play_sfx(self):
        """Failed item purchase due to insufficient gold does not play SFX."""
        screen = GSItemShopScreen()
        self.party.gold = 0
        screen.configure_shop(party=self.party, shopkeeper_npc=self.npc, region_code=1)
        potion_idx = next(i for i, it in enumerate(screen.current_items) if it["name"] == "Potion")
        screen.active_cursor = potion_idx

        with patch("eldoria_py.states.item_shop.get_audio_engine") as mock_get_audio:
            mock_audio = MagicMock()
            mock_get_audio.return_value = mock_audio
            screen._buy_item(qty=1)
            mock_audio.play_sfx.assert_not_called()


if __name__ == "__main__":
    unittest.main()
