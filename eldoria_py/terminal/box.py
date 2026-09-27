"""
Fixed terminal box formatting, ANSI-safe line measurement, and row padding utilities.
Standardized around Eldoria's maximum supported buffer dimensions (80x40).
"""

from __future__ import annotations
import re
import unicodedata
from typing import Optional


# Regular expression matching ANSI CSI sequences, OSC/APC strings, and charset shifts
ANSI_REGEX = re.compile(
    r"(\033\[[0-9;?]*[a-zA-Z]|\033_.*?(?:\033\\|\x07)|\033\].*?(?:\033\\|\x07)|\033[()][AB012])"
)


def strip_ansi(text: str) -> str:
    """Removes all ANSI escape codes, returning the visible character sequence."""
    if not text:
        return ""
    return ANSI_REGEX.sub("", text)


def char_width(ch: str) -> int:
    """
    Returns the visual column width (0, 1, or 2) of a single character in a terminal grid.
    Accounts for ANSI controls, zero-width combiners, East Asian Wide/Fullwidth,
    and Unicode emojis/symbols that occupy 2 terminal cells.
    """
    cp = ord(ch)
    # Control codes / zero-width characters
    if cp < 32 or (0x7F <= cp < 0xA0) or unicodedata.combining(ch):
        return 0
    if cp in (0x200B, 0x200C, 0x200D, 0xFEFF):
        return 0
    # East Asian Wide ('W') and Fullwidth ('F') occupy 2 columns
    eaw = unicodedata.east_asian_width(ch)
    if eaw in ("F", "W"):
        return 2
    return 1


def str_width(text: str) -> int:
    """Computes the visible column width of a plain text string."""
    if not text:
        return 0
    return sum(char_width(c) for c in text)


def visible_width(text: str) -> int:
    """Computes the visible column width of text after stripping ANSI escape sequences."""
    if not text:
        return 0
    return str_width(strip_ansi(text))


def truncate_ansi(text: str, max_visible_len: int, ellipsis: str = "") -> str:
    """
    Safely truncates text to max_visible_len visible columns while preserving
    internal ANSI color and styling codes without breaking escape sequences.
    Correctly accounts for multi-column (wide/emoji) characters.
    Appends an SGR reset (\\033[0m) at the conclusion of truncation.
    """
    if not text:
        return ""
    if visible_width(text) <= max_visible_len:
        return text

    target_len = max(0, max_visible_len - visible_width(ellipsis))
    result = []
    visible_count = 0
    tokens = ANSI_REGEX.split(text)

    for token in tokens:
        if not token:
            continue
        if ANSI_REGEX.match(token):
            result.append(token)
        else:
            for ch in token:
                cw = char_width(ch)
                if visible_count + cw > target_len:
                    break
                result.append(ch)
                visible_count += cw
            if visible_count >= target_len:
                break

    if ellipsis and visible_count > 0:
        result.append(ellipsis)
    result.append("\033[0m")
    return "".join(result)


def wrap_text(text: str, max_visible_len: int, subsequent_indent: str = "") -> list[str]:
    """
    Wraps text into lines where length at nearest whole word exceeds max_visible_len,
    carrying the message over to subsequent lines. Preserves ANSI codes and character widths.
    """
    if not text:
        return [""]
    if visible_width(text) <= max_visible_len:
        return [text]

    lines: list[str] = []
    words = text.split(" ")
    curr_line = ""
    curr_indent = ""

    for word in words:
        if not word:
            continue
        test_line = f"{curr_line} {word}" if curr_line else f"{curr_indent}{word}"
        if visible_width(test_line) <= max_visible_len:
            curr_line = test_line
        else:
            if curr_line:
                lines.append(curr_line)
                curr_indent = subsequent_indent
                curr_line = ""
                test_line = f"{curr_indent}{word}"
                if visible_width(test_line) <= max_visible_len:
                    curr_line = test_line
                    continue

            # Word itself (plus indent) exceeds max_visible_len
            w = word
            while w:
                avail = max(1, max_visible_len - visible_width(curr_indent))
                chunk = truncate_ansi(w, avail)
                clean_chunk = re.sub(r"\033\[0m$", "", chunk)
                if not clean_chunk:
                    break
                lines.append(f"{curr_indent}{clean_chunk}")
                w = w[len(strip_ansi(clean_chunk)):]
                curr_indent = subsequent_indent
            curr_line = ""

    if curr_line:
        lines.append(curr_line)

    return lines


def make_box_row(
    content: str,
    width: int = 80,
    left: str = "│ ",
    right: str = " │",
    fill: str = " ",
    clear_eol: bool = True,
) -> str:
    """
    Constructs a content row guaranteed to measure exactly `width` visible columns.
    Emits left border, content, exact space padding, reset modifier, and right border.
    Optionally appends \\033[K (Erase to end of line) to prevent stale characters outside the right margin.
    """
    left_w = str_width(left)
    right_w = str_width(right)
    inner_width = width - left_w - right_w
    vlen = visible_width(content)
    if vlen > inner_width:
        content = truncate_ansi(content, inner_width)
        vlen = visible_width(content)
    pad = fill * max(0, inner_width - vlen)
    eol = "\033[K" if clear_eol else ""
    return f"{left}{content}\033[0m{pad}{right}{eol}"


def make_border_row(
    title: str = "",
    width: int = 80,
    left: str = "╭",
    fill: str = "─",
    right: str = "╮",
    clear_eol: bool = True,
) -> str:
    """
    Constructs a top, bottom, or horizontal divider row guaranteed to measure exactly `width` visible columns.
    If title is provided, centers it with fill characters.
    """
    left_w = str_width(left)
    right_w = str_width(right)
    inner_width = width - left_w - right_w
    eol = "\033[K" if clear_eol else ""
    if not title:
        return f"{left}{fill * inner_width}{right}{eol}"

    vlen = visible_width(title)
    if vlen > inner_width:
        title = truncate_ansi(title, inner_width)
        vlen = visible_width(title)
    rem = max(0, inner_width - vlen)
    lp = rem // 2
    rp = rem - lp
    return f"{left}{fill * lp}{title}\033[0m{fill * rp}{right}{eol}"


def clear_buffer_tail(start_row: int, end_row: int = 40) -> str:
    """
    Generates terminal escape codes to clear lines from start_row to end_row.
    Useful for ensuring no leftover rows remain when transitioning between screens
    with different heights (e.g. 24 rows in an 80x40 terminal).
    """
    parts = []
    for r in range(start_row, end_row + 1):
        parts.append(f"\033[{r};1H\033[2K")
    return "".join(parts)
