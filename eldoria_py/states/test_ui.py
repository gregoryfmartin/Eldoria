"""
GSUiTestScreen: Interactive UI test state featuring rounded Unicode panel,
checkboxes, animated spinners, chevrons, and circular Tab focus navigation.
"""

from __future__ import annotations
from typing import Optional
from ..core.context import Context
from ..core.fsm import SMState
from ..terminal.ansi import ATControlSequences
from ..terminal.color import ColorLibrary
from ..terminal.input import KeyCode
from ..terminal.screen import TerminalScreen
from ..ui.panels.char_status import UICharacterStatusSummaryPanel


class GSUiTestScreen(SMState):
    """
    Test UI screen state matching New New Engine specification.
    """

    def __init__(self) -> None:
        super().__init__("GSUiTestScreen")
        self.sample_panel: UICharacterStatusSummaryPanel = UICharacterStatusSummaryPanel()

    def enter(self, context: Context) -> None:
        super().enter(context)
        TerminalScreen.write(ATControlSequences.CursorHide)
        TerminalScreen.clear_screen()

    def exit(self, context: Context) -> None:
        super().exit(context)
        TerminalScreen.clear_screen()
        TerminalScreen.write(ATControlSequences.CursorShow)
        TerminalScreen.flush()

    def update(self, context: Context) -> None:
        super().update(context)

        # Context layout:
        # 0: DeltaTime
        # 1: KeysPressed
        # 2: EldoriaCore
        keys_pressed = context.get(SMState.ContextKeysPressed)
        core = context.get(SMState.ContextEldoriaCore)

        if isinstance(keys_pressed, list) and len(keys_pressed) > 0:
            for key_info in list(keys_pressed):
                if key_info.key == KeyCode.SPACE:
                    self.sample_panel.toggle_active(context)
                    keys_pressed.remove(key_info)
                    break
                elif key_info.char in ("a", "A"):
                    self.sample_panel.set_border_color(ColorLibrary.ApplePinkLight)
                    keys_pressed.remove(key_info)
                    break
                elif key_info.char in ("b", "B"):
                    self.sample_panel.set_border_color(ColorLibrary.AppleOrangeLight)
                    keys_pressed.remove(key_info)
                    break
                elif key_info.char in ("m", "M"):
                    keys_pressed.clear()
                    if core and hasattr(core, "game_state"):
                        core.game_state.trigger("ToNoiseMap", context)
                    return
                elif key_info.char in ("c", "C"):
                    keys_pressed.clear()
                    if core and hasattr(core, "game_state"):
                        core.game_state.trigger("ToSodaCan", context)
                    return
                elif key_info.char in ("q", "Q"):
                    keys_pressed.clear()
                    if core and hasattr(core, "is_running"):
                        core.is_running = False
                    return

        self.sample_panel.update(context)

        # Atomic frame draw with DEC mode 2026 synchronized output
        TerminalScreen.write(ATControlSequences.DrawOptimizeOn)
        self.sample_panel.draw()
        footer_coord = ATControlSequences.generate_coordinates(22, 4)
        TerminalScreen.write(
            f"{footer_coord}\033[33m[Tab]\033[0m Focus   "
            f"\033[33m[Space]\033[0m Toggle   "
            f"\033[33m[A/B]\033[0m Border   "
            f"\033[33m[M]\033[0m Noise Map   "
            f"\033[33m[C]\033[0m Soda Cans   "
            f"\033[33m[Q]\033[0m Quit"
        )
        TerminalScreen.write(ATControlSequences.DrawOptimizeOff)
        TerminalScreen.flush()
