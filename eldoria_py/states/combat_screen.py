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
from ..terminal.box import clear_buffer_tail, strip_ansi, truncate_ansi, visible_width, wrap_text
from ..ui.elements.stat_bar import UIStatBar, StatBarType, StatNumberState
from ..combat.stats import StatId, BattleActionType, TargetScope, AffinityEffect, format_element_badge
from ..combat.actions import BattleAction, ActionCategory, ACTIONS
from ..combat.items import ConsumableItem, ItemType, ItemEffectType, get_item
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


def _pad_cell(text: str, width: int, align: str = "left", fill_char: str = " ") -> str:
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


class GSNvNCombatScreen(SMState):
    """Full-screen interactive NvN combat state."""

    TOTAL_WIDTH: int = 80
    LEFT_COL_WIDTH: int = 53  # enemy squad listing (53 chars)
    RIGHT_COL_WIDTH: int = 24 # tactical detail (24 chars)


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
        self.menu_mode: str = "MAIN"  # "MAIN", "SKILLS", "SPELLS", "ITEMS", "TARGET_SELECT"
        self.main_menu_cursor: int = 0  # 0: Attack, 1: Skills, 2: Spells, 3: Item, 4: Defend
        self.sub_menu_cursor: int = 0
        self.selected_action: Optional[BattleAction] = None
        self.inspected_enemy_idx: int = 0
        self.target_cursor: int = 0
        self.target_type: str = "ENEMY"  # "ENEMY" or "ALLY"
        self.step_delay: float = 0.75  # 0.75s cadence between turn actions
        self.execution_timer: float = 0.0

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
        self.execution_timer = 0.0

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
        delta_time = context.get(SMState.ContextDeltaTime)
        if delta_time is None or not isinstance(delta_time, (int, float)):
            delta_time = 0.016
        if self.party is not None:
            self.party.add_playtime(delta_time)

        if isinstance(keys_pressed, list) and len(keys_pressed) > 0:
            for key_info in list(keys_pressed):
                # 1. Victory / Defeat Screen Navigation
                if self.engine.phase in (CombatPhase.BATTLE_VICTORY, CombatPhase.BATTLE_DEFEAT):
                    if key_info.key in (KeyCode.ENTER, KeyCode.SPACE) or key_info.char in ("\r", "\n", " ", "q", "Q"):
                        keys_pressed.clear()
                        if core and hasattr(core, "game_state"):
                            transition_state = core.game_state.states.get("GSMatrixTransitionScreen")
                            if transition_state:
                                transition_state.configure(
                                    source_lines=self.generate_frame_lines(),
                                    target_event="EnterNoiseMap",
                                    target_state="GSNoiseMapTestScreen",
                                )
                            core.game_state.trigger("FromCombat", context)
                        return
                    continue

                # 2. Execution Phase: Keys (Cheat Win [K], Exit [Q])
                if self.engine.phase == CombatPhase.EXECUTION_PHASE:
                    if key_info.char in ("k", "K"):
                        for e in self.squad.enemies:
                            e.take_damage(99999)
                        self.engine._trigger_victory()
                        keys_pressed.remove(key_info)
                        break
                    elif key_info.char in ("q", "Q"):
                        keys_pressed.clear()
                        if core and hasattr(core, "game_state"):
                            transition_state = core.game_state.states.get("GSMatrixTransitionScreen")
                            if transition_state:
                                transition_state.configure(
                                    source_lines=self.generate_frame_lines(),
                                    target_event="EnterNoiseMap",
                                    target_state="GSNoiseMapTestScreen",
                                )
                            core.game_state.trigger("FromCombat", context)
                        return
                    continue

                # 3. Command Planning Phase
                if self.engine.phase == CombatPhase.COMMAND_PHASE:
                    # Debug Cheat: Instant win [K]
                    if key_info.char in ("k", "K"):
                        for e in self.squad.enemies:
                            e.take_damage(99999)
                        self.engine._trigger_victory()
                        keys_pressed.remove(key_info)
                        break

                    # Flee / Return to Overworld [Esc]
                    if key_info.key == KeyCode.ESCAPE or key_info.char in ("q", "Q"):
                        keys_pressed.clear()
                        if core and hasattr(core, "game_state"):
                            transition_state = core.game_state.states.get("GSMatrixTransitionScreen")
                            if transition_state:
                                transition_state.configure(
                                    source_lines=self.generate_frame_lines(),
                                    target_event="EnterNoiseMap",
                                    target_state="GSNoiseMapTestScreen",
                                )
                            core.game_state.trigger("FromCombat", context)
                        return

                    if self.menu_mode == "MAIN":
                        self._handle_main_menu_input(key_info)
                        keys_pressed.remove(key_info)
                        break
                    elif self.menu_mode in ("SKILLS", "SPELLS", "ITEMS"):
                        self._handle_sub_menu_input(key_info)
                        keys_pressed.remove(key_info)
                        break
                    elif self.menu_mode == "TARGET_SELECT":
                        self._handle_target_input(key_info)
                        keys_pressed.remove(key_info)
                        break

        # Automatic step execution during EXECUTION_PHASE
        if self.engine.phase == CombatPhase.EXECUTION_PHASE:
            self.execution_timer += delta_time
            if self.execution_timer >= self.step_delay:
                self.execution_timer = 0.0
                self.engine.step_execution()

                # If round completed and returned to COMMAND_PHASE, reset active hero to hero 1
                if self.engine.phase == CombatPhase.COMMAND_PHASE:
                    self.active_member_idx = self._find_first_living_member()
                    self.menu_mode = "MAIN"
                    self.main_menu_cursor = 0
                    self.sub_menu_cursor = 0
                    self.selected_action = None
                    self.target_type = "ENEMY"

        # Transition guard: do not render if transitioned away
        if core and hasattr(core, "game_state") and core.game_state.current_state != self.name:
            return

        self._render()

    def _handle_main_menu_input(self, key_info: any) -> None:
        curr_member = self.party.get_member(self.active_member_idx)
        if curr_member is None or not curr_member.is_alive:
            nxt = self._find_next_living_member(self.active_member_idx)
            if nxt is not None:
                self.active_member_idx = nxt
            return

        # Up/Down navigation (arrow keys only)
        if key_info.key == KeyCode.UP:
            self.main_menu_cursor = (self.main_menu_cursor - 1) % 5
        elif key_info.key == KeyCode.DOWN:
            self.main_menu_cursor = (self.main_menu_cursor + 1) % 5
        elif key_info.char in ("1", "2", "3", "4", "5"):
            self.main_menu_cursor = int(key_info.char) - 1
            self._activate_main_menu_selection()
        elif key_info.key == KeyCode.ENTER or key_info.char in ("\r", "\n", " "):
            self._activate_main_menu_selection()
        elif key_info.key == KeyCode.BACKSPACE or key_info.char in ("b", "B", "\x7f", "\x08"):
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
            self.target_type = "ENEMY"
            self.target_cursor = self._get_first_alive_enemy_idx()
            self.inspected_enemy_idx = self.target_cursor
        elif self.main_menu_cursor == 1:  # Skills
            self.menu_mode = "SKILLS"
            self.sub_menu_cursor = 0
        elif self.main_menu_cursor == 2:  # Spells
            self.menu_mode = "SPELLS"
            self.sub_menu_cursor = 0
        elif self.main_menu_cursor == 3:  # Item
            items = self._get_battle_items()
            if not items:
                self.engine.log("No battle-usable items in inventory!")
                return
            self.menu_mode = "ITEMS"
            self.sub_menu_cursor = 0
        elif self.main_menu_cursor == 4:  # Defend
            defend_act = ACTIONS["Defend"].copy()
            self.engine.plan_member_action(self.active_member_idx, defend_act, curr_member)
            self._advance_to_next_member()

    def _get_battle_items(self) -> list[tuple[ConsumableItem, int]]:
        """Returns all battle-usable items from inventory with quantities."""
        results = []
        for entry in self.party.inventory:
            item_id = entry.get("item_id", entry.get("name", ""))
            item_obj = get_item(item_id)
            if item_obj is not None and item_obj.usable_in_battle:
                qty = entry.get("qty", 1)
                if qty > 0:
                    results.append((item_obj, qty))
        return results

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
        if key_info.key == KeyCode.ESCAPE or key_info.char in ("b", "B", "q", "Q"):
            self.menu_mode = "MAIN"
            return

        if self.menu_mode == "ITEMS":
            items = self._get_battle_items()
            if not items:
                self.menu_mode = "MAIN"
                return

            if key_info.key == KeyCode.UP:
                self.sub_menu_cursor = (self.sub_menu_cursor - 1) % len(items)
            elif key_info.key == KeyCode.DOWN:
                self.sub_menu_cursor = (self.sub_menu_cursor + 1) % len(items)
            elif key_info.char in [str(i) for i in range(1, min(10, len(items) + 1))]:
                self.sub_menu_cursor = int(key_info.char) - 1
                item_obj, _ = items[self.sub_menu_cursor]
                self._choose_item_action(item_obj)
            elif key_info.key == KeyCode.ENTER or key_info.char in ("\r", "\n", " "):
                item_obj, _ = items[self.sub_menu_cursor]
                self._choose_item_action(item_obj)
            return

        cat = ActionCategory.SKILL if self.menu_mode == "SKILLS" else ActionCategory.SPELL
        act_list = self._get_available_actions(cat)

        if not act_list:
            self.menu_mode = "MAIN"
            return

        if key_info.key == KeyCode.UP:
            self.sub_menu_cursor = (self.sub_menu_cursor - 1) % len(act_list)
        elif key_info.key == KeyCode.DOWN:
            self.sub_menu_cursor = (self.sub_menu_cursor + 1) % len(act_list)
        elif key_info.char in [str(i) for i in range(1, min(10, len(act_list) + 1))]:
            self.sub_menu_cursor = int(key_info.char) - 1
            self._choose_sub_action(act_list[self.sub_menu_cursor])
        elif key_info.key == KeyCode.ENTER or key_info.char in ("\r", "\n", " "):
            self._choose_sub_action(act_list[self.sub_menu_cursor])

    def _choose_item_action(self, item_obj: ConsumableItem) -> None:
        action = item_obj.to_battle_action()
        self.selected_action = action.copy()

        if action.target_scope == TargetScope.ALL_ENEMIES:
            dummy_target = self.squad.enemies[0]
            self.engine.plan_member_action(self.active_member_idx, action, dummy_target)
            self._advance_to_next_member()
        elif action.target_scope == TargetScope.ALL_ALLIES:
            dummy_target = self.party.members[0]
            self.engine.plan_member_action(self.active_member_idx, action, dummy_target)
            self._advance_to_next_member()
        elif action.target_scope == TargetScope.SINGLE_ALLY:
            self.menu_mode = "TARGET_SELECT"
            self.target_type = "ALLY"
            if item_obj.effect_type == ItemEffectType.REVIVE:
                ko_allies = [i for i, m in enumerate(self.party.members) if not m.is_alive]
                self.target_cursor = ko_allies[0] if ko_allies else 0
            else:
                alive_allies = [i for i, m in enumerate(self.party.members) if m.is_alive]
                self.target_cursor = alive_allies[0] if alive_allies else 0
        else:  # SINGLE_ENEMY
            self.menu_mode = "TARGET_SELECT"
            self.target_type = "ENEMY"
            self.target_cursor = self._get_first_alive_enemy_idx()
            self.inspected_enemy_idx = self.target_cursor

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
        elif action.target_scope == TargetScope.SINGLE_ALLY:
            self.menu_mode = "TARGET_SELECT"
            self.target_type = "ALLY"
            alive_allies = [i for i, m in enumerate(self.party.members) if m.is_alive]
            self.target_cursor = alive_allies[0] if alive_allies else 0
        else:
            self.menu_mode = "TARGET_SELECT"
            self.target_type = "ENEMY"
            self.target_cursor = self._get_first_alive_enemy_idx()
            self.inspected_enemy_idx = self.target_cursor

    def _handle_target_input(self, key_info: any) -> None:
        if key_info.key == KeyCode.ESCAPE or key_info.char in ("b", "B"):
            self.menu_mode = "MAIN"
            return

        if self.target_type == "ALLY":
            is_revive = (
                self.selected_action is not None
                and self.selected_action.category == ActionCategory.ITEM
                and self.selected_action.name == "Revive Herb"
            )
            if is_revive:
                candidates = [i for i, m in enumerate(self.party.members) if not m.is_alive]
                if not candidates:
                    candidates = list(range(len(self.party.members)))
            else:
                candidates = [i for i, m in enumerate(self.party.members) if m.is_alive]

            if not candidates:
                self.menu_mode = "MAIN"
                return

            if key_info.key in (KeyCode.LEFT, KeyCode.UP):
                cur_pos = candidates.index(self.target_cursor) if self.target_cursor in candidates else 0
                self.target_cursor = candidates[(cur_pos - 1) % len(candidates)]
            elif key_info.key in (KeyCode.RIGHT, KeyCode.DOWN):
                cur_pos = candidates.index(self.target_cursor) if self.target_cursor in candidates else 0
                self.target_cursor = candidates[(cur_pos + 1) % len(candidates)]
            elif key_info.char in [str(i) for i in range(1, len(self.party.members) + 1)]:
                idx = int(key_info.char) - 1
                if idx in candidates:
                    self.target_cursor = idx
                    self._confirm_target_selection()
            elif key_info.key == KeyCode.ENTER or key_info.char in ("\r", "\n", " "):
                self._confirm_target_selection()
            return

        alive_indices = [i for i, e in enumerate(self.squad.enemies) if e.is_alive]
        if not alive_indices:
            return

        # Arrow navigation
        if key_info.key in (KeyCode.LEFT, KeyCode.UP):
            cur_pos = alive_indices.index(self.target_cursor) if self.target_cursor in alive_indices else 0
            new_pos = (cur_pos - 1) % len(alive_indices)
            self.target_cursor = alive_indices[new_pos]
            self.inspected_enemy_idx = self.target_cursor
        elif key_info.key in (KeyCode.RIGHT, KeyCode.DOWN):
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
        if self.selected_action is None:
            self.selected_action = ACTIONS["Attack"].copy()

        if self.target_type == "ALLY":
            target_member = self.party.get_member(self.target_cursor)
            if target_member is None:
                return
            self.engine.plan_member_action(self.active_member_idx, self.selected_action, target_member)
            self._advance_to_next_member()
        else:
            target_enemy = self.squad.get_enemy(self.target_cursor)
            if target_enemy is None or not target_enemy.is_alive:
                return
            self.engine.plan_member_action(self.active_member_idx, self.selected_action, target_enemy)
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
                self.execution_timer = 0.0
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
    def generate_frame_lines(self) -> List[str]:
        """Generates list of row strings representing the current combat screen frame."""
        lines: List[str] = []

        # Top border
        top_str = "┌─ ENEMY SQUAD (Up to 10 Enemies) " + ("─" * 20) + "┬─ TARGET DETAIL " + ("─" * 8) + "┐"
        lines.append(top_str)

        # Lines 2..6: Enemy Squad (Left 53 chars) and Target Detail (Right 24 chars)
        for row_idx in range(5):
            left_str = self._format_enemy_row(row_idx)
            right_str = self._format_target_detail_row(row_idx)
            lines.append(f"│{left_str}│{right_str}│")

        # Divider 1 (Row 7)
        lines.append("├" + ("─" * 53) + "┴" + ("─" * 24) + "┤")

        # Row 8: Player Party Header
        lines.append("│ PLAYER PARTY (Up to 5 Heroes) " + (" " * 47) + "│")

        # Rows 9..13: Party Members
        for m_idx in range(5):
            p_str = self._format_party_member_row(m_idx)
            lines.append(f"│{p_str}│")

        # Divider 2 (Row 14)
        lines.append("├" + ("─" * 24) + "┬" + ("─" * 53) + "┤")

        # Rows 15..22: Commands (Left 24 chars) and Combat Log (Right 53 chars)
        wrapped_logs = self._get_wrapped_log_lines(max_width=52)
        for c_idx in range(8):
            cmd_cell = self._format_command_cell(c_idx)
            log_cell = self._format_log_cell(c_idx, wrapped_logs)
            lines.append(f"│{cmd_cell}│{log_cell}│")

        # Bottom Border (Row 23)
        lines.append("└" + ("─" * 24) + "┴" + ("─" * 53) + "┘")

        # Row 24: Navigation / Action Hints
        hints = self._format_status_hints()
        lines.append(_pad_cell(f" {hints}", self.TOTAL_WIDTH))

        return lines

    def _render(self) -> None:
        """Atomic frame render of the 80x40 NvN combat screen."""
        lines = self.generate_frame_lines()
        out: List[str] = [ATControlSequences.DrawOptimizeOn]

        for idx, line in enumerate(lines):
            out.append(ATCoordinates(1 + idx, 1).to_ansi())
            out.append(line)

        # Clear tail lines up to 40
        out.append(clear_buffer_tail(len(lines) + 1, 40))

        out.append(ATControlSequences.DrawOptimizeOff)
        TerminalScreen.write("".join(out))
        TerminalScreen.flush()

    def _format_enemy_row(self, row_idx: int) -> str:
        """Left side: Displays enemy [1..5] in col 1, [6..10] in col 2 (53 characters total)."""
        idx1 = row_idx
        idx2 = row_idx + 5

        def format_enemy_slot(idx: int) -> str:
            if idx >= len(self.squad.enemies):
                return " " * 25
            e = self.squad.enemies[idx]
            tag = f"[{idx + 1}]"
            is_targeted = (self.menu_mode == "TARGET_SELECT" and self.target_cursor == idx) or (self.inspected_enemy_idx == idx)
            prefix = "\033[1;33m❱\033[0m" if is_targeted else " "

            if not e.is_alive:
                text = f"{prefix}{tag:<4} {e.name[:6]:<6} \033[31m[DEAD]\033[0m"
                return _pad_cell(text, 25)

            hp_str = f"{e.hp}/{e.max_hp}"
            aff_str = e.affinity.value.replace("Elemental", "")[:3]
            text = f"{prefix}{tag:<4} {e.name[:6]:<6} {hp_str[:7]:<7} {aff_str:<3}"
            return _pad_cell(text, 25)

        col1 = format_enemy_slot(idx1)
        col2 = format_enemy_slot(idx2)
        combined = f" {col1} {col2} "
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
            bar = _make_bar(target.hp, target.max_hp, length=8, bar_type=StatBarType.HEALTH)
            hp_txt = f" HP: {target.hp}/{target.max_hp} {bar}"
            return _pad_cell(hp_txt, self.RIGHT_COL_WIDTH)
        elif row_idx == 3:
            badge = format_element_badge(target.affinity)
            aff_txt = f" Affinity: {badge}"
            return _pad_cell(aff_txt, self.RIGHT_COL_WIDTH)
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
        """Middle rack: Hero summary with HP, MP, equipment readiness, and planned intent (78 chars)."""
        if member_idx >= len(self.party.members):
            return " " * 78
        m = self.party.members[member_idx]
        is_active = (self.engine.phase == CombatPhase.COMMAND_PHASE and self.active_member_idx == member_idx)
        is_targeted_ally = (self.menu_mode == "TARGET_SELECT" and self.target_type == "ALLY" and self.target_cursor == member_idx)
        if is_targeted_ally:
            prefix = "\033[1;33m❱\033[0m"
        else:
            prefix = "\033[1;36m❱\033[0m" if is_active else " "

        name_class = f"{m.name} ({m.job_class})"
        if not m.is_alive:
            txt = f"{prefix} {member_idx + 1}. {name_class[:16]:<16} \033[31m[FALLEN IN COMBAT]\033[0m"
            return _pad_cell(txt, 78)

        hp_str = f"HP:{m.hp}/{m.max_hp}"
        mp_str = f"MP:{m.mp}/{m.max_mp}"
        hp_bar = _make_bar(m.hp, m.max_hp, length=4, bar_type=StatBarType.HEALTH)

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

        line = f"{prefix} {member_idx + 1}. {name_class[:16]:<16} {hp_str[:11]:<11} {hp_bar} {mp_str[:10]:<10} {status_tag} {intent_str[:18]:<18}"
        return _pad_cell(line, 78)

    def _format_command_cell(self, row_idx: int) -> str:
        """Bottom Left: Command selector or target selection prompt (24 chars)."""
        curr_member = self.party.get_member(self.active_member_idx)
        name = curr_member.name if curr_member else "Hero"

        if row_idx == 0:
            if self.engine.phase == CombatPhase.EXECUTION_PHASE:
                return _pad_cell(" EXECUTION PHASE", 24)
            elif self.menu_mode == "TARGET_SELECT":
                target_tag = "ALLY" if self.target_type == "ALLY" else "ENEMY"
                return _pad_cell(f" TARGET {target_tag}", 24)
            elif self.menu_mode == "SKILLS":
                return _pad_cell(f" SKILLS ({name})", 24)
            elif self.menu_mode == "SPELLS":
                return _pad_cell(f" SPELLS ({name})", 24)
            elif self.menu_mode == "ITEMS":
                return _pad_cell(f" ITEMS ({name})", 24)
            else:
                return _pad_cell(f" COMMANDS ({name})", 24)

        if self.engine.phase == CombatPhase.EXECUTION_PHASE:
            if row_idx == 1:
                return _pad_cell(" Resolving turns...", 24)
            elif row_idx == 3:
                return _pad_cell("   [K] Cheat Win", 24)
            return " " * 24

        if self.menu_mode == "MAIN":
            options = ["[1] Attack", "[2] Skills", "[3] Spells", "[4] Item", "[5] Defend"]
            opt_idx = row_idx - 1
            if 0 <= opt_idx < len(options):
                cursor = "❱ " if self.main_menu_cursor == opt_idx else "  "
                return _pad_cell(f" {cursor}{options[opt_idx]}", 24)
            return " " * 24

        if self.menu_mode in ("SKILLS", "SPELLS"):
            cat = ActionCategory.SKILL if self.menu_mode == "SKILLS" else ActionCategory.SPELL
            actions = self._get_available_actions(cat)
            opt_idx = row_idx - 1
            if 0 <= opt_idx < len(actions):
                act = actions[opt_idx]
                cursor = "❱ " if self.sub_menu_cursor == opt_idx else "  "
                txt = f" {cursor}[{opt_idx + 1}] {act.name} ({act.mp_cost}M)"
                return _pad_cell(txt[:23], 24)
            elif opt_idx == len(actions):
                return _pad_cell("   [Esc] Back", 24)
            return " " * 24

        if self.menu_mode == "ITEMS":
            items = self._get_battle_items()
            opt_idx = row_idx - 1
            if 0 <= opt_idx < len(items):
                item_obj, qty = items[opt_idx]
                cursor = "❱ " if self.sub_menu_cursor == opt_idx else "  "
                txt = f" {cursor}[{opt_idx + 1}] {item_obj.name[:12]} x{qty}"
                return _pad_cell(txt[:23], 24)
            elif opt_idx == len(items):
                return _pad_cell("   [Esc] Back", 24)
            return " " * 24

        if self.menu_mode == "TARGET_SELECT":
            if self.target_type == "ALLY":
                target = self.party.get_member(self.target_cursor)
                target_name = target.name if target else "Ally"
                if row_idx == 1:
                    return _pad_cell(f" ❱ [{self.target_cursor + 1}] {target_name}", 24)
                elif row_idx == 2:
                    return _pad_cell("   [Arrows] Cycle", 24)
                elif row_idx == 3:
                    return _pad_cell("   [1..5] Direct", 24)
                elif row_idx == 4:
                    return _pad_cell("   [Enter] Confirm", 24)
                elif row_idx == 5:
                    return _pad_cell("   [Esc] Cancel", 24)
                return " " * 24
            else:
                target = self.squad.get_enemy(self.target_cursor)
                target_name = target.name if target else "Enemy"
                if row_idx == 1:
                    return _pad_cell(f" ❱ [{self.target_cursor + 1}] {target_name}", 24)
                elif row_idx == 2:
                    return _pad_cell("   [Arrows] Cycle", 24)
                elif row_idx == 3:
                    return _pad_cell("   [1..10] Direct", 24)
                elif row_idx == 4:
                    return _pad_cell("   [Enter] Confirm", 24)
                elif row_idx == 5:
                    return _pad_cell("   [Esc] Cancel", 24)
                return " " * 24

        return " " * 24

    def _get_wrapped_log_lines(self, max_width: int = 52) -> list[str]:
        """Returns all combat log messages word-wrapped to fit within the log panel width."""
        wrapped: list[str] = []
        for msg in self.engine.combat_log:
            wrapped.extend(wrap_text(msg, max_visible_len=max_width, subsequent_indent="  "))
        return wrapped

    def _format_log_cell(self, row_idx: int, wrapped_logs: Optional[list[str]] = None) -> str:
        """Bottom Right: Scrolling battle log (53 chars)."""
        if row_idx == 0:
            return _pad_cell(" COMBAT LOG", 53)

        if wrapped_logs is None:
            wrapped_logs = self._get_wrapped_log_lines(max_width=52)

        # Show last 7 combat log messages
        log_slice = wrapped_logs[-7:]
        log_offset = row_idx - 1
        if 0 <= log_offset < len(log_slice):
            msg = log_slice[log_offset]
            return _pad_cell(f" {msg}", 53)
        return " " * 53

    def _format_status_hints(self) -> str:
        if self.engine.phase == CombatPhase.BATTLE_VICTORY:
            return "\033[1;32m★ VICTORY! [Enter/Space] Return to Map\033[0m"
        elif self.engine.phase == CombatPhase.BATTLE_DEFEAT:
            return "\033[1;31m☠ DEFEAT! [Enter/Space] Return to Map\033[0m"
        elif self.engine.phase == CombatPhase.EXECUTION_PHASE:
            return "\033[33mResolving combat actions...  [K] Cheat Win  [Q] Exit Battle\033[0m"
        elif self.menu_mode == "TARGET_SELECT":
            return "\033[33m[1..10/Arrows] Select Target  [Enter] Confirm  [Esc] Back\033[0m"
        elif self.menu_mode in ("SKILLS", "SPELLS"):
            return "\033[33m[1..N/Arrows] Select Action  [Enter] Confirm  [Esc] Back\033[0m"
        elif self.menu_mode == "ITEMS":
            return "\033[33m[1..N/Arrows] Select Item  [Enter] Confirm  [Esc] Back\033[0m"
        else:
            can_go_back = any(self.party.members[i].is_alive for i in range(self.active_member_idx - 1, -1, -1))
            prev_hint = "  [B] Back" if can_go_back else ""
            return f"\033[33m[1..5/Arrows] Choose Action{prev_hint}  [K] Cheat Win  [Esc] Flee\033[0m"
