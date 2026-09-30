"""
Unit tests for terminal input parsing and escape sequence handling.
Verifies POSIX input parsing (CSI, SS3, modified keys, standalone Escape, and unparsed sequences).
"""

import unittest
from eldoria_py.terminal.input import InputManager, KeyCode, KeyEvent


class TestTerminalInput(unittest.TestCase):
    def test_csi_arrow_keys(self):
        tests = [
            (b"\x1b[A", KeyCode.UP),
            (b"\x1b[B", KeyCode.DOWN),
            (b"\x1b[C", KeyCode.RIGHT),
            (b"\x1b[D", KeyCode.LEFT),
        ]
        for seq, expected in tests:
            events = InputManager.parse_posix_bytes(seq)
            self.assertEqual(len(events), 1, f"Expected 1 event for {seq}")
            self.assertEqual(events[0].key, expected, f"Expected {expected} for {seq}")
            self.assertNotEqual(events[0].key, KeyCode.ESCAPE, f"{seq} must never produce ESCAPE")

    def test_ss3_arrow_keys(self):
        tests = [
            (b"\x1bOA", KeyCode.UP),
            (b"\x1bOB", KeyCode.DOWN),
            (b"\x1bOC", KeyCode.RIGHT),
            (b"\x1bOD", KeyCode.LEFT),
        ]
        for seq, expected in tests:
            events = InputManager.parse_posix_bytes(seq)
            self.assertEqual(len(events), 1, f"Expected 1 event for {seq}")
            self.assertEqual(events[0].key, expected, f"Expected {expected} for {seq}")
            self.assertNotEqual(events[0].key, KeyCode.ESCAPE, f"{seq} must never produce ESCAPE")

    def test_modified_arrow_keys(self):
        tests = [
            (b"\x1b[1;5A", KeyCode.UP),    # Ctrl+Up
            (b"\x1b[1;2B", KeyCode.DOWN),  # Shift+Down
            (b"\x1b[1;3C", KeyCode.RIGHT), # Alt+Right
            (b"\x1b[1;5D", KeyCode.LEFT),  # Ctrl+Left
        ]
        for seq, expected in tests:
            events = InputManager.parse_posix_bytes(seq)
            self.assertEqual(len(events), 1)
            self.assertEqual(events[0].key, expected)

    def test_standalone_escape(self):
        events = InputManager.parse_posix_bytes(b"\x1b")
        self.assertEqual(len(events), 1)
        self.assertEqual(events[0].key, KeyCode.ESCAPE)

    def test_unknown_escape_sequence_does_not_emit_escape(self):
        unknown_seqs = [
            b"\x1b[?25h",
            b"\x1b[6n",
            b"\x1b[999z",
            b"\x1bOX",
        ]
        for seq in unknown_seqs:
            events = InputManager.parse_posix_bytes(seq)
            self.assertEqual(len(events), 1)
            self.assertEqual(events[0].key, KeyCode.NONE, f"{seq} should be NONE")
            self.assertNotEqual(events[0].key, KeyCode.ESCAPE, f"{seq} must never be ESCAPE")

    def test_control_keys(self):
        self.assertEqual(InputManager.parse_posix_bytes(b"\r")[0].key, KeyCode.ENTER)
        self.assertEqual(InputManager.parse_posix_bytes(b"\n")[0].key, KeyCode.ENTER)
        self.assertEqual(InputManager.parse_posix_bytes(b"\r\n")[0].key, KeyCode.ENTER)
        self.assertEqual(InputManager.parse_posix_bytes(b"\t")[0].key, KeyCode.TAB)
        self.assertEqual(InputManager.parse_posix_bytes(b"\x7f")[0].key, KeyCode.BACKSPACE)
        self.assertEqual(InputManager.parse_posix_bytes(b"\x08")[0].key, KeyCode.BACKSPACE)
        self.assertEqual(InputManager.parse_posix_bytes(b" ")[0].key, KeyCode.SPACE)
        self.assertEqual(InputManager.parse_posix_bytes(b"\x1b[3~")[0].key, KeyCode.DELETE)
        self.assertEqual(InputManager.parse_posix_bytes(b"\x1b[Z")[0].key, KeyCode.TAB)

    def test_printable_and_unicode_characters(self):
        events = InputManager.parse_posix_bytes(b"w")
        self.assertEqual(events[0].key, KeyCode.CHAR)
        self.assertEqual(events[0].char, "w")

        events = InputManager.parse_posix_bytes("★".encode("utf-8"))
        self.assertEqual(events[0].key, KeyCode.CHAR)
        self.assertEqual(events[0].char, "★")

    def test_multiple_events_in_single_chunk(self):
        chunk = b"\x1b[Aw\x1b[B\r"
        events = InputManager.parse_posix_bytes(chunk)
        self.assertEqual(len(events), 4)
        self.assertEqual(events[0].key, KeyCode.UP)
        self.assertEqual(events[1].key, KeyCode.CHAR)
        self.assertEqual(events[1].char, "w")
        self.assertEqual(events[2].key, KeyCode.DOWN)
        self.assertEqual(events[3].key, KeyCode.ENTER)


if __name__ == "__main__":
    unittest.main()
