"""
GSEquipShopScreen: Full-featured Armorer and Equipment Shop subsystem for Eldoria.
Canvas: 80x28 box layout with mathematical column budgets:
- Left pane (Cols 1..35): Shop Inventory / Party Sell Listing (name and price only)
- Center divider: 1 column
- Right pane (Cols 37..80):
  - Top: Item Details & Description
  - Bottom: Summarized Party Member Displays with dynamic +/- stat change previews
- Bulk purchase & sale modal
- Tracks purchase history to return 'PURCHASED' or 'LOOKED' result to the Armorer POI.
"""

from __future__ import annotations
import math
from typing import Any, Dict, List, Optional, Tuple

from ..core.context import Context
from ..core.fsm import SMState
from ..terminal.ansi import ATCoordinates, ATControlSequences
from ..terminal.box import clear_buffer_tail, strip_ansi, truncate_ansi, visible_width, wrap_text
from ..terminal.color import TrueColor, ColorLibrary
from ..terminal.input import KeyCode, KeyEvent
from ..terminal.screen import TerminalScreen
from ..combat.stats import StatId, EquipmentSlot
from ..combat.equipment import BattleEquipment, EQUIPMENT_CATALOG, get_equipment
from ..combat.entities import PartyMember, Party
from ..combat.portrait import Gender
from ..procgen.npc import NPC, DialogCategory, generate_armorer_inventory
from ..audio.sound_engine import get_audio_engine


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


class GSEquipShopScreen(SMState):
    """
    80x28 Armorer Shop Screen.
    Provides browsing, stat diff comparison, single & bulk purchasing, and 20% resale.
    """

    TOTAL_WIDTH: int = 80
    LEFT_WIDTH: int = 34
    RIGHT_WIDTH: int = 43
    TOTAL_ROWS: int = 28

    def __init__(self) -> None:
        super().__init__("GSEquipShopScreen")
        self.party: Optional[Party] = None
        self.armorer_npc: Optional[NPC] = None
        self.noise_map_screen: Any = None
        self.region_code: int = 1

        # Session tracking
        self.mode: str = "BUY"  # "BUY" or "SELL"
        self.cursor_buy: int = 0
        self.scroll_buy: int = 0
        self.cursor_sell: int = 0
        self.scroll_sell: int = 0

        self.items_bought_count: int = 0
        self.feedback_msg: str = ""
        self.feedback_color: str = "\033[1;32m"  # Green default

        # Bulk modal
        self.bulk_modal_active: bool = False
        self.bulk_qty: int = 1

    def configure_shop(
        self,
        party: Party,
        armorer_npc: NPC,
        noise_map_screen: Any = None,
        region_code: int = 1,
    ) -> None:
        """Configures the shop with active party, NPC, and region."""
        self.party = party
        self.armorer_npc = armorer_npc
        self.noise_map_screen = noise_map_screen
        self.region_code = max(1, min(9, int(region_code)))

        self.mode = "BUY"
        self.cursor_buy = 0
        self.scroll_buy = 0
        self.cursor_sell = 0
        self.scroll_sell = 0
        self.items_bought_count = 0
        self.feedback_msg = "Welcome! Use [Enter] to buy or [B] for bulk."
        self.feedback_color = "\033[38;2;237;137;54m"
        self.bulk_modal_active = False
        self.bulk_qty = 1

        # Ensure armorer inventory is populated
        if not self.armorer_npc.shop_inventory:
            self.armorer_npc.shop_inventory = generate_armorer_inventory(region_tier=self.region_code)

    def _get_buy_items(self) -> List[Dict[str, Any]]:
        """Returns the list of valid equippable shop wares."""
        if not self.armorer_npc or not self.armorer_npc.shop_inventory:
            return []
        items = []
        for entry in self.armorer_npc.shop_inventory:
            name = entry.get("item_id", entry.get("name", ""))
            eq = get_equipment(name)
            if eq is not None and not eq.is_relic:
                items.append({
                    "name": eq.name,
                    "price": eq.price,
                    "equipment": eq,
                })
        return items

    def _get_sell_items(self) -> List[Dict[str, Any]]:
        """Returns equippable items currently held in party inventory."""
        if not self.party:
            return []
        sell_items = []
        for entry in self.party.inventory:
            item_id = entry.get("item_id", entry.get("name", ""))
            qty = entry.get("qty", 1)
            eq = get_equipment(item_id)
            if eq is not None:
                sell_items.append({
                    "name": eq.name,
                    "price": eq.sell_price,
                    "qty": qty,
                    "equipment": eq,
                })
        return sell_items

    @property
    def current_items(self) -> List[Dict[str, Any]]:
        if self.mode == "BUY":
            return self._get_buy_items()
        return self._get_sell_items()

    @property
    def active_cursor(self) -> int:
        return self.cursor_buy if self.mode == "BUY" else self.cursor_sell

    @active_cursor.setter
    def active_cursor(self, val: int) -> None:
        if self.mode == "BUY":
            self.cursor_buy = val
        else:
            self.cursor_sell = val

    @property
    def active_scroll(self) -> int:
        return self.scroll_buy if self.mode == "BUY" else self.scroll_sell

    @active_scroll.setter
    def active_scroll(self, val: int) -> None:
        if self.mode == "BUY":
            self.scroll_buy = val
        else:
            self.scroll_sell = val

    def get_highlighted_equipment(self) -> Optional[BattleEquipment]:
        items = self.current_items
        if 0 <= self.active_cursor < len(items):
            return items[self.active_cursor]["equipment"]
        return None

    def enter(self, context: Context) -> None:
        super().enter(context)
        TerminalScreen.write(ATControlSequences.CursorHide)
        TerminalScreen.clear_screen()
        TerminalScreen.flush()
        self._render()

    def exit(self, context: Context) -> None:
        super().exit(context)
        TerminalScreen.clear_screen()
        TerminalScreen.flush()

    # -------------------------------------------------------------------------
    # Input Handling
    # -------------------------------------------------------------------------
    def update(self, context: Context) -> None:
        keys_pressed = context.get(SMState.ContextKeysPressed)
        core = context.get(SMState.ContextEldoriaCore)
        if not isinstance(keys_pressed, list) or len(keys_pressed) == 0:
            self._render()
            return

        key_info = keys_pressed.pop(0)

        if self.bulk_modal_active:
            self._handle_bulk_input(key_info)
        else:
            self._handle_normal_input(key_info, context, core)

        self._render()

    def _handle_normal_input(self, key_info: KeyEvent, context: Context, core: Any) -> None:
        items = self.current_items
        max_idx = max(0, len(items) - 1)
        visible_rows = 14

        # Exit
        if key_info.key == KeyCode.ESCAPE or key_info.char in ("q", "Q"):
            self._exit_shop(context, core)
            return

        # Tab or Left / Right: Switch / Toggle Buy / Sell mode
        if key_info.key == KeyCode.TAB or key_info.char == "\t":
            self.mode = "SELL" if self.mode == "BUY" else "BUY"
            self.active_cursor = 0
            self.active_scroll = 0
            self.feedback_msg = f"Switched to {self.mode} mode."
            self.feedback_color = "\033[38;2;237;137;54m"
            return
        elif key_info.key == KeyCode.LEFT:
            if self.mode != "BUY":
                self.mode = "BUY"
                self.active_cursor = 0
                self.active_scroll = 0
                self.feedback_msg = "Switched to BUY mode."
                self.feedback_color = "\033[38;2;237;137;54m"
            return
        elif key_info.key == KeyCode.RIGHT:
            if self.mode != "SELL":
                self.mode = "SELL"
                self.active_cursor = 0
                self.active_scroll = 0
                self.feedback_msg = "Switched to SELL mode."
                self.feedback_color = "\033[38;2;237;137;54m"
            return

        # Up / Down
        if key_info.key == KeyCode.UP:
            if self.active_cursor > 0:
                self.active_cursor -= 1
                if self.active_cursor < self.active_scroll:
                    self.active_scroll = self.active_cursor
            elif len(items) > 0:
                self.active_cursor = max_idx
                self.active_scroll = max(0, max_idx - visible_rows + 1)
        elif key_info.key == KeyCode.DOWN:
            if self.active_cursor < max_idx:
                self.active_cursor += 1
                if self.active_cursor >= self.active_scroll + visible_rows:
                    self.active_scroll = self.active_cursor - visible_rows + 1
            elif len(items) > 0:
                self.active_cursor = 0
                self.active_scroll = 0

        # Enter: Single Buy / Sell
        elif key_info.key in (KeyCode.ENTER, KeyCode.SPACE) or key_info.char in ("\r", "\n", " "):
            if self.mode == "BUY":
                self._buy_item(qty=1)
            else:
                self._sell_item(qty=1)

        # 'B' or 'b': Open Bulk Modal
        elif key_info.char in ("b", "B"):
            if items:
                self.bulk_qty = 1
                self.bulk_modal_active = True

    def _handle_bulk_input(self, key_info: KeyEvent) -> None:
        eq = self.get_highlighted_equipment()
        if eq is None or self.party is None:
            self.bulk_modal_active = False
            return

        if self.mode == "BUY":
            max_affordable = self.party.gold // eq.price if eq.price > 0 else 99
            cur_qty = self.party.get_item_count(eq.name)
            max_qty = max(1, min(max_affordable, 99 - cur_qty))
        else:
            max_qty = max(1, self.party.get_item_count(eq.name))

        if key_info.key == KeyCode.ESCAPE or key_info.char in ("b", "B", "q", "Q"):
            self.bulk_modal_active = False
            return

        if key_info.key == KeyCode.LEFT:
            self.bulk_qty = max(1, self.bulk_qty - 1)
        elif key_info.key == KeyCode.RIGHT:
            self.bulk_qty = min(max_qty, self.bulk_qty + 1)
        elif key_info.key == KeyCode.UP:
            self.bulk_qty = min(max_qty, self.bulk_qty + 10)
        elif key_info.key == KeyCode.DOWN:
            self.bulk_qty = max(1, self.bulk_qty - 10)
        elif key_info.char in ("m", "M"):
            self.bulk_qty = max_qty
        elif key_info.key in (KeyCode.ENTER, KeyCode.SPACE) or key_info.char in ("\r", "\n"):
            self.bulk_modal_active = False
            if self.mode == "BUY":
                self._buy_item(qty=self.bulk_qty)
            else:
                self._sell_item(qty=self.bulk_qty)

    def _buy_item(self, qty: int = 1) -> None:
        eq = self.get_highlighted_equipment()
        if eq is None or self.party is None:
            return
        if qty <= 0:
            return

        total_cost = eq.price * qty
        if self.party.gold < total_cost:
            self.feedback_msg = f"Not enough gold! Needs {total_cost} G."
            self.feedback_color = "\033[1;31m"
            return

        cur_qty = self.party.get_item_count(eq.name)
        if cur_qty + qty > 99:
            can_add = 99 - cur_qty
            if can_add <= 0:
                self.feedback_msg = f"Inventory full for {eq.name} (Max 99)!"
                self.feedback_color = "\033[1;31m"
                return
            qty = can_add
            total_cost = eq.price * qty

        if self.party.spend_gold(total_cost):
            added = self.party.add_item(eq.name, qty=qty, item_type="equipment")
            self.items_bought_count += added
            self.feedback_msg = f"Purchased {added}x {eq.name} for {total_cost} G."
            self.feedback_color = "\033[1;32m"
            try:
                get_audio_engine(autostart_device=False).play_sfx("Resources/SFX/Inn Coin.mp3")
            except Exception:
                pass
        else:
            self.feedback_msg = "Transaction failed."
            self.feedback_color = "\033[1;31m"

    def _sell_item(self, qty: int = 1) -> None:
        eq = self.get_highlighted_equipment()
        if eq is None or self.party is None:
            return
        cur_qty = self.party.get_item_count(eq.name)
        if cur_qty <= 0:
            self.feedback_msg = f"You do not have any {eq.name} to sell."
            self.feedback_color = "\033[1;31m"
            return

        actual_qty = min(qty, cur_qty)
        unit_sell_price = eq.sell_price
        total_payout = unit_sell_price * actual_qty

        if self.party.remove_item(eq.name, actual_qty):
            self.party.add_gold(total_payout)
            self.feedback_msg = f"Sold {actual_qty}x {eq.name} for {total_payout} G."
            self.feedback_color = "\033[1;32m"
            # Adjust cursor if needed
            items = self.current_items
            if self.active_cursor >= len(items):
                self.active_cursor = max(0, len(items) - 1)
        else:
            self.feedback_msg = f"Failed to remove {eq.name} from inventory."
            self.feedback_color = "\033[1;31m"

    def _exit_shop(self, context: Context, core: Any) -> None:
        """Transitions back to map navigation screen and reports shop exit result."""
        result = "PURCHASED" if self.items_bought_count > 0 else "LOOKED"
        if self.noise_map_screen is not None and hasattr(self.noise_map_screen, "handle_shop_exit"):
            self.noise_map_screen.handle_shop_exit(npc=self.armorer_npc, result=result)

        if context:
            keys = context.get(SMState.ContextKeysPressed)
            if isinstance(keys, list):
                keys.clear()

        if core and hasattr(core, "game_state"):
            core.game_state.trigger("ToNoiseMap", context)

    # -------------------------------------------------------------------------
    # Frame Rendering (80x28)
    # -------------------------------------------------------------------------
    def generate_frame_lines(self) -> List[str]:
        """Generates all lines for the 80x28 screen buffer."""
        lines: List[str] = []
        shop_title = f"{self.armorer_npc.name}'s Forge & Armory" if self.armorer_npc else "Forge & Armory"
        gold_val = self.party.gold if self.party else 0
        gold_str = f"Gold: \033[1;33m{gold_val:,} G\033[0m"

        # Row 1: Header
        h_left = f" \033[1;38;2;237;137;54m⚒ {shop_title}\033[0m "
        h_right = f" {gold_str} "
        h_fill = "═" * max(0, self.TOTAL_WIDTH - 2 - visible_width(h_left) - visible_width(h_right))
        lines.append(f"\033[38;2;160;174;192m╔{h_left}{h_fill}{h_right}╗\033[0m")

        # Row 2: Mode Tabs & Controls
        buy_tag = "\033[1;30;48;2;237;137;54m [BUY WARES] \033[0m" if self.mode == "BUY" else " \033[90m[BUY WARES]\033[0m "
        sell_tag = "\033[1;30;48;2;237;137;54m [SELL EQUIPMENT] \033[0m" if self.mode == "SELL" else " \033[90m[SELL EQUIPMENT]\033[0m "
        tab_row = f"  {buy_tag}  {sell_tag}"
        tab_row_full = _pad_cell(tab_row, self.TOTAL_WIDTH - 2)
        lines.append(f"\033[38;2;160;174;192m║\033[0m{tab_row_full}\033[38;2;160;174;192m║\033[0m")

        # Row 3: Horizontal Splitter between Tabs and Panes
        s_left = "─" * self.LEFT_WIDTH
        s_right = "─" * self.RIGHT_WIDTH
        lines.append(f"\033[38;2;160;174;192m╟{s_left}┬{s_right}╢\033[0m")

        # Rows 4..25: Left Pane (Listing) and Right Pane (Details & Party Preview)
        left_lines = self._render_left_pane()
        right_lines = self._render_right_pane()
        pane_height = 22
        for r in range(pane_height):
            l_str = left_lines[r] if r < len(left_lines) else " " * self.LEFT_WIDTH
            r_str = right_lines[r] if r < len(right_lines) else " " * self.RIGHT_WIDTH
            lines.append(f"\033[38;2;160;174;192m║\033[0m{l_str}\033[38;2;160;174;192m│\033[0m{r_str}\033[38;2;160;174;192m║\033[0m")

        # Row 26: Bottom Splitter
        b_left = "─" * self.LEFT_WIDTH
        b_right = "─" * self.RIGHT_WIDTH
        lines.append(f"\033[38;2;160;174;192m╟{b_left}┴{b_right}╢\033[0m")

        # Row 27: Status / Feedback Line
        fb_padded = _pad_cell(f" {self.feedback_color}{self.feedback_msg}\033[0m", self.TOTAL_WIDTH - 2)
        lines.append(f"\033[38;2;160;174;192m║\033[0m{fb_padded}\033[38;2;160;174;192m║\033[0m")

        # Row 28: Bottom Border & Key Hints
        hints = " [▲/▼] Browse  [◄/►/Tab] Mode  [Enter] Buy/Sell  [B] Bulk  [Esc] Leave "
        hint_fill = "═" * max(0, self.TOTAL_WIDTH - 2 - visible_width(hints))
        left_f = hint_fill[:2]
        right_f = hint_fill[2:]
        lines.append(f"\033[38;2;160;174;192m╚{left_f}\033[90m{hints}\033[38;2;160;174;192m{right_f}╝\033[0m")

        # Overlay bulk modal if active
        if self.bulk_modal_active:
            lines = self._overlay_bulk_modal(lines)

        return lines

    def _render_left_pane(self) -> List[str]:
        """Renders the left pane: Inventory listings showing only name and price."""
        lines: List[str] = []
        pane_w = self.LEFT_WIDTH
        items = self.current_items

        # Sub-header
        title = " SHOP INVENTORY" if self.mode == "BUY" else " PARTY EQUIPMENT"
        lines.append(_pad_cell(f"\033[1;36m{title}\033[0m", pane_w))

        col_header = "  Item Name                Price " if self.mode == "BUY" else "  Item Name (Qty)          Resale"
        lines.append(_pad_cell(f"\033[90m{col_header}\033[0m", pane_w))
        lines.append(_pad_cell("  " + "─" * (pane_w - 4), pane_w))

        visible_count = 17
        scroll = self.active_scroll
        displayed_items = items[scroll : scroll + visible_count]

        for i in range(visible_count):
            item_idx = scroll + i
            if item_idx < len(items):
                item = items[item_idx]
                is_selected = (item_idx == self.active_cursor)
                cursor = "▶ " if is_selected else "  "
                name_raw = item["name"]
                if self.mode == "SELL" and item.get("qty", 1) > 1:
                    name_raw += f" (x{item['qty']})"

                price_str = f"{item['price']} G"
                name_width = pane_w - 2 - len(cursor) - len(price_str) - 1
                name_padded = _pad_cell(name_raw, name_width)

                if is_selected:
                    line_str = f"\033[1;38;2;237;137;54m{cursor}\033[1;37m{name_padded}\033[1;33m{price_str}\033[0m "
                else:
                    line_str = f"{cursor}{name_padded}\033[33m{price_str}\033[0m "
                lines.append(_pad_cell(line_str, pane_w))
            else:
                lines.append(" " * pane_w)

        # Scroll indicator line (21st row)
        up_ind = "▲" if scroll > 0 else " "
        down_ind = "▼" if scroll + visible_count < len(items) else " "
        count_str = f"[{self.active_cursor + 1}/{len(items)}]" if items else "[0/0]"
        scroll_line = f"  {up_ind} {down_ind}                   \033[90m{count_str}\033[0m"
        lines.append(_pad_cell(scroll_line, pane_w))

        # Pad to 22 lines
        while len(lines) < 22:
            lines.append(" " * pane_w)
        return lines

    def _render_right_pane(self) -> List[str]:
        """Renders item details (top) and party member preview with +/- stat diffs (bottom)."""
        lines: List[str] = []
        pane_w = self.RIGHT_WIDTH
        eq = self.get_highlighted_equipment()

        # --- Top Section: Item Details (Rows 0..6) ---
        if eq is not None:
            slot_badge = f"\033[1;36m[{eq.slot.value}]\033[0m"
            if eq.target_gender == Gender.MALE:
                gender_badge = "\033[1;36m[♂ Male Only]\033[0m"
            elif eq.target_gender == Gender.FEMALE:
                gender_badge = "\033[1;35m[♀ Female Only]\033[0m"
            else:
                gender_badge = "\033[90m[Unisex]\033[0m"
            lines.append(_pad_cell(f" {slot_badge} \033[1;37m{eq.name}\033[0m {gender_badge}", pane_w))
            # Description
            wrapped_desc = wrap_text(eq.description, pane_w - 4)
            desc_line1 = wrapped_desc[0] if len(wrapped_desc) > 0 else ""
            desc_line2 = wrapped_desc[1] if len(wrapped_desc) > 1 else ""
            lines.append(_pad_cell(f"  \033[90m{desc_line1}\033[0m", pane_w))
            lines.append(_pad_cell(f"  \033[90m{desc_line2}\033[0m", pane_w))

            # Action unlocked
            if eq.unlocked_action_name:
                lines.append(_pad_cell(f"  \033[35mSkill: {eq.unlocked_action_name}\033[0m", pane_w))
            else:
                lines.append(_pad_cell("  \033[90mSkill: None\033[0m", pane_w))

            # Stat bonuses summary
            stats_str = ", ".join(f"{k.value[:3].upper()} {v:+d}" for k, v in eq.stat_bonuses.items())
            lines.append(_pad_cell(f"  \033[33mModifiers:\033[0m {stats_str if stats_str else 'None'}", pane_w))
        else:
            lines.append(_pad_cell(" \033[90mNo item selected\033[0m", pane_w))
            lines.append(" " * pane_w)
            lines.append(" " * pane_w)
            lines.append(" " * pane_w)
            lines.append(" " * pane_w)

        # Divider between Item Details and Party Preview
        lines.append(_pad_cell("─" * (pane_w - 1), pane_w))

        # --- Bottom Section: Summarized Party Member Displays (Rows 7..21) ---
        lines.append(_pad_cell(" \033[1;36mPARTY COMPARISON & STAT PREVIEW\033[0m", pane_w))

        if self.party and self.party.members:
            for m in self.party.members[:5]:
                cur_eq = m.equipment.get(eq.slot) if eq is not None else None
                cur_eq_name = cur_eq.name if cur_eq else "None"
                can_equip_item = m.can_equip(eq) if eq is not None else True

                # Row 1: Member Name & Current Equipment in Slot
                name_tag = f"\033[1;37m{m.name}\033[0m"

                if not can_equip_item and eq is not None:
                    eq_tag = f"\033[90m[Cur: {truncate_ansi(cur_eq_name, 12)}]\033[0m"
                    incompat_badge = "\033[1;31m[Incompat]\033[0m"
                    lines.append(_pad_cell(f"  {name_tag}  {eq_tag} {incompat_badge}", pane_w))

                    if eq.target_gender == Gender.FEMALE:
                        req_str = "[Incompatible: ♀ Only]"
                    elif eq.target_gender == Gender.MALE:
                        req_str = "[Incompatible: ♂ Only]"
                    else:
                        req_str = "[Incompatible]"
                    lines.append(_pad_cell(f"   \033[1;31m{req_str}\033[0m", pane_w))
                else:
                    eq_tag = f"\033[90m[Cur: {truncate_ansi(cur_eq_name, 16)}]\033[0m"
                    lines.append(_pad_cell(f"  {name_tag}  {eq_tag}", pane_w))

                    # Row 2: Summarized Stats with Dynamic +/- Diffs
                    stat_parts: List[str] = []
                    key_stats = [
                        (StatId.ATTACK, "ATK"),
                        (StatId.DEFENSE, "DEF"),
                        (StatId.MAGIC_ATTACK, "MATK"),
                        (StatId.MAGIC_DEFENSE, "MDEF"),
                        (StatId.SPEED, "SPD"),
                    ]

                    for stat_id, abbr in key_stats:
                        prop = m.stats.get(stat_id)
                        cur_val = prop.total if prop else 0
                        if eq is not None:
                            cur_b = cur_eq.get_bonus(stat_id) if cur_eq else 0
                            new_b = eq.get_bonus(stat_id)
                            delta = new_b - cur_b
                            if delta > 0:
                                stat_parts.append(f"{abbr}:\033[1;32m+{delta}\033[0m")
                            elif delta < 0:
                                stat_parts.append(f"{abbr}:\033[1;31m{delta}\033[0m")
                        # If stat didn't change and we don't have too many, show cur_val
                        # Only highlight stats that actually have changes or relevance

                    # Also check HP / MP bonuses
                    if eq is not None:
                        hp_cur_b = cur_eq.get_bonus(StatId.HIT_POINTS) if cur_eq else 0
                        hp_new_b = eq.get_bonus(StatId.HIT_POINTS)
                        hp_delta = hp_new_b - hp_cur_b
                        if hp_delta > 0:
                            stat_parts.insert(0, f"HP:\033[1;32m+{hp_delta}\033[0m")
                        elif hp_delta < 0:
                            stat_parts.insert(0, f"HP:\033[1;31m{hp_delta}\033[0m")

                        luk_cur_b = cur_eq.get_bonus(StatId.LUCK) if cur_eq else 0
                        luk_new_b = eq.get_bonus(StatId.LUCK)
                        luk_delta = luk_new_b - luk_cur_b
                        if luk_delta > 0:
                            stat_parts.append(f"LUK:\033[1;32m+{luk_delta}\033[0m")
                        elif luk_delta < 0:
                            stat_parts.append(f"LUK:\033[1;31m{luk_delta}\033[0m")

                    if stat_parts:
                        diff_row = "   " + "  ".join(stat_parts)
                    else:
                        diff_row = "   \033[90m(No stat changes)\033[0m"
                    lines.append(_pad_cell(diff_row, pane_w))

                # Separator between members
                if len(self.party.members) <= 4:
                    lines.append(_pad_cell("   " + "·" * (pane_w - 6), pane_w))
        else:
            lines.append(_pad_cell(" \033[90mNo party members found.\033[0m", pane_w))

        # Pad right pane to 22 lines
        while len(lines) < 22:
            lines.append(" " * pane_w)
        return lines

    def _overlay_bulk_modal(self, lines: List[str]) -> List[str]:
        """Renders an interactive bulk quantity selector modal in the center of the screen."""
        eq = self.get_highlighted_equipment()
        if eq is None or self.party is None:
            return lines

        is_buy = (self.mode == "BUY")
        unit_price = eq.price if is_buy else eq.sell_price
        total_price = unit_price * self.bulk_qty
        gold_after = (self.party.gold - total_price) if is_buy else (self.party.gold + total_price)
        action_verb = "PURCHASE" if is_buy else "SELL"

        box_w = 46
        modal_lines = [
            f"┌{'─' * (box_w - 2)}┐",
            f"│{_pad_cell(f' BULK {action_verb} ', box_w - 2, align='center')}│",
            f"├{'─' * (box_w - 2)}┤",
            f"│{_pad_cell(f' Item: \033[1;37m{eq.name}\033[0m ({unit_price} G each)', box_w - 2)}│",
            f"│{_pad_cell('', box_w - 2)}│",
            f"│{_pad_cell(f' Quantity:   \033[1;33m◄  {self.bulk_qty:02d}  ►\033[0m', box_w - 2, align='center')}│",
            f"│{_pad_cell(f' Total {action_verb.capitalize()}: \033[1;33m{total_price:,} G\033[0m', box_w - 2, align='center')}│",
            f"│{_pad_cell(f' Gold After: {gold_after:,} G', box_w - 2, align='center')}│",
            f"│{_pad_cell('', box_w - 2)}│",
            f"│{_pad_cell(' [◄/►] -1/+1   [▲/▼] -10/+10   [M] Max ', box_w - 2, align='center')}│",
            f"│{_pad_cell(' [Enter] Confirm        [Esc] Cancel ', box_w - 2, align='center')}│",
            f"└{'─' * (box_w - 2)}┘",
        ]

        start_row = 7
        start_col = (self.TOTAL_WIDTH - box_w) // 2

        out_lines = list(lines)
        for idx, m_line in enumerate(modal_lines):
            target_r = start_row + idx
            if target_r < len(out_lines):
                orig = out_lines[target_r]
                # Replace segment
                # Strip ANSI from target slice region
                prefix = truncate_ansi(orig, start_col)
                prefix_pad = _pad_cell(prefix, start_col)
                suffix_start = start_col + box_w
                # Get tail after suffix_start
                suffix = ""
                orig_clean = strip_ansi(orig)
                if len(orig_clean) > suffix_start:
                    suffix = orig_clean[suffix_start:]
                out_lines[target_r] = f"{prefix_pad}\033[1;38;2;237;137;54m{m_line}\033[0m{suffix}"

        return out_lines

    def _render(self) -> None:
        """Atomic write to TerminalScreen."""
        lines = self.generate_frame_lines()
        out: List[str] = [ATControlSequences.DrawOptimizeOn]
        for idx, line in enumerate(lines):
            out.append(ATCoordinates(1 + idx, 1).to_ansi())
            out.append(line)
        out.append(clear_buffer_tail(len(lines) + 1, 45))
        out.append(ATControlSequences.DrawOptimizeOff)
        try:
            TerminalScreen.write("".join(out))
            TerminalScreen.flush()
        except Exception:
            pass
