"""
GSOpeningCinematicScreen: Borderless origin story pseudo-cinematic state.
Plays between GSSplashScreen and GSTitleScreen, and on GSTitleScreen attract-mode timeout.
Standardized around Eldoria's terminal buffer dimensions.
"""

from __future__ import annotations
from typing import List, Optional, Tuple

from ..audio import get_audio_engine
from ..core.context import Context
from ..core.fsm import SMState
from ..terminal.ansi import ATCoordinates, ATControlSequences
from ..terminal.box import clear_buffer_tail, visible_width
from ..terminal.color import ColorLibrary, TrueColor, dim_buffer, scale_color
from ..terminal.screen import TerminalScreen


class GSOpeningCinematicScreen(SMState):
    """
    Five-scene opening story pseudo-cinematic with looping BGM, thunder flash + SFX,
    TrueColor teletype apparition, and instant skip-to-title on any keypress.
    """

    BGM_TRACK = "Opening Cinematic Theme"
    THUNDER_SFX = "Thunder Clap"

    SCENES: List[Tuple[bool, List[str]]] = [
        (
            False,
            [
                "In the land,",
                "there are baddies.",
            ],
        ),
        (
            True,
            [
                "The baddies are real bad.",
                "The goodies aren’t Kenough.",
            ],
        ),
        (
            True,
            [
                "Some goodies, however, got gud.",
                "They are Kenough.",
            ],
        ),
        (
            True,
            [
                "Together, with strongeth welling, the party sets forth.",
                "Such friendship.",
                "Much Courag-e-ur.",
            ],
        ),
        (
            True,
            [
                "Teh Rune has been borked.",
                "Malakor is free.",
                "U ded.",
                "Ouchie.",
            ],
        ),
    ]

    TELETYPE_CHAR_FADE_FRACTION: float = 0.25

    def __init__(
        self,
        screen_width: int = 80,
        screen_height: int = 24,
        wait_duration: float = 1.0,
        thunder_duration: float = 0.4,
        fade_in_duration: float = 1.5,
        hold_duration: float = 3.0,
        fade_out_duration: float = 0.75,
        outro_wait_duration: float = 1.0,
        skip_fade_out_duration: float = 0.45,
    ) -> None:
        super().__init__("GSOpeningCinematicScreen")
        self.screen_width: int = screen_width
        self.screen_height: int = screen_height
        self.wait_duration: float = wait_duration
        self.thunder_duration: float = thunder_duration
        self.fade_in_duration: float = fade_in_duration
        self.hold_duration: float = hold_duration
        self.fade_out_duration: float = fade_out_duration
        self.outro_wait_duration: float = outro_wait_duration
        self.skip_fade_out_duration: float = skip_fade_out_duration

        self.audio_engine = get_audio_engine()

        self.scene_idx: int = 0
        self.phase: str = "WAIT"  # "THUNDER", "WAIT", "FADE_IN", "HOLD", "FADE_OUT", "OUTRO_WAIT", "SKIP_FADE_OUT", "FINISHED"
        self.phase_elapsed: float = 0.0
        self._bgm_started: bool = False
        self._skip_initial_brightness: float = 0.0
        self._skip_teletype_progress: float = 1.0

    @property
    def is_fading_in(self) -> bool:
        return self.phase == "FADE_IN"

    @property
    def is_fading_out(self) -> bool:
        return self.phase in ("FADE_OUT", "SKIP_FADE_OUT")

    def enter(self, context: Context) -> None:
        super().enter(context)
        self.scene_idx = 0
        self.phase = "WAIT"
        self.phase_elapsed = 0.0
        self._bgm_started = False
        self._skip_initial_brightness = 0.0
        self._skip_teletype_progress = 1.0

        TerminalScreen.write(ATControlSequences.CursorHide)
        TerminalScreen.clear_screen()
        TerminalScreen.flush()

    def exit(self, context: Context) -> None:
        super().exit(context)
        TerminalScreen.clear_screen()
        TerminalScreen.flush()

    def _current_text_brightness(self) -> float:
        if self.phase == "FADE_IN":
            if self.fade_in_duration <= 0:
                return 1.0
            return min(1.0, max(0.0, self.phase_elapsed / self.fade_in_duration))
        elif self.phase == "HOLD":
            return 1.0
        elif self.phase == "FADE_OUT":
            if self.fade_out_duration <= 0:
                return 0.0
            progress = min(1.0, max(0.0, self.phase_elapsed / self.fade_out_duration))
            return max(0.0, 1.0 - progress)
        elif self.phase == "SKIP_FADE_OUT":
            if self.skip_fade_out_duration <= 0:
                return 0.0
            progress = min(1.0, max(0.0, self.phase_elapsed / self.skip_fade_out_duration))
            return max(0.0, self._skip_initial_brightness * (1.0 - progress))
        return 0.0

    def _char_teletype_brightness(self, char_idx: int, total_chars: int, progress: float) -> float:
        """Computes per-character brightness (0.0 black -> 1.0 white) for a teletype wavefront at progress in [0, 1]."""
        if total_chars <= 0:
            return 0.0
        if progress <= 0.0:
            return 0.0
        if progress >= 1.0:
            return 1.0
        alpha = self.TELETYPE_CHAR_FADE_FRACTION
        start_p = (char_idx / (total_chars - 1)) * (1.0 - alpha) if total_chars > 1 else 0.0
        return min(1.0, max(0.0, (progress - start_p) / alpha))

    def _format_teletype_line(
        self,
        line: str,
        line_char_offset: int,
        total_chars: int,
        teletype_progress: float,
        overall_scale: float = 1.0,
    ) -> str:
        """Formats a line with per-character TrueColor transitions from black (0,0,0) to white (255,255,255)."""
        if not line:
            return ""
        parts: List[str] = []
        last_fg: Optional[str] = None
        for idx, ch in enumerate(line):
            char_b = self._char_teletype_brightness(line_char_offset + idx, total_chars, teletype_progress) * overall_scale
            color = scale_color(ColorLibrary.White, char_b)
            fg = color.to_ansi_fg()
            if fg != last_fg:
                parts.append(fg)
                last_fg = fg
            parts.append(ch)
        parts.append("\033[0m")
        return "".join(parts)

    def _thunder_flash_intensity(self) -> float:
        if self.phase != "THUNDER":
            return 0.0
        if self.thunder_duration <= 0:
            return 0.0
        p = min(1.0, max(0.0, self.phase_elapsed / self.thunder_duration))
        # Double-pulse lightning curve
        if p < 0.25:
            return 1.0 - (p / 0.25) * 0.6
        elif p < 0.40:
            return 0.25
        elif p < 0.65:
            return 0.95
        else:
            return max(0.0, 0.95 * (1.0 - (p - 0.65) / 0.35))

    def _finish_to_title(self, context: Context, core) -> None:
        self.phase = "FINISHED"
        TerminalScreen.clear_screen()
        TerminalScreen.flush()
        if core and hasattr(core, "game_state"):
            core.game_state.trigger("ToTitle", context)

    def update(self, context: Context) -> None:
        super().update(context)
        dt = context.get(SMState.ContextDeltaTime)
        if dt is None or not isinstance(dt, (int, float)):
            dt = 0.033
        keys_pressed = context.get(SMState.ContextKeysPressed)
        core = context.get(SMState.ContextEldoriaCore)

        has_key = isinstance(keys_pressed, list) and len(keys_pressed) > 0

        if has_key:
            if isinstance(keys_pressed, list):
                keys_pressed.clear()

            if self.phase not in ("SKIP_FADE_OUT", "FINISHED"):
                if self.phase == "FADE_IN":
                    self._skip_teletype_progress = self._current_text_brightness()
                    self._skip_initial_brightness = 1.0 if self._skip_teletype_progress > 0.0 else 0.0
                else:
                    self._skip_teletype_progress = 1.0
                    self._skip_initial_brightness = self._current_text_brightness()
                self.audio_engine.stop_sfx()
                if self.skip_fade_out_duration > 0:
                    if self._bgm_started:
                        self.audio_engine.fade_out_bgm(duration_seconds=self.skip_fade_out_duration)
                    self.phase = "SKIP_FADE_OUT"
                    self.phase_elapsed = 0.0
                else:
                    self.audio_engine.stop_bgm()
                    self._finish_to_title(context, core)
                    return
            elif self.phase == "SKIP_FADE_OUT":
                self.audio_engine.stop_bgm()
                self._finish_to_title(context, core)
                return
        else:
            self.phase_elapsed += float(dt)

            if self.phase == "THUNDER":
                if self.phase_elapsed >= self.thunder_duration:
                    self.phase = "WAIT"
                    self.phase_elapsed = 0.0

            elif self.phase == "WAIT":
                if self.phase_elapsed >= self.wait_duration:
                    if self.scene_idx == 0 and not self._bgm_started:
                        self.audio_engine.play_bgm(self.BGM_TRACK, loop=True)
                        self._bgm_started = True
                    self.phase = "FADE_IN"
                    self.phase_elapsed = 0.0

            elif self.phase == "FADE_IN":
                if self.phase_elapsed >= self.fade_in_duration:
                    self.phase = "HOLD"
                    self.phase_elapsed = 0.0

            elif self.phase == "HOLD":
                if self.phase_elapsed >= self.hold_duration:
                    self.phase = "FADE_OUT"
                    self.phase_elapsed = 0.0
                    if self.scene_idx == len(self.SCENES) - 1:
                        fade_dur = self.fade_out_duration if self.fade_out_duration > 0 else 0.75
                        self.audio_engine.fade_out_bgm(duration_seconds=fade_dur)

            elif self.phase == "FADE_OUT":
                if self.phase_elapsed >= self.fade_out_duration:
                    if self.scene_idx < len(self.SCENES) - 1:
                        self.scene_idx += 1
                        has_thunder, _ = self.SCENES[self.scene_idx]
                        if has_thunder:
                            self.audio_engine.play_sfx(self.THUNDER_SFX)
                            if self.thunder_duration > 0:
                                self.phase = "THUNDER"
                                self.phase_elapsed = 0.0
                            else:
                                self.phase = "WAIT"
                                self.phase_elapsed = 0.0
                        else:
                            self.phase = "WAIT"
                            self.phase_elapsed = 0.0
                    else:
                        self.phase = "OUTRO_WAIT"
                        self.phase_elapsed = 0.0

            elif self.phase == "OUTRO_WAIT":
                if self.phase_elapsed >= self.outro_wait_duration:
                    self.audio_engine.stop_bgm()
                    self._finish_to_title(context, core)
                    return

            elif self.phase == "SKIP_FADE_OUT":
                if self.phase_elapsed >= self.skip_fade_out_duration:
                    self.audio_engine.stop_bgm()
                    self._finish_to_title(context, core)
                    return

        if core and hasattr(core, "game_state") and core.game_state.current_state != self.name:
            return

        self._render()

    def _build_frame(self) -> str:
        out: List[str] = []
        blank_row = " " * self.screen_width

        if self.phase == "THUNDER":
            intensity = self._thunder_flash_intensity()
            flash_color = scale_color(TrueColor(225, 240, 255), intensity)
            fg_seq = flash_color.to_ansi_fg()
            flash_row = f"{fg_seq}{'█' * self.screen_width}\033[0m"
            for r in range(1, self.screen_height + 1):
                out.append(f"{ATCoordinates(r, 1).to_ansi()}{flash_row}")
            return "".join(out)

        # Default black canvas
        for r in range(1, self.screen_height + 1):
            out.append(f"{ATCoordinates(r, 1).to_ansi()}{blank_row}")

        if self.phase in ("FADE_IN", "HOLD", "FADE_OUT", "SKIP_FADE_OUT") and 0 <= self.scene_idx < len(self.SCENES):
            _, lines = self.SCENES[self.scene_idx]
            num_lines = len(lines)
            row_spacing = 2
            total_span = (num_lines - 1) * row_spacing + 1
            start_row = max(1, 1 + (self.screen_height - total_span) // 2)
            total_chars = sum(len(line) for line in lines)

            if self.phase == "FADE_IN":
                teletype_progress = self._current_text_brightness()
                char_offset = 0
                for i, line in enumerate(lines):
                    r = start_row + i * row_spacing
                    if 1 <= r <= self.screen_height:
                        vlen = visible_width(line)
                        col = max(1, 1 + (self.screen_width - vlen) // 2)
                        styled_line = self._format_teletype_line(
                            line, char_offset, total_chars, teletype_progress, overall_scale=1.0
                        )
                        out.append(f"{ATCoordinates(r, col).to_ansi()}{styled_line}")
                    char_offset += len(line)
            elif self.phase == "SKIP_FADE_OUT" and self._skip_teletype_progress < 1.0:
                overall_scale = self._current_text_brightness()
                if overall_scale > 0.001:
                    char_offset = 0
                    for i, line in enumerate(lines):
                        r = start_row + i * row_spacing
                        if 1 <= r <= self.screen_height:
                            vlen = visible_width(line)
                            col = max(1, 1 + (self.screen_width - vlen) // 2)
                            styled_line = self._format_teletype_line(
                                line, char_offset, total_chars, self._skip_teletype_progress, overall_scale=overall_scale
                            )
                            out.append(f"{ATCoordinates(r, col).to_ansi()}{styled_line}")
                        char_offset += len(line)
            else:
                brightness = self._current_text_brightness()
                if brightness > 0.001:
                    fg_seq = ColorLibrary.White.to_ansi_fg()
                    for i, line in enumerate(lines):
                        r = start_row + i * row_spacing
                        if 1 <= r <= self.screen_height:
                            vlen = visible_width(line)
                            col = max(1, 1 + (self.screen_width - vlen) // 2)
                            out.append(f"{ATCoordinates(r, col).to_ansi()}{fg_seq}{line}\033[0m")

        return "".join(out)

    def _render(self) -> None:
        brightness = 1.0
        if self.phase == "FADE_OUT" or (self.phase == "SKIP_FADE_OUT" and self._skip_teletype_progress >= 1.0):
            brightness = self._current_text_brightness()

        if brightness < 0.999 and (self.phase == "FADE_OUT" or (self.phase == "SKIP_FADE_OUT" and self._skip_teletype_progress >= 1.0)):
            TerminalScreen.set_write_filter(lambda s: dim_buffer(s, brightness))
        else:
            TerminalScreen.set_write_filter(None)

        try:
            TerminalScreen.write(ATControlSequences.DrawOptimizeOn)
            TerminalScreen.write(self._build_frame())
            TerminalScreen.write(clear_buffer_tail(self.screen_height + 1, 40))
            TerminalScreen.write(ATControlSequences.DrawOptimizeOff)
            TerminalScreen.flush()
        finally:
            TerminalScreen.set_write_filter(None)
