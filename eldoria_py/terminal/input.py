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
        if self._thread is not None and self._thread.is_alive() and threading.current_thread() != self._thread:
            try:
                self._thread.join(timeout=0.2)
            except Exception:
                pass
            self._thread = None
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

        fd = sys.stdin.fileno()
        try:
            r, _, _ = select.select([fd], [], [], 0.016)
        except (ValueError, OSError):
            return

        if r:
            try:
                raw_bytes = os.read(fd, 1024)
            except OSError:
                return

            if not raw_bytes:
                return

            # If the chunk ends with an incomplete escape prefix, wait briefly for remaining bytes
            if (
                raw_bytes == b"\x1b"
                or raw_bytes.endswith(b"\x1b")
                or raw_bytes.endswith(b"\x1b[")
                or raw_bytes.endswith(b"\x1bO")
            ):
                try:
                    r2, _, _ = select.select([fd], [], [], 0.025)
                    if r2:
                        extra = os.read(fd, 1024)
                        raw_bytes += extra
                except (ValueError, OSError):
                    pass

            events = self.parse_posix_bytes(raw_bytes)
            for evt in events:
                if evt.key == KeyCode.NONE and evt.raw == "\x03":
                    # Ctrl+C
                    self.stop()
                    os._exit(0)
                else:
                    self.input_queue.put(evt)

    @staticmethod
    def parse_posix_bytes(raw_bytes: bytes) -> List[KeyEvent]:
        """
        Parses raw bytes from POSIX stdin into structured KeyEvents.
        Correctly distinguishes standalone Escape (\x1b) from CSI (\x1b[) and SS3 (\x1bO) sequences.
        Unrecognized escape sequences are cleanly mapped to KeyCode.NONE rather than KeyCode.ESCAPE.
        """
        events: List[KeyEvent] = []
        i = 0
        n = len(raw_bytes)
        while i < n:
            b = raw_bytes[i:i + 1]
            if b == b"\x1b":
                if i + 1 < n and raw_bytes[i + 1:i + 2] in (b"[", b"O"):
                    prefix = raw_bytes[i + 1:i + 2]
                    if prefix == b"[":
                        # CSI sequence: \x1b[ ... [parameter/intermediate bytes] ... [final byte @-~]
                        j = i + 2
                        while j < n and not (64 <= raw_bytes[j] <= 126):
                            j += 1
                        if j < n:
                            j += 1
                        seq = raw_bytes[i:j].decode("latin1", errors="replace")
                        body = seq[2:]
                        if body == "A" or body.endswith("A"):
                            events.append(KeyEvent(key=KeyCode.UP, raw=seq))
                        elif body == "B" or body.endswith("B"):
                            events.append(KeyEvent(key=KeyCode.DOWN, raw=seq))
                        elif body == "C" or body.endswith("C"):
                            events.append(KeyEvent(key=KeyCode.RIGHT, raw=seq))
                        elif body == "D" or body.endswith("D"):
                            events.append(KeyEvent(key=KeyCode.LEFT, raw=seq))
                        elif body.startswith("3~"):
                            events.append(KeyEvent(key=KeyCode.DELETE, raw=seq))
                        elif body == "Z":
                            events.append(KeyEvent(key=KeyCode.TAB, raw=seq))
                        else:
                            events.append(KeyEvent(key=KeyCode.NONE, raw=seq))
                        i = j
                    else:  # prefix == b"O" (SS3 cursor keypad sequences: \x1bOA, \x1bOB, etc.)
                        j = i + 2
                        if j < n:
                            final_char = chr(raw_bytes[j])
                            seq = raw_bytes[i:j + 1].decode("latin1", errors="replace")
                            if final_char == "A":
                                events.append(KeyEvent(key=KeyCode.UP, raw=seq))
                            elif final_char == "B":
                                events.append(KeyEvent(key=KeyCode.DOWN, raw=seq))
                            elif final_char == "C":
                                events.append(KeyEvent(key=KeyCode.RIGHT, raw=seq))
                            elif final_char == "D":
                                events.append(KeyEvent(key=KeyCode.LEFT, raw=seq))
                            else:
                                events.append(KeyEvent(key=KeyCode.NONE, raw=seq))
                            i = j + 1
                        else:
                            seq = raw_bytes[i:j].decode("latin1", errors="replace")
                            events.append(KeyEvent(key=KeyCode.NONE, raw=seq))
                            i = j
                else:
                    # Standalone Escape key press
                    events.append(KeyEvent(key=KeyCode.ESCAPE, raw="\033"))
                    i += 1
            elif b in (b"\r", b"\n"):
                events.append(KeyEvent(key=KeyCode.ENTER, char="\n", raw=b.decode("latin1")))
                i += 1
                if b == b"\r" and i < n and raw_bytes[i:i + 1] == b"\n":
                    i += 1
            elif b == b"\t":
                events.append(KeyEvent(key=KeyCode.TAB, char="\t", raw="\t"))
                i += 1
            elif b in (b"\x7f", b"\x08"):
                events.append(KeyEvent(key=KeyCode.BACKSPACE, raw=b.decode("latin1")))
                i += 1
            elif b == b" ":
                events.append(KeyEvent(key=KeyCode.SPACE, char=" ", raw=" "))
                i += 1
            elif b == b"\x03":
                events.append(KeyEvent(key=KeyCode.NONE, raw="\x03"))
                i += 1
            else:
                try:
                    char = raw_bytes[i:].decode("utf-8")[0]
                    char_bytes_len = len(char.encode("utf-8"))
                    events.append(KeyEvent(key=KeyCode.CHAR, char=char, raw=char))
                    i += char_bytes_len
                except Exception:
                    char = chr(raw_bytes[i])
                    events.append(KeyEvent(key=KeyCode.CHAR, char=char, raw=char))
                    i += 1
        return events
