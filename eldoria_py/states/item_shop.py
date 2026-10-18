"""
GSItemShopScreen: Full-featured Item and Herbalist Shop subsystem for Eldoria.
Canvas: 80x28 box layout with mathematical column budgets:
- Left pane (Cols 1..37): Shop Inventory / Party Sell Listing (name and price only)
- Center divider: 1 column
- Right pane (Cols 39..80):
  - Top: Item Details, Category badge, Price/Resale, Bag Count (X/99)
  - Specifications: Target Scope, Usability context, Effect details
  - Description: Word-wrapped lore and medicinal function
  - Herbalist's Field Tip: Atmospheric survival advice
- Bulk purchase & sale modal
- Tracks purchase history to return 'PURCHASED' or 'LOOKED' result to the Shopkeeper POI.
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
from ..combat.stats import TargetScope
from ..combat.items import ConsumableItem, ItemType, ItemEffectType, ITEM_CATALOG, get_item
from ..combat.entities import Party
from ..procgen.npc import NPC, DialogCategory, generate_item_shop_inventory
from ..ui.panel import UIPanel
from ..ui.container import UIContainer
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


class GSItemShopScreen(SMState):
    """
    80x28 Item/Herbalist Shop Screen.
    Provides browsing, curative and battle consumable purchasing, 20% resale, and bulk transactions.
    """

    TOTAL_WIDTH: int = 80
    LEFT_WIDTH: int = 34
    RIGHT_WIDTH: int = 43
    TOTAL_ROWS: int = 28

    def __init__(self) -> None:
        super().__init__("GSItemShopScreen")
        self.party: Optional[Party] = None
        self.shopkeeper_npc: Optional[NPC] = None
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

        # Formal UIPanel component for Herbalist's Field Tip
        self.tip_panel: UIPanel = UIPanel(
            left_top=ATCoordinates(1, 1),
            right_bottom=ATCoordinates(4, 42),
            title="Herbalist's Field Tip",
            has_border=True,
        )
        self.tip_panel.current_window_designs = dict(UIContainer.WINDOW_DESIGN_SQUARE)
        self.tip_panel.border_draw_colors = [TrueColor(0x71, 0x80, 0x96) for _ in range(8)]
        self.tip_panel.setup_title("Herbalist's Field Tip", color=ColorLibrary.White, align="left")

    def configure_shop(
        self,
        party: Party,
        shopkeeper_npc: NPC,
        noise_map_screen: Any = None,
        region_code: int = 1,
    ) -> None:
        """Configures the shop with active party, NPC, and region."""
        self.party = party
        self.shopkeeper_npc = shopkeeper_npc
        self.noise_map_screen = noise_map_screen
        self.region_code = max(1, min(9, int(region_code)))

        self.mode = "BUY"
        self.cursor_buy = 0
        self.scroll_buy = 0
        self.cursor_sell = 0
        self.scroll_sell = 0
        self.items_bought_count = 0
        self.feedback_msg = "Welcome! Use [Enter] to buy or [B] for bulk."
        self.feedback_color = "\033[38;2;72;187;120m"
        self.bulk_modal_active = False
        self.bulk_qty = 1

        # Ensure herbalist inventory is populated and migrated from legacy formats
        if not self.shopkeeper_npc.shop_inventory or not any("tier" in entry for entry in self.shopkeeper_npc.shop_inventory):
            self.shopkeeper_npc.shop_inventory = generate_item_shop_inventory(region_tier=self.region_code)

    def _get_buy_items(self) -> List[Dict[str, Any]]:
        """Returns the list of valid consumable shop wares."""
        if not self.shopkeeper_npc or not self.shopkeeper_npc.shop_inventory:
            return []
        items = []
        for entry in self.shopkeeper_npc.shop_inventory:
            name = entry.get("item_id", entry.get("name", ""))
            c_item = get_item(name)
            if c_item is not None and c_item.item_type not in (ItemType.EQUIPMENT, ItemType.KEY_ITEM):
                items.append({
                    "name": c_item.name,
                    "price": c_item.price,
                    "sell_price": c_item.sell_price,
                    "item": c_item,
                })
        return items

    def _get_sell_items(self) -> List[Dict[str, Any]]:
        """Returns sellable consumable/remedy items currently held in party inventory."""
        if not self.party:
            return []
        sell_items = []
        for entry in self.party.inventory:
            if entry.get("type") == "equipment":
                continue
            item_id = entry.get("item_id", entry.get("name", ""))
            qty = entry.get("qty", 1)
            c_item = get_item(item_id)
            if c_item is not None and c_item.item_type not in (ItemType.EQUIPMENT, ItemType.KEY_ITEM):
                sell_items.append({
                    "name": c_item.name,
                    "price": c_item.sell_price,
                    "qty": qty,
                    "item": c_item,
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

    def get_highlighted_item(self) -> Optional[ConsumableItem]:
        """Returns the ConsumableItem corresponding to current active selection."""
        items = self.current_items
        if 0 <= self.active_cursor < len(items):
            return items[self.active_cursor].get("item")
        return None

    # -------------------------------------------------------------------------
    # Lifecycle
    # -------------------------------------------------------------------------
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
        visible_rows = 17

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
            self.feedback_color = "\033[38;2;72;187;120m"
            return
        elif key_info.key == KeyCode.LEFT:
            if self.mode != "BUY":
                self.mode = "BUY"
                self.active_cursor = 0
                self.active_scroll = 0
                self.feedback_msg = "Switched to BUY mode."
                self.feedback_color = "\033[38;2;72;187;120m"
            return
        elif key_info.key == KeyCode.RIGHT:
            if self.mode != "SELL":
                self.mode = "SELL"
                self.active_cursor = 0
                self.active_scroll = 0
                self.feedback_msg = "Switched to SELL mode."
                self.feedback_color = "\033[38;2;72;187;120m"
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

        # Enter / Space: Single Buy / Sell
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
        c_item = self.get_highlighted_item()
        if c_item is None or self.party is None:
            self.bulk_modal_active = False
            return

        if self.mode == "BUY":
            max_affordable = self.party.gold // c_item.price if c_item.price > 0 else 99
            cur_qty = self.party.get_item_count(c_item.name)
            max_qty = max(1, min(max_affordable, 99 - cur_qty))
        else:
            max_qty = max(1, self.party.get_item_count(c_item.name))

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
        c_item = self.get_highlighted_item()
        if c_item is None or self.party is None:
            return
        if qty <= 0:
            return

        total_cost = c_item.price * qty
        if self.party.gold < total_cost:
            self.feedback_msg = f"Not enough gold! Needs {total_cost} G."
            self.feedback_color = "\033[1;31m"
            return

        cur_qty = self.party.get_item_count(c_item.name)
        if cur_qty + qty > 99:
            can_add = 99 - cur_qty
            if can_add <= 0:
                self.feedback_msg = f"Inventory full for {c_item.name} (Max 99)!"
                self.feedback_color = "\033[1;31m"
                return
            qty = can_add
            total_cost = c_item.price * qty

        if self.party.spend_gold(total_cost):
            added = self.party.add_item(c_item.name, qty=qty, item_type="consumable")
            self.items_bought_count += added
            self.feedback_msg = f"Purchased {added}x {c_item.name} for {total_cost} G."
            self.feedback_color = "\033[1;32m"
            try:
                get_audio_engine(autostart_device=False).play_sfx("Resources/SFX/Inn Coin.mp3")
            except Exception:
                pass
        else:
            self.feedback_msg = "Transaction failed."
            self.feedback_color = "\033[1;31m"

    def _sell_item(self, qty: int = 1) -> None:
        c_item = self.get_highlighted_item()
        if c_item is None or self.party is None:
            return
        cur_qty = self.party.get_item_count(c_item.name)
        if cur_qty <= 0:
            self.feedback_msg = f"You do not have any {c_item.name} to sell."
            self.feedback_color = "\033[1;31m"
            return

        actual_qty = min(qty, cur_qty)
        unit_sell_price = c_item.sell_price
        total_payout = unit_sell_price * actual_qty

        if self.party.remove_item(c_item.name, actual_qty):
            self.party.add_gold(total_payout)
            self.feedback_msg = f"Sold {actual_qty}x {c_item.name} for {total_payout} G."
            self.feedback_color = "\033[1;32m"
            # Adjust cursor if needed
            items = self.current_items
            if self.active_cursor >= len(items):
                self.active_cursor = max(0, len(items) - 1)
        else:
            self.feedback_msg = f"Failed to remove {c_item.name} from inventory."
            self.feedback_color = "\033[1;31m"

    def _exit_shop(self, context: Context, core: Any) -> None:
        """Transitions back to map navigation screen and reports shop exit result."""
        result = "PURCHASED" if self.items_bought_count > 0 else "LOOKED"
        if self.noise_map_screen is not None and hasattr(self.noise_map_screen, "handle_shop_exit"):
            self.noise_map_screen.handle_shop_exit(npc=self.shopkeeper_npc, result=result)

        if context:
            keys = context.get(SMState.ContextKeysPressed)
            if isinstance(keys, list):
                keys.clear()

        if core and hasattr(core, "game_state"):
            core.game_state.trigger("ToNoiseMap", context)

    # -------------------------------------------------------------------------
    # Frame Assembly & Rendering
    # -------------------------------------------------------------------------
    def generate_frame_lines(self) -> List[str]:
        """Builds all 28 rows of the Item Shop Screen buffer."""
        lines: List[str] = []
        shop_title = f"{self.shopkeeper_npc.name}'s Apothecary & Remedies" if self.shopkeeper_npc else "Apothecary & Remedies"
        gold_val = self.party.gold if self.party else 0
        gold_str = f"Gold: \033[1;33m{gold_val:,} G\033[0m"

        # Row 1: Header
        h_left = f" \033[1;38;2;72;187;120m🌿 {shop_title}\033[0m "
        h_right = f" {gold_str} "
        h_fill = "═" * max(0, self.TOTAL_WIDTH - 2 - visible_width(h_left) - visible_width(h_right))
        lines.append(f"\033[38;2;160;174;192m╔{h_left}{h_fill}{h_right}╗\033[0m")

        # Row 2: Mode Tabs & Controls
        buy_tag = "\033[1;30;48;2;72;187;120m [BUY REMEDIES] \033[0m" if self.mode == "BUY" else " \033[90m[BUY REMEDIES]\033[0m "
        sell_tag = "\033[1;30;48;2;72;187;120m [SELL ITEMS] \033[0m" if self.mode == "SELL" else " \033[90m[SELL ITEMS]\033[0m "
        tab_row = f"  {buy_tag}  {sell_tag}"
        tab_row_full = _pad_cell(tab_row, self.TOTAL_WIDTH - 2)
        lines.append(f"\033[38;2;160;174;192m║\033[0m{tab_row_full}\033[38;2;160;174;192m║\033[0m")

        # Row 3: Horizontal Splitter between Tabs and Panes
        s_left = "─" * self.LEFT_WIDTH
        s_right = "─" * self.RIGHT_WIDTH
        lines.append(f"\033[38;2;160;174;192m╟{s_left}┬{s_right}╢\033[0m")

        # Rows 4..25: Left Pane (Listing) and Right Pane (Details & Properties)
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
        lines.append(f"\033[38;2;160;174;192m╚{left_f}{hints}{right_f}╝\033[0m")

        # Overlay bulk modal if active
        if self.bulk_modal_active:
            lines = self._overlay_bulk_modal(lines)

        return lines[: self.TOTAL_ROWS]

    def _render_left_pane(self) -> List[str]:
        """Renders the left pane: Inventory listings showing only name and price."""
        lines: List[str] = []
        pane_w = self.LEFT_WIDTH
        items = self.current_items

        # Sub-header
        title = " APOTHECARY STOCK" if self.mode == "BUY" else " SATCHEL ITEMS"
        lines.append(_pad_cell(f"\033[1;32m{title}\033[0m", pane_w))

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
                    line_str = f"\033[1;38;2;72;187;120m{cursor}\033[1;37m{name_padded}\033[1;33m{price_str}\033[0m "
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
        """Renders item details, specifications, description, and herbalist advice."""
        lines: List[str] = []
        pane_w = self.RIGHT_WIDTH
        c_item = self.get_highlighted_item()

        if c_item is not None:
            # Badge selection based on effect type
            if c_item.effect_type == ItemEffectType.RESTORE_HP:
                badge = "\033[1;32m[HP Curative]\033[0m"
            elif c_item.effect_type == ItemEffectType.RESTORE_MP:
                badge = "\033[1;36m[MP Tonic]\033[0m"
            elif c_item.effect_type == ItemEffectType.RESTORE_ALL_HP:
                badge = "\033[1;35m[Miraculous]\033[0m"
            elif c_item.effect_type == ItemEffectType.REVIVE:
                badge = "\033[1;33m[Revival Herb]\033[0m"
            elif c_item.effect_type == ItemEffectType.CURE_STATUS:
                badge = "\033[1;32m[Status Remedy]\033[0m"
            elif c_item.effect_type in (ItemEffectType.DAMAGE_PHYSICAL, ItemEffectType.DAMAGE_MAGICAL):
                badge = "\033[1;31m[Alchemical Weapon]\033[0m"
            elif c_item.effect_type == ItemEffectType.STATUS_EFFECT:
                badge = "\033[1;35m[Infliction Powder]\033[0m"
            elif c_item.effect_type == ItemEffectType.LOCATE_CAVE:
                badge = "\033[1;36m[Spiritual Conch]\033[0m"
            elif c_item.effect_type == ItemEffectType.TEACH_ACTION:
                badge = "\033[1;35m[Technique Manual]\033[0m"
            else:
                badge = "\033[1;34m[Consumable]\033[0m"

            # Row 0: Name & Badge
            lines.append(_pad_cell(f" {badge} \033[1;37m{c_item.name}\033[0m", pane_w))

            # Row 1: Pricing Breakdown
            pricing_str = f"  \033[33mPrice:\033[0m {c_item.price} G   \033[33mResale:\033[0m {c_item.sell_price} G"
            lines.append(_pad_cell(pricing_str, pane_w))

            # Row 2: Held in bag
            held_qty = self.party.get_item_count(c_item.name) if self.party else 0
            bag_color = "\033[1;32m" if held_qty > 0 else "\033[90m"
            lines.append(_pad_cell(f"  \033[36mIn Bag:\033[0m {bag_color}{held_qty}\033[0m / 99", pane_w))

            # Row 3: Divider
            lines.append(_pad_cell("  " + "─" * (pane_w - 4), pane_w))

            # Row 4: Target Scope
            scope_map = {
                TargetScope.SINGLE_ALLY: "Single Ally",
                TargetScope.ALL_ALLIES: "All Allies (Party)",
                TargetScope.SINGLE_ENEMY: "Single Enemy",
                TargetScope.ALL_ENEMIES: "All Enemies",
                TargetScope.SELF: "Self Only",
                TargetScope.NONE: "Special",
            }
            scope_str = scope_map.get(c_item.target_scope, "Single Ally")
            lines.append(_pad_cell(f"  \033[36mTarget:\033[0m  \033[1;37m{scope_str}\033[0m", pane_w))

            # Row 5: Usability Scope
            if c_item.usable_in_field and c_item.usable_in_battle:
                usable_str = "Field & Battle"
            elif c_item.usable_in_battle:
                usable_str = "Battle Only"
            elif c_item.usable_in_field:
                usable_str = "Field Only"
            else:
                usable_str = "Passive / Special"
            lines.append(_pad_cell(f"  \033[36mUsable:\033[0m  \033[1;37m{usable_str}\033[0m", pane_w))

            # Row 6: Effect Power / Potency
            if c_item.effect_type == ItemEffectType.RESTORE_HP:
                effect_str = f"Restores {c_item.power} HP"
            elif c_item.effect_type == ItemEffectType.RESTORE_MP:
                effect_str = f"Restores {c_item.power} MP"
            elif c_item.effect_type == ItemEffectType.RESTORE_ALL_HP:
                effect_str = "Full Recovery of HP & MP"
            elif c_item.effect_type == ItemEffectType.REVIVE:
                effect_str = f"Revives fallen ally with {c_item.power} HP"
            elif c_item.effect_type == ItemEffectType.CURE_STATUS:
                effect_str = "Cleanses negative status ailments"
            elif c_item.effect_type == ItemEffectType.DAMAGE_PHYSICAL:
                effect_str = f"Deals {c_item.power} physical damage"
            elif c_item.effect_type == ItemEffectType.DAMAGE_MAGICAL:
                effect_str = f"Deals {c_item.power} magical elemental damage"
            elif c_item.effect_type == ItemEffectType.STATUS_EFFECT:
                effect_str = "Inflicts debilitating status condition"
            elif c_item.effect_type == ItemEffectType.TEACH_ACTION:
                effect_str = f"Permanently teaches {c_item.teaches_action_name or 'technique'}"
            else:
                effect_str = "Special restorative effect"
            lines.append(_pad_cell(f"  \033[36mEffect:\033[0m  \033[1;37m{effect_str}\033[0m", pane_w))

            # Row 7: Divider
            lines.append(_pad_cell("  " + "─" * (pane_w - 4), pane_w))

            # Row 8: Description Header
            lines.append(_pad_cell("  \033[1;37mDescription:\033[0m", pane_w))

            # Rows 9..12: Description lines
            desc_wrapped = wrap_text(c_item.description, pane_w - 6)
            for d_idx in range(4):
                if d_idx < len(desc_wrapped):
                    lines.append(_pad_cell(f"   \033[90m{desc_wrapped[d_idx]}\033[0m", pane_w))
                else:
                    lines.append(" " * pane_w)

            # Rows 13..17: Herbalist's Field Tip Box (Rendered via formal UIPanel)
            lines.append(" " * pane_w)
            panel = self.tip_panel
            panel.ui_element_listing.clear()
            panel.border_draw_colors = [ColorLibrary.SlateGrey for _ in range(8)]
            panel.setup_title("Herbalist's Field Tip", color=ColorLibrary.White, align="left")

            tip_line1, tip_line2 = self._get_item_tip(c_item)
            max_tip_w = max(1, panel.inner_width - 4)
            panel.add_label(tip_line1[:max_tip_w], row=2, col=3, fg_color=ColorLibrary.AppleGreenLight)
            if tip_line2:
                panel.add_label(tip_line2[:max_tip_w], row=3, col=3, fg_color=ColorLibrary.AppleGreenLight)

            panel.set_all_dirty()
            for pl in panel.render_lines():
                lines.append(_pad_cell(f" {pl}", pane_w))

        else:
            lines.append(_pad_cell(" \033[90mNo item selected\033[0m", pane_w))
            while len(lines) < 22:
                lines.append(" " * pane_w)

        # Pad right pane to 22 lines
        while len(lines) < 22:
            lines.append(" " * pane_w)
        return lines

    def _get_item_tip(self, item: ConsumableItem) -> Tuple[str, str]:
        """Provides atmospheric survival tips based on item type."""
        if item.effect_type == ItemEffectType.RESTORE_HP:
            return ("Keep draughts ready before descending", "into monster-infested caverns!")
        elif item.effect_type == ItemEffectType.RESTORE_MP:
            return ("Mana does not replenish automatically;", "carry tonics when roaming the wilds.")
        elif item.effect_type == ItemEffectType.CURE_STATUS:
            return ("Poison will not fade after battle!", "Carry remedies for damp hollows.")
        elif item.effect_type == ItemEffectType.REVIVE:
            return ("Fallen heroes gain no experience.", "Revive comrades quickly in battle.")
        elif item.effect_type == ItemEffectType.RESTORE_ALL_HP:
            return ("Miraculous elixirs are rare gifts;", "save them for titanic dungeon bosses!")
        elif item.effect_type in (ItemEffectType.DAMAGE_PHYSICAL, ItemEffectType.DAMAGE_MAGICAL):
            return ("Alchemical flasks strike through armor", "and exploit elemental weaknesses.")
        elif item.effect_type == ItemEffectType.LOCATE_CAVE:
            return ("Blow the conch upon the overworld", "to divine where hidden caves dwell.")
        else:
            return ("Natural herbs harvested fresh from", "the Eldorian mountain meadows.")

    def _overlay_bulk_modal(self, lines: List[str]) -> List[str]:
        """Renders an interactive bulk quantity selector modal in the center of the screen."""
        c_item = self.get_highlighted_item()
        if c_item is None or self.party is None:
            return lines

        is_buy = (self.mode == "BUY")
        unit_price = c_item.price if is_buy else c_item.sell_price
        total_price = unit_price * self.bulk_qty
        gold_after = (self.party.gold - total_price) if is_buy else (self.party.gold + total_price)
        action_verb = "PURCHASE" if is_buy else "SELL"

        box_w = 46
        modal_lines = [
            f"┌{'─' * (box_w - 2)}┐",
            f"│{_pad_cell(f' BULK {action_verb} ', box_w - 2, align='center')}│",
            f"├{'─' * (box_w - 2)}┤",
            f"│{_pad_cell(f' Item: \033[1;37m{c_item.name}\033[0m ({unit_price} G each)', box_w - 2)}│",
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
                prefix = truncate_ansi(orig, start_col)
                prefix_pad = _pad_cell(prefix, start_col)
                suffix_start = start_col + box_w
                suffix = ""
                orig_clean = strip_ansi(orig)
                if len(orig_clean) > suffix_start:
                    suffix = orig_clean[suffix_start:]
                out_lines[target_r] = f"{prefix_pad}\033[1;38;2;72;187;120m{m_line}\033[0m{suffix}"

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
