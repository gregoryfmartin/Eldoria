"""
NPCDialogModal: Interactive dialogue and modal system for NPC conversations.
Supports 7-row fixed bottom text modal, word-wrapped paging, teletype rendering,
paging indicator (yellow down arrow), completion indicator (emerald checkmark),
and miniature right-aligned choice modal for interactive selections.
"""

from __future__ import annotations
from dataclasses import dataclass
from enum import Enum
import time
from typing import Any, Callable, Dict, List, Optional, Tuple

from ..procgen.npc import NPC, DialogCategory
from ..terminal.ansi import ATCoordinates, ATControlSequences
from ..terminal.box import (
    make_border_row,
    make_box_row,
    strip_ansi,
    visible_width,
    wrap_text,
)
from ..terminal.color import ColorLibrary
from ..terminal.input import KeyCode, KeyEvent


class DialogState(str, Enum):
    """Lifecycle states of an NPC dialogue interaction."""
    TELETYPING = "TELETYPING"
    PAGE_WAITING = "PAGE_WAITING"
    CHOICE_WAITING = "CHOICE_WAITING"
    FINISHED = "FINISHED"
    CLOSED = "CLOSED"


@dataclass
class DialogChoice:
    """Represents a selectable choice option in a choice modal."""
    label: str
    action: Optional[Callable[[], None]] = None


class NPCDialogModal:
    """
    Component managing the modal dialog UI for NPC interactions.
    - 7 rows in height at bottom of screen.
    - 2-cell horizontal padding and 1-cell vertical padding.
    - Up to 3 lines of dialogue text per page.
    - Paging with down arrow (▼) and completion with checkmark (✔).
    - Miniature choice modal aligned on the right above the text modal.
    """

    def __init__(
        self,
        screen_width: int = 54,
        screen_height: int = 27,
        chars_per_second: float = 35.0,
    ) -> None:
        self.screen_width: int = screen_width
        self.screen_height: int = screen_height
        self.chars_per_second: float = chars_per_second

        # Active conversation data
        self.npc: Optional[NPC] = None
        self.title: str = ""
        self.raw_text: str = ""
        self.pages: List[List[str]] = []
        self.current_page_idx: int = 0
        self.state: DialogState = DialogState.CLOSED

        # Teletype animation metrics
        self.page_start_time: float = 0.0
        self.chars_revealed: int = 0
        self.total_page_chars: int = 0
        self.is_flushed: bool = False

        # Choice modal attributes
        self.choices: List[DialogChoice] = []
        self.choice_cursor: int = 0
        self.category: DialogCategory = DialogCategory.STANDARD

        # Target selection mode (for disambiguating 2+ adjacent NPCs)
        self.is_target_selection: bool = False
        self.target_npcs: List[Tuple[NPC, str]] = []
        self.on_target_selected: Optional[Callable[[NPC], None]] = None

        # General close callback
        self.on_close_callback: Optional[Callable[[], None]] = None

    @property
    def is_active(self) -> bool:
        """Returns True if the modal is currently open and intercepting input."""
        return self.state != DialogState.CLOSED

    def start_dialog(
        self,
        npc: NPC,
        custom_text: Optional[str] = None,
        choices: Optional[List[DialogChoice]] = None,
        on_close: Optional[Callable[[], None]] = None,
    ) -> None:
        """Initializes and opens a conversation with the specified NPC."""
        self.npc = npc
        self.title = npc.name
        self.category = npc.category
        self.is_target_selection = False
        self.target_npcs = []
        self.on_close_callback = on_close

        # Dialogue text
        text = custom_text if custom_text is not None else npc.dialogue
        self.raw_text = text

        # Usable width: W - 2 (borders) - 4 (2 padding each side) = W - 6
        usable_width = max(10, self.screen_width - 6)
        self.pages = self._paginate_text(text, usable_width, max_lines_per_page=3)
        self.current_page_idx = 0

        # Configure choices if category is CHOICE
        self.choices = []
        self.choice_cursor = 0
        if choices:
            self.choices = list(choices)
        elif self.category == DialogCategory.CHOICE:
            opts = npc.choice_options if npc.choice_options else ["Yes", "No"]
            self.choices = [DialogChoice(label=opt) for opt in opts]

        self._start_page(0)

    def start_target_selection(
        self,
        adjacent_npcs: List[Tuple[NPC, str]],
        on_select: Callable[[NPC], None],
        on_close: Optional[Callable[[], None]] = None,
    ) -> None:
        """Opens a target disambiguation modal when 2+ NPCs are adjacent."""
        self.is_target_selection = True
        self.target_npcs = list(adjacent_npcs)
        self.on_target_selected = on_select
        self.on_close_callback = on_close
        self.npc = None
        self.title = "Interact"
        self.category = DialogCategory.CHOICE

        self.raw_text = "Who would you like to speak to?"
        usable_width = max(10, self.screen_width - 6)
        self.pages = self._paginate_text(self.raw_text, usable_width, max_lines_per_page=3)
        self.current_page_idx = 0

        self.choices = [
            DialogChoice(label=f"{npc.name} ({direction})")
            for npc, direction in adjacent_npcs
        ]
        self.choice_cursor = 0
        self._start_page(0)

    def _paginate_text(self, text: str, max_line_width: int, max_lines_per_page: int = 3) -> List[List[str]]:
        """Splits dialogue text into word-wrapped lines and groups them into 3-line pages."""
        wrapped_lines = wrap_text(text, max_line_width)
        if not wrapped_lines:
            return [[""]]

        pages: List[List[str]] = []
        for i in range(0, len(wrapped_lines), max_lines_per_page):
            pages.append(wrapped_lines[i : i + max_lines_per_page])
        return pages if pages else [[""]]

    def _start_page(self, page_idx: int) -> None:
        """Begins teletyping a specific page of dialogue."""
        self.current_page_idx = page_idx
        self.page_start_time = time.monotonic()
        self.is_flushed = False

        if 0 <= page_idx < len(self.pages):
            page_lines = self.pages[page_idx]
            self.total_page_chars = sum(len(line) for line in page_lines)
        else:
            self.total_page_chars = 0

        self.chars_revealed = 0
        self.state = DialogState.TELETYPING
        self._update_teletype()

    def _update_teletype(self) -> None:
        """Updates the revealed character count based on elapsed time."""
        if self.state != DialogState.TELETYPING:
            return

        if self.is_flushed:
            self.chars_revealed = self.total_page_chars
        else:
            elapsed = max(0.0, time.monotonic() - self.page_start_time)
            self.chars_revealed = min(
                self.total_page_chars,
                int(elapsed * self.chars_per_second),
            )

        if self.chars_revealed >= self.total_page_chars:
            is_last_page = self.current_page_idx >= len(self.pages) - 1
            if not is_last_page:
                self.state = DialogState.PAGE_WAITING
            else:
                if self.category == DialogCategory.CHOICE and self.choices:
                    self.state = DialogState.CHOICE_WAITING
                else:
                    self.state = DialogState.FINISHED

    def flush_page(self) -> None:
        """Immediately reveals all characters on the current page."""
        self.is_flushed = True
        self._update_teletype()

    def advance_or_act(self) -> None:
        """
        Handles Enter key interaction:
        - If teletyping: flushes current page immediately.
        - If page waiting: advances to next page.
        - If choice waiting: executes selected choice.
        - If finished: closes modal.
        """
        self._update_teletype()

        if self.state == DialogState.TELETYPING:
            self.flush_page()
            return

        if self.state == DialogState.PAGE_WAITING:
            if self.current_page_idx < len(self.pages) - 1:
                self._start_page(self.current_page_idx + 1)
            return

        if self.state == DialogState.CHOICE_WAITING:
            if 0 <= self.choice_cursor < len(self.choices):
                choice = self.choices[self.choice_cursor]
                if self.is_target_selection and self.on_target_selected:
                    selected_npc = self.target_npcs[self.choice_cursor][0]
                    self.on_target_selected(selected_npc)
                    return
                if choice.action:
                    choice.action()
            self.close()
            return

        if self.state == DialogState.FINISHED:
            self.close()
            return

    def move_cursor_up(self) -> None:
        """Moves selection cursor up in choice modal."""
        if self.state == DialogState.CHOICE_WAITING and self.choices:
            self.choice_cursor = (self.choice_cursor - 1) % len(self.choices)

    def move_cursor_down(self) -> None:
        """Moves selection cursor down in choice modal."""
        if self.state == DialogState.CHOICE_WAITING and self.choices:
            self.choice_cursor = (self.choice_cursor + 1) % len(self.choices)

    def close(self) -> None:
        """Closes the dialogue modal and invokes close callback."""
        self.state = DialogState.CLOSED
        if self.on_close_callback:
            self.on_close_callback()

    def handle_key(self, key_info: KeyEvent) -> bool:
        """
        Processes key events when the dialog is active.
        Returns True if the event was handled by the modal.
        """
        if not self.is_active:
            return False

        if key_info.key == KeyCode.UP:
            if self.state == DialogState.CHOICE_WAITING:
                self.move_cursor_up()
            return True

        if key_info.key == KeyCode.DOWN:
            if self.state == DialogState.CHOICE_WAITING:
                self.move_cursor_down()
            return True

        if key_info.key == KeyCode.ENTER or key_info.char in ("\r", "\n"):
            self.advance_or_act()
            return True

        if key_info.key == KeyCode.ESCAPE or key_info.char in ("q", "Q"):
            self.close()
            return True

        return True

    def render_overlay(self) -> List[Tuple[int, int, str]]:
        """
        Generates list of (row, col, ansi_string) drawing commands for the active modal.
        - Text modal: bottom 7 rows spanning screen_width.
        - Choice modal (if active): positioned above text modal, aligned on the right.
        """
        if not self.is_active:
            return []

        self._update_teletype()
        commands: List[Tuple[int, int, str]] = []

        # -------------------------------------------------------------
        # 1. Main Text Modal (7 rows)
        # -------------------------------------------------------------
        modal_height = 7
        modal_top = max(1, self.screen_height - modal_height + 1)
        w = self.screen_width

        # Title formatting: ╭── [ NPC Name ] ──────────────────────────╮
        title_badge = f" [ \033[1;37m{self.title}\033[0m ] " if self.title else ""
        top_border = make_border_row(
            title=title_badge,
            width=w,
            left="╭",
            fill="─",
            right="╮",
            clear_eol=False,
        )
        commands.append((modal_top, 1, top_border))

        # Row 2: Empty vertical padding (1 cell top padding)
        empty_row = make_box_row("", width=w, left="│  ", right="  │", clear_eol=False)
        commands.append((modal_top + 1, 1, empty_row))

        # Rows 3..5: 3 Text rows with revealed characters
        curr_page = self.pages[self.current_page_idx] if 0 <= self.current_page_idx < len(self.pages) else []
        revealed_lines = self._get_revealed_page_lines(curr_page)

        for idx in range(3):
            line_text = revealed_lines[idx] if idx < len(revealed_lines) else ""
            content_row = make_box_row(
                line_text,
                width=w,
                left="│  ",
                right="  │",
                clear_eol=False,
            )
            commands.append((modal_top + 2 + idx, 1, content_row))

        # Row 6: Empty vertical padding (1 cell bottom padding)
        commands.append((modal_top + 5, 1, empty_row))

        # Row 7: Bottom border with paging arrow (▼) or completion checkmark (✔)
        is_last_page = self.current_page_idx >= len(self.pages) - 1
        indicator_badge = ""

        if self.state == DialogState.PAGE_WAITING and not is_last_page:
            # Yellow down arrow for paging
            indicator_badge = " [ \033[1;33m▼\033[0m ] "
        elif self.state == DialogState.FINISHED and is_last_page and self.category == DialogCategory.STANDARD:
            # Emerald green checkmark for completion
            indicator_badge = " [ \033[1;32m✔\033[0m ] "

        bottom_border = self._make_bottom_border_with_badge(w, indicator_badge)
        commands.append((modal_top + 6, 1, bottom_border))

        # -------------------------------------------------------------
        # 2. Miniature Choice Modal (if active in CHOICE_WAITING)
        # -------------------------------------------------------------
        if self.state == DialogState.CHOICE_WAITING and self.choices:
            choice_cmds = self._render_choice_modal(modal_top)
            commands.extend(choice_cmds)

        return commands

    def _get_revealed_page_lines(self, page_lines: List[str]) -> List[str]:
        """Calculates visible substring of lines based on teletype chars_revealed."""
        revealed: List[str] = []
        rem = self.chars_revealed

        for line in page_lines:
            line_len = len(line)
            if rem <= 0:
                revealed.append("")
            elif rem >= line_len:
                revealed.append(line)
                rem -= line_len
            else:
                revealed.append(line[:rem])
                rem = 0

        while len(revealed) < 3:
            revealed.append("")
        return revealed

    def _make_bottom_border_with_badge(self, width: int, badge: str) -> str:
        """Constructs bottom border ╰───...[icon]─╯ with right-aligned badge if present."""
        if not badge:
            return make_border_row(title="", width=width, left="╰", fill="─", right="╯", clear_eol=False)

        badge_w = visible_width(badge)
        rem = max(0, width - 2 - badge_w)
        left_fill = "─" * (rem - 2 if rem >= 2 else rem)
        right_fill = "──" if rem >= 2 else ""
        return f"╰{left_fill}{badge}{right_fill}╯"

    def _render_choice_modal(self, text_modal_top: int) -> List[Tuple[int, int, str]]:
        """Renders the miniature choice box immediately above the text modal, right-aligned."""
        num_choices = len(self.choices)
        choice_height = num_choices + 4  # 1 top border + 1 top pad + N choices + 1 bottom pad + 1 bottom border
        choice_bottom = text_modal_top - 1
        choice_top = max(1, choice_bottom - choice_height + 1)

        # Calculate width based on longest choice label + chevron + padding
        max_label_len = max(visible_width(c.label) for c in self.choices)
        # 1 left border + 2 left pad + 2 chevron ("► ") + label + 2 right pad + 1 right border = max + 8
        choice_width = max(16, max_label_len + 8)
        choice_width = min(self.screen_width, choice_width)

        choice_right = self.screen_width
        choice_left = max(1, choice_right - choice_width + 1)

        cmds: List[Tuple[int, int, str]] = []

        # Top border
        top_row = make_border_row("", width=choice_width, left="╭", fill="─", right="╮", clear_eol=False)
        cmds.append((choice_top, choice_left, top_row))

        # Top padding
        pad_row = make_box_row("", width=choice_width, left="│  ", right="  │", clear_eol=False)
        cmds.append((choice_top + 1, choice_left, pad_row))

        # Choice rows
        inner_content_width = choice_width - 6  # 2 borders + 4 padding
        for idx, choice in enumerate(self.choices):
            row_num = choice_top + 2 + idx
            is_selected = idx == self.choice_cursor
            if is_selected:
                chevron = "\033[1;33m►\033[0m "
                label_str = f"\033[1;37m{choice.label}\033[0m"
            else:
                chevron = "  "
                label_str = f"\033[37m{choice.label}\033[0m"

            raw_choice_line = f"{chevron}{label_str}"
            choice_box_row = make_box_row(
                raw_choice_line,
                width=choice_width,
                left="│  ",
                right="  │",
                clear_eol=False,
            )
            cmds.append((row_num, choice_left, choice_box_row))

        # Bottom padding
        cmds.append((choice_top + 2 + num_choices, choice_left, pad_row))

        # Bottom border
        bottom_row = make_border_row("", width=choice_width, left="╰", fill="─", right="╯", clear_eol=False)
        cmds.append((choice_top + 3 + num_choices, choice_left, bottom_row))

        return cmds
