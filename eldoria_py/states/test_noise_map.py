"""
GSNoiseMapTestScreen: Interactive terminal visualizer for procedural noise maps
and tile navigation using FastNoiseLite and Eldoria's Map / MapTile architecture.
"""

from __future__ import annotations
import random
import re
from typing import List, Optional, Tuple

from ..core.context import Context
from ..core.fsm import SMState
from ..procgen.noise import FastNoiseLite, NoiseType, FractalType
from ..procgen.map_generator import (
    ProceduralMapGenerator,
    Map,
    MapTile,
    BiomeType,
    BIOME_CONFIGS,
)
from ..terminal.ansi import ATCoordinates, ATControlSequences
from ..terminal.color import ColorLibrary, TrueColor
from ..terminal.input import KeyCode
from ..terminal.screen import TerminalScreen


class GSNoiseMapTestScreen(SMState):
    """Interactive visualizer for procedural maps and tile connectivity."""

    NOISE_TYPES: List[NoiseType] = [
        NoiseType.OpenSimplex2,
        NoiseType.OpenSimplex2S,
        NoiseType.Cellular,
        NoiseType.Perlin,
        NoiseType.Value,
        NoiseType.ValueCubic,
    ]

    FRACTAL_TYPES: List[FractalType] = [
        FractalType.FBm,
        FractalType.Ridged,
        FractalType.PingPong,
        FractalType.None_,
    ]

    def __init__(self, map_width: int = 54, map_height: int = 24) -> None:
        super().__init__("GSNoiseMapTestScreen")
        self.map_width = map_width
        self.map_height = map_height
        self.seed = 1337
        self.frequency = 0.06
        self.noise_type_idx = 0
        self.fractal_type_idx = 0

        self.generator = ProceduralMapGenerator(
            seed=self.seed,
            frequency=self.frequency,
            noise_type=self.NOISE_TYPES[self.noise_type_idx],
            fractal_type=self.FRACTAL_TYPES[self.fractal_type_idx],
        )
        self.world_map: Map = self.generator.generate_map(
            width=self.map_width,
            height=self.map_height,
            create_road=True,
        )

        # Place player cursor on a walkable road or plains tile
        self.player_x = 0
        self.player_y = self.map_height // 2
        self._find_initial_player_pos()

    def _find_initial_player_pos(self) -> None:
        for y in range(self.map_height):
            for x in range(self.map_width):
                tile = self.world_map.tiles[y][x]
                if tile.biome == BiomeType.ROAD:
                    self.player_x, self.player_y = x, y
                    return
        for y in range(self.map_height):
            for x in range(self.map_width):
                if self.world_map.tiles[y][x].is_walkable:
                    self.player_x, self.player_y = x, y
                    return

    def _regenerate(self) -> None:
        self.generator = ProceduralMapGenerator(
            seed=self.seed,
            frequency=self.frequency,
            noise_type=self.NOISE_TYPES[self.noise_type_idx],
            fractal_type=self.FRACTAL_TYPES[self.fractal_type_idx],
        )
        self.world_map = self.generator.generate_map(
            width=self.map_width,
            height=self.map_height,
            create_road=True,
        )
        self._find_initial_player_pos()

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

        keys_pressed = context.get(SMState.ContextKeysPressed)
        core = context.get(SMState.ContextEldoriaCore)

        if isinstance(keys_pressed, list) and len(keys_pressed) > 0:
            for key_info in list(keys_pressed):
                # Movement controls: Arrows or WASD
                if key_info.key == KeyCode.UP or key_info.char in ("w", "W"):
                    self._try_move(0, -1, MapTile.EXIT_NORTH)
                    keys_pressed.remove(key_info)
                    break
                elif key_info.key == KeyCode.DOWN or key_info.char in ("s", "S"):
                    self._try_move(0, 1, MapTile.EXIT_SOUTH)
                    keys_pressed.remove(key_info)
                    break
                elif key_info.key == KeyCode.LEFT or key_info.char in ("a", "A"):
                    self._try_move(-1, 0, MapTile.EXIT_WEST)
                    keys_pressed.remove(key_info)
                    break
                elif key_info.key == KeyCode.RIGHT or key_info.char in ("d", "D"):
                    self._try_move(1, 0, MapTile.EXIT_EAST)
                    keys_pressed.remove(key_info)
                    break
                # Reseed
                elif key_info.char in ("r", "R"):
                    self.seed = random.randint(1, 999999)
                    self._regenerate()
                    keys_pressed.remove(key_info)
                    break
                # Cycle Noise Type
                elif key_info.char in ("n", "N"):
                    self.noise_type_idx = (self.noise_type_idx + 1) % len(self.NOISE_TYPES)
                    self._regenerate()
                    keys_pressed.remove(key_info)
                    break
                # Cycle Fractal Type
                elif key_info.char in ("f", "F"):
                    self.fractal_type_idx = (self.fractal_type_idx + 1) % len(self.FRACTAL_TYPES)
                    self._regenerate()
                    keys_pressed.remove(key_info)
                    break
                # Frequency Adjust (+ / -)
                elif key_info.char in ("+", "="):
                    self.frequency = min(0.30, self.frequency + 0.01)
                    self._regenerate()
                    keys_pressed.remove(key_info)
                    break
                elif key_info.char in ("-", "_"):
                    self.frequency = max(0.01, self.frequency - 0.01)
                    self._regenerate()
                    keys_pressed.remove(key_info)
                    break
                # Switch to UI Test
                elif key_info.char in ("u", "U"):
                    keys_pressed.clear()
                    if core and hasattr(core, "game_state"):
                        core.game_state.trigger("ToUiTest", context)
                    return
                # Switch to Soda Can Test
                elif key_info.char in ("c", "C"):
                    keys_pressed.clear()
                    if core and hasattr(core, "game_state"):
                        core.game_state.trigger("ToSodaCan", context)
                    return
                # Quit
                elif key_info.char in ("q", "Q"):
                    keys_pressed.clear()
                    if core and hasattr(core, "is_running"):
                        core.is_running = False
                    return

        self._render()

    def _try_move(self, dx: int, dy: int, exit_dir: int) -> None:
        curr_tile = self.world_map.tiles[self.player_y][self.player_x]
        if curr_tile.exits[exit_dir]:
            nx = self.player_x + dx
            ny = self.player_y + dy
            if 0 <= nx < self.map_width and 0 <= ny < self.map_height:
                self.player_x = nx
                self.player_y = ny

    @staticmethod
    def _make_border_line(left_char: str, text: str, right_char: str, width: int, fill_char: str = "─") -> str:
        vlen = len(re.sub(r"\033\[[0-9;]*[a-zA-Z]", "", text))
        rem = max(0, width - vlen)
        left_pad = rem // 2
        right_pad = rem - left_pad
        return f"{left_char}{fill_char * left_pad}{text}{fill_char * right_pad}{right_char}"

    def _render(self) -> None:
        """Atomic frame render of the procedural map and telemetry HUD."""
        out: List[str] = [ATControlSequences.DrawOptimizeOn]

        # Top border / Header
        cur_noise = self.NOISE_TYPES[self.noise_type_idx].name
        h_text = f"── \033[1;37mFastNoiseLite Map\033[0m ── Seed:\033[33m{self.seed:<6}\033[0m Freq:\033[32m{self.frequency:.2f}\033[0m ──"
        out.append(ATCoordinates(1, 1).to_ansi())
        out.append(self._make_border_line("╭", h_text, "╮", self.map_width, fill_char="─"))

        # Current tile telemetry
        curr_tile = self.world_map.tiles[self.player_y][self.player_x]
        cur_fractal = self.FRACTAL_TYPES[self.fractal_type_idx].name
        ex_str = "".join([
            "N" if curr_tile.exits[MapTile.EXIT_NORTH] else "·",
            "S" if curr_tile.exits[MapTile.EXIT_SOUTH] else "·",
            "E" if curr_tile.exits[MapTile.EXIT_EAST] else "·",
            "W" if curr_tile.exits[MapTile.EXIT_WEST] else "·",
        ])
        t_text = (
            f" \033[36m{cur_noise:<12}\033[0m \033[35m{cur_fractal:<7}\033[0m "
            f"Pos:({self.player_x:02d},{self.player_y:02d}) "
            f"\033[33m{curr_tile.biome.value:<8}\033[0m [{ex_str}] "
        )
        out.append(ATCoordinates(2, 1).to_ansi())
        out.append(self._make_border_line("│", t_text, "│", self.map_width, fill_char=" "))

        # Render Map Grid starting at row 3
        map_lines = ProceduralMapGenerator.render_ansi(
            self.world_map,
            cursor_pos=(self.player_x, self.player_y),
        )
        for idx, line in enumerate(map_lines):
            out.append(ATCoordinates(3 + idx, 1).to_ansi())
            out.append(f"│{line}│")

        # Bottom controls footer
        footer_y = 3 + len(map_lines)
        f_text = (
            " \033[33m[WASD]\033[0mMove \033[33m[R]\033[0mSeed \033[33m[N]\033[0mType "
            "\033[33m[F]\033[0mFrac \033[33m[U]\033[0mUI \033[33m[C]\033[0mCans \033[33m[Q]\033[0m "
        )
        out.append(ATCoordinates(footer_y, 1).to_ansi())
        out.append(self._make_border_line("╰", f_text, "╯", self.map_width, fill_char="─"))

        out.append(ATControlSequences.DrawOptimizeOff)
        TerminalScreen.write("".join(out))
        TerminalScreen.flush()
