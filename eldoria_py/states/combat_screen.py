"""
GSNvNCombatScreen: Full-featured NvN party combat screen (up to 5 heroes vs up to 10 enemies).
Includes advance round planning, initiative execution, tactical target detail (no ASCII art),
equipment-scaled stats, and scrolling battle telemetry.
"""
from __future__ import annotations
import math
import re
from typing import List, Optional, Tuple

from ..core.context import Context
from ..core.fsm import SMState
from ..terminal.ansi import ATCoordinates, ATControlSequences
from ..terminal.color import TrueColor
from ..terminal.input import KeyCode
from ..terminal.screen import TerminalScreen
from ..combat.stats import StatId, BattleActionType, TargetScope, AffinityEffect
from ..combat.actions import BattleAction, ActionCategory, ACTIONS
from ..combat.entities import (
    Combatant,
    PartyMember,
    EnemyCombatant,
    Party,
    EnemySquad,
    create_default_party,
    create_bat_squad,
)
from ..combat.engine import NvNCombatEngine, CombatPhase, QueuedAction


def _strip_ansi(text: str) -> str:
    return re.sub(r"\033\[[0-9;]*[a-zA-Z]", "", text)


def _pad_cell(text: str, width: int, align: str = "left", fill_char: str = " ") -> str:
    vlen = len(_strip_ansi(text))
    rem = max(0, width - vlen)
    if align == "right":
        return fill_char * rem + text
    elif align == "center":
        left = rem // 2
        right = rem - left
        return fill_char * left + text + fill_char * right
    else:
        return text + fill_char * rem


def _make_bar(current: int, maximum: int, length: int = 8) -> str:
    """Creates a visual bracketed bar: [████░░░░]."""
    if maximum <= 0:
        pct = 0.0
    else:
        pct = max(0.0, min(1.0, current / maximum))
    fill_len = int(round(pct * length))
    empty_len = length - fill_len
    return "[" + ("█" * fill_len) + ("░" * empty_len) + "]"


class GSNvNCombatScreen(SMState):
    """Full-screen interactive NvN combat state."""

    TOTAL_WIDTH: int = 86
    LEFT_COL_WIDTH: int = 59  # index 0 to 58 (59 chars), separator at index 59 (col 60)
    RIGHT_COL_WIDTH: int = 24 # index 60 to 83 (24 chars), right border at 85

    def __init__(
        self,
        party: Optional[Party] = None,
        squad: Optional[EnemySquad] = None,
    ) -> None:
        super().__init__("GSNvNCombatScreen")
        self.party: Party = party if party is not None else create_default_party()
        self.squad: EnemySquad = squad if squad is not None else create_bat_squad(size=6)
        self.engine: NvNCombatEngine = NvNCombatEngine(party=self.party, squad=self.squad)

        # UI Navigation State
        self.active_member_idx: int = 0
        self.menu_mode: str = "MAIN"  # "MAIN", "SKILLS", "SPELLS", "TARGET_SELECT"
        self.main_menu_cursor: int = 0  # 0: Attack, 1: Skills, 2: Spells, 3: Defend
        self.sub_menu_cursor: int = 0
        self.selected_action: Optional[BattleAction] = None
        self.inspected_enemy_idx: int = 0
        self.target_cursor: int = 0

    def start_encounter(self, party: Party, squad: EnemySquad) -> None:
        """Configures a new battle encounter."""
        self.party = party
        self.squad = squad
        self.engine = NvNCombatEngine(party=self.party, squad=self.squad)
        self.active_member_idx = self._find_first_living_member()
        self.menu_mode = "MAIN"
        self.main_menu_cursor = 0
        self.sub_menu_cursor = 0
        self.selected_action = None
        self.inspected_enemy_idx = 0
        self.target_cursor = 0

    def _find_first_living_member(self) -> int:
        for i, m in enumerate(self.party.members):
            if m.is_alive:
                return i
        return 0

    def _find_next_living_member(self, start_idx: int) -> Optional[int]:
        for i in range(start_idx + 1, len(self.party.members)):
            if self.party.members[i].is_alive:
                return i
        return None

    def enter(self, context: Context) -> None:
        super().enter(context)
        TerminalScreen.write(ATControlSequences.CursorHide)
        TerminalScreen.clear_screen()
        TerminalScreen.flush()

    def exit(self, context: Context) -> None:
        super().exit(context)
        TerminalScreen.clear_screen()
        TerminalScreen.write(ATControlSequences.CursorShow)
        TerminalScreen.flush()

    # -------------------------------------------------------------------------
    # Input Handling
    # -------------------------------------------------------------------------
    def update(self, context: Context) -> None:
        super().update(context)

        keys_pressed = context.get(SMState.ContextKeysPressed)
        core = context.get(SMState.ContextEldoriaCore)

        if isinstance(keys_pressed, list) and len(keys_pressed) > 0:
            for key_info in list(keys_pressed):
                # 1. Victory / Defeat Screen Navigation
                if self.engine.phase in (CombatPhase.BATTLE_VICTORY, CombatPhase.BATTLE_DEFEAT):
                    if key_info.key in (KeyCode.ENTER, KeyCode.SPACE) or key_info.char in ("\r", "\n", " ", "q", "Q"):
                        keys_pressed.clear()
                        if core and hasattr(core, "game_state"):
                            core.game_state.trigger("FromCombat", context)
                        return
                    continue

                # 2. Execution Phase: Step through turns or auto-play
                if self.engine.phase == CombatPhase.EXECUTION_PHASE:
                    if key_info.key in (KeyCode.ENTER, KeyCode.SPACE) or key_info.char in ("\r", "\n", " "):
                        self.engine.step_execution()
                        keys_pressed.remove(key_info)
                        break
                    elif key_info.char in ("a", "A"):
                        self.engine.execute_all_steps()
                        keys_pressed.remove(key_info)
                        break
                    elif key_info.char in ("q", "Q"):
                        keys_pressed.clear()
                        if core and hasattr(core, "game_state"):
                            core.game_state.trigger("FromCombat", context)
                        return
                    continue

                # 3. Command Planning Phase
                if self.engine.phase == CombatPhase.COMMAND_PHASE:
                    # Debug Cheat: Instant win [K]
                    if key_info.char in ("k", "K"):
                        for e in self.squad.enemies:
                            e.take_damage(99999)
                        self.engine.step_execution()
                        keys_pressed.remove(key_info)
                        break

                    # Flee / Return to Overworld [Esc]
                    if key_info.key == KeyCode.ESCAPE or key_info.char in ("q", "Q"):
                        keys_pressed.clear()
                        if core and hasattr(core, "game_state"):
                            core.game_state.trigger("FromCombat", context)
                        return

                    if self.menu_mode == "MAIN":
                        self._handle_main_menu_input(key_info)
                        keys_pressed.remove(key_info)
                        break
                    elif self.menu_mode in ("SKILLS", "SPELLS"):
                        self._handle_sub_menu_input(key_info)
                        keys_pressed.remove(key_info)
                        break
                    elif self.menu_mode == "TARGET_SELECT":
                        self._handle_target_input(key_info)
                        keys_pressed.remove(key_info)
                        break

        self._render()

    def _handle_main_menu_input(self, key_info: any) -> None:
        curr_member = self.party.get_member(self.active_member_idx)
        if curr_member is None or not curr_member.is_alive:
            nxt = self._find_next_living_member(self.active_member_idx)
            if nxt is not None:
                self.active_member_idx = nxt
            return

        # Up/Down navigation
        if key_info.key == KeyCode.UP or key_info.char in ("w", "W"):
            self.main_menu_cursor = (self.main_menu_cursor - 1) % 4
        elif key_info.key == KeyCode.DOWN or key_info.char in ("s", "S"):
            self.main_menu_cursor = (self.main_menu_cursor + 1) % 4
        elif key_info.char in ("1", "2", "3", "4"):
            self.main_menu_cursor = int(key_info.char) - 1
            self._activate_main_menu_selection()
        elif key_info.key == KeyCode.ENTER or key_info.char in ("\r", "\n", " "):
            self._activate_main_menu_selection()
        elif key_info.char in ("b", "B"):
            # Go back to previous living member if any
            for i in range(self.active_member_idx - 1, -1, -1):
                if self.party.members[i].is_alive:
                    self.active_member_idx = i
                    self.engine.clear_member_plan(i)
                    break

    def _activate_main_menu_selection(self) -> None:
        curr_member = self.party.get_member(self.active_member_idx)
        if curr_member is None:
            return

        if self.main_menu_cursor == 0:  # Attack
            self.selected_action = ACTIONS["Attack"].copy()
            self.menu_mode = "TARGET_SELECT"
            self.target_cursor = self._get_first_alive_enemy_idx()
            self.inspected_enemy_idx = self.target_cursor
        elif self.main_menu_cursor == 1:  # Skills
            self.menu_mode = "SKILLS"
            self.sub_menu_cursor = 0
        elif self.main_menu_cursor == 2:  # Spells
            self.menu_mode = "SPELLS"
            self.sub_menu_cursor = 0
        elif self.main_menu_cursor == 3:  # Defend
            defend_act = ACTIONS["Defend"].copy()
            self.engine.plan_member_action(self.active_member_idx, defend_act, curr_member)
            self._advance_to_next_member()

    def _get_first_alive_enemy_idx(self) -> int:
        for i, e in enumerate(self.squad.enemies):
            if e.is_alive:
                return i
        return 0

    def _get_available_actions(self, category: ActionCategory) -> list[BattleAction]:
        curr_member = self.party.get_member(self.active_member_idx)
        if not curr_member:
            return []
        return [a for a in curr_member.actions if a.category == category]

    def _handle_sub_menu_input(self, key_info: any) -> None:
        cat = ActionCategory.SKILL if self.menu_mode == "SKILLS" else ActionCategory.SPELL
        act_list = self._get_available_actions(cat)

        if key_info.key == KeyCode.ESCAPE or key_info.char in ("b", "B", "q", "Q"):
            self.menu_mode = "MAIN"
            return

        if not act_list:
            self.menu_mode = "MAIN"
            return

        if key_info.key == KeyCode.UP or key_info.char in ("w", "W"):
            self.sub_menu_cursor = (self.sub_menu_cursor - 1) % len(act_list)
        elif key_info.key == KeyCode.DOWN or key_info.char in ("s", "S"):
            self.sub_menu_cursor = (self.sub_menu_cursor + 1) % len(act_list)
        elif key_info.char in [str(i) for i in range(1, min(10, len(act_list) + 1))]:
            self.sub_menu_cursor = int(key_info.char) - 1
            self._choose_sub_action(act_list[self.sub_menu_cursor])
        elif key_info.key == KeyCode.ENTER or key_info.char in ("\r", "\n", " "):
            self._choose_sub_action(act_list[self.sub_menu_cursor])

    def _choose_sub_action(self, action: BattleAction) -> None:
        curr_member = self.party.get_member(self.active_member_idx)
        if not curr_member:
            return
        if curr_member.mp < action.mp_cost:
            self.engine.log(f"Not enough MP to use {action.name}! ({curr_member.mp}/{action.mp_cost})")
            return

        self.selected_action = action.copy()
        if action.target_scope in (TargetScope.ALL_ENEMIES, TargetScope.ALL_ALLIES, TargetScope.SELF):
            # No single target needed
            dummy_target = curr_member if action.target_scope == TargetScope.SELF else self.squad.enemies[0]
            self.engine.plan_member_action(self.active_member_idx, action, dummy_target)
            self._advance_to_next_member()
        else:
            self.menu_mode = "TARGET_SELECT"
            self.target_cursor = self._get_first_alive_enemy_idx()
            self.inspected_enemy_idx = self.target_cursor

    def _handle_target_input(self, key_info: any) -> None:
        alive_indices = [i for i, e in enumerate(self.squad.enemies) if e.is_alive]
        if not alive_indices:
            return

        if key_info.key == KeyCode.ESCAPE or key_info.char in ("b", "B"):
            self.menu_mode = "MAIN"
            return

        # Arrow navigation
        if key_info.key in (KeyCode.LEFT, KeyCode.UP) or key_info.char in ("a", "A", "w", "W"):
            cur_pos = alive_indices.index(self.target_cursor) if self.target_cursor in alive_indices else 0
            new_pos = (cur_pos - 1) % len(alive_indices)
            self.target_cursor = alive_indices[new_pos]
            self.inspected_enemy_idx = self.target_cursor
        elif key_info.key in (KeyCode.RIGHT, KeyCode.DOWN) or key_info.char in ("d", "D", "s", "S"):
            cur_pos = alive_indices.index(self.target_cursor) if self.target_cursor in alive_indices else 0
            new_pos = (cur_pos + 1) % len(alive_indices)
            self.target_cursor = alive_indices[new_pos]
            self.inspected_enemy_idx = self.target_cursor
        elif key_info.char in [str(i) for i in range(1, 10)]:
            idx = int(key_info.char) - 1
            if idx < len(self.squad.enemies) and self.squad.enemies[idx].is_alive:
                self.target_cursor = idx
                self.inspected_enemy_idx = idx
                self._confirm_target_selection()
        elif key_info.char == "0":
            if len(self.squad.enemies) >= 10 and self.squad.enemies[9].is_alive:
                self.target_cursor = 9
                self.inspected_enemy_idx = 9
                self._confirm_target_selection()
        elif key_info.key == KeyCode.ENTER or key_info.char in ("\r", "\n", " "):
            self._confirm_target_selection()

    def _confirm_target_selection(self) -> None:
        target = self.squad.get_enemy(self.target_cursor)
        if target is None or not target.is_alive:
            return
        if self.selected_action is None:
            self.selected_action = ACTIONS["Attack"].copy()

        self.engine.plan_member_action(self.active_member_idx, self.selected_action, target)
        self._advance_to_next_member()

    def _advance_to_next_member(self) -> None:
        """Advances active planning hero or triggers execution phase if all have chosen."""
        nxt = self._find_next_living_member(self.active_member_idx)
        if nxt is not None:
            self.active_member_idx = nxt
            self.menu_mode = "MAIN"
            self.main_menu_cursor = 0
            self.sub_menu_cursor = 0
            self.selected_action = None
        else:
            # Check if all living members have planned actions
            if self.engine.is_planning_complete():
                self.engine.finalize_planning()
                self.menu_mode = "MAIN"
            else:
                # Find any unplanned member
                for i, m in enumerate(self.party.members):
                    if m.is_alive and i not in self.engine.planned_actions:
                        self.active_member_idx = i
                        self.menu_mode = "MAIN"
                        return

    # -------------------------------------------------------------------------
    # Rendering
    # -------------------------------------------------------------------------
    def _render(self) -> None:
        """Atomic frame render of the 90x40 NvN combat screen."""
        out: List[str] = [ATControlSequences.DrawOptimizeOn]

        # Top border
        out.append(ATCoordinates(1, 1).to_ansi())
        top_str = "┌─ ENEMY SQUAD (Up to 10 Enemies) ──────────────────────────┬─ TARGET DETAIL ────────┐"
        out.append(top_str)

        # Lines 2..6: Enemy Squad (Left) and Target Detail (Right)
        # Note: Zero ASCII art in the right panel!
        for row_idx in range(5):
            left_str = self._format_enemy_row(row_idx)
            right_str = self._format_target_detail_row(row_idx)
            out.append(ATCoordinates(2 + row_idx, 1).to_ansi())
            out.append(f"│{left_str}│{right_str}│")

        # Divider 1 (Row 7)
        out.append(ATCoordinates(7, 1).to_ansi())
        out.append("├───────────────────────────────────────────────────────────┴────────────────────────┤")

        # Row 8: Player Party Header
        out.append(ATCoordinates(8, 1).to_ansi())
        out.append("│ PLAYER PARTY (Up to 5 Heroes)                                                      │")

        # Rows 9..13: Party Members
        for m_idx in range(5):
            p_str = self._format_party_member_row(m_idx)
            out.append(ATCoordinates(9 + m_idx, 1).to_ansi())
            out.append(f"│{p_str}│")

        # Divider 2 (Row 14)
        out.append(ATCoordinates(14, 1).to_ansi())
        out.append("├──────────────────────────┬─────────────────────────────────────────────────────────┤")

        # Rows 15..22: Commands (Left 26 chars) and Combat Log (Right 57 chars)
        for c_idx in range(8):
            cmd_cell = self._format_command_cell(c_idx)
            log_cell = self._format_log_cell(c_idx)
            out.append(ATCoordinates(15 + c_idx, 1).to_ansi())
            out.append(f"│{cmd_cell}│{log_cell}│")

        # Bottom Border (Row 23)
        out.append(ATCoordinates(23, 1).to_ansi())
        out.append("└──────────────────────────┴─────────────────────────────────────────────────────────┘")

        # Row 24: Navigation / Action Hints
        out.append(ATCoordinates(24, 1).to_ansi())
        hints = self._format_status_hints()
        out.append(_pad_cell(f" {hints}", self.TOTAL_WIDTH))

        out.append(ATControlSequences.DrawOptimizeOff)
        TerminalScreen.write("".join(out))
        TerminalScreen.flush()

    def _format_enemy_row(self, row_idx: int) -> str:
        """Left side: Displays enemy [1..5] in col 1, [6..10] in col 2 (59 characters total)."""
        idx1 = row_idx
        idx2 = row_idx + 5

        def format_enemy_slot(idx: int) -> str:
            if idx >= len(self.squad.enemies):
                return " " * 28
            e = self.squad.enemies[idx]
            tag = f"[{idx + 1}]"
            is_targeted = (self.menu_mode == "TARGET_SELECT" and self.target_cursor == idx) or (self.inspected_enemy_idx == idx)
            prefix = "\033[1;33m❱\033[0m" if is_targeted else " "

            if not e.is_alive:
                text = f"{prefix}{tag:<4} {e.name:<6} \033[31m[DEAD]\033[0m"
                return _pad_cell(text, 28)

            hp_str = f"HP:{e.hp}/{e.max_hp}"
            aff_str = e.affinity.value.replace("Elemental", "")[:3]
            text = f"{prefix}{tag:<4} {e.name:<6} {hp_str:<11} {aff_str:<3}"
            return _pad_cell(text, 28)

        col1 = format_enemy_slot(idx1)
        col2 = format_enemy_slot(idx2)
        combined = f" {col1}  {col2}"
        return _pad_cell(combined, self.LEFT_COL_WIDTH)

    def _format_target_detail_row(self, row_idx: int) -> str:
        """Right side: Purely textual tactical inspector without ASCII art (24 characters)."""
        target = self.squad.get_enemy(self.inspected_enemy_idx)
        if target is None:
            return " " * self.RIGHT_COL_WIDTH

        if row_idx == 0:
            name_txt = f" Name: [{self.inspected_enemy_idx + 1}] {target.name}"
            return _pad_cell(name_txt[:24], self.RIGHT_COL_WIDTH)
        elif row_idx == 1:
            fam_txt = f" Type: {target.family} (Lv.{target.level})"
            return _pad_cell(fam_txt[:24], self.RIGHT_COL_WIDTH)
        elif row_idx == 2:
            bar = _make_bar(target.hp, target.max_hp, length=8)
            hp_txt = f" HP: {target.hp}/{target.max_hp} {bar}"
            return _pad_cell(hp_txt[:24], self.RIGHT_COL_WIDTH)
        elif row_idx == 3:
            aff_name = target.affinity.value.replace("Elemental", "")
            aff_txt = f" Affinity: {aff_name}"
            return _pad_cell(aff_txt[:24], self.RIGHT_COL_WIDTH)
        elif row_idx == 4:
            # Show element weakness/threat
            if target.affinity == BattleActionType.ELEMENTAL_ICE:
                info_txt = " Weak: Fire | Res: Water"
            elif target.affinity == BattleActionType.ELEMENTAL_FIRE:
                info_txt = " Weak: Water | Res: Ice"
            elif target.affinity == BattleActionType.ELEMENTAL_WATER:
                info_txt = " Weak: Wind  | Res: Fire"
            else:
                info_txt = f" Threat: Rank {target.threat_rank}"
            return _pad_cell(info_txt[:24], self.RIGHT_COL_WIDTH)

        return " " * self.RIGHT_COL_WIDTH

    def _format_party_member_row(self, member_idx: int) -> str:
        """Middle rack: Hero summary with HP, MP, equipment readiness, and planned intent (84 chars)."""
        if member_idx >= len(self.party.members):
            return " " * 84
        m = self.party.members[member_idx]
        is_active = (self.engine.phase == CombatPhase.COMMAND_PHASE and self.active_member_idx == member_idx)
        prefix = "\033[1;36m❱\033[0m" if is_active else " "

        name_class = f"{m.name} ({m.job_class})"
        if not m.is_alive:
            txt = f"{prefix} {member_idx + 1}. {name_class:<20} \033[31m[FALLEN IN COMBAT]\033[0m"
            return _pad_cell(txt, 84)

        hp_str = f"HP:{m.hp}/{m.max_hp}"
        mp_str = f"MP:{m.mp}/{m.max_mp}"
        hp_bar = _make_bar(m.hp, m.max_hp, length=6)

        # Planned intent preview
        plan = self.engine.get_planned_action(member_idx)
        if plan:
            if plan.action.target_scope == TargetScope.ALL_ENEMIES:
                intent_str = f"Intent: [{plan.action.name}->All]"
            elif plan.action.target_scope == TargetScope.SELF:
                intent_str = f"Intent: [{plan.action.name}]"
            else:
                intent_str = f"Intent: [{plan.action.name}->{plan.target.name}]"
            status_tag = "\033[32m[Locked]\033[0m"
        else:
            intent_str = "Intent: [Planning...]" if is_active else "Intent: [Waiting]"
            status_tag = "\033[33m[Ready]\033[0m"

        line = f"{prefix} {member_idx + 1}. {name_class:<18} {hp_str:<12} {hp_bar} {mp_str:<10} {status_tag}  {intent_str}"
        return _pad_cell(line, 84)

    def _format_command_cell(self, row_idx: int) -> str:
        """Bottom Left: Command selector or target selection prompt (26 chars)."""
        curr_member = self.party.get_member(self.active_member_idx)
        name = curr_member.name if curr_member else "Hero"

        if row_idx == 0:
            if self.engine.phase == CombatPhase.EXECUTION_PHASE:
                return _pad_cell(" EXECUTION PHASE", 26)
            elif self.menu_mode == "TARGET_SELECT":
                return _pad_cell(" SELECT TARGET", 26)
            elif self.menu_mode == "SKILLS":
                return _pad_cell(f" SKILLS ({name})", 26)
            elif self.menu_mode == "SPELLS":
                return _pad_cell(f" SPELLS ({name})", 26)
            else:
                return _pad_cell(f" COMMANDS ({name})", 26)

        if self.engine.phase == CombatPhase.EXECUTION_PHASE:
            if row_idx == 1:
                return _pad_cell(" ❱ [Space] Step Turn", 26)
            elif row_idx == 2:
                return _pad_cell("   [A] Auto-Play", 26)
            return " " * 26

        if self.menu_mode == "MAIN":
            options = ["[1] Attack", "[2] Skills", "[3] Spells", "[4] Defend"]
            opt_idx = row_idx - 1
            if 0 <= opt_idx < len(options):
                cursor = "❱ " if self.main_menu_cursor == opt_idx else "  "
                return _pad_cell(f" {cursor}{options[opt_idx]}", 26)
            return " " * 26

        if self.menu_mode in ("SKILLS", "SPELLS"):
            cat = ActionCategory.SKILL if self.menu_mode == "SKILLS" else ActionCategory.SPELL
            actions = self._get_available_actions(cat)
            opt_idx = row_idx - 1
            if 0 <= opt_idx < len(actions):
                act = actions[opt_idx]
                cursor = "❱ " if self.sub_menu_cursor == opt_idx else "  "
                txt = f" {cursor}[{opt_idx + 1}] {act.name} ({act.mp_cost}M)"
                return _pad_cell(txt[:25], 26)
            elif opt_idx == len(actions):
                return _pad_cell("   [Esc] Back", 26)
            return " " * 26

        if self.menu_mode == "TARGET_SELECT":
            target = self.squad.get_enemy(self.target_cursor)
            target_name = target.name if target else "Enemy"
            if row_idx == 1:
                return _pad_cell(f" ❱ [{self.target_cursor + 1}] {target_name}", 26)
            elif row_idx == 2:
                return _pad_cell("   [Arrows] Cycle", 26)
            elif row_idx == 3:
                return _pad_cell("   [1..10] Direct", 26)
            elif row_idx == 4:
                return _pad_cell("   [Enter] Confirm", 26)
            elif row_idx == 5:
                return _pad_cell("   [Esc] Cancel", 26)
            return " " * 26

        return " " * 26

    def _format_log_cell(self, row_idx: int) -> str:
        """Bottom Right: Scrolling battle log (57 chars)."""
        if row_idx == 0:
            return _pad_cell(" COMBAT LOG", 57)

        # Show last 7 combat log messages
        log_slice = self.engine.combat_log[-7:]
        log_offset = row_idx - 1
        if 0 <= log_offset < len(log_slice):
            msg = log_slice[log_offset]
            return _pad_cell(f" {msg}", 57)
        return " " * 57

    def _format_status_hints(self) -> str:
        if self.engine.phase == CombatPhase.BATTLE_VICTORY:
            return "\033[1;32m★ VICTORY! [Enter/Space] Return to Map\033[0m"
        elif self.engine.phase == CombatPhase.BATTLE_DEFEAT:
            return "\033[1;31m☠ DEFEAT! [Enter/Space] Return to Map\033[0m"
        elif self.engine.phase == CombatPhase.EXECUTION_PHASE:
            return "\033[33m[Space/Enter] Step Turn  [A] Auto-Play  [Q] Exit Battle\033[0m"
        elif self.menu_mode == "TARGET_SELECT":
            return "\033[33m[1..10/Arrows] Select Target  [Enter] Confirm  [Esc] Back\033[0m"
        elif self.menu_mode in ("SKILLS", "SPELLS"):
            return "\033[33m[1..N/Arrows] Select Action  [Enter] Confirm  [Esc] Back\033[0m"
        else:
            return "\033[33m[1..4/WASD] Choose Action  [B] Previous Hero  [K] Cheat Win  [Esc] Flee\033[0m"
