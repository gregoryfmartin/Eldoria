"""
GSTitleScreen: Production title screen state using UIPanel component architecture.
Features canonical menu options, modal dialog views, and developer hotkeys.
Standardized around Eldoria's maximum supported buffer dimensions (80x40).
"""

from __future__ import annotations
from typing import List, Optional

from ..core.context import Context
from ..core.fsm import SMState
from ..core.save_manager import SaveManager, SaveSlotHeader
from ..terminal.ansi import ATCoordinates, ATControlSequences, ATDecoration
from ..terminal.color import ColorLibrary, dim_ansi
from ..terminal.input import KeyCode
from ..terminal.screen import TerminalScreen
from ..terminal.box import clear_buffer_tail, truncate_ansi, visible_width
from ..ui.panel import UIPanel
from ..ui.elements.menu import UIMenu


class GSTitleScreen(SMState):
    """Production Title Screen state managing primary game start and options."""

    MENU_ITEMS = [
        "New Game",
        "Load Game",
        "Options",
        "Credits",
        "Exit",
    ]

    def __init__(
        self,
        screen_width: int = 80,
        screen_height: int = 24,
        dev_mode: bool = True,
        fade_in_duration: float = 0.45,
    ) -> None:
        super().__init__("GSTitleScreen")
        self.screen_width: int = screen_width
        self.screen_height: int = screen_height
        self.dev_mode: bool = dev_mode
        self.fade_in_duration: float = fade_in_duration
        self.is_fading_in: bool = False
        self.fade_in_elapsed: float = 0.0

        self.active_dialog: Optional[str] = None  # None, "LOAD", "OPTIONS", "CREDITS"
        self.notice_message: str = ""
        self.dialog_dirty: bool = False

        # Save / Load service and state
        self.save_manager = SaveManager()
        self.load_slot_idx: int = 0
        self.load_headers: List[Optional[SaveSlotHeader]] = []
        self.delete_confirm_slot: Optional[int] = None

        # Options preferences
        from eldoria_py.audio import get_audio_engine
        self.audio_engine = get_audio_engine()
        self.opt_sfx_enabled: bool = not self.audio_engine.is_muted
        self.opt_fast_text: bool = True

        self._current_context: Optional[Context] = None
        self._current_core = None

        panel_bottom_row = min(self.screen_height - 2, 22)

        # Master Outer Window Panel (rows 1..22)
        self.title_panel = UIPanel(
            left_top=ATCoordinates(1, 1),
            right_bottom=ATCoordinates(panel_bottom_row, self.screen_width),
            title="── E L D O R I A ──",
            has_border=True,
        )
        self.title_panel.setup_footer("[↑/↓]Navigate  [Enter]Select  [Q]Quit", ColorLibrary.AppleYellowLight)

        # Banner Labels (rows 3 and 4)
        self.banner_title = self.title_panel.add_label(
            "⚔   THE REALMS OF ELDORIA   ⚔",
            row=3,
            align="center",
            fg_color=ColorLibrary.White,
            decorations=ATDecoration(bold=True),
        )
        self.banner_subtitle = self.title_panel.add_label(
            "Chronicles of the Broken Rune",
            row=4,
            align="center",
            fg_color=ColorLibrary.DarkGrey,
        )

        # Dividers at row 6 and row 20
        self.divider_top = self.title_panel.add_divider(row=6)
        self.divider_bottom = self.title_panel.add_divider(row=20)

        # Hint Label at row 21
        hint_text = (
            "Dev Hotkeys: [M]Map  [B]Combat  [U]UI  [C]Cans"
            if self.dev_mode
            else "Use [↑/↓] or [1-5] to choose, [Enter] to select"
        )
        self.hint_label = self.title_panel.add_label(
            hint_text,
            row=21,
            align="center",
            fg_color=ColorLibrary.DarkGrey,
        )

        self.title_panel.activate()

        # UIMenu (managing granular UIMenuItems in rows 8, 10, 12, 14, 16)
        self.menu = UIMenu(parent=self.title_panel, start_row=8, row_spacing=2, align="center")
        self.menu.add_item("New Game", action=lambda: self._execute_menu_action("New Game"))
        self.menu.add_item("Load Game", action=lambda: self._execute_menu_action("Load Game"))
        self.menu.add_item("Options", action=lambda: self._execute_menu_action("Options"))
        self.menu.add_item("Credits", action=lambda: self._execute_menu_action("Credits"))
        self.menu.add_item("Exit", action=lambda: self._execute_menu_action("Exit"))
        self.menu.activate()

        # Content Area sub-panels for dialog overlays (rows 7..19, borderless)
        content_right = self.screen_width - 1
        self.load_panel = UIPanel(
            left_top=ATCoordinates(7, 2),
            right_bottom=ATCoordinates(19, content_right),
            has_border=False,
        )
        self.load_panel.add_label("── Load Adventure ──", row=7, align="center", fg_color=ColorLibrary.White, decorations=ATDecoration(bold=True))
        slot_col = max(self.load_panel.inner_left + 2, (self.load_panel.inner_width - 66) // 2 + self.load_panel.inner_left)
        self.slot1_lbl_a = self.load_panel.add_label("[Slot 1] ··· Empty Slot ···", row=9, col=slot_col, fg_color=ColorLibrary.DarkGrey)
        self.slot1_lbl_b = self.load_panel.add_label("     No adventure recorded", row=10, col=slot_col, fg_color=ColorLibrary.DarkGrey)
        self.slot2_lbl_a = self.load_panel.add_label("[Slot 2] ··· Empty Slot ···", row=12, col=slot_col, fg_color=ColorLibrary.DarkGrey)
        self.slot2_lbl_b = self.load_panel.add_label("     No adventure recorded", row=13, col=slot_col, fg_color=ColorLibrary.DarkGrey)
        self.slot3_lbl_a = self.load_panel.add_label("[Slot 3] ··· Empty Slot ···", row=15, col=slot_col, fg_color=ColorLibrary.DarkGrey)
        self.slot3_lbl_b = self.load_panel.add_label("     No adventure recorded", row=16, col=slot_col, fg_color=ColorLibrary.DarkGrey)
        self.load_hint_lbl = self.load_panel.add_label("[↑/↓]Navigate  [Enter]Load  [D]Delete  [Esc]Return", row=18, align="center", fg_color=ColorLibrary.AppleCyanLight, decorations=ATDecoration(bold=True))

        self.options_panel = UIPanel(
            left_top=ATCoordinates(7, 2),
            right_bottom=ATCoordinates(19, content_right),
            has_border=False,
        )
        self.options_panel.add_label("── Engine Settings ──", row=8, align="center", fg_color=ColorLibrary.White, decorations=ATDecoration(bold=True))
        self.opt_sfx_lbl = self.options_panel.add_label(self._sfx_text(), row=10, align="center", fg_color=ColorLibrary.White)
        self.opt_fast_lbl = self.options_panel.add_label(self._fast_text(), row=11, align="center", fg_color=ColorLibrary.White)
        self.opt_vol_lbl = self.options_panel.add_label(self._volume_text(), row=12, align="center", fg_color=ColorLibrary.White)
        self.options_panel.add_label("  [4] Graphics Protocol:  ANSI 24-bit TrueColor  ", row=13, align="center", fg_color=ColorLibrary.AppleCyanLight)
        self.options_panel.add_label("Press [1]/[2] to toggle, [-]/[+] for volume.", row=15, align="center", fg_color=ColorLibrary.DarkGrey)
        self.options_panel.add_label("[Press Enter or Esc to return]", row=17, align="center", fg_color=ColorLibrary.AppleCyanLight, decorations=ATDecoration(bold=True))

        self.credits_panel = UIPanel(
            left_top=ATCoordinates(7, 2),
            right_bottom=ATCoordinates(19, content_right),
            has_border=False,
        )
        self.credits_panel.add_label("── Eldoria Project Credits ──", row=7, align="center", fg_color=ColorLibrary.White, decorations=ATDecoration(bold=True))
        self.credits_panel.add_label("Original Concept & Architecture:", row=9, align="center", fg_color=ColorLibrary.AppleCyanLight)
        self.credits_panel.add_label("Not Gary (Gregory F Martin)", row=10, align="center", fg_color=ColorLibrary.White)
        self.credits_panel.add_label("Programming:", row=12, align="center", fg_color=ColorLibrary.AppleCyanLight)
        self.credits_panel.add_label("Not Gary; Antigravity", row=13, align="center", fg_color=ColorLibrary.White)
        self.credits_panel.add_label("Original FastNoiseLite:", row=15, align="center", fg_color=ColorLibrary.AppleCyanLight)
        self.credits_panel.add_label("Auburn", row=16, align="center", fg_color=ColorLibrary.White)
        # self.credits_panel.add_label("FastNoiseLite • Procedural Maps • NvN Combat", row=15, align="center", fg_color=ColorLibrary.DarkGrey)
        self.credits_panel.add_label("[Press Enter or Esc to return]", row=18, align="center", fg_color=ColorLibrary.AppleCyanLight, decorations=ATDecoration(bold=True))

    @property
    def selected_idx(self) -> int:
        return self.menu.selected_index

    @selected_idx.setter
    def selected_idx(self, val: int) -> None:
        self.menu.select_index(val)

    def _sfx_text(self) -> str:
        status = "[ON] " if self.opt_sfx_enabled else "[OFF]"
        return f"  [1] Audio & Sound FX:   {status}  "

    def _fast_text(self) -> str:
        status = "[ON] " if self.opt_fast_text else "[OFF]"
        return f"  [2] Instant Text Speed: {status}  "

    def _volume_text(self) -> str:
        vol_pct = int(round(self.audio_engine.get_master_volume() * 100))
        return f"  [3] Master Volume:      [ {vol_pct:>3}% ] ([-] / [+])  "

    def _update_options_labels(self) -> None:
        self.opt_sfx_lbl.set_user_data(self._sfx_text())
        self.opt_fast_lbl.set_user_data(self._fast_text())
        self.opt_vol_lbl.set_user_data(self._volume_text())

    def _refresh_load_panel(self) -> None:
        """Refreshes the 3-slot preview labels from disk headers with bounds-safe formatting."""
        self.load_headers = self.save_manager.list_save_slots(3)
        slot_col = max(self.load_panel.inner_left + 2, (self.load_panel.inner_width - 66) // 2 + self.load_panel.inner_left)
        max_w = self.load_panel.inner_right - slot_col + 1

        for i in range(3):
            header = self.load_headers[i] if i < len(self.load_headers) else None
            is_sel = (i == self.load_slot_idx)
            prefix = "▶ " if is_sel else "  "
            lbl_a = getattr(self, f"slot{i+1}_lbl_a")
            lbl_b = getattr(self, f"slot{i+1}_lbl_b")

            lbl_a.coordinates = ATCoordinates(lbl_a.coordinates.row, slot_col)
            lbl_b.coordinates = ATCoordinates(lbl_b.coordinates.row, slot_col)

            if header is not None:
                if max_w < 65:
                    line_a = f"{prefix}[Slot {i+1}] ★ {header.party_leader_name} ({header.world_size_label})"
                    line_b = f"     {header.current_location} ─ {header.formatted_playtime()}"
                else:
                    line_a = f"{prefix}[Slot {i+1}] ★ {header.party_leader_name} (Lv. {header.party_leader_level} {header.party_leader_class}) ─ {header.world_size_label}"
                    line_b = f"     {header.current_location} ─ Time: {header.formatted_playtime()} ─ {header.timestamp}"

                lbl_a.set_user_data(truncate_ansi(line_a, max_w))
                lbl_a.fg_color = ColorLibrary.AppleGreenLight if is_sel else ColorLibrary.White
                lbl_b.set_user_data(truncate_ansi(line_b, max_w))
                lbl_b.fg_color = ColorLibrary.White if is_sel else ColorLibrary.DarkGrey
            else:
                line_a = f"{prefix}[Slot {i+1}] ··· Empty Slot ···"
                line_b = "     No adventure recorded"
                lbl_a.set_user_data(truncate_ansi(line_a, max_w))
                lbl_a.fg_color = ColorLibrary.AppleYellowLight if is_sel else ColorLibrary.DarkGrey
                lbl_b.set_user_data(truncate_ansi(line_b, max_w))
                lbl_b.fg_color = ColorLibrary.DarkGrey

        if self.delete_confirm_slot is not None:
            raw_hint = f"⚠ Delete Slot {self.delete_confirm_slot}? Press [Y]/[N]"
            hint_fg = ColorLibrary.AppleRedLight
        elif self.notice_message:
            raw_hint = self.notice_message
            hint_fg = ColorLibrary.AppleYellowLight
        else:
            raw_hint = "[↑/↓]Select  [Enter]Load  [D]Del  [Esc]Return" if max_w < 65 else "[↑/↓]Navigate  [Enter]Load  [D]Delete  [Esc]Return"
            hint_fg = ColorLibrary.AppleCyanLight

        hint_w = min(visible_width(raw_hint), self.load_panel.inner_width)
        hint_col = max(self.load_panel.inner_left, (self.load_panel.inner_width - hint_w) // 2 + self.load_panel.inner_left)
        max_hint_w = self.load_panel.inner_right - hint_col + 1
        self.load_hint_lbl.coordinates = ATCoordinates(18, hint_col)
        self.load_hint_lbl.set_user_data(truncate_ansi(raw_hint, max_hint_w))
        self.load_hint_lbl.fg_color = hint_fg

        self.load_panel.set_all_dirty()

    def enter(self, context: Context) -> None:
        super().enter(context)
        self.selected_idx = 0
        self.active_dialog = None
        self.notice_message = ""
        self.dialog_dirty = False
        self._current_context = context
        self._current_core = context.get(SMState.ContextEldoriaCore)

        if self.fade_in_duration > 0:
            self.is_fading_in = True
            self.fade_in_elapsed = 0.0
        else:
            self.is_fading_in = False

        TerminalScreen.write(ATControlSequences.CursorHide)
        TerminalScreen.clear_screen()
        TerminalScreen.flush()
        self.title_panel.set_all_dirty()
        self.menu.set_all_dirty()

    def exit(self, context: Context) -> None:
        super().exit(context)
        TerminalScreen.clear_screen()
        TerminalScreen.flush()

    def update(self, context: Context) -> None:
        super().update(context)
        self._current_context = context
        keys_pressed = context.get(SMState.ContextKeysPressed)
        core = context.get(SMState.ContextEldoriaCore)
        self._current_core = core
        dt = context.get(SMState.ContextDeltaTime)
        if dt is None or not isinstance(dt, (int, float)):
            dt = 0.033

        if self.is_fading_in:
            if isinstance(keys_pressed, list) and len(keys_pressed) > 0:
                # Keypress during fade-in snaps immediately to 100% full brightness
                keys_pressed.clear()
                self.is_fading_in = False
                self.fade_in_elapsed = self.fade_in_duration
                self.title_panel.set_all_dirty()
                self.menu.set_all_dirty()
            else:
                self.fade_in_elapsed += float(dt)
                self.title_panel.set_all_dirty()
                self.menu.set_all_dirty()
                if self.fade_in_elapsed >= self.fade_in_duration:
                    self.is_fading_in = False

        if not self.is_fading_in and isinstance(keys_pressed, list) and len(keys_pressed) > 0:
            for key_info in list(keys_pressed):
                self._handle_input(key_info, context, core)
                keys_pressed.remove(key_info)
                break

        # Transition guard: do not render if transitioned away
        if core and hasattr(core, "game_state") and core.game_state.current_state != self.name:
            return

        self._render()

    def _handle_input(self, key_info, context: Context, core) -> None:
        self._current_context = context
        self._current_core = core

        # If dialog overlay is active, dismiss or interact
        if self.active_dialog is not None:
            if self.active_dialog == "LOAD":
                if self.delete_confirm_slot is not None:
                    if key_info.char in ("y", "Y"):
                        self.save_manager.delete_slot(self.delete_confirm_slot)
                        self.delete_confirm_slot = None
                        self.notice_message = "Slot deleted."
                        self._refresh_load_panel()
                        return
                    elif key_info.char in ("n", "N") or key_info.key == KeyCode.ESCAPE:
                        self.delete_confirm_slot = None
                        self.notice_message = ""
                        self._refresh_load_panel()
                        return
                    return

                if key_info.key == KeyCode.UP or key_info.char in ("k", "K"):
                    self.load_slot_idx = (self.load_slot_idx - 1) % 3
                    self.notice_message = ""
                    self._refresh_load_panel()
                    return
                elif key_info.key == KeyCode.DOWN or key_info.char in ("j", "J"):
                    self.load_slot_idx = (self.load_slot_idx + 1) % 3
                    self.notice_message = ""
                    self._refresh_load_panel()
                    return
                elif key_info.char in ("1", "2", "3"):
                    self.load_slot_idx = int(key_info.char) - 1
                    self.notice_message = ""
                    self._refresh_load_panel()
                    return
                elif key_info.char in ("d", "D"):
                    if self.load_headers and self.load_headers[self.load_slot_idx] is not None:
                        self.delete_confirm_slot = self.load_slot_idx + 1
                        self.notice_message = ""
                        self._refresh_load_panel()
                    else:
                        self.notice_message = "Slot is empty; nothing to delete."
                        self._refresh_load_panel()
                    return
                elif key_info.key == KeyCode.ESCAPE:
                    self._close_dialog()
                    return
                elif key_info.key == KeyCode.ENTER or key_info.char in ("\r", "\n"):
                    slot_num = self.load_slot_idx + 1
                    if self.load_headers and self.load_headers[self.load_slot_idx] is not None:
                        try:
                            loaded_party, loaded_macro, loaded_state = self.save_manager.load_game(slot_num)
                            context.set("party", loaded_party)
                            context.set("world_macro", loaded_macro)
                            context.set("exploration_state", loaded_state)
                            context.set("active_slot", slot_num)

                            if core and hasattr(core, "game_state"):
                                map_screen = core.game_state.states.get("GSNoiseMapTestScreen")
                                if map_screen:
                                    map_screen.party = loaded_party
                                    map_screen.world_macro = loaded_macro
                                    map_screen.active_slot = slot_num
                                    map_screen.current_sector = tuple(loaded_state.get("current_sector", loaded_macro.starter_sector))
                                    map_screen.player_x, map_screen.player_y = tuple(loaded_state.get("player_pos", loaded_macro.starter_player_pos))
                                    if hasattr(map_screen, "_ensure_walkable_player_pos"):
                                        map_screen._ensure_walkable_player_pos()
                                    map_screen.playtime_seconds = loaded_state.get("playtime_seconds", 0)
                                    if "danger_counter" in loaded_state:
                                        map_screen.danger_counter = float(loaded_state["danger_counter"])
                                    if "danger_threshold" in loaded_state:
                                        map_screen.danger_threshold = float(loaded_state["danger_threshold"])
                                    if "steps_since_battle" in loaded_state:
                                        map_screen.steps_since_battle = int(loaded_state["steps_since_battle"])
                                    map_screen.last_status_msg = f"★ Loaded Slot {slot_num}."

                                    submap_name = loaded_state.get("active_submap_poi")
                                    if submap_name:
                                        poi = loaded_macro.get_poi(submap_name)
                                        if poi and poi.sub_map:
                                            map_screen.active_poi = poi
                                            map_screen.active_submap = poi.sub_map
                                    else:
                                        map_screen.active_submap = None
                                        map_screen.active_poi = None
                                self._close_dialog()
                                core.game_state.trigger("ToNoiseMap", context)
                                return
                        except Exception as e:
                            self.notice_message = f"Error loading save: {e}"
                            self._refresh_load_panel()
                            return
                    else:
                        self.notice_message = "Slot is empty! Start a New Game."
                        self._refresh_load_panel()
                        return
            elif self.active_dialog == "OPTIONS" and key_info.char in ("1", "s", "S"):
                self.opt_sfx_enabled = not self.opt_sfx_enabled
                if self.audio_engine.is_muted != (not self.opt_sfx_enabled):
                    self.audio_engine.toggle_mute()
                self._update_options_labels()
                return
            elif self.active_dialog == "OPTIONS" and key_info.char in ("2", "f", "F"):
                self.opt_fast_text = not self.opt_fast_text
                self._update_options_labels()
                return
            elif self.active_dialog == "OPTIONS" and key_info.char in ("3", "v", "V"):
                curr = self.audio_engine.get_master_volume()
                next_vol = 0.2 if curr >= 1.0 else round(min(1.0, curr + 0.2), 1)
                self.audio_engine.set_master_volume(next_vol)
                self._update_options_labels()
                return
            elif self.active_dialog == "OPTIONS" and key_info.char in ("-", "_"):
                self.audio_engine.adjust_master_volume(-0.05)
                self._update_options_labels()
                return
            elif self.active_dialog == "OPTIONS" and key_info.char in ("+", "="):
                self.audio_engine.adjust_master_volume(0.05)
                self._update_options_labels()
                return
            elif key_info.key in (KeyCode.ENTER, KeyCode.ESCAPE, KeyCode.SPACE) or key_info.char in ("\r", "\n", " "):
                self._close_dialog()
            return

        # Main Menu navigation delegated to UIMenu
        if self.menu.handle_input(key_info):
            self.notice_message = ""
            return

        # Developer hotkeys
        if self.dev_mode and key_info.char in ("m", "M"):
            if core and hasattr(core, "game_state"):
                core.game_state.trigger("ToNoiseMap", context)
        elif self.dev_mode and key_info.char in ("b", "B"):
            if core and hasattr(core, "game_state"):
                core.game_state.trigger("ToCombat", context)
        elif self.dev_mode and key_info.char in ("u", "U"):
            if core and hasattr(core, "game_state"):
                core.game_state.trigger("ToUiTest", context)
        elif self.dev_mode and key_info.char in ("c", "C"):
            if core and hasattr(core, "game_state"):
                core.game_state.trigger("ToSodaCan", context)
        elif key_info.char in ("q", "Q"):
            if core and hasattr(core, "is_running"):
                core.is_running = False
            self.audio_engine.cleanup()

    def _execute_menu_item(self, context: Optional[Context] = None, core = None) -> None:
        if context is not None:
            self._current_context = context
        if core is not None:
            self._current_core = core
        self.menu.execute_selected()

    def _execute_menu_action(self, sel: str) -> None:
        if sel == "New Game":
            if self._current_core and hasattr(self._current_core, "game_state"):
                self._current_core.game_state.trigger("ToPartyBuilder", self._current_context)
        elif sel == "Load Game":
            self._open_dialog("LOAD")
        elif sel == "Options":
            self._open_dialog("OPTIONS")
        elif sel == "Credits":
            self._open_dialog("CREDITS")
        elif sel == "Exit":
            if self._current_core and hasattr(self._current_core, "is_running"):
                self._current_core.is_running = False
            self.audio_engine.cleanup()

    def _open_dialog(self, dialog: str) -> None:
        self.active_dialog = dialog
        self.dialog_dirty = True
        self.menu.deactivate()
        if dialog == "LOAD":
            self.load_slot_idx = 0
            self.delete_confirm_slot = None
            self.notice_message = ""
            self._refresh_load_panel()
            self.load_panel.activate()
            self.load_panel.set_all_dirty()
        elif dialog == "OPTIONS":
            self._update_options_labels()
            self.options_panel.activate()
            self.options_panel.set_all_dirty()
        elif dialog == "CREDITS":
            self.credits_panel.activate()
            self.credits_panel.set_all_dirty()

    def _close_dialog(self) -> None:
        self.active_dialog = None
        self.dialog_dirty = True
        self.load_panel.deactivate()
        self.options_panel.deactivate()
        self.credits_panel.deactivate()
        self.menu.activate()
        self.menu.set_all_dirty()

    def _clear_content_rect_ansi(self) -> str:
        """Clears rows 7..19 between left and right borders."""
        left = self.title_panel.inner_left
        width = self.title_panel.inner_width
        blank = " " * width
        return "".join(f"\033[{r};{left}H{blank}" for r in range(7, 20))

    def _render(self) -> None:
        brightness = 1.0
        if self.is_fading_in and self.fade_in_duration > 0:
            brightness = min(1.0, self.fade_in_elapsed / self.fade_in_duration)

        if brightness < 0.999:
            TerminalScreen.set_write_filter(lambda s: dim_ansi(s, brightness))
        else:
            TerminalScreen.set_write_filter(None)

        try:
            TerminalScreen.write(ATControlSequences.DrawOptimizeOn)

            # Draw master title panel (borders, title, dividers, banners, footer, hint)
            self.title_panel.draw()

            # If dialog state changed, wipe the interior content area
            if self.dialog_dirty:
                TerminalScreen.write(self._clear_content_rect_ansi())
                self.dialog_dirty = False

            # Draw active view
            if self.active_dialog == "LOAD":
                self.load_panel.draw()
            elif self.active_dialog == "OPTIONS":
                self.options_panel.draw()
            elif self.active_dialog == "CREDITS":
                self.credits_panel.draw()
            else:
                self.menu.draw()

            # Clear buffer tail rows 23..40
            TerminalScreen.write(clear_buffer_tail(self.title_panel.right_bottom.row + 1, 40))
            TerminalScreen.write(ATControlSequences.DrawOptimizeOff)
            TerminalScreen.flush()
        finally:
            TerminalScreen.set_write_filter(None)
