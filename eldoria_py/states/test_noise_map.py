"""
GSNoiseMapTestScreen: Interactive terminal visualizer for procedural noise maps,
4x4 macro world map exploration, POI sub-map entry/egress, and tile navigation.
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
from ..procgen.poi import POIDescriptor, POIType, WarpTarget
from ..procgen.world_macro import WorldMacroMap
from ..terminal.ansi import ATCoordinates, ATControlSequences
from ..terminal.color import ColorLibrary, TrueColor
from ..terminal.input import KeyCode
from ..terminal.screen import TerminalScreen
from ..combat import (
    StatId,
    Party,
    create_default_party,
    generate_encounter,
    create_bat_squad,
)


class GSNoiseMapTestScreen(SMState):
    """Interactive visualizer for 4x4 macro world map and POI sub-maps."""

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
        self.frequency = 0.035
        self.noise_type_idx = 0
        self.fractal_type_idx = 0

        # Persistent Player Party across Exploration & Combat
        self.party: Party = create_default_party()
        self.steps_since_battle: int = 5
        self.min_grace_steps: int = 5
        self.last_status_msg: str = ""

        # World Macro Map (4x4 sectors = 16 interconnected sectors)
        self.world_macro: WorldMacroMap = WorldMacroMap(
            seed=self.seed,
            macro_width=4,
            macro_height=4,
            sector_width=self.map_width,
            sector_height=self.map_height,
            frequency=self.frequency,
            noise_type=self.NOISE_TYPES[self.noise_type_idx],
            fractal_type=self.FRACTAL_TYPES[self.fractal_type_idx],
        )

        # Active sector coordinates in 4x4 macro grid
        self.current_sector: Tuple[int, int] = self.world_macro.starter_sector
        self.player_x, self.player_y = self.world_macro.starter_player_pos

        # Sub-map & Warp Stack state
        self.active_submap: Optional[Map] = None
        self.active_poi: Optional[POIDescriptor] = None
        self.warp_stack: List[Tuple[Tuple[int, int], Tuple[int, int]]] = []

    @property
    def world_map(self) -> Map:
        """Backward-compatible property returning the currently active Map."""
        return self._current_map()

    def _current_map(self) -> Map:
        """Returns the currently active Map (either sub-map or current overworld sector)."""
        if self.active_submap is not None:
            return self.active_submap
        sec = self.world_macro.get_sector(self.current_sector[0], self.current_sector[1])
        if sec is None:
            sec = self.world_macro.sectors[0][0]
        return sec

    def _regenerate(self) -> None:
        """Regenerates the WorldMacroMap and resets player location to starter sector."""
        self.world_macro = WorldMacroMap(
            seed=self.seed,
            macro_width=4,
            macro_height=4,
            sector_width=self.map_width,
            sector_height=self.map_height,
            frequency=self.frequency,
            noise_type=self.NOISE_TYPES[self.noise_type_idx],
            fractal_type=self.FRACTAL_TYPES[self.fractal_type_idx],
        )
        self.current_sector = self.world_macro.starter_sector
        self.player_x, self.player_y = self.world_macro.starter_player_pos
        self.active_submap = None
        self.active_poi = None
        self.warp_stack.clear()
        self.steps_since_battle = 5
        self.last_status_msg = ""
        TerminalScreen.clear_screen()
        TerminalScreen.flush()

    def enter(self, context: Context) -> None:
        super().enter(context)
        TerminalScreen.write(ATControlSequences.CursorHide)
        TerminalScreen.clear_screen()
        TerminalScreen.flush()

        # Check if returning from a wiped party battle (Defeat)
        if self.party.is_wiped:
            # Revive party with 50% HP and 50% MP
            for m in self.party.members:
                m.stats[StatId.HIT_POINTS].current = max(1, m.max_hp // 2)
                m.stats[StatId.MAGIC_POINTS].current = max(1, m.max_mp // 2)
            # Warp player to safety (starter sector)
            self.current_sector = self.world_macro.starter_sector
            self.player_x, self.player_y = self.world_macro.starter_player_pos
            self.active_submap = None
            self.active_poi = None
            self.warp_stack.clear()
            self.steps_since_battle = 0
            self.last_status_msg = "☠ Party was revived and returned to safety."
        TerminalScreen.flush()

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
                moved = False
                # Movement controls: Arrows or WASD
                if key_info.key == KeyCode.UP or key_info.char in ("w", "W"):
                    moved = self._try_move(0, -1, MapTile.EXIT_NORTH)
                    keys_pressed.remove(key_info)
                elif key_info.key == KeyCode.DOWN or key_info.char in ("s", "S"):
                    moved = self._try_move(0, 1, MapTile.EXIT_SOUTH)
                    keys_pressed.remove(key_info)
                elif key_info.key == KeyCode.LEFT or key_info.char in ("a", "A"):
                    moved = self._try_move(-1, 0, MapTile.EXIT_WEST)
                    keys_pressed.remove(key_info)
                elif key_info.key == KeyCode.RIGHT or key_info.char in ("d", "D"):
                    moved = self._try_move(1, 0, MapTile.EXIT_EAST)
                    keys_pressed.remove(key_info)

                if moved:
                    self.last_status_msg = ""
                    if self._check_step_encounter(context):
                        return
                    break

                # Interaction: Enter key to enter POI, rest at Inn, or leave via egress
                elif key_info.key == KeyCode.ENTER or key_info.char in ("\r", "\n"):
                    self._handle_interact()
                    keys_pressed.remove(key_info)
                    break

                # Screen switching & Combat Encounter
                elif key_info.char in ("b", "B"):
                    keys_pressed.clear()
                    if core and hasattr(core, "game_state"):
                        combat_state = core.game_state.states.get("GSNvNCombatScreen")
                        if combat_state:
                            curr_map = self._current_map()
                            curr_tile = curr_map.tiles[self.player_y][self.player_x]
                            reg = curr_tile.region_code if curr_tile.region_code > 0 else 1
                            squad = generate_encounter(reg) or create_bat_squad(size=6)
                            self.steps_since_battle = 0
                            combat_state.start_encounter(self.party, squad)
                        core.game_state.trigger("ToCombat", context)
                    return
                elif key_info.char in ("u", "U"):
                    keys_pressed.clear()
                    if core and hasattr(core, "game_state"):
                        core.game_state.trigger("ToUiTest", context)
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

        self._render()

    def _try_move(self, dx: int, dy: int, exit_dir: int) -> bool:
        """Handles player movement and seamless sector boundary crossing. Returns True if moved."""
        curr_map = self._current_map()
        curr_tile = curr_map.tiles[self.player_y][self.player_x]

        if not curr_tile.exits[exit_dir]:
            return False

        nx = self.player_x + dx
        ny = self.player_y + dy

        # Sub-map movement
        if self.active_submap is not None:
            if 0 <= nx < self.map_width and 0 <= ny < self.map_height:
                self.player_x = nx
                self.player_y = ny
                return True
            return False

        # Overworld 4x4 sector navigation
        sx, sy = self.current_sector

        # East boundary transition
        if nx >= self.map_width:
            if sx < self.world_macro.macro_width - 1:
                next_sec = self.world_macro.get_sector(sx + 1, sy)
                if next_sec and next_sec.tiles[ny][0].is_walkable:
                    self.current_sector = (sx + 1, sy)
                    self.player_x = 0
                    self.player_y = ny
                    TerminalScreen.clear_screen()
                    TerminalScreen.flush()
                    return True
            return False

        # West boundary transition
        if nx < 0:
            if sx > 0:
                next_sec = self.world_macro.get_sector(sx - 1, sy)
                if next_sec and next_sec.tiles[ny][self.map_width - 1].is_walkable:
                    self.current_sector = (sx - 1, sy)
                    self.player_x = self.map_width - 1
                    self.player_y = ny
                    TerminalScreen.clear_screen()
                    TerminalScreen.flush()
                    return True
            return False

        # South boundary transition
        if ny >= self.map_height:
            if sy < self.world_macro.macro_height - 1:
                next_sec = self.world_macro.get_sector(sx, sy + 1)
                if next_sec and next_sec.tiles[0][nx].is_walkable:
                    self.current_sector = (sx, sy + 1)
                    self.player_x = nx
                    self.player_y = 0
                    TerminalScreen.clear_screen()
                    TerminalScreen.flush()
                    return True
            return False

        # North boundary transition
        if ny < 0:
            if sy > 0:
                next_sec = self.world_macro.get_sector(sx, sy - 1)
                if next_sec and next_sec.tiles[self.map_height - 1][nx].is_walkable:
                    self.current_sector = (sx, sy - 1)
                    self.player_x = nx
                    self.player_y = self.map_height - 1
                    TerminalScreen.clear_screen()
                    TerminalScreen.flush()
                    return True
            return False

        # Regular move within the same sector
        self.player_x = nx
        self.player_y = ny
        return True

    def _check_step_encounter(self, context: Context) -> bool:
        """Evaluates step-based random encounter rolls. Returns True if encounter triggered."""
        self.steps_since_battle += 1
        if self.steps_since_battle < self.min_grace_steps:
            return False

        curr_map = self._current_map()
        curr_tile = curr_map.tiles[self.player_y][self.player_x]

        # Warp tiles, egress tiles, safe tiles never trigger encounters
        if curr_tile.warp_target is not None:
            return False

        if not curr_tile.battle_allowed or curr_tile.encounter_rate <= 0.0:
            return False

        if curr_tile.region_code == 0:
            return False

        # Roll encounter chance
        roll = random.random()
        if roll < curr_tile.encounter_rate:
            return self._trigger_encounter(context, curr_tile.region_code)

        return False

    def _trigger_encounter(self, context: Context, region_code: int) -> bool:
        """Spawns an enemy squad for region_code and transitions to GSNvNCombatScreen."""
        squad = generate_encounter(region_code)
        if squad is None:
            return False

        core = context.get(SMState.ContextEldoriaCore)
        if not core or not hasattr(core, "game_state"):
            return False

        combat_state = core.game_state.states.get("GSNvNCombatScreen")
        if not combat_state:
            return False

        self.steps_since_battle = 0
        combat_state.start_encounter(self.party, squad)
        core.game_state.trigger("ToCombat", context)
        return True

    def _handle_interact(self) -> None:
        """Handles Enter key interaction: enters POI sub-map, rests at Inn, or leaves via egress."""
        curr_map = self._current_map()
        curr_tile = curr_map.tiles[self.player_y][self.player_x]

        # Check for healing interactables (Inn or Well)
        if any(obj in curr_tile.object_listing for obj in ("MTOInn", "MTOWell")):
            for m in self.party.members:
                m.stats[StatId.HIT_POINTS].current = m.max_hp
                m.stats[StatId.MAGIC_POINTS].current = m.max_mp
            place_name = "Oakhaven Inn" if "MTOInn" in curr_tile.object_listing else "Town Well"
            self.last_status_msg = f"★ Rested at {place_name}! Party fully restored."
            return

        if self.active_submap is None:
            # Overworld: Check for POI WarpTarget
            if curr_tile.warp_target and not curr_tile.warp_target.is_egress:
                poi = curr_tile.poi
                if poi and poi.sub_map:
                    # Push return sector and position to warp stack
                    self.warp_stack.append((self.current_sector, (self.player_x, self.player_y)))
                    self.active_submap = poi.sub_map
                    self.active_poi = poi
                    self.player_x, self.player_y = poi.spawn_pos
                    TerminalScreen.clear_screen()
                    TerminalScreen.flush()
        else:
            # Inside Sub-Map: Check for Egress WarpTarget
            if curr_tile.warp_target and curr_tile.warp_target.is_egress:
                if self.warp_stack:
                    ret_sector, (ret_x, ret_y) = self.warp_stack.pop()
                    self.current_sector = ret_sector
                    self.player_x = ret_x
                    self.player_y = ret_y
                self.active_submap = None
                self.active_poi = None
                TerminalScreen.clear_screen()
                TerminalScreen.flush()

    @staticmethod
    def _make_border_line(left_char: str, text: str, right_char: str, width: int, fill_char: str = "─") -> str:
        vlen = len(re.sub(r"\033\[[0-9;]*[a-zA-Z]", "", text))
        rem = max(0, width - vlen)
        left_pad = rem // 2
        right_pad = rem - left_pad
        return f"{left_char}{fill_char * left_pad}{text}{fill_char * right_pad}{right_char}"

    def _render(self) -> None:
        """Atomic frame render of the procedural map, POI highlights, and telemetry HUD."""
        curr_map = self._current_map()
        out: List[str] = [ATControlSequences.DrawOptimizeOn]

        # 1. Top border / Header
        if self.active_submap is None:
            sx, sy = self.current_sector
            h_text = f"── \033[1;37mWorld Map\033[0m ── Sector: \033[36m({sx},{sy})\033[0m/4x4 ──"
        else:
            poi_name = self.active_poi.name if self.active_poi else "Interior"
            h_text = f"── \033[1;37mSub-Map: {poi_name}\033[0m ──"

        out.append(ATCoordinates(1, 1).to_ansi())
        out.append(self._make_border_line("╭", h_text, "╮", self.map_width, fill_char="─"))

        # 2. Current tile telemetry (row 2)
        curr_tile = curr_map.tiles[self.player_y][self.player_x]
        ex_str = "".join([
            "N" if curr_tile.exits[MapTile.EXIT_NORTH] else "·",
            "S" if curr_tile.exits[MapTile.EXIT_SOUTH] else "·",
            "E" if curr_tile.exits[MapTile.EXIT_EAST] else "·",
            "W" if curr_tile.exits[MapTile.EXIT_WEST] else "·",
        ])

        # Party telemetry badge
        alive_count = sum(1 for m in self.party.members if m.is_alive)
        total_hp = sum(m.hp for m in self.party.members)
        total_max_hp = sum(m.max_hp for m in self.party.members)
        hp_pct = int((total_hp / total_max_hp) * 100) if total_max_hp > 0 else 0
        hp_color = "\033[1;32m" if hp_pct > 60 else ("\033[1;33m" if hp_pct > 25 else "\033[1;31m")
        party_badge = f"Party:{alive_count}/{len(self.party.members)} [{hp_color}{hp_pct}%\033[0m]"

        danger_str = f"R{curr_tile.region_code}" if curr_tile.battle_allowed else "Safe"

        if self.last_status_msg:
            t_text = f" {party_badge} \033[1;36m{self.last_status_msg}\033[0m"
        elif self.active_submap is None:
            if curr_tile.warp_target and not curr_tile.warp_target.is_egress:
                t_text = (
                    f" ({self.player_x:02d},{self.player_y:02d}) {party_badge} "
                    f"\033[1;32m★ {curr_tile.warp_target.prompt_label}\033[0m "
                    f"\033[1;33m[Enter]\033[0m"
                )
            else:
                t_text = (
                    f" ({self.player_x:02d},{self.player_y:02d}) {party_badge} "
                    f"\033[33m{curr_tile.biome.value:<6}\033[0m[{ex_str}] \033[35m{danger_str}\033[0m"
                )
        else:
            if curr_tile.warp_target and curr_tile.warp_target.is_egress:
                t_text = (
                    f" ({self.player_x:02d},{self.player_y:02d}) {party_badge} "
                    f"\033[1;33m[Egress]\033[0m \033[1;32m[Enter] Leave\033[0m"
                )
            elif any(obj in curr_tile.object_listing for obj in ("MTOInn", "MTOWell")):
                obj_label = "Inn" if "MTOInn" in curr_tile.object_listing else "Well"
                t_text = (
                    f" ({self.player_x:02d},{self.player_y:02d}) {party_badge} "
                    f"\033[1;32m★ {obj_label}\033[0m \033[1;33m[Enter] Rest\033[0m"
                )
            else:
                t_text = (
                    f" ({self.player_x:02d},{self.player_y:02d}) {party_badge} "
                    f"\033[33m{curr_tile.biome.value:<6}\033[0m[{ex_str}] \033[35m{danger_str}\033[0m"
                )

        out.append(ATCoordinates(2, 1).to_ansi())
        out.append(self._make_border_line("│", t_text, "│", self.map_width, fill_char=" "))

        # 3. Render Map Grid starting at row 3
        map_lines = ProceduralMapGenerator.render_ansi(
            curr_map,
            cursor_pos=(self.player_x, self.player_y),
        )
        for idx, line in enumerate(map_lines):
            out.append(ATCoordinates(3 + idx, 1).to_ansi())
            out.append(f"│{line}│")

        # 4. Bottom controls footer
        footer_y = 3 + len(map_lines)
        if self.active_submap is None:
            f_text = (
                " \033[33m[WASD]\033[0mMove \033[33m[Enter]\033[0mEnter POI "
                "\033[33m[B]\033[0mBattle \033[33m[U]\033[0mUI \033[33m[C]\033[0mCans \033[33m[Q]\033[0mQuit "
            )
        else:
            f_text = (
                " \033[33m[WASD]\033[0mMove \033[33m[Enter]\033[0mLeave Gate "
                "\033[33m[B]\033[0mBattle \033[33m[U]\033[0mUI \033[33m[C]\033[0mCans \033[33m[Q]\033[0mQuit "
            )

        out.append(ATCoordinates(footer_y, 1).to_ansi())
        out.append(self._make_border_line("╰", f_text, "╯", self.map_width, fill_char="─"))

        out.append(ATControlSequences.DrawOptimizeOff)
        TerminalScreen.write("".join(out))
        TerminalScreen.flush()
