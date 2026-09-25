"""
Cross-platform raw terminal input handler.
Supports non-blocking background queue polling, arrow keys, escape sequences, and clean terminal restoration.
"""

from __future__ import annotations
import atexit
import os
import queue
import sys
import threading
import time
from dataclasses import dataclass
from enum import Enum, auto
from typing import List, Optional

# Detect platform
IS_WINDOWS = os.name == "nt"

if not IS_WINDOWS:
    import select
    import termios
    import tty
else:
    import msvcrt


class KeyCode(Enum):
    NONE = auto()
    UP = auto()
    DOWN = auto()
    LEFT = auto()
    RIGHT = auto()
    ENTER = auto()
    ESCAPE = auto()
    TAB = auto()
    SPACE = auto()
    BACKSPACE = auto()
    DELETE = auto()
    CHAR = auto()


@dataclass
class KeyEvent:
    key: KeyCode
    char: str = ""
    raw: str = ""

    def is_key(self, key_code: KeyCode) -> bool:
        return self.key == key_code

    def is_char(self, c: str) -> bool:
        return self.key == KeyCode.CHAR and self.char.lower() == c.lower()


# Alias matching PowerShell's ConsoleKeyInfo
ConsoleKeyInfo = KeyEvent



class InputManager:
    """
    Manages non-blocking keyboard input using a background listener thread
    and thread-safe queue, identical to the Eldoria New New Engine input architecture.
    """

    def __init__(self) -> None:
        self.input_queue: queue.Queue[KeyEvent] = queue.Queue()
        self._running: bool = False
        self._thread: Optional[threading.Thread] = None
        self._original_termios = None

        if not IS_WINDOWS:
            try:
                self._original_termios = termios.tcgetattr(sys.stdin)
            except Exception:
                self._original_termios = None

        atexit.register(self.restore)

    def start(self) -> None:
        """Enables raw mode and begins background key capture."""
        if self._running:
            return
        self._running = True

        if not IS_WINDOWS and self._original_termios and sys.stdin.isatty():
            try:
                tty.setraw(sys.stdin.fileno())
            except Exception:
                pass

        self._thread = threading.Thread(target=self._input_loop, daemon=True, name="EldoriaInputThread")
        self._thread.start()

    def stop(self) -> None:
        """Stops the input listener thread and restores terminal mode."""
        self._running = False
        self.restore()

    def restore(self) -> None:
        """Restores the original terminal state."""
        if not IS_WINDOWS and self._original_termios and sys.stdin.isatty():
            try:
                termios.tcsetattr(sys.stdin, termios.TCSADRAIN, self._original_termios)
            except Exception:
                pass

    def drain_keys(self) -> List[KeyEvent]:
        """Drains and returns all keys pressed during the current frame."""
        keys = []
        while not self.input_queue.empty():
            try:
                keys.append(self.input_queue.get_nowait())
            except queue.Empty:
                break
        return keys

    def _input_loop(self) -> None:
        """Daemon thread loop for reading raw input."""
        while self._running:
            try:
                if IS_WINDOWS:
                    self._read_windows()
                else:
                    self._read_posix()
            except Exception:
                time.sleep(0.01)

    def _read_windows(self) -> None:
        if msvcrt.kbhit():
            ch = msvcrt.getwch()
            if ch in ("\x00", "\xe0"):
                # Extended key
                ch2 = msvcrt.getwch()
                if ch2 == "H":
                    self.input_queue.put(KeyEvent(key=KeyCode.UP, raw=ch + ch2))
                elif ch2 == "P":
                    self.input_queue.put(KeyEvent(key=KeyCode.DOWN, raw=ch + ch2))
                elif ch2 == "K":
                    self.input_queue.put(KeyEvent(key=KeyCode.LEFT, raw=ch + ch2))
                elif ch2 == "M":
                    self.input_queue.put(KeyEvent(key=KeyCode.RIGHT, raw=ch + ch2))
                elif ch2 == "S":
                    self.input_queue.put(KeyEvent(key=KeyCode.DELETE, raw=ch + ch2))
            elif ch == "\r" or ch == "\n":
                self.input_queue.put(KeyEvent(key=KeyCode.ENTER, char="\n", raw=ch))
            elif ch == "\x1b":
                self.input_queue.put(KeyEvent(key=KeyCode.ESCAPE, raw=ch))
            elif ch == "\t":
                self.input_queue.put(KeyEvent(key=KeyCode.TAB, raw=ch))
            elif ch == " ":
                self.input_queue.put(KeyEvent(key=KeyCode.SPACE, char=" ", raw=ch))
            elif ch == "\x08":
                self.input_queue.put(KeyEvent(key=KeyCode.BACKSPACE, raw=ch))
            else:
                self.input_queue.put(KeyEvent(key=KeyCode.CHAR, char=ch, raw=ch))
        else:
            time.sleep(0.016)

    def _read_posix(self) -> None:
        if not sys.stdin.isatty():
            time.sleep(0.016)
            return

        r, _, _ = select.select([sys.stdin], [], [], 0.016)
        if r:
            char = sys.stdin.read(1)
            if char == "\033":
                # Check if this is the start of an escape sequence or a standalone Escape press
                r2, _, _ = select.select([sys.stdin], [], [], 0.03)
                if r2:
                    next1 = sys.stdin.read(1)
                    if next1 == "[":
                        # CSI sequence
                        seq = ""
                        while True:
                            r3, _, _ = select.select([sys.stdin], [], [], 0.01)
                            if not r3:
                                break
                            c = sys.stdin.read(1)
                            seq += c
                            if c.isalpha() or c == "~":
                                break
                        self._parse_csi(seq)
                    else:
                        self.input_queue.put(KeyEvent(key=KeyCode.ESCAPE, raw="\033" + next1))
                else:
                    self.input_queue.put(KeyEvent(key=KeyCode.ESCAPE, raw="\033"))
            elif char in ("\r", "\n"):
                self.input_queue.put(KeyEvent(key=KeyCode.ENTER, char="\n", raw=char))
            elif char == "\t":
                self.input_queue.put(KeyEvent(key=KeyCode.TAB, char="\t", raw=char))
            elif char == " ":
                self.input_queue.put(KeyEvent(key=KeyCode.SPACE, char=" ", raw=char))
            elif char in ("\x7f", "\x08"):
                self.input_queue.put(KeyEvent(key=KeyCode.BACKSPACE, raw=char))
            elif char == "\x03":
                # Ctrl+C
                self.stop()
                os._exit(0)
            else:
                self.input_queue.put(KeyEvent(key=KeyCode.CHAR, char=char, raw=char))

    def _parse_csi(self, seq: str) -> None:
        if seq == "A":
            self.input_queue.put(KeyEvent(key=KeyCode.UP, raw="\033[" + seq))
        elif seq == "B":
            self.input_queue.put(KeyEvent(key=KeyCode.DOWN, raw="\033[" + seq))
        elif seq == "C":
            self.input_queue.put(KeyEvent(key=KeyCode.RIGHT, raw="\033[" + seq))
        elif seq == "D":
            self.input_queue.put(KeyEvent(key=KeyCode.LEFT, raw="\033[" + seq))
        elif seq.startswith("3~"):
            self.input_queue.put(KeyEvent(key=KeyCode.DELETE, raw="\033[" + seq))
        elif seq == "Z":
            # Shift+Tab
            self.input_queue.put(KeyEvent(key=KeyCode.TAB, raw="\033[" + seq))
        else:
            self.input_queue.put(KeyEvent(key=KeyCode.NONE, raw="\033[" + seq))
