"""
GSSplashScreen: Animated splash screen state.
Plays intro presentation using UIPanel component architecture.
Standardized around Eldoria's maximum supported buffer dimensions (80x40).
"""

from __future__ import annotations
from typing import Optional

from ..core.context import Context
from ..core.fsm import SMState
from ..terminal.ansi import ATCoordinates, ATControlSequences, ATDecoration
from ..terminal.color import ColorLibrary
from ..terminal.screen import TerminalScreen
from ..terminal.box import clear_buffer_tail
from ..ui.panel import UIPanel


class GSSplashScreen(SMState):
    """Production boot splash screen state with timing animation and skip keypress."""

    def __init__(self, screen_width: int = 80, screen_height: int = 24, duration: float = 1.8) -> None:
        super().__init__("GSSplashScreen")
        self.screen_width: int = screen_width
        self.screen_height: int = screen_height
        self.duration: float = duration
        self.elapsed: float = 0.0
        self.pulse_phase: int = 0

        panel_bottom_row = min(self.screen_height - 2, 22)
        self.splash_panel = UIPanel(
            left_top=ATCoordinates(1, 1),
            right_bottom=ATCoordinates(panel_bottom_row, self.screen_width),
            title="",
        )
        self.splash_panel.activate()

        # Add child labels to splash_panel with container-validated bounds
        self.stars_label = self.splash_panel.add_label(
            "✦   ✦   ✦",
            row=7,
            align="center",
            fg_color=ColorLibrary.AppleYellowLight,
        )
        self.title_label = self.splash_panel.add_label(
            "E L D O R I A",
            row=9,
            align="center",
            fg_color=ColorLibrary.White,
            decorations=ATDecoration(bold=True),
        )
        self.divider_label = self.splash_panel.add_label(
            "────────────────────────────────────",
            row=10,
            align="center",
            fg_color=ColorLibrary.AppleCyanLight,
        )
        self.subtitle_label = self.splash_panel.add_label(
            "A Retro Tactical Virtual Terminal RPG",
            row=11,
            align="center",
            fg_color=ColorLibrary.DarkGrey,
        )
        self.engine_label = self.splash_panel.add_label(
            "Powered by Eldoria Python Engine",
            row=13,
            align="center",
            fg_color=ColorLibrary.AppleYellowLight,
        )
        self.prompt_label = self.splash_panel.add_label(
            "Press any key to start",
            row=18,
            align="center",
            fg_color=ColorLibrary.DarkGrey,
        )

    def enter(self, context: Context) -> None:
        super().enter(context)
        self.elapsed = 0.0
        self.pulse_phase = 0
        TerminalScreen.write(ATControlSequences.CursorHide)
        TerminalScreen.clear_screen()
        TerminalScreen.flush()
        self.splash_panel.set_all_dirty()

    def exit(self, context: Context) -> None:
        super().exit(context)
        TerminalScreen.clear_screen()
        TerminalScreen.flush()

    def update(self, context: Context) -> None:
        super().update(context)
        dt = context.get(SMState.ContextDeltaTime) or 0.033
        keys_pressed = context.get(SMState.ContextKeysPressed)
        core = context.get(SMState.ContextEldoriaCore)

        self.elapsed += float(dt)
        new_phase = int(self.elapsed * 4) % 4
        if new_phase != self.pulse_phase:
            self.pulse_phase = new_phase
            pulses = ["✧", "✦", "★", "✦"]
            star = pulses[self.pulse_phase]
            self.stars_label.set_user_data(f"{star}   {star}   {star}")

        # Advance on keypress or when duration expires
        has_key = isinstance(keys_pressed, list) and len(keys_pressed) > 0
        if has_key or self.elapsed >= self.duration:
            if isinstance(keys_pressed, list):
                keys_pressed.clear()
            if core and hasattr(core, "game_state"):
                core.game_state.trigger("ToTitle", context)

        # Transition guard: do not render if transitioned away
        if core and hasattr(core, "game_state") and core.game_state.current_state != self.name:
            return

        self.splash_panel.update(context)
        self._render()

    def _render(self) -> None:
        TerminalScreen.write(ATControlSequences.DrawOptimizeOn)
        self.splash_panel.draw()
        TerminalScreen.write(clear_buffer_tail(self.splash_panel.right_bottom.row + 1, 40))
        TerminalScreen.write(ATControlSequences.DrawOptimizeOff)
        TerminalScreen.flush()
