"""Unit tests for Eldoria's Inventory Items Subsystem:
- Unified party inventory with 99-stack cap
- Key / Story items retention and non-discardable invariants
- Main Menu item modals (tiered discard, target selection & validation)
- Combat 5-option command menu, item selection, ally/enemy target filtering
- Map POI lock interaction, UIPanel item picker, unlocking & key retention
"""

import random
import unittest
from eldoria_py.core.context import Context
from eldoria_py.terminal.input import KeyEvent, KeyCode
from eldoria_py.combat.stats import StatId, TargetScope, BattleActionType
from eldoria_py.combat.entities import PartyMember, Party, EnemyCombatant, EnemySquad, create_default_party
from eldoria_py.combat.items import (
    ItemType,
    ItemEffectType,
    ConsumableItem,
    ITEM_CATALOG,
    get_item,
    is_key_item,
    can_discard_item,
    apply_item_effect,
)
from eldoria_py.combat.engine import NvNCombatEngine, CombatPhase
from eldoria_py.states.main_menu_screen import GSMainMenuScreen
from eldoria_py.states.combat_screen import GSNvNCombatScreen
from eldoria_py.states.test_noise_map import GSNoiseMapTestScreen
from eldoria_py.procgen.poi import POIDescriptor, POIType


class MockCore:
    def __init__(self):
        self.game_state = MockGameState()


class MockGameState:
    def __init__(self):
        self.states = {}
        self.last_trigger = None

    def trigger(self, event, context):
        self.last_trigger = event


class TestInventorySubsystem(unittest.TestCase):
    def setUp(self):
        self.party = create_default_party()
        self.party.inventory.clear()
        self.context = Context()
        self.mock_core = MockCore()

    def test_party_inventory_99_cap(self):
        """Verifies party inventory enforces strict 99-quantity cap."""
        # Add 60 Potions
        added_1 = self.party.add_item("Potion", 60)
        self.assertEqual(added_1, 60)
        self.assertEqual(self.party.get_item_count("Potion"), 60)

        # Add another 50 Potions (should only add 39 to reach 99)
        added_2 = self.party.add_item("Potion", 50)
        self.assertEqual(added_2, 39)
        self.assertEqual(self.party.get_item_count("Potion"), 99)

        # Attempting to add more when capped adds 0
        added_3 = self.party.add_item("Potion", 5)
        self.assertEqual(added_3, 0)
        self.assertEqual(self.party.get_item_count("Potion"), 99)

    def test_key_items_cannot_be_discarded(self):
        """Verifies that key items are permanently protected against discard."""
        self.party.add_item("Iron Key", 1)
        self.assertFalse(can_discard_item("Iron Key"))

        ok, msg = self.party.discard_item("Iron Key", 1)
        self.assertFalse(ok)
        self.assertIn("cannot be discarded", msg)
        self.assertEqual(self.party.get_item_count("Iron Key"), 1)

    def test_key_items_not_consumed_on_use(self):
        """Verifies that key items are not deducted from inventory when applied."""
        self.party.add_item("Iron Key", 1)
        key_obj = get_item("Iron Key")
        self.assertIsNotNone(key_obj)
        self.assertFalse(key_obj.consumed_on_use)
        self.assertEqual(key_obj.item_type, ItemType.KEY_ITEM)

        # Consumable items ARE consumed
        self.party.add_item("Potion", 3)
        hero = self.party.members[0]
        hero.hp = 100
        ok, msg = apply_item_effect(get_item("Potion"), hero, self.party)
        self.assertTrue(ok)
        self.assertEqual(self.party.get_item_count("Potion"), 2)

    def test_tiered_discard_flow_in_main_menu(self):
        """Tests Main Menu discard modal: Discard 1, Discard Many, Discard All."""
        menu = GSMainMenuScreen()
        menu.configure_menu(party=self.party)
        menu.category_idx = 1  # Items
        menu.focus_mode = "SUBMENU"
        self.party.inventory.clear()
        self.party.add_item("Hi-Potion", 10)

        # 1. Test Discard 1
        # Enter on Hi-Potion -> ACTION_SELECT
        menu._handle_input(KeyEvent(key=KeyCode.ENTER), self.context, self.mock_core)
        self.assertEqual(menu.item_modal_mode, "ACTION_SELECT")

        # Move to Discard (index 1) and press Enter -> enters DISCARD_CHOICE
        menu._handle_input(KeyEvent(key=KeyCode.RIGHT), self.context, self.mock_core)
        menu._handle_input(KeyEvent(key=KeyCode.ENTER), self.context, self.mock_core)
        self.assertEqual(menu.item_modal_mode, "DISCARD_CHOICE")
        self.assertEqual(menu.discard_choice_cursor, 0)  # [Discard 1]

        # Press Enter -> enters DISCARD_CONFIRM with amount 1
        menu._handle_input(KeyEvent(key=KeyCode.ENTER), self.context, self.mock_core)
        self.assertEqual(menu.item_modal_mode, "DISCARD_CONFIRM")
        self.assertEqual(menu.discard_amount, 1)

        # Press 'Y' to confirm discard
        menu._handle_input(KeyEvent(key=KeyCode.CHAR, char="y"), self.context, self.mock_core)
        self.assertEqual(self.party.get_item_count("Hi-Potion"), 9)
        self.assertEqual(menu.focus_mode, "SUBMENU")

        # 2. Test Discard Many (discard 4)
        menu._handle_input(KeyEvent(key=KeyCode.ENTER), self.context, self.mock_core)
        menu._handle_input(KeyEvent(key=KeyCode.RIGHT), self.context, self.mock_core)
        menu._handle_input(KeyEvent(key=KeyCode.ENTER), self.context, self.mock_core)
        self.assertEqual(menu.item_modal_mode, "DISCARD_CHOICE")

        # Select Discard Many (index 1)
        menu._handle_input(KeyEvent(key=KeyCode.RIGHT), self.context, self.mock_core)
        self.assertEqual(menu.discard_choice_cursor, 1)
        menu._handle_input(KeyEvent(key=KeyCode.ENTER), self.context, self.mock_core)
        self.assertEqual(menu.item_modal_mode, "DISCARD_AMOUNT")
        self.assertEqual(menu.discard_amount, 2)

        # Increase amount by 2 (to 4)
        for _ in range(2):
            menu._handle_input(KeyEvent(key=KeyCode.RIGHT), self.context, self.mock_core)
        self.assertEqual(menu.discard_amount, 4)

        # Press Enter -> enters DISCARD_CONFIRM
        menu._handle_input(KeyEvent(key=KeyCode.ENTER), self.context, self.mock_core)
        self.assertEqual(menu.item_modal_mode, "DISCARD_CONFIRM")
        self.assertEqual(menu.discard_amount, 4)

        # Press 'Y' to confirm discard
        menu._handle_input(KeyEvent(key=KeyCode.CHAR, char="y"), self.context, self.mock_core)
        self.assertEqual(self.party.get_item_count("Hi-Potion"), 5)

        # 3. Test Discard All (discard remaining 5)
        menu._handle_input(KeyEvent(key=KeyCode.ENTER), self.context, self.mock_core)
        menu._handle_input(KeyEvent(key=KeyCode.RIGHT), self.context, self.mock_core)
        menu._handle_input(KeyEvent(key=KeyCode.ENTER), self.context, self.mock_core)
        self.assertEqual(menu.item_modal_mode, "DISCARD_CHOICE")

        # Select Discard All (index 2)
        menu._handle_input(KeyEvent(key=KeyCode.RIGHT), self.context, self.mock_core)
        menu._handle_input(KeyEvent(key=KeyCode.RIGHT), self.context, self.mock_core)
        self.assertEqual(menu.discard_choice_cursor, 2)
        menu._handle_input(KeyEvent(key=KeyCode.ENTER), self.context, self.mock_core)
        self.assertEqual(menu.item_modal_mode, "DISCARD_CONFIRM")
        self.assertEqual(menu.discard_amount, 5)

        # Press 'Y' to confirm discard
        menu._handle_input(KeyEvent(key=KeyCode.CHAR, char="y"), self.context, self.mock_core)
        self.assertEqual(self.party.get_item_count("Hi-Potion"), 0)

    def test_key_item_modal_has_no_discard_option(self):
        """Verifies that key items only present 'Use Item' and 'Cancel' options."""
        menu = GSMainMenuScreen()
        menu.configure_menu(party=self.party)
        menu.category_idx = 1
        menu.focus_mode = "SUBMENU"
        self.party.inventory.clear()
        self.party.add_item("Ancient Crest", 1)

        # Enter on Ancient Crest -> ACTION_SELECT
        menu._handle_input(KeyEvent(key=KeyCode.ENTER), self.context, self.mock_core)
        self.assertEqual(menu.item_modal_mode, "ACTION_SELECT")

        # Moving right goes directly to Cancel (no Discard option available)
        menu._handle_input(KeyEvent(key=KeyCode.RIGHT), self.context, self.mock_core)
        self.assertEqual(menu.item_action_cursor, 1)

        # Pressing Enter selects Cancel and returns to SUBMENU
        menu._handle_input(KeyEvent(key=KeyCode.ENTER), self.context, self.mock_core)
        self.assertEqual(menu.focus_mode, "SUBMENU")
        self.assertEqual(menu.item_modal_mode, "NONE")

    def test_main_menu_item_target_validation(self):
        """Verifies contextual target eligibility checks (KO ally, full HP/MP ally, Revive Herb)."""
        menu = GSMainMenuScreen()
        menu.configure_menu(party=self.party)
        menu.category_idx = 1
        menu.focus_mode = "SUBMENU"
        self.party.inventory.clear()
        self.party.add_item("Potion", 2)
        self.party.add_item("Revive Herb", 2)

        hero = self.party.members[0]
        ally = self.party.members[1]

        # Case 1: Potion on fully healed hero should be rejected
        hero.hp = hero.max_hp
        menu.item_cursor = 0  # Potion
        menu._handle_input(KeyEvent(key=KeyCode.ENTER), self.context, self.mock_core)
        menu._handle_input(KeyEvent(key=KeyCode.ENTER), self.context, self.mock_core)
        self.assertEqual(menu.item_modal_mode, "TARGET_SELECT")
        menu.item_target_cursor = 0  # Hero (full HP)
        menu._handle_input(KeyEvent(key=KeyCode.ENTER), self.context, self.mock_core)
        self.assertIn("already at full HP", menu.banner_message)
        self.assertEqual(self.party.get_item_count("Potion"), 2)

        # Case 2: Potion on KO'd ally should be rejected
        ally.hp = 0
        menu.item_target_cursor = 1  # Ally (KO'd)
        menu._handle_input(KeyEvent(key=KeyCode.ENTER), self.context, self.mock_core)
        self.assertIn("fallen", menu.banner_message)
        self.assertEqual(self.party.get_item_count("Potion"), 2)

        # Cancel out of Potion
        menu._handle_input(KeyEvent(key=KeyCode.ESCAPE), self.context, self.mock_core)
        menu._handle_input(KeyEvent(key=KeyCode.ESCAPE), self.context, self.mock_core)

        # Case 3: Revive Herb on living hero should be rejected
        menu.item_cursor = 1  # Revive Herb
        menu._handle_input(KeyEvent(key=KeyCode.ENTER), self.context, self.mock_core)
        menu._handle_input(KeyEvent(key=KeyCode.ENTER), self.context, self.mock_core)
        self.assertEqual(menu.item_modal_mode, "TARGET_SELECT")
        menu.item_target_cursor = 0  # Hero (alive)
        menu._handle_input(KeyEvent(key=KeyCode.ENTER), self.context, self.mock_core)
        self.assertIn("already alive", menu.banner_message)
        self.assertEqual(self.party.get_item_count("Revive Herb"), 2)

        # Case 4: Revive Herb on KO'd ally succeeds!
        menu.item_target_cursor = 1  # Ally (KO'd)
        menu._handle_input(KeyEvent(key=KeyCode.ENTER), self.context, self.mock_core)
        self.assertTrue(ally.is_alive)
        self.assertGreater(ally.hp, 0)
        self.assertEqual(self.party.get_item_count("Revive Herb"), 1)
        self.assertEqual(menu.focus_mode, "SUBMENU")

    def test_combat_5_option_command_menu_and_item_use(self):
        """Verifies combat 5-option command menu, [Item] selection, and round execution."""
        combat_screen = GSNvNCombatScreen()
        enemy = EnemyCombatant(
            name="Goblin Scout",
            level=2,
            affinity=BattleActionType.ELEMENTAL_EARTH,
            stats={
                StatId.HIT_POINTS: 100,
                StatId.MAGIC_POINTS: 20,
                StatId.ATTACK: 15,
                StatId.DEFENSE: 10,
                StatId.MAGIC_ATTACK: 5,
                StatId.MAGIC_DEFENSE: 10,
                StatId.SPEED: 10,
                StatId.LUCK: 5,
                StatId.ACCURACY: 90,
            },
        )
        squad = EnemySquad([enemy])
        self.party.inventory.clear()
        self.party.add_item("Potion", 2)
        self.party.add_item("Bomb", 2)

        hero = self.party.members[0]
        hero.hp = 100  # Damaged hero

        combat_screen.start_encounter(self.party, squad)

        # 1. Use friendly Potion targeting Hero
        # Move cursor to 'Item' (index 3)
        combat_screen.main_menu_cursor = 3
        combat_screen._activate_main_menu_selection()
        self.assertEqual(combat_screen.menu_mode, "ITEMS")

        # Select Potion (index 0)
        items = combat_screen._get_battle_items()
        self.assertEqual(len(items), 2)
        combat_screen.sub_menu_cursor = 0
        combat_screen._choose_item_action(items[0][0])
        self.assertEqual(combat_screen.menu_mode, "TARGET_SELECT")
        self.assertEqual(combat_screen.target_type, "ALLY")

        # Confirm target (Hero)
        combat_screen.target_cursor = 0
        combat_screen._confirm_target_selection()
        self.assertIsNotNone(combat_screen.engine.planned_actions.get(0))
        queued = combat_screen.engine.planned_actions[0]
        self.assertEqual(queued.action.name, "Potion")

        # 2. Complete turn planning for remaining 4 heroes with Defend
        for _ in range(4):
            combat_screen.main_menu_cursor = 4  # Defend
            combat_screen._activate_main_menu_selection()

        # All 5 party members have chosen actions -> transition to EXECUTION_PHASE
        self.assertEqual(combat_screen.engine.phase, CombatPhase.EXECUTION_PHASE)

        # Step execution to resolve round
        guard = 0
        while combat_screen.engine.phase == CombatPhase.EXECUTION_PHASE:
            guard += 1
            if guard > 100:
                self.fail("Infinite loop in combat execution phase")
            combat_screen.engine.step_execution()
        # Hero should have recovered HP and 1 Potion was consumed
        self.assertGreater(hero.hp, 100)
        self.assertEqual(self.party.get_item_count("Potion"), 1)

    def test_combat_offensive_item_targets_enemy(self):
        """Verifies offensive combat item (Bomb) targets enemy and deals damage."""
        combat_screen = GSNvNCombatScreen()
        enemy = EnemyCombatant(
            name="Forest Troll",
            level=3,
            affinity=BattleActionType.ELEMENTAL_EARTH,
            stats={
                StatId.HIT_POINTS: 150,
                StatId.MAGIC_POINTS: 20,
                StatId.ATTACK: 20,
                StatId.DEFENSE: 10,
                StatId.MAGIC_ATTACK: 5,
                StatId.MAGIC_DEFENSE: 10,
                StatId.SPEED: 5,
                StatId.LUCK: 5,
                StatId.ACCURACY: 90,
            },
        )
        squad = EnemySquad([enemy])
        self.party.inventory.clear()
        self.party.add_item("Bomb", 3)

        combat_screen.start_encounter(self.party, squad)

        # Choose Bomb
        combat_screen.main_menu_cursor = 3  # Item
        combat_screen._activate_main_menu_selection()
        self.assertEqual(combat_screen.menu_mode, "ITEMS")

        # Bomb is the only item
        items = combat_screen._get_battle_items()
        self.assertEqual(len(items), 1)
        combat_screen._choose_item_action(items[0][0])
        self.assertEqual(combat_screen.menu_mode, "TARGET_SELECT")
        self.assertEqual(combat_screen.target_type, "ENEMY")

        # Confirm target (Enemy)
        combat_screen.target_cursor = 0
        combat_screen._confirm_target_selection()

        # Other 4 party members defend
        for _ in range(4):
            combat_screen.main_menu_cursor = 4
            combat_screen._activate_main_menu_selection()

        # Execute round
        initial_enemy_hp = enemy.hp
        guard = 0
        while combat_screen.engine.phase == CombatPhase.EXECUTION_PHASE:
            guard += 1
            if guard > 100:
                self.fail("Infinite loop in combat execution phase")
            combat_screen.engine.step_execution()

        # Enemy took damage from Bomb and 1 Bomb was consumed
        self.assertLess(enemy.hp, initial_enemy_hp)
        self.assertEqual(self.party.get_item_count("Bomb"), 2)

    def test_locked_poi_interaction_and_item_picker_unlock(self):
        """Verifies locked POI prompts item picker, unlocks on correct key, and retains key."""
        screen = GSNoiseMapTestScreen(map_width=54, map_height=24)
        screen.party = self.party
        self.party.inventory.clear()

        locked_cave = POIDescriptor(
            poi_type=POIType.CAVE,
            name="Ancient Sanctum",
            glyph="∩",
            fg_color=None,
            bg_color=None,
            sector_coord=(0, 0),
            local_pos=(10, 10),
            spawn_pos=(10, 10),
            is_locked=True,
            required_key="Ancient Crest",
            unlock_msg="The ancient seal dissipates!",
        )

        # Place locked POI on current tile
        curr_tile = screen._current_map().tiles[screen.player_y][screen.player_x]
        from eldoria_py.procgen.poi import WarpTarget
        curr_tile.warp_target = WarpTarget(target_map_name="Ancient Sanctum", prompt_label="Ancient Sanctum")
        curr_tile.poi = locked_cave

        # 1. Interact without keys -> feedback that entrance is locked
        screen._handle_interact()
        self.assertFalse(screen.is_item_picker_active)
        self.assertIn("Locked! Entrance requires Ancient Crest", screen.last_status_msg)

        # 2. Add correct key item to party inventory
        self.party.add_item("Ancient Crest", 1)
        self.assertEqual(self.party.get_item_count("Ancient Crest"), 1)

        # 3. Interact with key in inventory -> activates Item Picker modal
        screen._handle_interact()
        self.assertTrue(screen.is_item_picker_active)
        self.assertEqual(screen.locked_poi_target, locked_cave)

        # 4. Press Enter on Item Picker cursor -> unlocks POI without consuming key item
        ctx = Context()
        ctx.set(GSNoiseMapTestScreen.ContextKeysPressed, [KeyEvent(key=KeyCode.ENTER)])
        screen.update(ctx)

        self.assertFalse(screen.is_item_picker_active)
        self.assertFalse(locked_cave.is_locked)
        self.assertIn("Used Ancient Crest", screen.last_status_msg)
        self.assertIn("The ancient seal dissipates!", screen.last_status_msg)
        # CRITICAL: Key item is NOT consumed
        self.assertEqual(self.party.get_item_count("Ancient Crest"), 1)

    def test_rpg_item_catalog_set(self):
        """Verifies typical RPG items set: Potion, Ether, Door Key, Chest Key, Golden Key, Poison Bottle."""
        # 1. Potion
        potion = get_item("Potion")
        self.assertIsNotNone(potion)
        self.assertEqual(potion.item_type, ItemType.CONSUMABLE)
        self.assertEqual(potion.effect_type, ItemEffectType.RESTORE_HP)
        self.assertTrue(potion.usable_in_field)
        self.assertTrue(potion.usable_in_battle)

        # 2. Ether
        ether = get_item("Ether")
        self.assertIsNotNone(ether)
        self.assertEqual(ether.item_type, ItemType.CONSUMABLE)
        self.assertEqual(ether.effect_type, ItemEffectType.RESTORE_MP)
        self.assertTrue(ether.usable_in_field)
        self.assertTrue(ether.usable_in_battle)

        # 3. Door Key
        door_key = get_item("Door Key")
        self.assertIsNotNone(door_key)
        self.assertEqual(door_key.item_type, ItemType.KEY_ITEM)
        self.assertFalse(door_key.can_discard)
        self.assertFalse(door_key.consumed_on_use)
        self.assertEqual(door_key.target_scope, TargetScope.NONE)

        # 4. Chest Key
        chest_key = get_item("Chest Key")
        self.assertIsNotNone(chest_key)
        self.assertEqual(chest_key.item_type, ItemType.KEY_ITEM)
        self.assertFalse(chest_key.can_discard)
        self.assertFalse(chest_key.consumed_on_use)
        self.assertEqual(chest_key.target_scope, TargetScope.NONE)

        # 5. Golden Key
        golden_key = get_item("Golden Key")
        self.assertIsNotNone(golden_key)
        self.assertEqual(golden_key.item_type, ItemType.KEY_ITEM)
        self.assertFalse(golden_key.can_discard)
        self.assertFalse(golden_key.consumed_on_use)
        self.assertEqual(golden_key.target_scope, TargetScope.NONE)

        # 6. Poison Bottle
        poison = get_item("Poison Bottle")
        self.assertIsNotNone(poison)
        self.assertEqual(poison.item_type, ItemType.CONSUMABLE)
        self.assertEqual(poison.effect_type, ItemEffectType.STATUS_EFFECT)
        self.assertEqual(poison.target_scope, TargetScope.SINGLE_ENEMY)
        self.assertTrue(poison.usable_in_battle)
        self.assertFalse(poison.usable_in_field)
        self.assertTrue(poison.can_discard)

        # Compatibility aliases
        self.assertIs(get_item("door_key"), door_key)
        self.assertIs(get_item("chest_key"), chest_key)
        self.assertIs(get_item("golden_key"), golden_key)
        self.assertIs(get_item("poison_bottle"), poison)

    def test_hidden_dev_cheat_key_in_inventory_menu(self):
        """Verifies hidden dev key ('+', '9', 'C') fills inventory with 99 of each item."""
        menu = GSMainMenuScreen()
        menu.configure_menu(party=self.party)
        menu.category_idx = 1  # Items
        menu.focus_mode = "SUBMENU"
        self.party.inventory.clear()
        self.assertEqual(len(self.party.inventory), 0)

        # Press '+' hidden cheat key
        menu._handle_input(KeyEvent(key=KeyCode.CHAR, char="+"), self.context, self.mock_core)

        # Banner feedback confirms cheat activation
        self.assertIn("DEV CHEAT", menu.banner_message)
        self.assertIn("Stocked 99x", menu.banner_message)

        # Check all required items are present at 99
        self.assertEqual(self.party.get_item_count("Potion"), 99)
        self.assertEqual(self.party.get_item_count("Ether"), 99)
        self.assertEqual(self.party.get_item_count("Door Key"), 99)
        self.assertEqual(self.party.get_item_count("Chest Key"), 99)
        self.assertEqual(self.party.get_item_count("Golden Key"), 99)
        self.assertEqual(self.party.get_item_count("Poison Bottle"), 99)

        # Verify key items retained non-discardable status
        self.assertFalse(can_discard_item("Door Key"))
        self.assertFalse(can_discard_item("Chest Key"))
        self.assertFalse(can_discard_item("Golden Key"))

    def test_hidden_dev_cheat_key_from_categories_focus(self):
        """Verifies dev cheat key also activates when highlighting Items in CATEGORIES focus."""
        menu = GSMainMenuScreen()
        menu.configure_menu(party=self.party)
        menu.category_idx = 1  # Items
        menu.focus_mode = "CATEGORIES"
        self.party.inventory.clear()

        # Press 'C' cheat key
        menu._handle_input(KeyEvent(key=KeyCode.CHAR, char="c"), self.context, self.mock_core)

        self.assertIn("DEV CHEAT", menu.banner_message)
        self.assertEqual(self.party.get_item_count("Potion"), 99)
        self.assertEqual(self.party.get_item_count("Golden Key"), 99)

    def test_item_inventory_current_line_highlight(self):
        """Verifies that the item inventory highlights the current line the chevron is on."""
        from eldoria_py.states.main_menu_screen import visible_width, strip_ansi
        menu = GSMainMenuScreen()
        menu.configure_menu(party=self.party)
        menu.category_idx = 1  # Items
        menu.focus_mode = "SUBMENU"
        self.party.inventory.clear()
        self.party.add_item("Potion", 10)
        self.party.add_item("Ether", 5)

        bg_code = "\033[48;2;25;55;85m"

        # Cursor on Potion (index 0)
        menu.item_cursor = 0
        lines = menu._render_items_submenu()
        # Row 0: Category, Row 1: Divider, Row 2: first item (Potion), Row 3: second item (Ether)
        potion_line = lines[2]
        ether_line = lines[3]

        self.assertIn("Potion", potion_line)
        self.assertIn("Ether", ether_line)
        self.assertIn(bg_code, potion_line)
        self.assertIn("❱", potion_line)
        self.assertEqual(visible_width(potion_line), 55)

        self.assertNotIn(bg_code, ether_line)
        self.assertNotIn("❱", ether_line)

        # Move cursor to Ether (index 1)
        menu.item_cursor = 1
        lines = menu._render_items_submenu()
        potion_line_after = lines[2]
        ether_line_after = lines[3]

        self.assertNotIn(bg_code, potion_line_after)
        self.assertNotIn("❱", potion_line_after)

        self.assertIn(bg_code, ether_line_after)
        self.assertIn("❱", ether_line_after)
        self.assertEqual(visible_width(ether_line_after), 55)

    def test_combat_item_selection_paged_mode_and_chevron_visibility(self):
        """Verifies combat items list pages properly, keeps chevron visible, and navigates pages."""
        from eldoria_py.states.main_menu_screen import visible_width, strip_ansi
        combat_screen = GSNvNCombatScreen()
        enemy = EnemyCombatant(
            name="Goblin",
            level=1,
            affinity=BattleActionType.ELEMENTAL_EARTH,
            stats={StatId.HIT_POINTS: 100, StatId.MAGIC_POINTS: 20, StatId.ATTACK: 10, StatId.DEFENSE: 10, StatId.MAGIC_ATTACK: 5, StatId.MAGIC_DEFENSE: 5, StatId.SPEED: 10, StatId.LUCK: 5, StatId.ACCURACY: 90},
        )
        squad = EnemySquad([enemy])

        # Add 9 different battle-usable items to party
        self.party.inventory.clear()
        self.party.add_item("Potion", 10)
        self.party.add_item("Hi-Potion", 5)
        self.party.add_item("Ether", 5)
        self.party.add_item("Hi-Ether", 3)
        self.party.add_item("Elixir", 2)
        self.party.add_item("Revive Herb", 4)
        self.party.add_item("Antidote", 10)
        self.party.add_item("Bomb", 2)
        self.party.add_item("Poison Bottle", 5)

        combat_screen.start_encounter(self.party, squad)
        combat_screen.menu_mode = "ITEMS"
        combat_screen.sub_menu_cursor = 0

        # Page 1: Header shows [1/2]
        hdr = combat_screen._format_command_cell(0)
        self.assertIn("[1/2]", hdr)
        self.assertEqual(visible_width(hdr), 24)

        # Slot 0 (Row 1): Potion has chevron
        row1 = combat_screen._format_command_cell(1)
        self.assertIn("Potion", row1)
        self.assertIn("❱", row1)
        self.assertEqual(visible_width(row1), 24)

        # Row 7: Footer shows Page indicator
        row7 = combat_screen._format_command_cell(7)
        self.assertIn("P.1/2", row7)
        self.assertEqual(visible_width(row7), 24)

        # Move cursor to item 6 (Antidote on page 2)
        combat_screen.sub_menu_cursor = 6
        hdr2 = combat_screen._format_command_cell(0)
        self.assertIn("[2/2]", hdr2)

        # On Page 2, Slot 0 (Row 1) must show Antidote AND have the chevron!
        row1_p2 = combat_screen._format_command_cell(1)
        self.assertIn("Antidote", row1_p2)
        self.assertIn("❱", row1_p2)
        self.assertEqual(visible_width(row1_p2), 24)

        # Test Right Arrow input pages forward
        combat_screen.sub_menu_cursor = 0  # Page 1
        combat_screen._handle_sub_menu_input(KeyEvent(key=KeyCode.RIGHT))
        self.assertEqual(combat_screen.sub_menu_cursor, 6)  # Flips to Page 2

        # Test Left Arrow input pages back
        combat_screen._handle_sub_menu_input(KeyEvent(key=KeyCode.LEFT))
        self.assertEqual(combat_screen.sub_menu_cursor, 0)  # Flips back to Page 1

        # Number keys are ignored in the command window:
        combat_screen.sub_menu_cursor = 6
        combat_screen._handle_sub_menu_input(KeyEvent(key=KeyCode.CHAR, char="2"))
        self.assertEqual(combat_screen.menu_mode, "ITEMS")

        # Down arrow navigates to item 7: Bomb, and Enter selects it
        combat_screen._handle_sub_menu_input(KeyEvent(key=KeyCode.DOWN))
        self.assertEqual(combat_screen.sub_menu_cursor, 7)
        combat_screen._handle_sub_menu_input(KeyEvent(key=KeyCode.ENTER))
        self.assertEqual(combat_screen.menu_mode, "TARGET_SELECT")
        self.assertIsNotNone(combat_screen.selected_action)
        self.assertEqual(combat_screen.selected_action.name, "Bomb")

    def test_combat_escape_key_unwinds_menu_stack(self):
        """Verifies Escape key unwinds TARGET_SELECT -> ITEMS -> MAIN, and flees only from MAIN."""
        from eldoria_py.core.fsm import SMStateMachine, SMTransition
        from eldoria_py.states.test_noise_map import GSNoiseMapTestScreen

        noise_screen = GSNoiseMapTestScreen()
        combat_screen = GSNvNCombatScreen()
        fsm = SMStateMachine("GSNvNCombatScreen")
        fsm.add_state(noise_screen)
        fsm.add_state(combat_screen)
        fsm.add_transition(SMTransition("GSNvNCombatScreen", "FromCombat", "GSNoiseMapTestScreen"))

        class MockCore:
            def __init__(self, game_state):
                self.game_state = game_state

        mock_core = MockCore(fsm)

        self.party.inventory.clear()
        self.party.add_item("Potion", 5)
        enemy = EnemyCombatant(
            name="Goblin",
            level=1,
            affinity=BattleActionType.ELEMENTAL_EARTH,
            stats={StatId.HIT_POINTS: 100, StatId.MAGIC_POINTS: 20, StatId.ATTACK: 10, StatId.DEFENSE: 10, StatId.MAGIC_ATTACK: 5, StatId.MAGIC_DEFENSE: 5, StatId.SPEED: 10, StatId.LUCK: 5, StatId.ACCURACY: 90},
        )
        squad = EnemySquad([enemy])
        combat_screen.start_encounter(self.party, squad)

        # 1. Enter ITEMS menu
        combat_screen.menu_mode = "ITEMS"
        # Press [Esc] in ITEMS -> should return to MAIN, NOT flee
        ctx = Context([0.016, [KeyEvent(key=KeyCode.ESCAPE)], mock_core])
        combat_screen.update(ctx)
        self.assertEqual(combat_screen.menu_mode, "MAIN")
        self.assertEqual(fsm.current_state, "GSNvNCombatScreen")

        # 2. Select Potion -> enters TARGET_SELECT
        combat_screen.menu_mode = "ITEMS"
        combat_screen._choose_item_action(combat_screen._get_battle_items()[0][0])
        self.assertEqual(combat_screen.menu_mode, "TARGET_SELECT")

        # Press [Esc] in TARGET_SELECT -> should return to ITEMS, NOT flee
        ctx = Context([0.016, [KeyEvent(key=KeyCode.ESCAPE)], mock_core])
        combat_screen.update(ctx)
        self.assertEqual(combat_screen.menu_mode, "ITEMS")
        self.assertEqual(fsm.current_state, "GSNvNCombatScreen")

        # Press [Esc] in ITEMS -> returns to MAIN
        ctx = Context([0.016, [KeyEvent(key=KeyCode.ESCAPE)], mock_core])
        combat_screen.update(ctx)
        self.assertEqual(combat_screen.menu_mode, "MAIN")
        self.assertEqual(fsm.current_state, "GSNvNCombatScreen")

        # 3. Press [Esc] in MAIN -> flees battle (transitions to FromCombat)
        ctx = Context([0.016, [KeyEvent(key=KeyCode.ESCAPE)], mock_core])
        combat_screen.update(ctx)
        self.assertEqual(fsm.current_state, "GSNoiseMapTestScreen")

    def test_fire_flask_to_battle_action_and_combat_selection(self):
        """Verifies Fire Flask converts to ELEMENTAL_FIRE BattleAction and can be selected without crashing."""
        fire_flask = ITEM_CATALOG["Fire Flask"]
        battle_act = fire_flask.to_battle_action()
        self.assertEqual(battle_act.action_type, BattleActionType.ELEMENTAL_FIRE)
        self.assertEqual(battle_act.target_scope, TargetScope.ALL_ENEMIES)

        combat_screen = GSNvNCombatScreen()
        self.party.inventory.clear()
        # Add items to force 2 pages
        all_item_names = ["Potion", "Hi-Potion", "Ether", "Hi-Ether", "Elixir", "Revive Herb", "Bomb", "Fire Flask"]
        for name in all_item_names:
            self.party.add_item(name, 5)

        enemy = EnemyCombatant(
            name="Ice Bat",
            level=1,
            affinity=BattleActionType.ELEMENTAL_ICE,
            stats={StatId.HIT_POINTS: 100, StatId.MAGIC_POINTS: 20, StatId.ATTACK: 10, StatId.DEFENSE: 10, StatId.MAGIC_ATTACK: 5, StatId.MAGIC_DEFENSE: 5, StatId.SPEED: 10, StatId.LUCK: 5, StatId.ACCURACY: 90},
        )
        combat_screen.start_encounter(self.party, EnemySquad([enemy]))

        # Enter ITEMS mode
        combat_screen.menu_mode = "ITEMS"
        # Page right to page 2 (Fire Flask is slot 1 on page 2: index 7)
        combat_screen._handle_sub_menu_input(KeyEvent(key=KeyCode.RIGHT))
        # Move down to Fire Flask (index 7)
        combat_screen._handle_sub_menu_input(KeyEvent(key=KeyCode.DOWN))
        self.assertEqual(combat_screen.sub_menu_cursor, 7)
        cur_item, _ = combat_screen._get_battle_items()[combat_screen.sub_menu_cursor]
        self.assertEqual(cur_item.name, "Fire Flask")

        # Press ENTER: Should plan action for active hero and advance to next member without crashing!
        combat_screen._handle_sub_menu_input(KeyEvent(key=KeyCode.ENTER))
        # Since Fire Flask targets ALL_ENEMIES, it automatically plans action and advances
        self.assertIn(0, combat_screen.engine.planned_actions)
        planned = combat_screen.engine.planned_actions[0]
        self.assertEqual(planned.action.name, "Fire Flask")
        self.assertEqual(planned.action.action_type, BattleActionType.ELEMENTAL_FIRE)
        self.assertEqual(combat_screen.active_member_idx, 1)

    def test_fire_flask_execution_in_combat_engine(self):
        """Verifies Fire Flask deals elemental fire damage to all alive enemies and consumes 1 item."""
        combat_screen = GSNvNCombatScreen()
        hero = self.party.members[0]
        test_party = Party([hero])
        test_party.inventory.clear()
        test_party.add_item("Fire Flask", 3)

        e1 = EnemyCombatant(name="Ice Bat A", level=1, affinity=BattleActionType.ELEMENTAL_ICE, stats={StatId.HIT_POINTS: 100, StatId.MAGIC_POINTS: 20, StatId.ATTACK: 10, StatId.DEFENSE: 10, StatId.MAGIC_ATTACK: 5, StatId.MAGIC_DEFENSE: 5, StatId.SPEED: 10, StatId.LUCK: 5, StatId.ACCURACY: 90})
        e2 = EnemyCombatant(name="Ice Bat B", level=1, affinity=BattleActionType.ELEMENTAL_ICE, stats={StatId.HIT_POINTS: 100, StatId.MAGIC_POINTS: 20, StatId.ATTACK: 10, StatId.DEFENSE: 10, StatId.MAGIC_ATTACK: 5, StatId.MAGIC_DEFENSE: 5, StatId.SPEED: 10, StatId.LUCK: 5, StatId.ACCURACY: 90})
        combat_screen.start_encounter(test_party, EnemySquad([e1, e2]))
        combat_screen.engine.rng = random.Random(42)

        fire_flask = ITEM_CATALOG["Fire Flask"]
        action = fire_flask.to_battle_action()
        combat_screen.engine.plan_member_action(0, action, e1)
        self.assertTrue(combat_screen.engine.finalize_planning())

        # Execute actions until hero 0 acts
        guard = 0
        while combat_screen.engine.phase == CombatPhase.EXECUTION_PHASE:
            guard += 1
            if guard > 100:
                self.fail("Infinite loop in combat execution phase")
            act = combat_screen.engine.step_execution()
            if act and act.actor == hero:
                break

        self.assertEqual(test_party.get_item_count("Fire Flask"), 2)
        self.assertLess(e1.hp, 100)
        self.assertLess(e2.hp, 100)
        self.assertTrue(any("Fire Flask" in log and "Ice Bat" in log for log in combat_screen.engine.combat_log))

    def test_ether_combat_execution_restores_mp(self):
        """Verifies Ether restores MP in combat instead of dealing damage."""
        combat_screen = GSNvNCombatScreen()
        hero = self.party.members[1]  # Lyra (Mage, max_mp=75)
        hero.stats[StatId.MAGIC_POINTS].current = 10
        self.assertEqual(hero.mp, 10)

        test_party = Party([hero])
        test_party.inventory.clear()
        test_party.add_item("Ether", 3)

        enemy = EnemyCombatant(name="Goblin", level=1, stats={StatId.HIT_POINTS: 100, StatId.MAGIC_POINTS: 20, StatId.ATTACK: 10, StatId.DEFENSE: 10, StatId.MAGIC_ATTACK: 5, StatId.MAGIC_DEFENSE: 5, StatId.SPEED: 10, StatId.LUCK: 5, StatId.ACCURACY: 90})
        combat_screen.start_encounter(test_party, EnemySquad([enemy]))

        ether = ITEM_CATALOG["Ether"]
        action = ether.to_battle_action()
        combat_screen.engine.plan_member_action(0, action, hero)
        self.assertTrue(combat_screen.engine.finalize_planning())

        guard = 0
        while combat_screen.engine.phase == CombatPhase.EXECUTION_PHASE:
            guard += 1
            if guard > 100:
                self.fail("Infinite loop in combat execution phase")
            act = combat_screen.engine.step_execution()
            if act and act.actor == hero:
                break

        self.assertEqual(test_party.get_item_count("Ether"), 2)
        self.assertGreater(hero.mp, 10)
        self.assertTrue(any("uses Ether on" in log and "+40 MP" in log for log in combat_screen.engine.combat_log))


if __name__ == "__main__":
    unittest.main()



