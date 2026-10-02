"""
GSMainMenuScreen: Unified party management and pause menu subsystem for Eldoria.
Utilizes an 80x40 canvas with strict mathematical column budgets:
- Left rail: strictly 22 inner columns (persistent 5-hero vitals, telemetry, category selector)
- Center divider: 1 column
- Right pane: strictly 55 inner columns (Status, Items, Equipment, Magic, Save, Quit)
- Status bar: Row 40
Zero text overflow beyond borders.
"""
from __future__ import annotations
import math
from typing import List, Optional, Tuple, Any

from ..core.context import Context
from ..core.fsm import SMState
from ..terminal.ansi import ATCoordinates, ATControlSequences
from ..terminal.color import TrueColor, ColorLibrary
from ..terminal.input import KeyCode, KeyEvent
from ..terminal.screen import TerminalScreen
from ..terminal.box import clear_buffer_tail, strip_ansi, truncate_ansi, visible_width, wrap_text
from ..ui.panel import UIPanel
from ..ui.container import UIContainer, WindowBorderPart
from ..ui.elements.label import UILabel
from ..ui.elements.stat_bar import UIStatBar, StatBarType, StatNumberState
from ..combat.stats import StatId, EquipmentSlot, TargetScope, format_element_badge, BattleEntityProperty
from ..combat.actions import BattleAction, ActionCategory, ACTIONS
from ..combat.equipment import BattleEquipment, EQUIPMENT_CATALOG
from ..combat.entities import PartyMember, Party, create_default_party
from ..combat.items import (
    ConsumableItem,
    ItemType,
    ItemEffectType,
    ITEM_CATALOG,
    get_item,
    apply_item_effect,
    is_key_item,
    can_discard_item,
)
from ..core.save_manager import SaveManager, SaveSlotHeader


def _pad_cell(text: str, width: int, align: str = "left", fill_char: str = " ") -> str:
    """Formats text to exactly width visible characters, strictly truncating and padding."""
    vlen = visible_width(text)
    if vlen > width:
        text = truncate_ansi(text, width)
        vlen = visible_width(text)
    rem = max(0, width - vlen)
    if align == "right":
        return fill_char * rem + text
    elif align == "center":
        left = rem // 2
        right = rem - left
        return fill_char * left + text + fill_char * right
    else:
        return text + fill_char * rem


def _make_bar(
    current: int,
    maximum: int,
    length: int = 8,
    bar_type: Union[StatBarType, str] = StatBarType.HEALTH,
) -> str:
    """Creates a visual bracketed bar using UIStatBar with colored stage indicators: [████░░░░]."""
    return UIStatBar.format_bar(current, maximum, length=length, bar_type=bar_type)


def _format_time(total_seconds: int) -> str:
    hrs = total_seconds // 3600
    mins = (total_seconds % 3600) // 60
    secs = total_seconds % 60
    return f"{hrs:02d}:{mins:02d}:{secs:02d}"


class GSMainMenuScreen(SMState):
    """80x40 Full-Featured Party Management and Pause Menu Screen."""

    TOTAL_WIDTH: int = 80
    LEFT_WIDTH: int = 22
    RIGHT_WIDTH: int = 55
    TOTAL_ROWS: int = 40

    CATEGORIES = ["Status", "Items", "Equipment", "Magic", "Quests", "Save", "Quit"]

    EQUIP_SLOTS: list[EquipmentSlot] = [
        EquipmentSlot.WEAPON,
        EquipmentSlot.HELMET,
        EquipmentSlot.ARMOR,
        EquipmentSlot.PAULDRON,
        EquipmentSlot.GAUNTLETS,
        EquipmentSlot.GREAVES,
        EquipmentSlot.BOOTS,
        EquipmentSlot.JEWELRY_A,
        EquipmentSlot.JEWELRY_B,
        EquipmentSlot.CAPE,
    ]

    SLOT_NAMES: dict[EquipmentSlot, str] = {
        EquipmentSlot.WEAPON: "Weapon",
        EquipmentSlot.HELMET: "Helmet",
        EquipmentSlot.ARMOR: "Armor",
        EquipmentSlot.PAULDRON: "Pauldron",
        EquipmentSlot.GAUNTLETS: "Gauntlets",
        EquipmentSlot.GREAVES: "Greaves",
        EquipmentSlot.BOOTS: "Boots",
        EquipmentSlot.JEWELRY_A: "Jewelry A",
        EquipmentSlot.JEWELRY_B: "Jewelry B",
        EquipmentSlot.CAPE: "Cape",
    }

    def __init__(self, party: Optional[Party] = None) -> None:
        super().__init__("GSMainMenuScreen")
        self.party: Party = party if party is not None else create_default_party()
        self.noise_map_screen: Any = None
        self.save_manager: SaveManager = SaveManager()

        # Telemetry
        self.sector_coords: Tuple[int, int] = (0, 0)
        self._fallback_playtime_seconds: int = 0

        # Navigation state
        self._is_active: bool = True
        self.category_idx: int = 0
        self.hero_idx: int = 0
        self.focus_mode: str = "CATEGORIES"  # "CATEGORIES", "SUBMENU", "MODAL"

        # Feedback banner
        self.banner_message: str = ""
        self.banner_timer: float = 0.0

        # Submenu State: ITEMS
        self.item_filter_idx: int = 0  # 0: All, 1: Usable, 2: Equip, 3: Key
        self.item_cursor: int = 0
        self.item_page: int = 0
        self.item_modal_mode: str = "NONE"  # "NONE", "ACTION_SELECT", "TARGET_SELECT", "DISCARD_CHOICE", "DISCARD_AMOUNT", "DISCARD_CONFIRM"
        self.item_action_cursor: int = 0  # 0: Use, 1: Discard, 2: Cancel
        self.item_target_cursor: int = 0
        self.discard_choice_cursor: int = 0  # 0: Discard 1, 1: Discard Many, 2: Discard All, 3: Cancel
        self.discard_amount: int = 1

        # Submenu State: EQUIPMENT
        self.equip_slot_cursor: int = 0
        self.equip_drawer_open: bool = False
        self.equip_drawer_cursor: int = 0
        self.equip_drawer_items: list[Optional[BattleEquipment]] = []

        # Submenu State: MAGIC
        self.magic_cursor: int = 0
        self.magic_modal_mode: str = "NONE"  # "NONE", "TARGET_SELECT"
        self.magic_target_cursor: int = 0

        # Submenu State: QUESTS (Structured Accordion)
        self.quest_cursor: int = 0
        self.quest_scroll: int = 0
        self.quest_expanded_nodes: set[str] = set()

        # Submenu State: SAVE (Formal UIPanel components)
        self.save_slot_cursor: int = 0  # 0..2 (slots 1..3)
        self.slot_headers: list[Optional[SaveSlotHeader]] = []
        self.save_slot_panels: list[UIPanel] = []
        self._init_save_slot_panels()

        # Submenu State: QUIT
        self.quit_option_cursor: int = 0  # 0: Title, 1: Desktop, 2: Cancel

        # Formal UIPanel dialog and card components
        self.quit_modal_panel: UIPanel = UIPanel(
            left_top=ATCoordinates(12, 27),
            right_bottom=ATCoordinates(20, 77),
            title="Quit Game?",
            has_border=True,
        )
        self.quit_modal_panel.current_window_designs = dict(UIContainer.WINDOW_DESIGN_SQUARE)

        self.item_modal_panel: UIPanel = UIPanel(
            left_top=ATCoordinates(27, 27),
            right_bottom=ATCoordinates(36, 77),
            title="Action",
            has_border=True,
        )
        self.item_modal_panel.current_window_designs = dict(UIContainer.WINDOW_DESIGN_SQUARE)

        self.stat_delta_panel: UIPanel = UIPanel(
            left_top=ATCoordinates(31, 27),
            right_bottom=ATCoordinates(36, 77),
            title="Stat Delta",
            has_border=True,
        )
        self.stat_delta_panel.current_window_designs = dict(UIContainer.WINDOW_DESIGN_SQUARE)

        self.magic_modal_panel: UIPanel = UIPanel(
            left_top=ATCoordinates(28, 27),
            right_bottom=ATCoordinates(32, 77),
            title="Cast Spell",
            has_border=True,
        )
        self.magic_modal_panel.current_window_designs = dict(UIContainer.WINDOW_DESIGN_SQUARE)

    def _init_save_slot_panels(self) -> None:
        """Initializes 3 formal UIPanel instances for Save Slots 1..3 with square borders."""
        self.save_slot_panels = []
        for i in range(3):
            top_row = 6 + i * 6
            bot_row = top_row + 4
            p = UIPanel(
                left_top=ATCoordinates(top_row, 27),
                right_bottom=ATCoordinates(bot_row, 77),
                title=f"SLOT {i + 1}",
                has_border=True,
            )
            p.current_window_designs = dict(UIContainer.WINDOW_DESIGN_SQUARE)
            p.setup_title(f"SLOT {i + 1}", color=ColorLibrary.DarkGrey, align="left")
            p.activate()
            self.save_slot_panels.append(p)

    @property
    def playtime_seconds(self) -> int:
        """Returns campaign playtime from party, or fallback if party is unset."""
        if self.party is not None:
            return self.party.playtime_seconds
        return self._fallback_playtime_seconds

    @playtime_seconds.setter
    def playtime_seconds(self, value: int) -> None:
        self._fallback_playtime_seconds = value
        if self.party is not None:
            self.party.playtime_seconds = value
            self.party._playtime_accumulator = 0.0

    def configure_menu(
        self,
        party: Party,
        noise_map_screen: Any = None,
        sector_coords: Tuple[int, int] = (0, 0),
        playtime_seconds: int = 0,
    ) -> None:
        """Sets the active party and external world links."""
        self.party = party
        self.noise_map_screen = noise_map_screen
        self.sector_coords = sector_coords
        self.playtime_seconds = playtime_seconds
        self.hero_idx = min(self.hero_idx, max(0, len(self.party.members) - 1))
        self.banner_message = ""
        self.banner_timer = 0.0
        self.focus_mode = "CATEGORIES"
        self._refresh_save_headers()

    def _refresh_save_headers(self) -> None:
        try:
            self.slot_headers = self.save_manager.list_save_slots(3)
        except Exception:
            self.slot_headers = [None, None, None]

    def enter(self, context: Context) -> None:
        self._is_active = True
        super().enter(context)
        TerminalScreen.write(ATControlSequences.CursorHide)
        TerminalScreen.clear_screen()
        TerminalScreen.flush()

        core = context.get(SMState.ContextEldoriaCore)
        if core and hasattr(core, "game_state"):
            nm = core.game_state.states.get("GSNoiseMapTestScreen")
            if nm:
                self.noise_map_screen = nm
                self.party = nm.party
                self.sector_coords = nm.current_sector
                self.playtime_seconds = nm.playtime_seconds
                self.save_manager = nm.save_manager
        self._refresh_save_headers()

    def exit(self, context: Context) -> None:
        self._is_active = False
        super().exit(context)
        TerminalScreen.clear_screen()
        TerminalScreen.write(ATControlSequences.CursorShow)
        TerminalScreen.flush()

    # -------------------------------------------------------------------------
    # Input Handling
    # -------------------------------------------------------------------------
    def update(self, context: Context) -> None:
        super().update(context)

        if not self._is_active:
            return

        keys_pressed = context.get(SMState.ContextKeysPressed)
        core = context.get(SMState.ContextEldoriaCore)
        delta_time = context.get(SMState.ContextDeltaTime)
        if delta_time is None or not isinstance(delta_time, (int, float)):
            delta_time = 0.016

        if self.party is not None:
            self.party.add_playtime(delta_time)

        if self.banner_timer > 0:
            self.banner_timer -= delta_time
            if self.banner_timer <= 0:
                self.banner_message = ""

        if isinstance(keys_pressed, list) and len(keys_pressed) > 0:
            for key_info in list(keys_pressed):
                self._handle_input(key_info, context, core)
                if not self._is_active or (core and hasattr(core, "game_state") and core.game_state.current_state != self.name):
                    keys_pressed.clear()
                    return
            keys_pressed.clear()

        if not self._is_active or (core and hasattr(core, "game_state") and core.game_state.current_state != self.name):
            return

        self._render()

    def _handle_input(self, key_info: KeyEvent, context: Context, core: Any) -> None:
        # Global Hero switch via left/right arrows when not in modal or text input
        if self.focus_mode in ("CATEGORIES", "SUBMENU") and not self.equip_drawer_open:
            if key_info.key == KeyCode.LEFT:
                if len(self.party.members) > 1:
                    self.hero_idx = (self.hero_idx - 1) % len(self.party.members)
                return
            elif key_info.key == KeyCode.RIGHT:
                if len(self.party.members) > 1:
                    self.hero_idx = (self.hero_idx + 1) % len(self.party.members)
                return

        # 1. CATEGORIES FOCUS (Left Rail)
        if self.focus_mode == "CATEGORIES":
            cat = self.CATEGORIES[self.category_idx]
            if cat == "Items" and key_info.char in ("+", "=", "9", "c", "C", "d", "D", "*", "~", "`"):
                if self.party:
                    added = self.party.add_dev_items(99)
                    self._set_banner(f"★ DEV CHEAT: Stocked 99x of each item in inventory! (+{added})")
                return
            if key_info.key == KeyCode.UP:
                self.category_idx = (self.category_idx - 1) % len(self.CATEGORIES)
            elif key_info.key == KeyCode.DOWN:
                self.category_idx = (self.category_idx + 1) % len(self.CATEGORIES)
            elif key_info.key == KeyCode.ENTER or key_info.char in ("\r", "\n"):
                if cat != "Status":
                    self._enter_submenu()
            elif key_info.key == KeyCode.ESCAPE or key_info.char in ("m", "M"):
                self._resume_exploration(context, core)
            return

        # 2. MODAL FOCUS (Dialog overlays)
        if self.focus_mode == "MODAL":
            self._handle_modal_input(key_info, context, core)
            return

        # 3. SUBMENU FOCUS (Right Pane)
        if self.focus_mode == "SUBMENU":
            cat = self.CATEGORIES[self.category_idx]
            if key_info.key == KeyCode.ESCAPE:
                if self.equip_drawer_open:
                    self.equip_drawer_open = False
                    return
                if cat == "Quests":
                    if self._handle_quests_escape():
                        return
                self.focus_mode = "CATEGORIES"
                return

            if cat == "Status":
                self.focus_mode = "CATEGORIES"
                return
            elif cat == "Items":
                self._handle_items_input(key_info)
            elif cat == "Equipment":
                self._handle_equipment_input(key_info)
            elif cat == "Magic":
                self._handle_magic_input(key_info)
            elif cat == "Quests":
                self._handle_quests_input(key_info)
            elif cat == "Save":
                self._handle_save_input(key_info)
            elif cat == "Quit":
                self._handle_quit_input(key_info, context, core)

    def _enter_submenu(self) -> None:
        cat = self.CATEGORIES[self.category_idx]
        if cat == "Status":
            return
        elif cat == "Quit":
            self.focus_mode = "MODAL"
            self.quit_option_cursor = 0
        elif cat == "Items":
            self.focus_mode = "SUBMENU"
            self.item_cursor = 0
            self.item_modal_mode = "NONE"
        elif cat == "Equipment":
            self.focus_mode = "SUBMENU"
            self.equip_slot_cursor = 0
            self.equip_drawer_open = False
        elif cat == "Magic":
            self.focus_mode = "SUBMENU"
            self.magic_cursor = 0
            self.magic_modal_mode = "NONE"
        elif cat == "Quests":
            self.focus_mode = "SUBMENU"
            self.quest_cursor = 0
            self.quest_scroll = 0
            qm = getattr(self.party, "quest_manager", None)
            if qm:
                self.quest_expanded_nodes.add(qm.storyline.questline_id)
                act_q = qm.storyline.get_active_quest()
                if act_q:
                    self.quest_expanded_nodes.add(act_q.quest_id)
        elif cat == "Save":
            self.focus_mode = "SUBMENU"
            self.save_slot_cursor = 0
            self._refresh_save_headers()
        else:
            self.focus_mode = "SUBMENU"

    def _resume_exploration(self, context: Context, core: Any) -> None:
        self._is_active = False
        if self.noise_map_screen is not None:
            self.noise_map_screen.playtime_seconds = self.playtime_seconds
        if core and hasattr(core, "game_state"):
            core.game_state.trigger("ToNoiseMap", context)

    # -------------------------------------------------------------------------
    # Items Input & Action Logic
    # -------------------------------------------------------------------------
    def _get_filtered_items(self) -> list[dict]:
        all_inv = list(self.party.inventory)
        inv_ids = {it.get("item_id", it.get("name", "")) for it in all_inv}
        for q in self.party.quest_items:
            if q not in inv_ids:
                all_inv.append({"item_id": q, "qty": 1, "type": "key"})

        if self.item_filter_idx == 1:  # Usable/Consumable
            return [
                it for it in all_inv
                if it.get("type") == "consumable" or (get_item(it.get("item_id", "")) and get_item(it.get("item_id", "")).usable_in_field)
            ]
        elif self.item_filter_idx == 2:  # Equipment
            return [
                it for it in all_inv
                if it.get("type") == "equipment" or it.get("item_id") in EQUIPMENT_CATALOG
            ]
        elif self.item_filter_idx == 3:  # Key items
            return [
                it for it in all_inv
                if it.get("type") == "key" or is_key_item(it.get("item_id", ""))
            ]
        return all_inv

    def _handle_items_input(self, key_info: KeyEvent) -> None:
        # Hidden dev cheat key: '+', '=', '9', 'c', 'C', 'd', 'D', '*'
        if key_info.char in ("+", "=", "9", "c", "C", "d", "D", "*", "~", "`"):
            if self.party:
                added = self.party.add_dev_items(99)
                self._set_banner(f"★ DEV CHEAT: Stocked 99x of each item in inventory! (+{added})")
            return

        items = self._get_filtered_items()
        max_idx = max(0, len(items) - 1)

        if key_info.key == KeyCode.UP:
            if self.item_cursor > 0:
                self.item_cursor -= 1
        elif key_info.key == KeyCode.DOWN:
            if self.item_cursor < max_idx:
                self.item_cursor += 1
        elif key_info.key == KeyCode.TAB or key_info.char == "\t":
            self.item_filter_idx = (self.item_filter_idx + 1) % 4
            self.item_cursor = 0
        elif key_info.key == KeyCode.ENTER or key_info.char in ("\r", "\n"):
            if 0 <= self.item_cursor < len(items):
                item_entry = items[self.item_cursor]
                item_id = item_entry.get("item_id", item_entry.get("name", ""))
                item_obj = get_item(item_id)
                if is_key_item(item_id):
                    self.focus_mode = "MODAL"
                    self.item_modal_mode = "ACTION_SELECT"
                    self.item_action_cursor = 0
                elif item_obj is not None:
                    self.focus_mode = "MODAL"
                    self.item_modal_mode = "ACTION_SELECT"
                    self.item_action_cursor = 0
                elif item_entry.get("type") == "equipment" or item_id in EQUIPMENT_CATALOG:
                    self.focus_mode = "MODAL"
                    self.item_modal_mode = "ACTION_SELECT"
                    self.item_action_cursor = 1
                else:
                    self._set_banner(f"{item_id} cannot be used here.")

    def _handle_modal_input(self, key_info: KeyEvent, context: Context, core: Any) -> None:
        cat = self.CATEGORIES[self.category_idx]
        if cat == "Quit":
            if key_info.key == KeyCode.UP:
                self.quit_option_cursor = (self.quit_option_cursor - 1) % 3
            elif key_info.key == KeyCode.DOWN:
                self.quit_option_cursor = (self.quit_option_cursor + 1) % 3
            elif key_info.key == KeyCode.ESCAPE:
                self.focus_mode = "CATEGORIES"
            elif key_info.key == KeyCode.ENTER or key_info.char in ("\r", "\n"):
                if self.quit_option_cursor == 0:
                    self._is_active = False
                    if core and hasattr(core, "game_state"):
                        core.game_state.trigger("ToTitle", context)
                elif self.quit_option_cursor == 1:
                    self._is_active = False
                    if core:
                        core.is_running = False
                else:
                    self.focus_mode = "CATEGORIES"
            return

        if cat == "Items":
            items = self._get_filtered_items()
            if not items or self.item_cursor >= len(items):
                self.focus_mode = "SUBMENU"
                return
            item_entry = items[self.item_cursor]
            item_id = item_entry.get("item_id", item_entry.get("name", ""))
            item_obj = get_item(item_id)
            is_key = is_key_item(item_id)
            cur_qty = self.party.get_item_count(item_id)
            if cur_qty <= 0 and is_key:
                cur_qty = item_entry.get("qty", 1)

            if self.item_modal_mode == "ACTION_SELECT":
                max_opts = 2 if is_key else 3
                if key_info.key == KeyCode.LEFT:
                    self.item_action_cursor = (self.item_action_cursor - 1) % max_opts
                elif key_info.key == KeyCode.RIGHT:
                    self.item_action_cursor = (self.item_action_cursor + 1) % max_opts
                elif key_info.key == KeyCode.ESCAPE:
                    self.focus_mode = "SUBMENU"
                    self.item_modal_mode = "NONE"
                elif key_info.key == KeyCode.ENTER or key_info.char in ("\r", "\n"):
                    if self.item_action_cursor == 0:  # Use Item
                        if is_key:
                            self._set_banner("Key items cannot be used directly from the menu.")
                            self.focus_mode = "SUBMENU"
                            self.item_modal_mode = "NONE"
                        elif item_obj is None or not item_obj.usable_in_field:
                            name = item_obj.name if item_obj else item_id
                            self._set_banner(f"{name} cannot be used outside of battle!")
                            self.focus_mode = "SUBMENU"
                            self.item_modal_mode = "NONE"
                        elif item_obj.target_scope == TargetScope.ALL_ALLIES:
                            success, msg = apply_item_effect(item_obj, None, self.party)
                            self._set_banner(msg)
                            self.focus_mode = "SUBMENU"
                            self.item_modal_mode = "NONE"
                        else:
                            self.item_modal_mode = "TARGET_SELECT"
                            self.item_target_cursor = self.hero_idx
                    elif not is_key and self.item_action_cursor == 1:  # Discard
                        if not can_discard_item(item_id):
                            self._set_banner(f"{item_id} cannot be discarded!")
                            self.focus_mode = "SUBMENU"
                            self.item_modal_mode = "NONE"
                        else:
                            self.item_modal_mode = "DISCARD_CHOICE"
                            self.discard_choice_cursor = 0
                    else:  # Cancel
                        self.focus_mode = "SUBMENU"
                        self.item_modal_mode = "NONE"

            elif self.item_modal_mode == "TARGET_SELECT":
                num_members = len(self.party.members)
                if key_info.key == KeyCode.LEFT:
                    self.item_target_cursor = (self.item_target_cursor - 1) % num_members
                elif key_info.key == KeyCode.RIGHT:
                    self.item_target_cursor = (self.item_target_cursor + 1) % num_members
                elif key_info.key == KeyCode.ESCAPE:
                    self.item_modal_mode = "ACTION_SELECT"
                elif key_info.key == KeyCode.ENTER or key_info.char in ("\r", "\n"):
                    target_member = self.party.members[self.item_target_cursor]
                    if item_obj is not None:
                        # Contextual validation
                        if item_obj.effect_type == ItemEffectType.REVIVE and target_member.is_alive:
                            self._set_banner(f"{target_member.name} is already alive!")
                            return
                        elif item_obj.effect_type != ItemEffectType.REVIVE and not target_member.is_alive:
                            self._set_banner(f"{target_member.name} has fallen! Use Revive Herb.")
                            return
                        elif item_obj.effect_type == ItemEffectType.RESTORE_HP and target_member.hp >= target_member.max_hp:
                            self._set_banner(f"{target_member.name} is already at full HP!")
                            return
                        elif item_obj.effect_type == ItemEffectType.RESTORE_MP and target_member.mp >= target_member.max_mp:
                            self._set_banner(f"{target_member.name} is already at full MP!")
                            return

                        success, msg = apply_item_effect(item_obj, target_member, self.party)
                        self._set_banner(msg)
                        self.focus_mode = "SUBMENU"
                        self.item_modal_mode = "NONE"
                        new_items = self._get_filtered_items()
                        self.item_cursor = min(self.item_cursor, max(0, len(new_items) - 1))

            elif self.item_modal_mode == "DISCARD_CHOICE":
                if key_info.key == KeyCode.LEFT:
                    self.discard_choice_cursor = (self.discard_choice_cursor - 1) % 4
                elif key_info.key == KeyCode.RIGHT:
                    self.discard_choice_cursor = (self.discard_choice_cursor + 1) % 4
                elif key_info.key == KeyCode.ESCAPE:
                    self.item_modal_mode = "ACTION_SELECT"
                elif key_info.key == KeyCode.ENTER or key_info.char in ("\r", "\n"):
                    if self.discard_choice_cursor == 0:  # Discard 1
                        self.discard_amount = 1
                        self.item_modal_mode = "DISCARD_CONFIRM"
                    elif self.discard_choice_cursor == 1:  # Discard Many
                        self.discard_amount = min(cur_qty, 2) if cur_qty > 1 else 1
                        self.item_modal_mode = "DISCARD_AMOUNT"
                    elif self.discard_choice_cursor == 2:  # Discard All
                        self.discard_amount = cur_qty
                        self.item_modal_mode = "DISCARD_CONFIRM"
                    else:  # Cancel
                        self.item_modal_mode = "ACTION_SELECT"

            elif self.item_modal_mode == "DISCARD_AMOUNT":
                if key_info.key in (KeyCode.LEFT, KeyCode.DOWN):
                    self.discard_amount = max(1, self.discard_amount - 1)
                elif key_info.key in (KeyCode.RIGHT, KeyCode.UP):
                    self.discard_amount = min(cur_qty, self.discard_amount + 1)
                elif key_info.key == KeyCode.ESCAPE:
                    self.item_modal_mode = "DISCARD_CHOICE"
                elif key_info.key == KeyCode.ENTER or key_info.char in ("\r", "\n"):
                    self.item_modal_mode = "DISCARD_CONFIRM"

            elif self.item_modal_mode == "DISCARD_CONFIRM":
                if key_info.char in ("y", "Y") or key_info.key == KeyCode.ENTER or key_info.char in ("\r", "\n"):
                    success, msg = self.party.discard_item(item_id, self.discard_amount)
                    self._set_banner(msg)
                    self.focus_mode = "SUBMENU"
                    self.item_modal_mode = "NONE"
                    new_items = self._get_filtered_items()
                    self.item_cursor = min(self.item_cursor, max(0, len(new_items) - 1))
                elif key_info.key == KeyCode.ESCAPE or key_info.char in ("n", "N"):
                    self.item_modal_mode = "DISCARD_CHOICE"
                elif key_info.key == KeyCode.ESCAPE or key_info.char in ("n", "N", "\r", "\n"):
                    self.item_modal_mode = "ACTION_SELECT"

        elif cat == "Magic":
            member = self.party.members[self.hero_idx]
            spells = [a for a in member.actions if a.category in (ActionCategory.SPELL, ActionCategory.SKILL)]
            if not spells or self.magic_cursor >= len(spells):
                self.focus_mode = "SUBMENU"
                return
            spell = spells[self.magic_cursor]

            if self.magic_modal_mode == "TARGET_SELECT":
                if key_info.key == KeyCode.LEFT:
                    self.magic_target_cursor = (self.magic_target_cursor - 1) % len(self.party.members)
                elif key_info.key == KeyCode.RIGHT:
                    self.magic_target_cursor = (self.magic_target_cursor + 1) % len(self.party.members)
                elif key_info.key == KeyCode.ESCAPE:
                    self.focus_mode = "SUBMENU"
                    self.magic_modal_mode = "NONE"
                elif key_info.key == KeyCode.ENTER or key_info.char in ("\r", "\n"):
                    target_member = self.party.members[self.magic_target_cursor]
                    self._cast_field_spell(member, spell, target_member)
                    self.focus_mode = "SUBMENU"
                    self.magic_modal_mode = "NONE"

    def _cast_field_spell(self, caster: PartyMember, spell: BattleAction, target: PartyMember) -> None:
        if caster.mp < spell.mp_cost:
            self._set_banner("Not enough MP to cast spell!")
            return
        if not target.is_alive:
            self._set_banner(f"{target.name} has fallen!")
            return
        if target.hp >= target.max_hp:
            self._set_banner(f"{target.name} is already at full health!")
            return

        caster.mp -= spell.mp_cost
        old_hp = target.hp
        target.hp = min(target.max_hp, target.hp + spell.effect_value)
        healed = target.hp - old_hp
        self._set_banner(f"{caster.name} cast {spell.name}! {target.name} recovered {healed} HP.")

    # -------------------------------------------------------------------------
    # Equipment Input & Swapping Logic
    # -------------------------------------------------------------------------
    def _handle_equipment_input(self, key_info: KeyEvent) -> None:
        member = self.party.members[self.hero_idx]

        if not self.equip_drawer_open:
            if key_info.key == KeyCode.UP:
                self.equip_slot_cursor = (self.equip_slot_cursor - 1) % len(self.EQUIP_SLOTS)
            elif key_info.key == KeyCode.DOWN:
                self.equip_slot_cursor = (self.equip_slot_cursor + 1) % len(self.EQUIP_SLOTS)
            elif key_info.key == KeyCode.ENTER or key_info.char in ("\r", "\n"):
                # Open matching drawer
                target_slot = self.EQUIP_SLOTS[self.equip_slot_cursor]
                matching = []
                for entry in self.party.inventory:
                    item_id = entry.get("item_id", "")
                    if item_id in EQUIPMENT_CATALOG:
                        eq = EQUIPMENT_CATALOG[item_id]
                        if eq.slot == target_slot:
                            matching.append(eq)
                matching.append(None)  # None represents (Unequip Slot)
                self.equip_drawer_items = matching
                self.equip_drawer_cursor = 0
                self.equip_drawer_open = True
        else:
            # Inside Drawer
            drawer_len = len(self.equip_drawer_items)
            if key_info.key == KeyCode.UP:
                self.equip_drawer_cursor = (self.equip_drawer_cursor - 1) % drawer_len
            elif key_info.key == KeyCode.DOWN:
                self.equip_drawer_cursor = (self.equip_drawer_cursor + 1) % drawer_len
            elif key_info.key == KeyCode.ESCAPE:
                self.equip_drawer_open = False
            elif key_info.key == KeyCode.ENTER or key_info.char in ("\r", "\n"):
                selected_gear = self.equip_drawer_items[self.equip_drawer_cursor]
                target_slot = self.EQUIP_SLOTS[self.equip_slot_cursor]
                if selected_gear is None:
                    # Unequip current
                    old_gear = member.unequip(target_slot)
                    if old_gear:
                        self.party.add_item(old_gear.name, 1, item_type="equipment")
                        self._set_banner(f"Unequipped {old_gear.name}.")
                    else:
                        self._set_banner("Slot is already empty.")
                else:
                    # Equip new
                    old_gear = member.equip(selected_gear)
                    self.party.remove_item(selected_gear.name, 1)
                    if old_gear:
                        self.party.add_item(old_gear.name, 1, item_type="equipment")
                    self._set_banner(f"Equipped {selected_gear.name}!")
                self.equip_drawer_open = False

    # -------------------------------------------------------------------------
    # Magic & Save Inputs
    # -------------------------------------------------------------------------
    def _handle_magic_input(self, key_info: KeyEvent) -> None:
        member = self.party.members[self.hero_idx]
        spells = [a for a in member.actions if a.category in (ActionCategory.SPELL, ActionCategory.SKILL)]
        max_idx = max(0, len(spells) - 1)

        if key_info.key == KeyCode.UP:
            if self.magic_cursor > 0:
                self.magic_cursor -= 1
        elif key_info.key == KeyCode.DOWN:
            if self.magic_cursor < max_idx:
                self.magic_cursor += 1
        elif key_info.key == KeyCode.ENTER or key_info.char in ("\r", "\n"):
            if 0 <= self.magic_cursor < len(spells):
                spell = spells[self.magic_cursor]
                if "heal" in spell.name.lower() or "cure" in spell.name.lower():
                    self.focus_mode = "MODAL"
                    self.magic_modal_mode = "TARGET_SELECT"
                    self.magic_target_cursor = self.hero_idx
                else:
                    self._set_banner(f"{spell.name} cannot be cast in the field.")

    def _handle_save_input(self, key_info: KeyEvent) -> None:
        if key_info.key == KeyCode.UP:
            self.save_slot_cursor = (self.save_slot_cursor - 1) % 3
        elif key_info.key == KeyCode.DOWN:
            self.save_slot_cursor = (self.save_slot_cursor + 1) % 3
        elif key_info.key == KeyCode.ENTER or key_info.char in ("\r", "\n"):
            slot_num = self.save_slot_cursor + 1
            if self.noise_map_screen:
                self.noise_map_screen.playtime_seconds = self.playtime_seconds
                self.noise_map_screen._save_to_slot(slot_num)
            else:
                self.save_manager.save_game(
                    slot_idx=slot_num,
                    party=self.party,
                    exploration_state={"current_sector": list(self.sector_coords), "player_pos": [0, 0]},
                    playtime_seconds=self.playtime_seconds,
                )
            self._refresh_save_headers()
            self._set_banner(f"★ Progress saved to Slot {slot_num}!")

    def _handle_quit_input(self, key_info: KeyEvent, context: Context, core: Any) -> None:
        self.focus_mode = "MODAL"
        self.quit_option_cursor = 0

    def _set_banner(self, msg: str, duration: float = 3.0) -> None:
        self.banner_message = msg
        self.banner_timer = duration

    # -------------------------------------------------------------------------
    # Rendering (Exact 80x40 Grid with Invariant Row Widths)
    # -------------------------------------------------------------------------
    def _render(self) -> None:
        out: List[str] = [ATControlSequences.DrawOptimizeOn]

        # Row 1: Top Border
        out.append(ATCoordinates(1, 1).to_ansi())
        top_str = "┌" + ("─" * self.LEFT_WIDTH) + "┬" + ("─" * self.RIGHT_WIDTH) + "┐"
        out.append(top_str)

        # Build Left Rail Lines (37 lines for rows 2..38)
        left_lines = self._render_left_rail()

        # Build Right Pane Lines (37 lines for rows 2..38)
        right_lines = self._render_right_pane()

        # Render Rows 2..38
        for row_idx in range(37):
            l_cell = _pad_cell(left_lines[row_idx] if row_idx < len(left_lines) else "", self.LEFT_WIDTH)
            r_cell = _pad_cell(right_lines[row_idx] if row_idx < len(right_lines) else "", self.RIGHT_WIDTH)
            out.append(ATCoordinates(2 + row_idx, 1).to_ansi())
            out.append(f"│{l_cell}│{r_cell}│")

        # Row 39: Bottom Border
        out.append(ATCoordinates(39, 1).to_ansi())
        bot_str = "└" + ("─" * self.LEFT_WIDTH) + "┴" + ("─" * self.RIGHT_WIDTH) + "┘"
        out.append(bot_str)

        # Row 40: Status Bar
        out.append(ATCoordinates(40, 1).to_ansi())
        hints = self._format_status_hints()
        out.append(_pad_cell(f" {hints}", self.TOTAL_WIDTH))

        # Clear buffer tail up to 45
        out.append(clear_buffer_tail(41, 45))
        out.append(ATControlSequences.DrawOptimizeOff)

        TerminalScreen.write("".join(out))
        TerminalScreen.flush()

    def _render_left_rail(self) -> list[str]:
        lines: list[str] = []

        # Rows 2..7: Categories
        for idx, cat_name in enumerate(self.CATEGORIES):
            is_active = (idx == self.category_idx)
            cursor = "\033[1;36m❱\033[0m " if is_active else "  "
            if is_active and self.focus_mode == "CATEGORIES":
                line_str = f"{cursor}\033[1;37m{cat_name}\033[0m"
            elif is_active:
                line_str = f"{cursor}\033[36m{cat_name}\033[0m"
            else:
                line_str = f"{cursor}\033[90m{cat_name}\033[0m"
            lines.append(line_str)

        # Row 8: Divider
        lines.append("─" * self.LEFT_WIDTH)

        # Rows 9..11: Telemetry
        lines.append(f" Gold:    \033[1;33m{self.party.gold} G\033[0m")
        lines.append(f" Sector:  ({self.sector_coords[0]}, {self.sector_coords[1]})")
        lines.append(f" Time:    {_format_time(self.playtime_seconds)}")

        # Row 12: Divider
        lines.append("─" * self.LEFT_WIDTH)

        # Row 13: Vitals Header
        lines.append("\033[1;37mPARTY VITALS:\033[0m")

        # Rows 14..33: 5 Heroes * 4 lines = 20 lines
        for m_idx in range(5):
            if m_idx < len(self.party.members):
                m = self.party.members[m_idx]
                is_selected = (m_idx == self.hero_idx)
                name_prefix = "\033[1;32m" if is_selected else "\033[37m"
                state_str = "\033[32mOK\033[0m" if m.is_alive else "\033[1;31mKO\033[0m"

                name_clean = m.name[:4]
                lines.append(f"{name_prefix}{name_clean}\033[0m (Lv.{m.level:<2}) {state_str}")
                hp_left = f"  HP:{m.hp}/{m.max_hp}"
                hp_bar = _make_bar(m.hp, m.max_hp, 4, bar_type=StatBarType.HEALTH)
                rem_hp = self.LEFT_WIDTH - visible_width(hp_left) - visible_width(hp_bar)
                pad_hp = max(1, rem_hp - 1) if rem_hp >= 2 else max(0, rem_hp)
                lines.append(f"{hp_left}{' ' * pad_hp}{hp_bar}")

                mp_left = f"  MP:{m.mp}/{m.max_mp}"
                mp_bar = _make_bar(m.mp, m.max_mp, 4, bar_type=StatBarType.MANA)
                rem_mp = self.LEFT_WIDTH - visible_width(mp_left) - visible_width(mp_bar)
                pad_mp = max(1, rem_mp - 1) if rem_mp >= 2 else max(0, rem_mp)
                lines.append(f"{mp_left}{' ' * pad_mp}{mp_bar}")
                lines.append("")
            else:
                lines.extend(["", "", "", ""])

        while len(lines) < 37:
            lines.append("")
        return lines[:37]

    def _render_right_pane(self) -> list[str]:
        lines: list[str] = []

        # Row 2 (Index 0): Hero Tabs Header (deterministic 46 chars centered in 55)
        tabs_str = self._format_hero_tabs()
        lines.append(tabs_str)

        # Row 3 (Index 1): Divider
        lines.append("─" * self.RIGHT_WIDTH)

        # Banner row if active
        if self.banner_message:
            lines.append(f" \033[1;33m★ {self.banner_message}\033[0m")
        else:
            lines.append("")

        # Submenu contents for rows 5..38 (Indices 3..36 = 34 lines)
        cat = self.CATEGORIES[self.category_idx]
        if self.focus_mode == "MODAL" and cat == "Quit":
            sub_lines = self._render_quit_modal()
        elif cat == "Status":
            sub_lines = self._render_status_submenu()
        elif cat == "Items":
            sub_lines = self._render_items_submenu()
        elif cat == "Equipment":
            sub_lines = self._render_equipment_submenu()
        elif cat == "Magic":
            sub_lines = self._render_magic_submenu()
        elif cat == "Quests":
            sub_lines = self._render_quests_submenu()
        elif cat == "Save":
            sub_lines = self._render_save_submenu()
        else:
            sub_lines = self._render_quit_modal()

        lines.extend(sub_lines)
        while len(lines) < 37:
            lines.append("")
        return lines[:37]

    def _format_hero_tabs(self) -> str:
        """Formats the 4-letter hero tabs bar centered in 55 columns."""
        tab_chunks = []
        for idx in range(len(self.party.members)):
            m = self.party.members[idx]
            name = m.name[:4].center(4)
            if idx == self.hero_idx:
                tab_chunks.append(f"\033[1;36m[◄ {name} ►]\033[0m")
            else:
                tab_chunks.append(f"\033[90m[{name}]\033[0m")
        bar = "   ".join(tab_chunks)
        # Pad left 4 spaces to center
        return "    " + bar

    # -------------------------------------------------------------------------
    # Submenu Renderers
    # -------------------------------------------------------------------------
    def _render_status_submenu(self) -> list[str]:
        lines: list[str] = []
        m = self.party.members[self.hero_idx]

        # Profile
        lines.append(f" Archetype: \033[1;37m{m.job_class:<20}\033[0m Level: \033[1;33m{m.level}\033[0m")
        badge = format_element_badge(m.affinity)
        badge_pad = badge + (" " * max(0, 20 - visible_width(badge)))
        lines.append(f" Element:   {badge_pad} Gender: {m.gender.value}")
        hp_left = f" HP:  {m.hp} / {m.max_hp}"
        hp_bar = _make_bar(m.hp, m.max_hp, 20, bar_type=StatBarType.HEALTH)
        rem_hp = self.RIGHT_WIDTH - visible_width(hp_left) - visible_width(hp_bar)
        pad_hp = max(1, rem_hp - 1) if rem_hp >= 2 else max(0, rem_hp)
        lines.append(f"{hp_left}{' ' * pad_hp}{hp_bar}")

        mp_left = f" MP:  {m.mp} / {m.max_mp}"
        mp_bar = _make_bar(m.mp, m.max_mp, 20, bar_type=StatBarType.MANA)
        rem_mp = self.RIGHT_WIDTH - visible_width(mp_left) - visible_width(mp_bar)
        pad_mp = max(1, rem_mp - 1) if rem_mp >= 2 else max(0, rem_mp)
        lines.append(f"{mp_left}{' ' * pad_mp}{mp_bar}")
        if m.current_xp >= 1_000_000:
            gold_stars = f"{ColorLibrary.Gold.to_fg_ansi()}★★\033[0m"
            lines.append(f" EXP: {gold_stars}")
        else:
            lines.append(f" EXP: {m.current_xp:>3} / {m.next_level_xp:<3}")
        lines.append("── ATTRIBUTES ──────────────────────────────────────────")

        # 4 attribute lines without 'Base'
        lines.append(self._format_attr_pair(m, StatId.ATTACK, "ATK", StatId.DEFENSE, "DEF"))
        lines.append(self._format_attr_pair(m, StatId.MAGIC_ATTACK, "MAT", StatId.MAGIC_DEFENSE, "MDF"))
        lines.append(self._format_attr_pair(m, StatId.SPEED, "SPD", StatId.ACCURACY, "ACC"))
        lines.append(self._format_attr_pair(m, StatId.LUCK, "LCK", StatId.HIT_POINTS, "EVA/CRIT"))

        lines.append("── EQUIPPED GEAR ───────────────────────────────────────")
        for slot in self.EQUIP_SLOTS:
            slot_name = self.SLOT_NAMES[slot]
            eq = m.equipment.get(slot)
            if eq:
                bonus_parts = [f"+{v} {k.name[:3]}" for k, v in eq.stat_bonuses.items()]
                b_str = f"({', '.join(bonus_parts[:2])})" if bonus_parts else ""
                lines.append(f"  {slot_name:<11}: \033[1;37m{eq.name[:20]:<20}\033[0m \033[36m{b_str:<16}\033[0m")
            else:
                lines.append(f"  {slot_name:<11}: \033[90m(Empty)\033[0m")

        lines.append("── ACTIVE COMBAT SKILLS ────────────────────────────────")
        skill_names = [f"• {a.name}" for a in m.actions[:6]]
        for i in range(0, len(skill_names), 2):
            s1 = skill_names[i]
            s2 = skill_names[i + 1] if i + 1 < len(skill_names) else ""
            lines.append(f"  {s1:<25} {s2:<25}")

        return lines

    @staticmethod
    def _format_stat_augment(p: BattleEntityProperty) -> str:
        aug = p.equipment_bonus + p.augment_value
        val_str = str(aug)
        padded = f"{val_str:>2}"
        leading_spaces = len(padded) - len(val_str)
        spaces = " " * leading_spaces
        if aug > 0:
            return f"{spaces}{ColorLibrary.EmeraldGreen.to_fg_ansi()}{val_str}\033[0m"
        elif aug < 0:
            return f"{spaces}{ColorLibrary.RubyRed.to_fg_ansi()}{val_str}\033[0m"
        else:
            return f"{aug:>2}"

    def _format_attr_pair(self, m: PartyMember, s1: StatId, l1: str, s2: StatId, l2: str) -> str:
        gold_stars = f"{ColorLibrary.Gold.to_fg_ansi()}★★\033[0m"
        p1 = m.stats[s1]
        aug1_str = self._format_stat_augment(p1)
        tot1_str = gold_stars if p1.total >= 99 else f"{p1.total:>2}"
        c1 = f" {l1}:  {tot1_str} ({p1.base:>2} + {aug1_str})"

        if l2 == "EVA/CRIT":
            spd = m.get_stat(StatId.SPEED)
            lck = m.get_stat(StatId.LUCK)
            eva_pct = max(2, min(95, int(round((spd * 0.4 + lck * 0.2) / 1.8))))
            crit_pct = max(2, min(50, int(round(lck * 0.5))))
            c2 = f" EVA:  {eva_pct:>2}%   CRIT: {crit_pct:>2}%"
            return f"{_pad_cell(c1, 28)}{_pad_cell(c2, 27)}"

        p2 = m.stats[s2]
        aug2_str = self._format_stat_augment(p2)
        tot2_str = gold_stars if p2.total >= 99 else f"{p2.total:>2}"
        c2 = f" {l2}:  {tot2_str} ({p2.base:>2} + {aug2_str})"
        return f"{_pad_cell(c1, 28)}{_pad_cell(c2, 27)}"

    def _render_items_submenu(self) -> list[str]:
        lines: list[str] = []
        tabs = ["[All]", "[Usable]", "[Equip]", "[Key]"]
        tab_str = " ".join([f"\033[1;36m{t}\033[0m" if i == self.item_filter_idx else f"\033[90m{t}\033[0m" for i, t in enumerate(tabs)])
        items = self._get_filtered_items()
        lines.append(f" Category: {tab_str}  \033[33m({len(items)} items)\033[0m")
        lines.append("─" * self.RIGHT_WIDTH)

        # 16 Item Rows
        page_size = 14
        start_idx = (self.item_cursor // page_size) * page_size
        visible_items = items[start_idx : start_idx + page_size]

        for idx, it in enumerate(visible_items):
            real_idx = start_idx + idx
            is_cur = (real_idx == self.item_cursor and self.focus_mode in ("SUBMENU", "MODAL"))
            name = it.get("item_id", it.get("name", "Item"))[:20]
            qty = f"x{it.get('qty', 1):02d}"
            t_tag = f"[{it.get('type', 'item')[:4].upper()}]"

            if is_cur:
                bg = "\033[48;2;25;55;85m"
                base_content = f" ❱ {name:<20} {qty:<5} {t_tag}"
                pad_len = max(0, self.RIGHT_WIDTH - visible_width(base_content))
                lines.append(f"{bg} \033[1;36m❱ \033[1;37m{name:<20} \033[1;33m{qty:<5} \033[1;36m{t_tag}{' ' * pad_len}\033[0m")
            else:
                lines.append(f"   \033[37m{name:<20}\033[0m {qty:<5} \033[90m{t_tag}\033[0m")

        # Fill remaining lines up to 16
        for _ in range(page_size - len(visible_items)):
            lines.append("")

        lines.append("─" * self.RIGHT_WIDTH)

        # Detail / Context Dialog area (Rows 18..34)
        if 0 <= self.item_cursor < len(items):
            cur_entry = items[self.item_cursor]
            item_id = cur_entry.get("item_id", cur_entry.get("name", ""))
            c_obj = get_item(item_id)
            if c_obj:
                desc = c_obj.description
            elif item_id in EQUIPMENT_CATALOG:
                eq = EQUIPMENT_CATALOG[item_id]
                stat_parts = [f"+{v} {k.name[:3]}" for k, v in eq.stat_bonuses.items()]
                stat_str = ", ".join(stat_parts) if stat_parts else "No stat bonuses"
                desc = f"Equipment ({eq.slot.value}): {stat_str}"
            else:
                desc = "Standard party inventory item."
            wrapped = wrap_text(desc, 53)
            for w in wrapped[:2]:
                lines.append(f" {w}")

        if self.focus_mode == "MODAL" and self.item_modal_mode != "NONE":
            lines.extend(self._render_item_modal_card())

        return lines

    def _render_item_modal_card(self) -> list[str]:
        panel = self.item_modal_panel
        panel.ui_element_listing.clear()
        panel.border_draw_colors = [ColorLibrary.AppleCyanLight for _ in range(8)]

        items = self._get_filtered_items()
        item_entry = items[self.item_cursor] if 0 <= self.item_cursor < len(items) else {}
        item_id = item_entry.get("item_id", item_entry.get("name", "Item"))
        item_obj = get_item(item_id)
        item_name = item_obj.name if item_obj else item_id
        is_key = is_key_item(item_id)
        cur_qty = self.party.get_item_count(item_id)
        if cur_qty <= 0 and is_key:
            cur_qty = item_entry.get("qty", 1)

        if self.item_modal_mode == "ACTION_SELECT":
            panel.setup_title(f"Item: {item_name[:16]}", color=ColorLibrary.AppleCyanLight, align="left")
            opts = ["Use Item", "Cancel"] if is_key else ["Use Item", "Discard", "Cancel"]
            cur_idx = min(self.item_action_cursor, len(opts) - 1)
            opt_str = "    ".join([
                f"\033[1;36m[{o}]\033[0m" if i == cur_idx else f" {o} "
                for i, o in enumerate(opts)
            ])
            panel.add_label(opt_str, row=29, align="center")
            hint_str = "[◄/►] Select   [Enter] Choose   [Esc] Back"
            panel.add_label(hint_str, row=31, align="center", fg_color=ColorLibrary.DarkGrey)

        elif self.item_modal_mode == "TARGET_SELECT":
            panel.setup_title("Select Target Ally", color=ColorLibrary.AppleCyanLight, align="left")
            target_member = self.party.members[self.item_target_cursor]
            target_name = target_member.name[:4]
            state_str = "\033[32mOK\033[0m" if target_member.is_alive else "\033[1;31mKO\033[0m"
            panel.add_label(
                f"Target: [◄ \033[1;36m{target_name}\033[0m ►] (Lv.{target_member.level})  Class: {target_member.job_class[:10]}",
                row=28,
                align="center",
            )
            hp_bar = _make_bar(target_member.hp, target_member.max_hp, 6, bar_type=StatBarType.HEALTH)
            mp_bar = _make_bar(target_member.mp, target_member.max_mp, 6, bar_type=StatBarType.MANA)
            panel.add_label(
                f"HP:{target_member.hp:>3}/{target_member.max_hp:<3} {hp_bar} MP:{target_member.mp:>2}/{target_member.max_mp:<2} {mp_bar} [{state_str}]",
                row=30,
                align="center",
            )

            # Target validation status line
            if item_obj is not None:
                if item_obj.effect_type == ItemEffectType.REVIVE:
                    if target_member.is_alive:
                        val_msg = "\033[1;33m⚠️ Ineligible: Target is alive\033[0m"
                    else:
                        val_msg = "\033[1;32m★ Valid: Will revive with HP\033[0m"
                else:
                    if not target_member.is_alive:
                        val_msg = "\033[1;31m⚠️ Ineligible: Target has fallen\033[0m"
                    elif item_obj.effect_type == ItemEffectType.RESTORE_HP and target_member.hp >= target_member.max_hp:
                        val_msg = "\033[1;33m⚠️ Ineligible: Target at full HP\033[0m"
                    elif item_obj.effect_type == ItemEffectType.RESTORE_MP and target_member.mp >= target_member.max_mp:
                        val_msg = "\033[1;33m⚠️ Ineligible: Target at full MP\033[0m"
                    else:
                        val_msg = "\033[1;32m★ Valid: Ready to use item\033[0m"
            else:
                val_msg = "\033[1;37mReady to use\033[0m"

            panel.add_label(val_msg, row=32, align="center")
            panel.add_label("[◄/►] Cycle Ally   [Enter] Use Item   [Esc] Back", row=34, align="center", fg_color=ColorLibrary.DarkGrey)

        elif self.item_modal_mode == "DISCARD_CHOICE":
            panel.setup_title(f"Discard: {item_name[:16]}", color=ColorLibrary.AppleCyanLight, align="left")
            opts = ["Discard 1", "Many", "All", "Cancel"]
            opt_str = "   ".join([
                f"\033[1;36m[{o}]\033[0m" if i == self.discard_choice_cursor else f" {o} "
                for i, o in enumerate(opts)
            ])
            panel.add_label(opt_str, row=29, align="center")
            panel.add_label(f"Current stock in inventory: {cur_qty}", row=31, align="center", fg_color=ColorLibrary.AppleCyanLight)
            panel.add_label("[◄/►] Choose   [Enter] Select   [Esc] Back", row=33, align="center", fg_color=ColorLibrary.DarkGrey)

        elif self.item_modal_mode == "DISCARD_AMOUNT":
            panel.setup_title("Discard Quantity", color=ColorLibrary.AppleCyanLight, align="left")
            amt_str = f"Discard Amount: [ ◄  \033[1;33m{self.discard_amount:02d}\033[0m  ► ] / {cur_qty:02d}"
            panel.add_label(amt_str, row=29, align="center")
            panel.add_label("[◄/►] Adjust Qty   [Enter] Confirm   [Esc] Back", row=31, align="center", fg_color=ColorLibrary.DarkGrey)

        elif self.item_modal_mode == "DISCARD_CONFIRM":
            panel.setup_title("Confirm Discard", color=ColorLibrary.AppleRedLight, align="left")
            panel.border_draw_colors = [ColorLibrary.AppleRedLight for _ in range(8)]
            panel.add_label(
                f"Discard \033[1;31m{self.discard_amount}x\033[0m {item_name}? Are you sure?",
                row=29,
                align="center",
                fg_color=ColorLibrary.AppleRedLight,
            )
            panel.add_label(
                "\033[1;37m[Y] Yes, Discard\033[0m          \033[90m[N / Esc] Cancel\033[0m",
                row=31,
                align="center",
            )

        panel.set_all_dirty()
        return [f"  {pl}" for pl in panel.render_lines()]


    def _render_equipment_submenu(self) -> list[str]:
        lines: list[str] = []
        member = self.party.members[self.hero_idx]

        lines.append("── EQUIPPED SLOTS ──────────────────────────────────────")
        for idx, slot in enumerate(self.EQUIP_SLOTS):
            slot_name = self.SLOT_NAMES[slot]
            is_cur = (idx == self.equip_slot_cursor and not self.equip_drawer_open and self.focus_mode in ("SUBMENU", "MODAL"))
            eq = member.equipment.get(slot)
            if eq:
                bonus_parts = [f"+{v}{k.name[:2]}" for k, v in eq.stat_bonuses.items()]
                b_str = f"({', '.join(bonus_parts[:2])})" if bonus_parts else ""
            else:
                b_str = ""

            if is_cur:
                bg = "\033[48;2;25;55;85m"
                if eq:
                    base_content = f" ❱ {slot_name:<10}: {eq.name[:18]:<18} {b_str:<14}"
                    pad_len = max(0, self.RIGHT_WIDTH - visible_width(base_content))
                    lines.append(
                        f"{bg} \033[1;36m❱ \033[1;37m{slot_name:<10}\033[0m{bg}: \033[1;37m{eq.name[:18]:<18}\033[0m{bg} \033[1;36m{b_str:<14}\033[0m{bg}{' ' * pad_len}\033[0m"
                    )
                else:
                    base_content = f" ❱ {slot_name:<10}: (Empty)"
                    pad_len = max(0, self.RIGHT_WIDTH - visible_width(base_content))
                    lines.append(
                        f"{bg} \033[1;36m❱ \033[1;37m{slot_name:<10}\033[0m{bg}: \033[90m(Empty)\033[0m{bg}{' ' * pad_len}\033[0m"
                    )
            elif self.equip_drawer_open and idx == self.equip_slot_cursor:
                if eq:
                    lines.append(f" \033[36m› \033[1;36m{slot_name:<10}\033[0m: \033[1;37m{eq.name[:18]:<18}\033[0m \033[36m{b_str:<14}\033[0m")
                else:
                    lines.append(f" \033[36m› \033[1;36m{slot_name:<10}\033[0m: \033[90m(Empty)\033[0m")
            else:
                if eq:
                    lines.append(f"   \033[37m{slot_name:<10}\033[0m: \033[1;37m{eq.name[:18]:<18}\033[0m \033[36m{b_str:<14}\033[0m")
                else:
                    lines.append(f"   \033[37m{slot_name:<10}\033[0m: \033[90m(Empty)\033[0m")

        lines.append("── AVAILABLE GEAR IN BAG ───────────────────────────────")
        if self.equip_drawer_open:
            for idx, item in enumerate(self.equip_drawer_items[:7]):
                is_cur = (idx == self.equip_drawer_cursor)
                if is_cur:
                    bg = "\033[48;2;25;55;85m"
                    if item is None:
                        base_content = " ❱ (Unequip Current Gear)"
                        pad_len = max(0, self.RIGHT_WIDTH - visible_width(base_content))
                        lines.append(f"{bg} \033[1;36m❱ \033[1;31m(Unequip Current Gear)\033[0m{bg}{' ' * pad_len}\033[0m")
                    else:
                        bonus_parts = [f"+{v}{k.name[:2]}" for k, v in item.stat_bonuses.items()]
                        b_str = f"({', '.join(bonus_parts[:2])})" if bonus_parts else ""
                        base_content = f" ❱ {item.name[:20]:<20} {b_str}"
                        pad_len = max(0, self.RIGHT_WIDTH - visible_width(base_content))
                        lines.append(f"{bg} \033[1;36m❱ \033[1;37m{item.name[:20]:<20}\033[0m{bg} \033[1;36m{b_str}\033[0m{bg}{' ' * pad_len}\033[0m")
                else:
                    if item is None:
                        lines.append("   \033[31m(Unequip Current Gear)\033[0m")
                    else:
                        bonus_parts = [f"+{v}{k.name[:2]}" for k, v in item.stat_bonuses.items()]
                        b_str = f"({', '.join(bonus_parts[:2])})" if bonus_parts else ""
                        lines.append(f"   \033[1;37m{item.name[:20]:<20}\033[0m \033[36m{b_str}\033[0m")
            for _ in range(7 - len(self.equip_drawer_items[:7])):
                lines.append("")
        else:
            lines.append(" \033[90m[Press Enter on a slot to browse available gear]\033[0m")
            for _ in range(6):
                lines.append("")

        lines.append("── STAT COMPARISON ─────────────────────────────────────")
        lines.extend(self._render_equip_comparison_card())
        return lines

    def _render_equip_comparison_card(self) -> list[str]:
        member = self.party.members[self.hero_idx]
        slot = self.EQUIP_SLOTS[self.equip_slot_cursor]
        cur_eq = member.equipment.get(slot)
        new_eq = None
        if self.equip_drawer_open and 0 <= self.equip_drawer_cursor < len(self.equip_drawer_items):
            new_eq = self.equip_drawer_items[self.equip_drawer_cursor]

        cur_name = cur_eq.name[:16] if cur_eq else "None"
        new_name = new_eq.name[:16] if new_eq else ("(Empty)" if self.equip_drawer_open else "-")

        panel = self.stat_delta_panel
        panel.ui_element_listing.clear()
        panel.border_draw_colors = [ColorLibrary.AppleCyanLight for _ in range(8)]
        panel.setup_title("Stat Delta", color=ColorLibrary.AppleCyanLight, align="left")

        header_text = f"{cur_name} -> {new_name}"
        panel.add_label(header_text, row=32, align="center", fg_color=ColorLibrary.White)

        # Deltas
        atk_diff = (new_eq.get_bonus(StatId.ATTACK) if new_eq else 0) - (cur_eq.get_bonus(StatId.ATTACK) if cur_eq else 0)
        def_diff = (new_eq.get_bonus(StatId.DEFENSE) if new_eq else 0) - (cur_eq.get_bonus(StatId.DEFENSE) if cur_eq else 0)
        spd_diff = (new_eq.get_bonus(StatId.SPEED) if new_eq else 0) - (cur_eq.get_bonus(StatId.SPEED) if cur_eq else 0)
        mat_diff = (new_eq.get_bonus(StatId.MAGIC_ATTACK) if new_eq else 0) - (cur_eq.get_bonus(StatId.MAGIC_ATTACK) if cur_eq else 0)

        r1 = f"ATK: {member.get_stat(StatId.ATTACK):>2} ({atk_diff:>+2})    DEF: {member.get_stat(StatId.DEFENSE):>2} ({def_diff:>+2})"
        r2 = f"MAT: {member.get_stat(StatId.MAGIC_ATTACK):>2} ({mat_diff:>+2})    SPD: {member.get_stat(StatId.SPEED):>2} ({spd_diff:>+2})"
        panel.add_label(r1, row=33, align="center", fg_color=ColorLibrary.AppleCyanLight)
        panel.add_label(r2, row=34, align="center", fg_color=ColorLibrary.AppleCyanLight)

        panel.set_all_dirty()
        return [f"  {pl}  " for pl in panel.render_lines()]

    def _render_magic_submenu(self) -> list[str]:
        lines: list[str] = []
        member = self.party.members[self.hero_idx]
        spells = [a for a in member.actions if a.category in (ActionCategory.SPELL, ActionCategory.SKILL)]

        lines.append(f" Known Spells & Skills ({len(spells)} total):")
        lines.append("─" * self.RIGHT_WIDTH)

        page_size = 14
        start_idx = (self.magic_cursor // page_size) * page_size
        visible_spells = spells[start_idx : start_idx + page_size]

        for idx, sp in enumerate(visible_spells):
            real_idx = start_idx + idx
            is_cur = (real_idx == self.magic_cursor and self.focus_mode in ("SUBMENU", "MODAL"))
            name_str = f"{sp.name[:18]:<18}"
            mp_str = f"MP: {sp.mp_cost:>2}"
            scope_str = f"{sp.target_scope.name[:12]:<12}"

            if is_cur:
                bg = "\033[48;2;25;55;85m"
                base_content = f" ❱ {name_str} {mp_str}  {scope_str}"
                pad_len = max(0, self.RIGHT_WIDTH - visible_width(base_content))
                lines.append(f"{bg} \033[1;36m❱ \033[1;37m{name_str} \033[1;33m{mp_str}  \033[1;36m{scope_str}{' ' * pad_len}\033[0m")
            else:
                lines.append(f"   \033[37m{name_str}\033[0m \033[33m{mp_str}\033[0m  \033[36m{scope_str}\033[0m")

        for _ in range(page_size - len(visible_spells)):
            lines.append("")

        lines.append("─" * self.RIGHT_WIDTH)
        if 0 <= self.magic_cursor < len(spells):
            cur_spell = spells[self.magic_cursor]
            desc = cur_spell.description or "Magical combat or field technique."
            for w in wrap_text(desc, 53)[:2]:
                lines.append(f" {w}")

        if self.focus_mode == "MODAL" and self.magic_modal_mode == "TARGET_SELECT":
            target_name = self.party.members[self.magic_target_cursor].name[:4]
            panel = self.magic_modal_panel
            panel.ui_element_listing.clear()
            panel.border_draw_colors = [ColorLibrary.AppleCyanLight for _ in range(8)]
            panel.setup_title("Cast Spell", color=ColorLibrary.AppleCyanLight, align="left")
            panel.add_label(f"Target Ally: [◄ {target_name} ►]", row=29, align="center", fg_color=ColorLibrary.AppleCyanLight)
            panel.add_label("[Enter] Cast     [Esc] Cancel", row=30, align="center", fg_color=ColorLibrary.DarkGrey)
            panel.set_all_dirty()
            lines.extend([f"  {pl}  " for pl in panel.render_lines()])

        return lines

    def _render_save_submenu(self) -> list[str]:
        lines: list[str] = []
        lines.append(" Select a save slot to record your progress:")
        lines.append("")

        self._refresh_save_slot_panels()

        for slot_idx, panel in enumerate(self.save_slot_panels):
            p_lines = panel.render_lines()
            for pl in p_lines:
                lines.append(f"  {pl}  ")
            lines.append("")

        return lines

    def _refresh_save_slot_panels(self) -> None:
        """Configures UIPanel border colors, titles, and child UILabels based on current save data and selection."""
        for slot_idx in range(3):
            panel = self.save_slot_panels[slot_idx]
            is_cur = (slot_idx == self.save_slot_cursor)
            header = self.slot_headers[slot_idx] if slot_idx < len(self.slot_headers) else None
            top_row = panel.left_top.row

            # Clear previous child labels
            panel.ui_element_listing.clear()

            # Border and Title styling
            if is_cur:
                panel.border_draw_colors = [ColorLibrary.AppleCyanLight for _ in range(8)]
                panel.setup_title(f"SLOT {slot_idx + 1}", color=ColorLibrary.AppleCyanLight, align="left")
            else:
                panel.border_draw_colors = [ColorLibrary.DarkGrey for _ in range(8)]
                panel.setup_title(f"SLOT {slot_idx + 1}", color=ColorLibrary.DarkGrey, align="left")

            # Child UILabels
            if header:
                loc = header.current_location or f"Slot {slot_idx + 1}"
                fg_loc = ColorLibrary.White if is_cur else ColorLibrary.DarkGrey
                fg_lead = ColorLibrary.AppleCyanLight if is_cur else ColorLibrary.DarkGrey
                fg_time = ColorLibrary.AppleYellowLight if is_cur else ColorLibrary.DarkGrey

                panel.add_label(f"Location: {loc[:38]}", row=top_row + 1, col=panel.inner_left + 1, fg_color=fg_loc)
                panel.add_label(f"Leader:   {header.party_leader_name} (Lv.{header.party_leader_level})", row=top_row + 2, col=panel.inner_left + 1, fg_color=fg_lead)
                panel.add_label(f"Time: {header.formatted_playtime()}   Saved: {header.timestamp[:16]}", row=top_row + 3, col=panel.inner_left + 1, fg_color=fg_time)
            else:
                fg_empty = ColorLibrary.AppleCyanLight if is_cur else ColorLibrary.DarkGrey
                fg_ready = ColorLibrary.White if is_cur else ColorLibrary.DarkGrey

                panel.add_label("[ Empty Slot ]", row=top_row + 1, align="center", fg_color=fg_empty)
                panel.add_label("Ready to record journey", row=top_row + 2, align="center", fg_color=fg_ready)

            panel.set_all_dirty()

    def _render_quit_modal(self) -> list[str]:
        lines: list[str] = []
        lines.append("")

        panel = self.quit_modal_panel
        panel.ui_element_listing.clear()
        panel.border_draw_colors = [ColorLibrary.AppleRedLight for _ in range(8)]
        panel.setup_title("Quit Game?", color=ColorLibrary.AppleRedLight, align="left")

        panel.add_label("Any unsaved progress will be lost!", row=14, col=panel.inner_left + 3, fg_color=ColorLibrary.AppleYellowLight)

        opts = ["Return to Title Screen", "Quit to Desktop", "Cancel / Keep Playing"]
        bg = "\033[48;2;25;55;85m"
        for idx, opt in enumerate(opts):
            is_cur = (idx == self.quit_option_cursor and self.focus_mode in ("SUBMENU", "MODAL"))
            if is_cur:
                base_content = f"    ❱ {opt}"
                pad_len = max(0, panel.inner_width - visible_width(base_content))
                styled = f"{bg}    \033[1;36m❱ \033[1;37m{opt}{' ' * pad_len}\033[0m"
                panel.add_label(styled, row=16 + idx, col=panel.inner_left)
            else:
                panel.add_label(f"      {opt}", row=16 + idx, col=panel.inner_left, fg_color=ColorLibrary.DarkGrey)

        panel.set_all_dirty()
        p_lines = panel.render_lines()
        for pl in p_lines:
            lines.append(f"  {pl}  ")
        return lines

    def _format_status_hints(self) -> str:
        if self.focus_mode == "CATEGORIES":
            if self.CATEGORIES[self.category_idx] == "Status":
                return "\033[33m[↑↓] Select Category  [◄►] Switch Hero  [Esc/M] Resume Map\033[0m"
            return "\033[33m[↑↓] Select Category  [◄►] Switch Hero  [Enter] Confirm  [Esc/M] Resume Map\033[0m"
        elif self.focus_mode == "MODAL":
            return "\033[33m[Arrows] Select Option  [Enter] Confirm  [Esc] Cancel\033[0m"
        elif self.CATEGORIES[self.category_idx] == "Equipment":
            if self.equip_drawer_open:
                return "\033[33m[↑↓] Choose Gear to Equip  [Enter] Confirm  [Esc] Back\033[0m"
            return "\033[33m[↑↓] Select Slot  [◄►] Switch Hero  [Enter] Browse Gear  [Esc] Back\033[0m"
        elif self.CATEGORIES[self.category_idx] == "Items":
            return "\033[33m[↑↓] Select Item  [Tab] Category Filter  [Enter] Item Action  [Esc] Back\033[0m"
        elif self.CATEGORIES[self.category_idx] == "Save":
            return "\033[33m[↑↓] Select Slot  [Enter] Save Game  [Esc] Back\033[0m"
        elif self.CATEGORIES[self.category_idx] == "Quests":
            return "\033[33m[↑↓] Navigate Quests  [Enter] Expand/Collapse  [T/Space] Track  [Esc] Up\033[0m"
        return "\033[33m[↑↓] Navigate  [◄►] Switch Hero  [Enter] Select  [Esc] Back\033[0m"

    # -------------------------------------------------------------------------
    # Quest Submenu: Structured Accordion
    # -------------------------------------------------------------------------
    def _build_flat_quest_tree(self) -> list[dict]:
        """
        Flattens the hierarchical questlines -> quests -> steps structure into
        an accordion list based on which nodes are in self.quest_expanded_nodes.
        Completed quests and steps sink to the bottom.
        """
        qm = getattr(self.party, "quest_manager", None)
        if not qm:
            return []

        flat_nodes: list[dict] = []
        tracked_ql, tracked_q, tracked_s = qm.get_tracked_artifact()

        # 1. Storyline Questline (always at top)
        story_expanded = qm.storyline.questline_id in self.quest_expanded_nodes
        story_tracked = (tracked_ql is qm.storyline)
        flat_nodes.append({
            "id": qm.storyline.questline_id,
            "type": "QUESTLINE",
            "depth": 0,
            "obj": qm.storyline,
            "parent_ql": qm.storyline,
            "parent_q": None,
            "is_expanded": story_expanded,
            "is_tracked": story_tracked,
            "is_completed": qm.storyline.is_completed,
            "title": qm.storyline.title,
            "is_storyline": True,
        })

        if story_expanded:
            sorted_quests = sorted(qm.storyline.quests, key=lambda q: 1 if q.is_completed else 0)
            for q in sorted_quests:
                q_expanded = q.quest_id in self.quest_expanded_nodes
                q_tracked = (story_tracked and tracked_q is q)
                flat_nodes.append({
                    "id": q.quest_id,
                    "type": "QUEST",
                    "depth": 1,
                    "obj": q,
                    "parent_ql": qm.storyline,
                    "parent_q": q,
                    "is_expanded": q_expanded,
                    "is_tracked": q_tracked,
                    "is_completed": q.is_completed,
                    "title": q.title,
                    "is_storyline": True,
                })
                if q_expanded:
                    sorted_steps = sorted(q.steps, key=lambda s: 1 if s.is_completed else 0)
                    for s in sorted_steps:
                        s_tracked = (q_tracked and tracked_s is s)
                        flat_nodes.append({
                            "id": s.step_id,
                            "type": "STEP",
                            "depth": 2,
                            "obj": s,
                            "parent_ql": qm.storyline,
                            "parent_q": q,
                            "is_expanded": False,
                            "is_tracked": s_tracked,
                            "is_completed": s.is_completed,
                            "title": s.description,
                            "is_storyline": True,
                        })

        # 2. Side Questlines (incomplete first, completed at bottom)
        sorted_side_qls = sorted(qm.side_questlines, key=lambda sq: 1 if sq.is_completed else 0)
        for sq in sorted_side_qls:
            sq_expanded = sq.questline_id in self.quest_expanded_nodes
            sq_tracked = (tracked_ql is sq)
            flat_nodes.append({
                "id": sq.questline_id,
                "type": "QUESTLINE",
                "depth": 0,
                "obj": sq,
                "parent_ql": sq,
                "parent_q": None,
                "is_expanded": sq_expanded,
                "is_tracked": sq_tracked,
                "is_completed": sq.is_completed,
                "title": sq.title,
                "is_storyline": False,
            })

            if sq_expanded:
                sorted_quests = sorted(sq.quests, key=lambda q: 1 if q.is_completed else 0)
                for q in sorted_quests:
                    q_expanded = q.quest_id in self.quest_expanded_nodes
                    q_tracked = (sq_tracked and tracked_q is q)
                    flat_nodes.append({
                        "id": q.quest_id,
                        "type": "QUEST",
                        "depth": 1,
                        "obj": q,
                        "parent_ql": sq,
                        "parent_q": q,
                        "is_expanded": q_expanded,
                        "is_tracked": q_tracked,
                        "is_completed": q.is_completed,
                        "title": q.title,
                        "is_storyline": False,
                    })
                    if q_expanded:
                        sorted_steps = sorted(q.steps, key=lambda s: 1 if s.is_completed else 0)
                        for s in sorted_steps:
                            s_tracked = (q_tracked and tracked_s is s)
                            flat_nodes.append({
                                "id": s.step_id,
                                "type": "STEP",
                                "depth": 2,
                                "obj": s,
                                "parent_ql": sq,
                                "parent_q": q,
                                "is_expanded": False,
                                "is_tracked": s_tracked,
                                "is_completed": s.is_completed,
                                "title": s.description,
                                "is_storyline": False,
                            })

        return flat_nodes

    def _handle_quests_input(self, key_info: Any) -> None:
        qm = getattr(self.party, "quest_manager", None)
        if not qm:
            return

        flat_tree = self._build_flat_quest_tree()
        if not flat_tree:
            return

        self.quest_cursor = max(0, min(len(flat_tree) - 1, self.quest_cursor))

        if key_info.key == KeyCode.UP:
            if self.quest_cursor > 0:
                self.quest_cursor -= 1
        elif key_info.key == KeyCode.DOWN:
            if self.quest_cursor < len(flat_tree) - 1:
                self.quest_cursor += 1
        elif key_info.key in (KeyCode.ENTER, KeyCode.NONE) and (key_info.key == KeyCode.ENTER or key_info.char in ("\r", "\n")):
            node = flat_tree[self.quest_cursor]
            if node["type"] in ("QUESTLINE", "QUEST"):
                node_id = node["id"]
                if node_id in self.quest_expanded_nodes:
                    self.quest_expanded_nodes.remove(node_id)
                else:
                    self.quest_expanded_nodes.add(node_id)
            elif node["type"] == "STEP":
                s_obj = node["obj"]
                p_q = node["parent_q"]
                p_ql = node["parent_ql"]
                qm.set_tracked_artifact(
                    questline_id=p_ql.questline_id,
                    quest_id=p_q.quest_id if p_q else None,
                    step_id=s_obj.step_id,
                )
                self._set_banner(f"📌 Tracking: {s_obj.description}")

        elif key_info.char in ("t", "T", " "):
            node = flat_tree[self.quest_cursor]
            p_ql = node["parent_ql"]
            p_q = node.get("parent_q")
            if node["type"] == "QUESTLINE":
                qm.set_tracked_artifact(questline_id=p_ql.questline_id)
                self._set_banner(f"📌 Tracking: {p_ql.title}")
            elif node["type"] == "QUEST":
                qm.set_tracked_artifact(
                    questline_id=p_ql.questline_id,
                    quest_id=node["obj"].quest_id,
                )
                self._set_banner(f"📌 Tracking: {node['title']}")
            elif node["type"] == "STEP":
                qm.set_tracked_artifact(
                    questline_id=p_ql.questline_id,
                    quest_id=p_q.quest_id if p_q else None,
                    step_id=node["obj"].step_id,
                )
                self._set_banner(f"📌 Tracking: {node['title']}")

    def _handle_quests_escape(self) -> bool:
        """
        Hierarchical collapse / ascending escape logic:
        - If on a Step: jumps to parent Quest and collapses it.
        - If on an expanded Quest: collapses it.
        - If on a collapsed Quest: jumps to parent Questline and collapses it.
        - If on an expanded Questline: collapses it.
        - If on a collapsed Questline: returns False (allowing escape to Categories rail).
        """
        flat_tree = self._build_flat_quest_tree()
        if not flat_tree or self.quest_cursor >= len(flat_tree):
            return False

        node = flat_tree[self.quest_cursor]
        node_type = node["type"]

        if node_type == "STEP":
            p_q = node["parent_q"]
            if p_q and p_q.quest_id in self.quest_expanded_nodes:
                self.quest_expanded_nodes.remove(p_q.quest_id)
                for idx, n in enumerate(self._build_flat_quest_tree()):
                    if n["id"] == p_q.quest_id:
                        self.quest_cursor = idx
                        break
                return True

        elif node_type == "QUEST":
            if node["id"] in self.quest_expanded_nodes:
                self.quest_expanded_nodes.remove(node["id"])
                return True
            else:
                p_ql = node["parent_ql"]
                if p_ql and p_ql.questline_id in self.quest_expanded_nodes:
                    self.quest_expanded_nodes.remove(p_ql.questline_id)
                    for idx, n in enumerate(self._build_flat_quest_tree()):
                        if n["id"] == p_ql.questline_id:
                            self.quest_cursor = idx
                            break
                    return True

        elif node_type == "QUESTLINE":
            if node["id"] in self.quest_expanded_nodes:
                self.quest_expanded_nodes.remove(node["id"])
                return True

        return False

    def _render_quests_submenu(self) -> list[str]:
        lines: list[str] = []
        lines.append(" \033[1;36mQuest Journal\033[0m ────────── \033[90m[Enter]Toggle [T]Track [Esc]Up\033[0m")
        lines.append("")

        qm = getattr(self.party, "quest_manager", None)
        if not qm:
            lines.append(" \033[90mNo active quest log found.\033[0m")
            return lines

        flat_tree = self._build_flat_quest_tree()
        if not flat_tree:
            lines.append(" \033[90mNo quests recorded in journal.\033[0m")
            return lines

        total_items = len(flat_tree)
        self.quest_cursor = max(0, min(total_items - 1, self.quest_cursor))
        max_visible = 30
        if self.quest_cursor >= self.quest_scroll + max_visible:
            self.quest_scroll = self.quest_cursor - max_visible + 1
        elif self.quest_cursor < self.quest_scroll:
            self.quest_scroll = self.quest_cursor
        self.quest_scroll = max(0, min(self.quest_scroll, max(0, total_items - max_visible)))

        visible_nodes = flat_tree[self.quest_scroll : self.quest_scroll + max_visible]

        for rel_idx, node in enumerate(visible_nodes):
            abs_idx = self.quest_scroll + rel_idx
            is_cur = (abs_idx == self.quest_cursor and self.focus_mode == "SUBMENU")
            cursor_str = "\033[1;36m►\033[0m " if is_cur else "  "

            is_tracked = node["is_tracked"]
            is_completed = node["is_completed"]
            tracked_tag = " \033[1;32m[📌 TRACKED]\033[0m" if is_tracked else ""

            if node["type"] == "QUESTLINE":
                expand_glyph = "▼ " if node["is_expanded"] else "► "
                if node["is_storyline"]:
                    badge = "\033[1;33m★ STORY:\033[0m"
                    title_col = "\033[1;37m" if is_cur else "\033[37m"
                else:
                    badge = "\033[1;36m◇ SIDE:\033[0m"
                    title_col = "\033[1;37m" if is_cur else "\033[36m"

                comp_tag = " \033[32m[Completed ✔]\033[0m" if is_completed else ""
                line = f"{cursor_str}{expand_glyph}{badge} {title_col}{node['title']}\033[0m{comp_tag}{tracked_tag}"

            elif node["type"] == "QUEST":
                indent = "    "
                expand_glyph = "▼ " if node["is_expanded"] else "► "
                q_obj = node["obj"]
                step_done_cnt = sum(1 for s in q_obj.steps if s.is_completed)
                progress_str = f"({step_done_cnt}/{len(q_obj.steps)})"
                if is_completed:
                    comp_tag = " \033[32m[✔ Completed]\033[0m"
                    title_col = "\033[90m"
                else:
                    comp_tag = f" \033[33m{progress_str}\033[0m"
                    title_col = "\033[1;37m" if is_cur else "\033[37m"

                line = f"{cursor_str}{indent}{expand_glyph}{title_col}{node['title']}\033[0m{comp_tag}{tracked_tag}"

            else:  # STEP
                indent = "      "
                s_obj = node["obj"]
                bullet = "• "
                if is_completed:
                    status_str = "\033[32m[✔ Done]\033[0m"
                    title_col = "\033[90m"
                else:
                    status_str = f"\033[33m[{s_obj.formatted_progress}]\033[0m"
                    title_col = "\033[37m" if not is_cur else "\033[1;37m"

                line = f"{cursor_str}{indent}{bullet}{title_col}{node['title']}\033[0m {status_str}{tracked_tag}"

            lines.append(line)

        # Truncate lines to RIGHT_WIDTH if needed
        trimmed_lines = []
        for l in lines:
            if visible_width(l) > self.RIGHT_WIDTH:
                trimmed_lines.append(truncate_ansi(l, self.RIGHT_WIDTH))
            else:
                trimmed_lines.append(l)

        return trimmed_lines
