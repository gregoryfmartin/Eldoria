"""
Unit and Integration Tests for the Armorer NPC & Equipment Shop Subsystem.
Tests:
- Regional inventory generation across Regions 1-9
- Exclusion of endgame relics (Excalibur, Dragon Shield, etc.)
- 20% resale economy rule
- Armorer POI interaction (Yes/No choice prompts)
- Declining wares ('Some other time then!')
- Accepting wares (transition ToEquipShop)
- Shop Screen UI listing (name & price only)
- Dynamic party stat diff preview (+/- deltas)
- Single and bulk purchasing
- Selling equipment at 20% resale
- Exiting shop with PURCHASED vs LOOKED result and contextual NPC reactions
"""

import unittest
from unittest.mock import MagicMock, patch

from eldoria_py.core.context import Context
from eldoria_py.core.fsm import SMState
from eldoria_py.combat.stats import StatId, EquipmentSlot
from eldoria_py.combat.equipment import BattleEquipment, EQUIPMENT_CATALOG, get_equipment
from eldoria_py.combat.entities import PartyMember, Party, create_default_party
from eldoria_py.procgen.npc import (
    DialogCategory,
    NPCRole,
    NPC,
    create_service_owner,
    generate_armorer_inventory,
)
from eldoria_py.procgen.map_generator import Map, MapTile, BiomeType
from eldoria_py.states.test_noise_map import GSNoiseMapTestScreen
from eldoria_py.states.equip_shop import GSEquipShopScreen
from eldoria_py.terminal.box import strip_ansi
from eldoria_py.terminal.input import KeyCode, KeyEvent
from eldoria_py.ui.npc_dialog import DialogState


class TestEquipShopSubsystem(unittest.TestCase):
    def setUp(self):
        self.party = create_default_party()
        self.armorer_npc = create_service_owner(
            role=NPCRole.EQUIP_SHOPKEEPER,
            name="Torvald",
            pos=(10, 10),
            region=1,
        )

    # -------------------------------------------------------------------------
    # 1. Economy & Regional Inventory Generation Tests
    # -------------------------------------------------------------------------
    def test_regional_inventory_only_equipment(self):
        """Verify armorer inventory contains exclusively non-relic equipment items."""
        for reg in range(1, 10):
            inv = generate_armorer_inventory(region_tier=reg)
            self.assertGreater(len(inv), 0)
            for item_entry in inv:
                self.assertEqual(item_entry.get("type"), "equipment")
                eq = get_equipment(item_entry["name"])
                self.assertIsNotNone(eq)
                self.assertFalse(eq.is_relic)

    def test_relics_strictly_excluded_from_all_armorers(self):
        """Verify high-end endgame relics are never stocked at any regional armorer."""
        relic_names = {"Excalibur", "Dragon Shield", "Mythril Plate", "Titan Helm", "Aegis Cloak"}
        for reg in range(1, 10):
            inv = generate_armorer_inventory(region_tier=reg)
            stocked_names = {entry["name"] for entry in inv}
            overlap = relic_names.intersection(stocked_names)
            self.assertEqual(len(overlap), 0, f"Found relics {overlap} in Region {reg} inventory!")

    def test_regional_tier_distribution(self):
        """Verify Region 1 has Tier 1 + smattering of Tier 2, while Region 7+ has Tier 2 & 3."""
        r1_inv = generate_armorer_inventory(region_tier=1)
        r1_names = {e["name"] for e in r1_inv}
        # Region 1 must contain Iron Longsword and Leather Hood (Tier 1)
        self.assertIn("Iron Longsword", r1_names)
        self.assertIn("Leather Hood", r1_names)
        # Smattering of Tier 2
        self.assertIn("Iron Greathelm", r1_names)
        # Should not contain high-end Tier 3 Steel Broadsword in Region 1
        self.assertNotIn("Steel Broadsword", r1_names)

        # Higher regions include Tier 3
        r7_inv = generate_armorer_inventory(region_tier=7)
        r7_names = {e["name"] for e in r7_inv}
        self.assertIn("Steel Broadsword", r7_names)
        self.assertIn("Plate Cuirass", r7_names)

    def test_fixed_twenty_percent_resale(self):
        """Verify equipment sell price is strictly 20% of base purchase value in all cases."""
        for name, eq in EQUIPMENT_CATALOG.items():
            expected_sell = max(1, int(eq.price * 0.20))
            self.assertEqual(eq.sell_price, expected_sell, f"Mismatch in sell_price for {name}")

    # -------------------------------------------------------------------------
    # 2. NPC POI Interaction & Dialogue Branching
    # -------------------------------------------------------------------------
    def test_armorer_poi_interaction_prompt_and_decline(self):
        """Verify interacting with Armorer POI prompts with Yes/No, and selecting No says 'Some other time then!'."""
        screen = GSNoiseMapTestScreen(map_width=54, map_height=24)
        town_map = Map(name="Test Town", width=54, height=24)
        for y in range(24):
            for x in range(54):
                town_map.set_tile(x, y, MapTile(biome=BiomeType.ROAD))

        armorer = create_service_owner(role=NPCRole.EQUIP_SHOPKEEPER, name="Torvald", pos=(10, 9), region=1)
        town_map.tiles[9][10].npc = armorer
        screen.active_submap = town_map
        screen.player_x, screen.player_y = 10, 10

        # Step 1: Interact (Enter facing North)
        context = Context()
        context.set(SMState.ContextKeysPressed, [KeyEvent(key=KeyCode.ENTER, char="\r")])
        with patch("eldoria_py.terminal.screen.TerminalScreen.write"):
            screen.update(context)

        screen.npc_dialog.flush_page()
        self.assertEqual(screen.npc_dialog.state, DialogState.CHOICE_WAITING)
        self.assertIn("Welcome to my forge! Care to examine my wares?", screen.npc_dialog.raw_text)
        self.assertEqual([c.label for c in screen.npc_dialog.choices], ["Yes", "No"])

        # Step 2: Select 'No' (Down Arrow, then Enter in separate updates)
        context.set(SMState.ContextKeysPressed, [KeyEvent(key=KeyCode.DOWN)])
        with patch("eldoria_py.terminal.screen.TerminalScreen.write"):
            screen.update(context)
        self.assertEqual(screen.npc_dialog.choice_cursor, 1)

        context.set(SMState.ContextKeysPressed, [KeyEvent(key=KeyCode.ENTER, char="\r")])
        with patch("eldoria_py.terminal.screen.TerminalScreen.write"):
            screen.update(context)

        screen.npc_dialog.flush_page()
        self.assertIn("Some other time then! Safe travels.", screen.npc_dialog.raw_text)
        self.assertEqual(screen.npc_dialog.choices, [])

        # Step 3: Dismiss closing dialogue
        context.set(SMState.ContextKeysPressed, [KeyEvent(key=KeyCode.ENTER, char="\r")])
        with patch("eldoria_py.terminal.screen.TerminalScreen.write"):
            screen.update(context)

        self.assertFalse(screen.npc_dialog.is_active)

    def test_armorer_poi_interaction_accept_transitions_to_shop(self):
        """Verify selecting 'Yes' to view wares triggers ToEquipShop FSM transition and configures shop."""
        screen = GSNoiseMapTestScreen(map_width=54, map_height=24)
        town_map = Map(name="Test Town", width=54, height=24)
        for y in range(24):
            for x in range(54):
                town_map.set_tile(x, y, MapTile(biome=BiomeType.ROAD))

        armorer = create_service_owner(role=NPCRole.EQUIP_SHOPKEEPER, name="Torvald", pos=(10, 9), region=2)
        town_map.tiles[9][10].npc = armorer
        screen.active_submap = town_map
        screen.player_x, screen.player_y = 10, 10

        # Mock engine core and FSM
        mock_core = MagicMock()
        mock_game_state = MagicMock()
        shop_screen = GSEquipShopScreen()
        mock_game_state.states = {"GSEquipShopScreen": shop_screen}
        mock_core.game_state = mock_game_state

        context = Context()
        context.set(SMState.ContextEldoriaCore, mock_core)
        context.set(SMState.ContextKeysPressed, [KeyEvent(key=KeyCode.ENTER, char="\r")])

        with patch("eldoria_py.terminal.screen.TerminalScreen.write"):
            screen.update(context)

        screen.npc_dialog.flush_page()
        self.assertEqual(screen.npc_dialog.state, DialogState.CHOICE_WAITING)

        # Select 'Yes' (Enter)
        context.set(SMState.ContextKeysPressed, [KeyEvent(key=KeyCode.ENTER, char="\r")])
        with patch("eldoria_py.terminal.screen.TerminalScreen.write"):
            screen.update(context)

        mock_game_state.trigger.assert_called_with("ToEquipShop", context)
        self.assertEqual(shop_screen.armorer_npc, armorer)
        self.assertEqual(shop_screen.region_code, 2)
        self.assertFalse(screen.npc_dialog.is_active)

    # -------------------------------------------------------------------------
    # 3. Shop Screen Features & UI Rendering
    # -------------------------------------------------------------------------
    def test_shop_screen_frame_rendering(self):
        """Verify shop screen generates an 80-column layout showing only equipment name and price."""
        shop = GSEquipShopScreen()
        shop.configure_shop(party=self.party, armorer_npc=self.armorer_npc, region_code=1)

        lines = shop.generate_frame_lines()
        self.assertGreaterEqual(len(lines), 28)
        # Check title row
        self.assertIn("Torvald's Forge & Armory", strip_ansi(lines[0]))
        self.assertIn("Gold:", strip_ansi(lines[0]))

        # Check left pane listing contains name and price
        full_text = "\n".join(strip_ansi(l) for l in lines)
        self.assertIn("SHOP INVENTORY", full_text)
        self.assertIn("Iron Longsword", full_text)
        self.assertIn("150 G", full_text)

        # Check right pane contains details and party preview
        self.assertIn("PARTY COMPARISON & STAT PREVIEW", full_text)
        self.assertIn(self.party.members[0].name, full_text)

    def test_stat_diff_preview_calculation(self):
        """Verify dynamic +/- stat diff calculation comparing highlighted item with equipped gear."""
        shop = GSEquipShopScreen()
        # Equip Iron Longsword on Steve (Warrior)
        steve = self.party.members[0]
        steve.equip(EQUIPMENT_CATALOG["Iron Longsword"])  # ATK +18, ACC +5

        armorer_r3 = create_service_owner(role=NPCRole.EQUIP_SHOPKEEPER, name="Torvald", pos=(10, 10), region=3)
        shop.configure_shop(party=self.party, armorer_npc=armorer_r3, region_code=3)

        # Find Steel Broadsword in shop (ATK +32, ACC -4)
        items = shop.current_items
        broadsword_idx = next(i for i, it in enumerate(items) if it["name"] == "Steel Broadsword")
        shop.active_cursor = broadsword_idx

        eq = shop.get_highlighted_equipment()
        self.assertEqual(eq.name, "Steel Broadsword")

        # Expected deltas for Steve:
        # ATK: 32 - 18 = +14
        # ACC: -4 - 5 = -9
        lines = shop.generate_frame_lines()
        full_text = "\n".join(lines)
        self.assertIn("ATK:\033[1;32m+14\033[0m", full_text)

    # -------------------------------------------------------------------------
    # 4. Purchasing & Selling Mechanics
    # -------------------------------------------------------------------------
    def test_single_purchase_success(self):
        """Verify single item purchase deducts gold, increments inventory, and tracks purchase count."""
        shop = GSEquipShopScreen()
        self.party.gold = 500
        shop.configure_shop(party=self.party, armorer_npc=self.armorer_npc, region_code=1)

        # Highlight Iron Longsword (150 G)
        items = shop.current_items
        sword_idx = next(i for i, it in enumerate(items) if it["name"] == "Iron Longsword")
        shop.active_cursor = sword_idx

        # Buy 1
        shop._buy_item(qty=1)

        self.assertEqual(self.party.gold, 350)
        self.assertEqual(self.party.get_item_count("Iron Longsword"), 1)
        self.assertEqual(shop.items_bought_count, 1)
        self.assertIn("Purchased 1x Iron Longsword", shop.feedback_msg)

    def test_bulk_purchase_success(self):
        """Verify bulk purchase buys specified quantity, multiplies cost, and adds to inventory."""
        shop = GSEquipShopScreen()
        self.party.gold = 1000
        shop.configure_shop(party=self.party, armorer_npc=self.armorer_npc, region_code=1)

        items = shop.current_items
        sword_idx = next(i for i, it in enumerate(items) if it["name"] == "Iron Longsword")
        shop.active_cursor = sword_idx

        # Bulk buy 5x (150 * 5 = 750 G)
        shop._buy_item(qty=5)

        self.assertEqual(self.party.gold, 250)
        self.assertEqual(self.party.get_item_count("Iron Longsword"), 5)
        self.assertEqual(shop.items_bought_count, 5)
        self.assertIn("Purchased 5x Iron Longsword for 750 G", shop.feedback_msg)

    def test_insufficient_gold_purchase_fails(self):
        """Verify buying without sufficient gold fails and leaves party state intact."""
        shop = GSEquipShopScreen()
        self.party.gold = 100
        shop.configure_shop(party=self.party, armorer_npc=self.armorer_npc, region_code=1)

        items = shop.current_items
        sword_idx = next(i for i, it in enumerate(items) if it["name"] == "Iron Longsword")
        shop.active_cursor = sword_idx

        # Attempt to buy (150 G)
        shop._buy_item(qty=1)

        self.assertEqual(self.party.gold, 100)
        self.assertEqual(self.party.get_item_count("Iron Longsword"), 0)
        self.assertEqual(shop.items_bought_count, 0)
        self.assertIn("Not enough gold", shop.feedback_msg)

    def test_sell_equipment_at_twenty_percent(self):
        """Verify selling equipment awards exactly 20% resale value and removes item from inventory."""
        shop = GSEquipShopScreen()
        self.party.gold = 0
        self.party.inventory.clear()
        self.party.add_item("Iron Longsword", qty=2, item_type="equipment")  # Base 150 G -> Sell 30 G
        shop.configure_shop(party=self.party, armorer_npc=self.armorer_npc, region_code=1)

        shop.mode = "SELL"
        items = shop.current_items
        self.assertEqual(len(items), 1)
        self.assertEqual(items[0]["price"], 30)

        # Sell 1
        shop._sell_item(qty=1)

        self.assertEqual(self.party.gold, 30)
        self.assertEqual(self.party.get_item_count("Iron Longsword"), 1)
        self.assertIn("Sold 1x Iron Longsword for 30 G", shop.feedback_msg)

    # -------------------------------------------------------------------------
    # 5. Return Result & Contextual NPC Reactions
    # -------------------------------------------------------------------------
    def test_exit_shop_with_looked_result(self):
        """Verify exiting shop without buying passes 'LOOKED' and Armorer says 'Didn't find what you were looking for?'."""
        screen = GSNoiseMapTestScreen(map_width=54, map_height=24)
        shop = GSEquipShopScreen()
        shop.configure_shop(party=self.party, armorer_npc=self.armorer_npc, noise_map_screen=screen)

        mock_core = MagicMock()
        context = Context()

        # Exit without buying anything (items_bought_count == 0)
        shop._exit_shop(context, mock_core)

        mock_core.game_state.trigger.assert_called_with("ToNoiseMap", context)
        screen.npc_dialog.flush_page()
        self.assertTrue(screen.npc_dialog.is_active)
        self.assertIn("Didn't find what you were looking for? Stop by anytime!", screen.npc_dialog.raw_text)

    def test_exit_shop_with_purchased_result(self):
        """Verify exiting shop after purchasing passes 'PURCHASED' and Armorer thanks player."""
        screen = GSNoiseMapTestScreen(map_width=54, map_height=24)
        shop = GSEquipShopScreen()
        self.party.gold = 500
        shop.configure_shop(party=self.party, armorer_npc=self.armorer_npc, noise_map_screen=screen)

        mock_core = MagicMock()
        context = Context()

        # Buy an item
        shop._buy_item(qty=1)
        self.assertGreater(shop.items_bought_count, 0)

        # Exit shop
        shop._exit_shop(context, mock_core)

        mock_core.game_state.trigger.assert_called_with("ToNoiseMap", context)
        screen.npc_dialog.flush_page()
        self.assertTrue(screen.npc_dialog.is_active)
        self.assertIn("Thank you for your patronage! May that steel keep you safe out there.", screen.npc_dialog.raw_text)

    def test_render_row_coordinate_anchoring_and_no_raw_newlines(self):
        """Verify _render uses coordinate anchoring per row and no raw newlines in raw mode."""
        shop = GSEquipShopScreen()
        shop.configure_shop(party=self.party, armorer_npc=self.armorer_npc)

        written_chunks = []
        with patch("eldoria_py.states.equip_shop.TerminalScreen.write", side_effect=lambda s: written_chunks.append(s)), \
             patch("eldoria_py.states.equip_shop.TerminalScreen.flush"):
            shop._render()

        self.assertGreater(len(written_chunks), 0)
        full_output = "".join(written_chunks)

        # 1. Output must not contain raw newline characters that cause cursor drift in raw mode
        self.assertNotIn("\n", full_output)

        # 2. Must contain coordinate escape sequences for row positioning (1 to 28)
        for r in range(1, 29):
            coord_str = f"\033[{r};1H"
            self.assertIn(coord_str, full_output, f"Missing row coordinate {coord_str}")

        # 3. Must clear buffer tail up to line 45
        self.assertIn("\033[45;1H", full_output)

    def test_transition_from_poi_dialog_clears_keys_and_suppresses_map_render(self):
        """Verify pressing Enter on 'Yes' in Armorer POI dialog triggers transition without collision."""
        screen = GSNoiseMapTestScreen(map_width=54, map_height=24)
        screen.party = self.party
        screen.current_map = Map(width=54, height=24)

        mock_core = MagicMock()
        mock_game_state = MagicMock()
        mock_core.game_state = mock_game_state
        mock_game_state.current_state = screen

        def switch_state(event, ctx):
            mock_game_state.current_state = "GSEquipShopScreen"
        mock_game_state.trigger.side_effect = switch_state

        context = Context()
        keys = [KeyEvent(key=KeyCode.ENTER, char="\r")]
        context.set(SMState.ContextKeysPressed, keys)
        context.set(SMState.ContextEldoriaCore, mock_core)

        # Start POI interaction
        screen._start_npc_dialog(self.armorer_npc)
        screen.npc_dialog.flush_page()
        self.assertTrue(screen.npc_dialog.is_active)

        with patch.object(screen, "_render") as mock_map_render:
            screen.update(context)
            # Map render must be suppressed because state changed to GSEquipShopScreen
            mock_map_render.assert_not_called()

        mock_game_state.trigger.assert_called_with("ToEquipShop", context)
        self.assertEqual(len(keys), 0)

    def test_left_and_right_arrow_keys_switch_mode(self):
        """Verify pressing Left or Right arrow keys switches BUY/SELL modes without throwing exceptions."""
        shop = GSEquipShopScreen()
        shop.configure_shop(party=self.party, armorer_npc=self.armorer_npc)
        self.assertEqual(shop.mode, "BUY")

        context = Context()
        mock_core = MagicMock()

        with patch.object(shop, "_render"):
            # 1. Press Right Arrow -> should switch to SELL mode without exception
            key_right = KeyEvent(key=KeyCode.RIGHT)
            context.set(SMState.ContextKeysPressed, [key_right])
            shop.update(context)
            self.assertEqual(shop.mode, "SELL")
            self.assertIn("SELL", shop.feedback_msg)

            # 2. Press Left Arrow -> should switch to BUY mode without exception
            key_left = KeyEvent(key=KeyCode.LEFT)
            context.set(SMState.ContextKeysPressed, [key_left])
            shop.update(context)
            self.assertEqual(shop.mode, "BUY")
            self.assertIn("BUY", shop.feedback_msg)

            # 3. Press Left Arrow again -> already in BUY mode, remains BUY without error
            context.set(SMState.ContextKeysPressed, [key_left])
            shop.update(context)
            self.assertEqual(shop.mode, "BUY")


if __name__ == "__main__":
    unittest.main()
