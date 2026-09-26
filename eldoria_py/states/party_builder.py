"""
GSPartyBuilderScreen: 5-slot Player Party Builder state.
Allows players to select any of the 5 party slots to create or edit characters,
auto-fill empty slots with balanced archetypes, and embark into overworld exploration.
Refactored to Eldoria's component UI framework (UIPanel, UIContainer, UIDivider, UILabel, UIPartySlotList).
"""

from __future__ import annotations
import sys
import threading
import time
from typing import List, Optional

from ..core.context import Context
from ..core.fsm import SMState
from ..core.save_manager import SaveManager, SaveSlotHeader
from ..terminal.ansi import ATCoordinates, ATControlSequences, ATDecoration
from ..terminal.color import ColorLibrary, format_chromatic_wave
from ..terminal.input import KeyCode
from ..terminal.screen import TerminalScreen
from ..combat.stats import StatId, BattleActionType
from ..combat.actions import ACTIONS
from ..combat.entities import PartyMember, Party
from ..combat.portrait import Gender
from ..terminal.box import clear_buffer_tail, visible_width, truncate_ansi
from ..ui.panel import UIPanel
from ..ui.elements.label import UILabel
from ..ui.elements.divider import UIDivider
from ..ui.elements.party_slot import UIPartySlotList


class GSPartyBuilderScreen(SMState):
    """Player Party Builder managing 5 fixed character positions with component UI controls."""

    def __init__(self, screen_width: int = 80, screen_height: int = 24) -> None:
        super().__init__("GSPartyBuilderScreen")
        self.screen_width: int = screen_width
        self.screen_height: int = screen_height

        # 5 Fixed Party Positions (Slot 0 is Party Leader)
        self.party_slots: List[Optional[PartyMember]] = [None, None, None, None, None]
        self.status_message: str = ""

        panel_bottom_row = min(self.screen_height - 1, 23)

        # Master Outer Window Panel (rows 1..23)
        self.party_panel = UIPanel(
            left_top=ATCoordinates(1, 1),
            right_bottom=ATCoordinates(panel_bottom_row, self.screen_width),
            title=self._build_title(),
            has_border=True,
        )
        self.party_panel.setup_title(self._build_title(), ColorLibrary.AppleCyanLight)
        self.party_panel.setup_footer(self._footer_text(), ColorLibrary.AppleYellowLight)

        # Status / Subtitle Label at row 2
        st_text = self._status_text()
        vlen = visible_width(st_text)
        col = self.party_panel.inner_left + max(0, (self.party_panel.inner_width - vlen) // 2)
        self.status_label = self.party_panel.add_label(
            st_text,
            row=2,
            col=col,
            fg_color=ColorLibrary.DarkGrey,
        )

        # Divider at row 3
        self.divider_header = self.party_panel.add_divider(row=3)

        # Slot list coordinator (managing 5 UIPartySlotItem instances at rows 4, 7, 10, 13, 16)
        self.slot_list = UIPartySlotList(parent=self.party_panel, start_row=4, slot_spacing=3, num_slots=5)
        self._sync_slot_locks()

        self.party_panel.activate()
        self.slot_list.activate()

        # Embark Configuration Modal State
        self.embark_modal_step: Optional[int] = None
        self.modal_just_closed: bool = False
        self.selected_world_size: str = "standard"
        self.save_manager = SaveManager()
        self.slot_headers: List[Optional[SaveSlotHeader]] = []
        self.animate_transition: bool = True

        # Embark Configuration Modal Panels (formal UIPanel components)
        modal_w = min(46, self.screen_width - 4)
        left_c = (self.screen_width - modal_w) // 2 + 1
        right_c = left_c + modal_w - 1

        # Step 1: World Size Panel
        self.embark_size_panel = UIPanel(
            left_top=ATCoordinates(6, left_c),
            right_bottom=ATCoordinates(12, right_c),
            has_border=True,
            title="Choose World Size",
        )
        self.embark_size_panel.title_color = ColorLibrary.AppleCyanLight
        self.opt1_label = self.embark_size_panel.add_label(
            "[1] Quick", row=7, align="center",
            fg_color=ColorLibrary.AppleGreenLight, decorations=ATDecoration(bold=True)
        )
        self.opt2_label = self.embark_size_panel.add_label(
            "[2] Standard", row=8, align="center",
            fg_color=ColorLibrary.AppleYellowLight, decorations=ATDecoration(bold=True)
        )
        self.opt3_label = self.embark_size_panel.add_label(
            "[3] Odyssey", row=9, align="center",
            fg_color=ColorLibrary.ApplePurpleLight, decorations=ATDecoration(bold=True)
        )
        self.size_divider = self.embark_size_panel.add_divider(row=10)
        self.size_hint_label = self.embark_size_panel.add_label(
            "[1-3] Choose Size   [Esc] Cancel", row=11, align="center",
            fg_color=ColorLibrary.DarkGrey
        )
        self.embark_size_panel.activate()

        # Step 2: Save Slot Panel
        self.embark_slot_panel = UIPanel(
            left_top=ATCoordinates(6, left_c),
            right_bottom=ATCoordinates(12, right_c),
            has_border=True,
            title="Select Save Slot",
        )
        self.embark_slot_panel.title_color = ColorLibrary.AppleCyanLight
        self.slot1_label = self.embark_slot_panel.add_label(
            "[1] Slot 1: ··· Empty ···", row=7, align="center", fg_color=ColorLibrary.DarkGrey
        )
        self.slot2_label = self.embark_slot_panel.add_label(
            "[2] Slot 2: ··· Empty ···", row=8, align="center", fg_color=ColorLibrary.DarkGrey
        )
        self.slot3_label = self.embark_slot_panel.add_label(
            "[3] Slot 3: ··· Empty ···", row=9, align="center", fg_color=ColorLibrary.DarkGrey
        )
        self.slot_divider = self.embark_slot_panel.add_divider(row=10)
        self.slot_hint_label = self.embark_slot_panel.add_label(
            "[1-3] Select Slot & Embark   [Esc] Back", row=11, align="center",
            fg_color=ColorLibrary.DarkGrey
        )
        self.embark_slot_panel.activate()

    @property
    def selected_slot_idx(self) -> int:
        return self.slot_list.selected_index

    @selected_slot_idx.setter
    def selected_slot_idx(self, val: int) -> None:
        self.slot_list.select_index(val)

    def max_accessible_slot_idx(self) -> int:
        """
        Calculates the highest accessible slot index based on sequential progression.
        Slot 0 (Leader) is always accessible. Each subsequent slot unlocks only
        when the preceding slot has been filled.
        """
        last_filled = -1
        for idx, member in enumerate(self.party_slots):
            if member is not None:
                last_filled = idx
        if last_filled == -1:
            return 0
        return min(len(self.party_slots) - 1, last_filled + 1)

    def _sync_slot_locks(self) -> None:
        """Synchronizes slot lock statuses across the UI slot list."""
        self.slot_list.set_max_unlocked_index(self.max_accessible_slot_idx())

    def _build_title(self) -> str:
        active_count = sum(1 for s in self.party_slots if s is not None)
        if self.screen_width < 70:
            return f"Player Party Builder [{active_count}/5]"
        return f"Player Party Builder [{active_count}/5 Members]"

    def _status_text(self) -> str:
        if self.status_message:
            return self.status_message
        if self.screen_width < 70:
            return "Use [↑/↓] or [1-5] to select. Slot 1 is Leader."
        return "Use [↑/↓] or [1-5] to select a slot. Slot 1 is Party Leader."

    def _footer_text(self) -> str:
        if self.screen_width < 70:
            return "[↑/↓]Slot [Enter]Edit [Space]Go [R]Fill [Esc]Title"
        return "[↑/↓]Select  [Enter]Edit  [Space]Embark  [R]Fill  [D]Clear  [Esc]Title"

    def _update_header_and_status(self) -> None:
        self.party_panel.setup_title(self._build_title(), ColorLibrary.AppleCyanLight)
        self.party_panel.setup_footer(self._footer_text(), ColorLibrary.AppleYellowLight)
        st_text = self._status_text()
        vlen = visible_width(st_text)
        col = self.party_panel.inner_left + max(0, (self.party_panel.inner_width - vlen) // 2)
        self.status_label.coordinates = ATCoordinates(2, col)
        color = ColorLibrary.AppleYellowLight if self.status_message else ColorLibrary.DarkGrey
        self.status_label.fg_color = color
        self.status_label.set_user_data(st_text)

    def set_member_slot(self, slot_idx: int, member: PartyMember) -> None:
        """Stores a configured PartyMember into the specified slot."""
        if 0 <= slot_idx < len(self.party_slots):
            self.party_slots[slot_idx] = member
            self.slot_list.set_slot_member(slot_idx, member)
            self._sync_slot_locks()
            self.status_message = f"★ Saved {member.name} into Slot {slot_idx + 1}."
            self._update_header_and_status()

    def clear_slot(self, slot_idx: int) -> None:
        """Clears a party slot and shifts subsequent members forward to maintain contiguity."""
        if 0 <= slot_idx < len(self.party_slots):
            removed = self.party_slots[slot_idx]
            if removed is None:
                self.status_message = f"Slot {slot_idx + 1} is already empty."
                self._update_header_and_status()
                return

            # Remove member at slot_idx and shift subsequent members forward
            del self.party_slots[slot_idx]
            self.party_slots.append(None)

            # Update slot UI items with shifted members
            for i, member in enumerate(self.party_slots):
                self.slot_list.set_slot_member(i, member)

            self._sync_slot_locks()

            # Ensure cursor is within newly unlocked bounds
            if self.slot_list.selected_index > self.slot_list.max_unlocked_idx:
                self.slot_list.select_index(self.slot_list.max_unlocked_idx)

            self.status_message = f"Cleared {removed.name}."
            self._update_header_and_status()

    def auto_fill_templates(self) -> None:
        """Populates any empty slots with pre-balanced class templates."""
        templates = [
            # Slot 0: Guardian (Earth / High Defense Tank)
            {
                "name": "Aiden",
                "class": "Earth Guardian",
                "gender": Gender.MALE,
                "affinity": BattleActionType.ELEMENTAL_EARTH,
                "profile": 1,
                "stats": {
                    StatId.HIT_POINTS: 290,
                    StatId.MAGIC_POINTS: 85,
                    StatId.ATTACK: 18,
                    StatId.DEFENSE: 18,
                    StatId.MAGIC_ATTACK: 6,
                    StatId.MAGIC_DEFENSE: 10,
                    StatId.SPEED: 12,
                    StatId.ACCURACY: 90,
                    StatId.LUCK: 12,
                },
                "actions": [ACTIONS["Attack"].copy(), ACTIONS["Defend"].copy(), ACTIONS["Boulder Bash"].copy(), ACTIONS["Drop Kick"].copy()],
            },
            # Slot 1: Elementalist (Water / High Magic Striker)
            {
                "name": "Lyra",
                "class": "Water Sorceress",
                "gender": Gender.FEMALE,
                "affinity": BattleActionType.ELEMENTAL_WATER,
                "profile": 2,
                "stats": {
                    StatId.HIT_POINTS: 220,
                    StatId.MAGIC_POINTS: 160,
                    StatId.ATTACK: 8,
                    StatId.DEFENSE: 8,
                    StatId.MAGIC_ATTACK: 22,
                    StatId.MAGIC_DEFENSE: 16,
                    StatId.SPEED: 16,
                    StatId.ACCURACY: 95,
                    StatId.LUCK: 15,
                },
                "actions": [ACTIONS["Attack"].copy(), ACTIONS["Defend"].copy(), ACTIONS["Tidal Crush"].copy(), ACTIONS["Ice Bolt"].copy()],
            },
            # Slot 2: Shadow Rogue (Wind / High Speed & Crit)
            {
                "name": "Vesper",
                "class": "Wind Rogue",
                "gender": Gender.MALE,
                "affinity": BattleActionType.ELEMENTAL_WIND,
                "profile": 3,
                "stats": {
                    StatId.HIT_POINTS: 240,
                    StatId.MAGIC_POINTS: 95,
                    StatId.ATTACK: 19,
                    StatId.DEFENSE: 10,
                    StatId.MAGIC_ATTACK: 10,
                    StatId.MAGIC_DEFENSE: 8,
                    StatId.SPEED: 22,
                    StatId.ACCURACY: 98,
                    StatId.LUCK: 20,
                },
                "actions": [ACTIONS["Attack"].copy(), ACTIONS["Defend"].copy(), ACTIONS["Galeflash"].copy(), ACTIONS["Double Scratch"].copy()],
            },
            # Slot 3: High Priestess (Light / Healer Support)
            {
                "name": "Seraphina",
                "class": "Light Priestess",
                "gender": Gender.FEMALE,
                "affinity": BattleActionType.ELEMENTAL_LIGHT,
                "profile": 1,
                "stats": {
                    StatId.HIT_POINTS: 230,
                    StatId.MAGIC_POINTS: 175,
                    StatId.ATTACK: 10,
                    StatId.DEFENSE: 10,
                    StatId.MAGIC_ATTACK: 18,
                    StatId.MAGIC_DEFENSE: 20,
                    StatId.SPEED: 14,
                    StatId.ACCURACY: 92,
                    StatId.LUCK: 16,
                },
                "actions": [ACTIONS["Attack"].copy(), ACTIONS["Defend"].copy(), ACTIONS["Heal"].copy(), ACTIONS["Radiance"].copy()],
            },
            # Slot 4: Flame Berserker (Fire / Frontline DPS)
            {
                "name": "Brand",
                "class": "Fire Berserker",
                "gender": Gender.MALE,
                "affinity": BattleActionType.ELEMENTAL_FIRE,
                "profile": 0,
                "stats": {
                    StatId.HIT_POINTS: 310,
                    StatId.MAGIC_POINTS: 70,
                    StatId.ATTACK: 24,
                    StatId.DEFENSE: 14,
                    StatId.MAGIC_ATTACK: 10,
                    StatId.MAGIC_DEFENSE: 6,
                    StatId.SPEED: 15,
                    StatId.ACCURACY: 88,
                    StatId.LUCK: 14,
                },
                "actions": [ACTIONS["Attack"].copy(), ACTIONS["Defend"].copy(), ACTIONS["Axe Cleave"].copy(), ACTIONS["Fireball"].copy()],
            },
        ]

        filled_count = 0
        for idx in range(len(self.party_slots)):
            if self.party_slots[idx] is None:
                t = templates[idx]
                member = PartyMember(
                    name=t["name"],
                    job_class=t["class"],
                    level=1,
                    affinity=t["affinity"],
                    base_stats=t["stats"],
                    actions=t["actions"],
                    gender=t["gender"],
                    profile_image_index=t["profile"],
                )
                self.party_slots[idx] = member
                self.slot_list.set_slot_member(idx, member)
                filled_count += 1

        self._sync_slot_locks()
        self.status_message = f"★ Auto-filled {filled_count} template companion(s)."
        self._update_header_and_status()

    def can_embark(self) -> bool:
        """Returns True if the party satisfies minimum embark criteria (Leader configured)."""
        return self.party_slots[0] is not None

    def build_party(self) -> Party:
        """Constructs a Party entity from all active member slots."""
        active_members = [m for m in self.party_slots if m is not None]
        return Party(members=active_members)

    def enter(self, context: Context) -> None:
        super().enter(context)
        TerminalScreen.write(ATControlSequences.CursorHide)
        TerminalScreen.clear_screen()
        TerminalScreen.flush()
        self.embark_modal_step = None
        self._sync_slot_locks()
        self.party_panel.set_all_dirty()
        self.slot_list.set_all_dirty()
        self._update_header_and_status()

    def exit(self, context: Context) -> None:
        super().exit(context)
        TerminalScreen.clear_screen()
        TerminalScreen.write(ATControlSequences.CursorShow)
        TerminalScreen.flush()

    def update(self, context: Context) -> None:
        super().update(context)
        keys_pressed = context.get(SMState.ContextKeysPressed)
        core = context.get(SMState.ContextEldoriaCore)

        if isinstance(keys_pressed, list) and len(keys_pressed) > 0:
            for key_info in list(keys_pressed):
                self._handle_input(key_info, context, core)
                keys_pressed.remove(key_info)
                break

        # Transition guard: do not render if transitioned away
        if core and hasattr(core, "game_state") and core.game_state.current_state != self.name:
            return

        self._render()

    def _handle_input(self, key_info, context: Context, core) -> None:
        # If Embark modal is open, handle modal keys
        if self.embark_modal_step is not None:
            if self.embark_modal_step == 1:
                if key_info.char in ("1", "q", "Q"):
                    self.selected_world_size = "quick"
                    self.embark_modal_step = 2
                    self._refresh_slot_panel()
                elif key_info.char in ("2", "s", "S", "m", "M"):
                    self.selected_world_size = "standard"
                    self.embark_modal_step = 2
                    self._refresh_slot_panel()
                elif key_info.char in ("3", "o", "O", "l", "L"):
                    self.selected_world_size = "odyssey"
                    self.embark_modal_step = 2
                    self._refresh_slot_panel()
                elif key_info.key == KeyCode.ESCAPE:
                    self.embark_modal_step = None
                    self.modal_just_closed = True
                    self._update_header_and_status()
                return

            elif self.embark_modal_step == 2:
                if key_info.char in ("1", "2", "3"):
                    slot_idx = int(key_info.char)
                    # 1. Clear buffer completely to remove all prior UI elements
                    TerminalScreen.clear_screen()
                    TerminalScreen.write(clear_buffer_tail(1, 40))
                    TerminalScreen.flush()

                    party = self.build_party()

                    # 2. Concurrency & rainbow animation during world creation
                    is_interactive = (
                        self.animate_transition
                        and sys.stdout.isatty()
                        and ("unittest" not in sys.modules or getattr(self, "_force_animation", False))
                    )

                    if is_interactive:
                        gen_result: dict = {}
                        gen_error: list = []

                        def worker() -> None:
                            try:
                                gen_result["data"] = self.save_manager.create_new_game(
                                    slot_idx=slot_idx,
                                    party=party,
                                    macro_size=self.selected_world_size,
                                )
                            except Exception as ex:
                                gen_error.append(ex)

                        t = threading.Thread(target=worker, daemon=True)
                        t.start()

                        phase = 0.0
                        start_time = time.monotonic()
                        min_display_time = 0.6  # Brief display window to enjoy the rainbow animation

                        while t.is_alive() or (time.monotonic() - start_time < min_display_time):
                            self._render_forging_world_frame(phase)
                            time.sleep(0.033)  # ~30 FPS
                            phase += 0.03

                        t.join()

                        if gen_error:
                            raise gen_error[0]

                        world_macro, exp_state = gen_result["data"]
                    else:
                        # Fast-path for unit tests and headless environments
                        self._render_forging_world_frame(0.0)
                        world_macro, exp_state = self.save_manager.create_new_game(
                            slot_idx=slot_idx,
                            party=party,
                            macro_size=self.selected_world_size,
                        )
                    context.set("party", party)
                    context.set("world_macro", world_macro)
                    context.set("exploration_state", exp_state)
                    context.set("active_slot", slot_idx)

                    if core and hasattr(core, "game_state"):
                        map_screen = core.game_state.states.get("GSNoiseMapTestScreen")
                        if map_screen:
                            map_screen.party = party
                            map_screen.world_macro = world_macro
                            map_screen.active_slot = slot_idx
                            map_screen.current_sector = world_macro.starter_sector
                            map_screen.player_x, map_screen.player_y = world_macro.starter_player_pos
                            map_screen.playtime_seconds = 0
                            map_screen.last_status_msg = f"★ Embarked into {self.selected_world_size.title()} Eldoria!"
                        self.embark_modal_step = None
                        self.modal_just_closed = True
                        core.game_state.trigger("ToNoiseMap", context)
                    return
                elif key_info.key == KeyCode.ESCAPE:
                    self.embark_modal_step = 1
                return

        # Move slot cursor
        if key_info.key == KeyCode.UP:
            self.slot_list.select_prev()
            self.status_message = ""
            self._update_header_and_status()
        elif key_info.key == KeyCode.DOWN:
            self.slot_list.select_next()
            self.status_message = ""
            self._update_header_and_status()

        # Direct slot selection (1-5)
        elif key_info.char in ("1", "2", "3", "4", "5"):
            target_idx = int(key_info.char) - 1
            if self.slot_list.select_index(target_idx):
                self.status_message = ""
                self._update_header_and_status()
            else:
                if self.screen_width < 70:
                    req_slot = (
                        "Leader"
                        if self.slot_list.max_unlocked_idx == 0
                        else f"Slot {self.slot_list.max_unlocked_idx + 1}"
                    )
                    self.status_message = f"⚠ Slot {target_idx + 1} locked! Configure {req_slot} first."
                else:
                    req_slot = (
                        "Party Leader"
                        if self.slot_list.max_unlocked_idx == 0
                        else f"Slot {self.slot_list.max_unlocked_idx + 1}"
                    )
                    self.status_message = f"⚠ Slot {target_idx + 1} is locked! Configure {req_slot} first."
                self._update_header_and_status()

        # Configure selected slot
        elif key_info.key == KeyCode.ENTER or key_info.char in ("\r", "\n"):
            if core and hasattr(core, "game_state"):
                builder_state = core.game_state.states.get("GSCharacterBuilderScreen")
                if builder_state and hasattr(builder_state, "set_target_slot"):
                    builder_state.set_target_slot(
                        self.selected_slot_idx, self.party_slots[self.selected_slot_idx]
                    )
                core.game_state.trigger("ToCharacterBuilder", context)

        # Embark
        elif key_info.key == KeyCode.SPACE or key_info.char in ("e", "E"):
            if self.can_embark():
                self.embark_modal_step = 1
                self.embark_size_panel.set_all_dirty()
            else:
                self.status_message = "⚠ Party Leader (Slot 1) is required to embark!"
                self._update_header_and_status()

        # Auto-fill empty slots
        elif key_info.char in ("r", "R"):
            self.auto_fill_templates()

        # Clear selected slot
        elif key_info.key == KeyCode.DELETE or key_info.char in ("d", "D"):
            self.clear_slot(self.selected_slot_idx)

        # Return to title screen
        elif key_info.key == KeyCode.ESCAPE:
            if core and hasattr(core, "game_state"):
                core.game_state.trigger("ToTitle", context)

    def _clear_modal_rect(self, panel: UIPanel) -> None:
        """Clears the rectangular footprint of the modal to prevent underlying text bleed."""
        width = panel.right_bottom.column - panel.left_top.column + 1
        blank = " " * width
        ansi = "".join(
            f"\033[{r};{panel.left_top.column}H{blank}"
            for r in range(panel.left_top.row, panel.right_bottom.row + 1)
        )
        TerminalScreen.write(ansi)

    def _clear_interior(self) -> None:
        """Clears the interior of the party panel when a modal is dismissed."""
        left = self.party_panel.inner_left
        width = self.party_panel.inner_width
        blank = " " * width
        ansi = "".join(
            f"\033[{r};{left}H{blank}"
            for r in range(self.party_panel.inner_top, self.party_panel.inner_bottom + 1)
        )
        TerminalScreen.write(ansi)

    def _refresh_slot_panel(self) -> None:
        """Updates slot labels from disk headers in a bounds-safe manner."""
        self.slot_headers = self.save_manager.list_save_slots(3)
        self.embark_slot_panel.setup_title(f"Save Slot ─ {self.selected_world_size.title()}", ColorLibrary.AppleCyanLight)
        max_w = self.embark_slot_panel.inner_width

        for idx in range(3):
            lbl = getattr(self, f"slot{idx+1}_label")
            h = self.slot_headers[idx] if idx < len(self.slot_headers) else None
            if h is not None:
                line = f"[{idx + 1}] Slot {idx + 1}: ★ {h.party_leader_name} ({h.world_size_label})"
                fg = ColorLibrary.AppleGreenLight
            else:
                line = f"[{idx + 1}] Slot {idx + 1}: ··· Empty ···"
                fg = ColorLibrary.DarkGrey

            truncated_line = truncate_ansi(line, max_w)
            vlen = visible_width(truncated_line)
            c = self.embark_slot_panel.inner_left + max(0, (max_w - vlen) // 2)
            lbl.coordinates = ATCoordinates(lbl.coordinates.row, c)
            lbl.set_user_data(truncated_line)
            lbl.fg_color = fg

        self.embark_slot_panel.set_all_dirty()

    def _render_forging_world_frame(self, phase: float = 0.0) -> None:
        """Renders the centered 'Forging World' and 'Carving and establishing terrain' labels with rainbow wave."""
        line1 = "Forging World"
        line2 = "Carving and establishing terrain"

        col1 = max(1, (self.screen_width - len(line1)) // 2 + 1)
        col2 = max(1, (self.screen_width - len(line2)) // 2 + 1)

        mid_row = self.screen_height // 2
        row1 = max(1, mid_row - 1)
        row2 = min(self.screen_height, mid_row + 1)

        rendered_l1 = format_chromatic_wave(line1, phase=phase, char_step=0.04, bold=True)
        rendered_l2 = format_chromatic_wave(line2, phase=phase + 0.20, char_step=0.025, bold=False)

        out = [
            f"\033[{row1};{col1}H{rendered_l1}",
            f"\033[{row2};{col2}H{rendered_l2}",
        ]
        TerminalScreen.write("".join(out))
        TerminalScreen.flush()

    def _render_embark_modal(self) -> None:
        """Renders the active modal panel (Step 1 or Step 2) with clean background clearing."""
        if self.embark_modal_step == 1:
            panel = self.embark_size_panel
        elif self.embark_modal_step == 2:
            panel = self.embark_slot_panel
        else:
            return

        self._clear_modal_rect(panel)
        panel.set_all_dirty()
        panel.draw()

    def _render(self) -> None:
        """Atomic frame render of the 5-slot Party Builder screen using UI components."""
        TerminalScreen.write(ATControlSequences.DrawOptimizeOn)

        if self.modal_just_closed:
            self._clear_interior()
            self.party_panel.set_all_dirty()
            self.slot_list.set_all_dirty()
            self.modal_just_closed = False

        # Draw master panel (borders, title if dirty, status label if dirty, divider)
        self.party_panel.draw()

        # Draw only dirty party slot items
        self.slot_list.draw()

        # If embark configuration modal is active, draw it on top
        if self.embark_modal_step is not None:
            self._render_embark_modal()

        # Wipe tail lines from panel bottom row up to maximum buffer height 40
        tail_start = self.party_panel.right_bottom.row + 1
        if tail_start <= 40:
            TerminalScreen.write(clear_buffer_tail(tail_start, 40))

        TerminalScreen.write(ATControlSequences.DrawOptimizeOff)
        TerminalScreen.flush()
