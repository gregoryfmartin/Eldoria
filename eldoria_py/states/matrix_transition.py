"""
GSMatrixTransitionScreen: Horizontal white bar wipe battle transition.

Performs a bidirectional terminal transition between Navigation (GSNoiseMapTestScreen)
and Combat (GSNvNCombatScreen):
1. Ingests current screen buffer as a full 80x40 2D grid.
2. Sweeps a luminous bright white vertical bar from left to right (~0.40s)
   with a trailing grayscale gradient (█ -> ▓ -> ▒ -> ░ -> black) wiping the canvas to pure black.
3. Holds the black buffer for exactly 0.75s of dramatic anticipation.
4. Transitions smoothly to the target state.
5. Swallows all keyboard inputs during transition to prevent accidental actions.
"""

from __future__ import annotations
from typing import List, Optional

from ..core.context import Context
from ..core.fsm import SMState
from ..terminal.ansi import ATCoordinates, ATControlSequences, ATDecoration
from ..terminal.color import ColorLibrary, TrueColor
from ..terminal.screen import TerminalScreen
from ..terminal.box import visible_width, strip_ansi, clear_buffer_tail


# Unicode shading blocks strictly 1 column in visible width
WIPE_SHADE_BLOCKS: List[str] = ["█", "▓", "▒", "░", " "]
MATRIX_GLYPHS: List[str] = WIPE_SHADE_BLOCKS  # Maintained for backward compatibility


class GSMatrixTransitionScreen(SMState):
    """
    Intermediate state orchestrating the horizontal white bar wipe transition
    between exploration navigation and combat screens, covering the full 80x40 buffer.
    """

    MAX_BUFFER_WIDTH: int = 80
    MAX_BUFFER_HEIGHT: int = 40

    def __init__(
        self,
        screen_width: int = 80,
        screen_height: int = 40,
        dissolve_duration: float = 0.40,
        black_hold_duration: float = 0.75,
    ) -> None:
        super().__init__("GSMatrixTransitionScreen")
        self.screen_width: int = max(screen_width, self.MAX_BUFFER_WIDTH)
        self.screen_height: int = max(screen_height, self.MAX_BUFFER_HEIGHT)
        self.dissolve_duration: float = dissolve_duration
        self.black_hold_duration: float = black_hold_duration

        # Transition configuration
        self.target_event: str = "EnterCombat"
        self.target_state: str = "GSNvNCombatScreen"
        self.source_lines: List[str] = []
        self.source_grid: List[List[str]] = []

        # Lifecycle tracking
        self.phase: str = "DISSOLVE"  # "DISSOLVE" -> "HOLD_BLACK" -> "FINISHED"
        self.elapsed: float = 0.0
        self.black_elapsed: float = 0.0

        # Horizontal wipe state
        self.head_x: float = -1.0
        self.trail_len: int = 12
        self.speed: float = (self.screen_width + self.trail_len) / max(0.1, self.dissolve_duration)

        # Grayscale TrueColor gradient steps
        self.color_bar_head: TrueColor = ColorLibrary.White                  # #FFFFFF
        self.color_step_1: TrueColor = TrueColor(220, 220, 220)              # Bright grey
        self.color_step_2: TrueColor = TrueColor(160, 160, 160)              # Medium-light grey
        self.color_step_3: TrueColor = TrueColor(100, 100, 100)              # Medium grey
        self.color_step_4: TrueColor = TrueColor(50, 50, 50)                 # Dark grey
        self.color_step_5: TrueColor = TrueColor(25, 25, 25)                 # Deep shadow

    def configure(
        self,
        source_lines: Optional[List[str]] = None,
        target_event: str = "EnterCombat",
        target_state: str = "GSNvNCombatScreen",
        dissolve_duration: Optional[float] = None,
        black_hold_duration: Optional[float] = None,
    ) -> None:
        """Configures the transition parameters and source buffer for the upcoming animation."""
        self.target_event = target_event
        self.target_state = target_state
        self.source_lines = source_lines or []
        if dissolve_duration is not None:
            self.dissolve_duration = dissolve_duration
            self.speed = (self.screen_width + self.trail_len) / max(0.1, self.dissolve_duration)
        if black_hold_duration is not None:
            self.black_hold_duration = black_hold_duration

    def enter(self, context: Context) -> None:
        super().enter(context)
        self.phase = "DISSOLVE"
        self.elapsed = 0.0
        self.black_elapsed = 0.0
        self.head_x = -1.0
        self.speed = (self.screen_width + self.trail_len) / max(0.1, self.dissolve_duration)

        # Ingest source lines into full 80x40 2D character grid
        self.source_grid = []
        for r in range(self.screen_height):
            if r < len(self.source_lines):
                plain = strip_ansi(self.source_lines[r])
                row_chars = list(plain[:self.screen_width].ljust(self.screen_width))
            else:
                row_chars = [" "] * self.screen_width
            self.source_grid.append(row_chars)

        TerminalScreen.write(ATControlSequences.CursorHide)
        TerminalScreen.flush()

    def exit(self, context: Context) -> None:
        super().exit(context)
        TerminalScreen.clear_screen()
        TerminalScreen.flush()

    def update(self, context: Context) -> None:
        super().update(context)

        # 1. Input Swallowing: drain all keyboard input during transition
        keys_pressed = context.get(SMState.ContextKeysPressed)
        if isinstance(keys_pressed, list) and len(keys_pressed) > 0:
            keys_pressed.clear()

        core = context.get(SMState.ContextEldoriaCore)
        dt = context.get(SMState.ContextDeltaTime)
        if dt is None or not isinstance(dt, (int, float)):
            dt = 0.016

        self.elapsed += float(dt)

        # 2. Phase 1: Horizontal White Bar Wipe to the Right
        if self.phase == "DISSOLVE":
            self.head_x += self.speed * float(dt)

            # Sweep completes when the trailing edge has completely cleared column 79
            if self.head_x - self.trail_len >= self.screen_width:
                self.phase = "HOLD_BLACK"
                self.black_elapsed = 0.0
                TerminalScreen.clear_screen()
                TerminalScreen.flush()
                return

            self._render_frame()

        # 3. Phase 2: Black Buffer Hold (0.75 seconds)
        elif self.phase == "HOLD_BLACK":
            self.black_elapsed += float(dt)
            if self.black_elapsed >= self.black_hold_duration:
                self.phase = "FINISHED"
                if core and hasattr(core, "game_state"):
                    core.game_state.trigger(self.target_event, context)
                return

    def _render_frame(self) -> None:
        """Renders one synchronized atomic frame of the horizontal white bar wipe across all 40 rows."""
        out: List[str] = [
            ATControlSequences.DrawOptimizeOn,
            ATCoordinates(1, 1).to_ansi(),
        ]

        bold_ansi = ATDecoration(bold=True).to_ansi()
        reset_ansi = ATControlSequences.SGR_RESET
        fg_bar_head = self.color_bar_head.to_ansi_fg()
        fg_s1 = self.color_step_1.to_ansi_fg()
        fg_s2 = self.color_step_2.to_ansi_fg()
        fg_s3 = self.color_step_3.to_ansi_fg()
        fg_s4 = self.color_step_4.to_ansi_fg()
        fg_s5 = self.color_step_5.to_ansi_fg()

        # Render all 40 allowable buffer rows
        for r in range(self.screen_height):
            row_parts: List[str] = []
            cur_color: str = ""

            for c in range(self.screen_width):
                dist = self.head_x - c

                # Behind the trail -> pure black space
                if dist >= self.trail_len:
                    if cur_color != "":
                        row_parts.append(reset_ansi)
                        cur_color = ""
                    row_parts.append(" ")

                # Step 5: Light shade, near-black (10 <= dist < 12)
                elif dist >= 10:
                    desired = fg_s5
                    if cur_color != desired:
                        row_parts.append(f"{reset_ansi}{desired}")
                        cur_color = desired
                    row_parts.append("░")

                # Step 4: Light shade, deep shadow (8 <= dist < 10)
                elif dist >= 8:
                    desired = fg_s4
                    if cur_color != desired:
                        row_parts.append(f"{reset_ansi}{desired}")
                        cur_color = desired
                    row_parts.append("░")

                # Step 3: Medium shade, mid-grey (6 <= dist < 8)
                elif dist >= 6:
                    desired = fg_s3
                    if cur_color != desired:
                        row_parts.append(f"{reset_ansi}{desired}")
                        cur_color = desired
                    row_parts.append("▒")

                # Step 2: Dark shade, light-medium grey (4 <= dist < 6)
                elif dist >= 4:
                    desired = fg_s2
                    if cur_color != desired:
                        row_parts.append(f"{reset_ansi}{desired}")
                        cur_color = desired
                    row_parts.append("▓")

                # Step 1: Full block, bright grey glow (2 <= dist < 4)
                elif dist >= 2:
                    desired = fg_s1
                    if cur_color != desired:
                        row_parts.append(f"{reset_ansi}{desired}")
                        cur_color = desired
                    row_parts.append("█")

                # Leading edge: Bright White Bar (0 <= dist < 2)
                elif dist >= 0:
                    desired = f"{bold_ansi}{fg_bar_head}"
                    if cur_color != desired:
                        row_parts.append(desired)
                        cur_color = desired
                    row_parts.append("█")

                # Ahead of wipe bar (dist < 0): original source buffer character
                else:
                    if cur_color != "":
                        row_parts.append(reset_ansi)
                        cur_color = ""
                    row_parts.append(self.source_grid[r][c])

            if cur_color != "":
                row_parts.append(reset_ansi)

            out.append(f"\033[{r + 1};1H" + "".join(row_parts) + ATControlSequences.ClearLineToEnd)

        out.append(ATControlSequences.DrawOptimizeOff)
        TerminalScreen.write("".join(out))
        TerminalScreen.flush()
