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
from ..core.save_manager import SaveManager
from ..terminal.ansi import ATCoordinates, ATControlSequences
from ..terminal.color import ColorLibrary, TrueColor
from ..terminal.input import KeyCode
from ..terminal.screen import TerminalScreen
from ..terminal.box import visible_width, truncate_ansi, clear_buffer_tail
from ..combat import (
    StatId,
    Party,
    create_default_party,
    generate_encounter,
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

        # Save / Load state
        self.save_manager: SaveManager = SaveManager()
        self.active_slot: Optional[int] = 1
        self._fallback_playtime_seconds: int = 0

    @property
    def playtime_seconds(self) -> int:
        """Returns campaign playtime from party, or fallback if party is unset."""
        if self.party is not None:
            return self.party.playtime_seconds
        return self._fallback_playtime_seconds

    @playtime_seconds.setter
    def playtime_seconds(self, value: int) -> None:
        self._fallback_playtime_seconds = value
        if self.party is not None:
            self.party.playtime_seconds = value
            self.party._playtime_accumulator = 0.0

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

        # Check if context has an active party from Party Builder or Load Game
        ctx_party = context.get("party")
        if ctx_party is not None and isinstance(ctx_party, Party) and len(ctx_party.members) > 0:
            self.party = ctx_party

        # Check if context has active world_macro
        ctx_macro = context.get("world_macro")
        if ctx_macro is not None and isinstance(ctx_macro, WorldMacroMap):
            self.world_macro = ctx_macro
            self.current_sector = self.world_macro.starter_sector
            self.player_x, self.player_y = self.world_macro.starter_player_pos

        # Check if context has active slot
        ctx_slot = context.get("active_slot")
        if ctx_slot is not None:
            self.active_slot = ctx_slot

        # Check if context has exploration state
        ctx_exp = context.get("exploration_state")
        if ctx_exp is not None and isinstance(ctx_exp, dict):
            if "current_sector" in ctx_exp:
                self.current_sector = tuple(ctx_exp["current_sector"])
            if "player_pos" in ctx_exp:
                self.player_x, self.player_y = tuple(ctx_exp["player_pos"])
            self.playtime_seconds = ctx_exp.get("playtime_seconds", 0)

            submap_name = ctx_exp.get("active_submap_poi")
            if submap_name:
                poi = self.world_macro.get_poi(submap_name)
                if poi and poi.sub_map:
                    self.active_poi = poi
                    self.active_submap = poi.sub_map
            else:
                self.active_submap = None
                self.active_poi = None

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
            self.last_status_msg = "Revived!"
        TerminalScreen.flush()

    def exit(self, context: Context) -> None:
        super().exit(context)
        TerminalScreen.clear_screen()
        TerminalScreen.write(ATControlSequences.CursorShow)
        TerminalScreen.flush()

    def update(self, context: Context) -> None:
        super().update(context)

        delta_time = context.get(SMState.ContextDeltaTime)
        if delta_time is None or not isinstance(delta_time, (int, float)):
            delta_time = 0.016
        if self.party is not None:
            self.party.add_playtime(delta_time)

        keys_pressed = context.get(SMState.ContextKeysPressed)
        core = context.get(SMState.ContextEldoriaCore)

        if isinstance(keys_pressed, list) and len(keys_pressed) > 0:
            for key_info in list(keys_pressed):
                moved = False
                # Movement controls: Arrow keys only
                if key_info.key == KeyCode.UP:
                    moved = self._try_move(0, -1, MapTile.EXIT_NORTH)
                    keys_pressed.remove(key_info)
                elif key_info.key == KeyCode.DOWN:
                    moved = self._try_move(0, 1, MapTile.EXIT_SOUTH)
                    keys_pressed.remove(key_info)
                elif key_info.key == KeyCode.LEFT:
                    moved = self._try_move(-1, 0, MapTile.EXIT_WEST)
                    keys_pressed.remove(key_info)
                elif key_info.key == KeyCode.RIGHT:
                    moved = self._try_move(1, 0, MapTile.EXIT_EAST)
                    keys_pressed.remove(key_info)

                # Main Menu trigger ([M] or [Tab])
                elif key_info.char in ("m", "M") or key_info.key == KeyCode.TAB or key_info.char == "\t":
                    keys_pressed.clear()
                    if core and hasattr(core, "game_state"):
                        menu_state = core.game_state.states.get("GSMainMenuScreen")
                        if menu_state:
                            menu_state.configure_menu(
                                party=self.party,
                                noise_map_screen=self,
                                sector_coords=self.current_sector,
                                playtime_seconds=self.playtime_seconds,
                            )
                        core.game_state.trigger("ToMenu", context)
                    return

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

                # Developer navigation shortcuts (Title, UI Test, Soda Can)
                elif key_info.char in ("t", "T"):
                    keys_pressed.clear()
                    if core and hasattr(core, "game_state"):
                        core.game_state.trigger("ToTitle", context)
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
        transition_state = core.game_state.states.get("GSMatrixTransitionScreen")
        if transition_state:
            transition_state.configure(
                source_lines=self.generate_frame_lines(),
                target_event="EnterCombat",
                target_state="GSNvNCombatScreen",
            )
        core.game_state.trigger("ToCombat", context)
        return True

    def _save_to_slot(self, slot_idx: int) -> None:
        """Atomically saves game state to the designated slot."""
        exploration_state = {
            "current_sector": list(self.current_sector),
            "player_pos": [self.player_x, self.player_y],
            "current_map_name": self.active_poi.name if self.active_poi else "Overworld",
            "active_submap_poi": self.active_poi.name if self.active_poi else None,
            "visited_sectors": [list(self.current_sector)],
            "flags": {},
        }
        self.save_manager.save_game(
            slot_idx=slot_idx,
            party=self.party,
            exploration_state=exploration_state,
            playtime_seconds=self.playtime_seconds,
            world_macro=self.world_macro,
        )

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
            if "MTOInn" in curr_tile.object_listing:
                slot = self.active_slot or 1
                self._save_to_slot(slot)
                self.last_status_msg = f"★ Rested at {place_name}! Fully restored & saved to Slot {slot}."
            else:
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
                elif self.active_poi:
                    self.current_sector = self.active_poi.sector_coord
                    self.player_x, self.player_y = self.active_poi.local_pos
                self.active_submap = None
                self.active_poi = None
                TerminalScreen.clear_screen()
                TerminalScreen.flush()


    @staticmethod
    def _make_border_line(left_char: str, text: str, right_char: str, width: int, fill_char: str = "─") -> str:
        vlen = visible_width(text)
        if vlen > width:
            text = truncate_ansi(text, width)
            vlen = visible_width(text)
        rem = max(0, width - vlen)
        left_pad = rem // 2
        right_pad = rem - left_pad
        return f"{left_char}{fill_char * left_pad}{text}{fill_char * right_pad}{right_char}"

    def generate_frame_lines(self) -> List[str]:
        """Generates list of row strings representing the current visual frame."""
        curr_map = self._current_map()
        lines: List[str] = []

        # 1. Top border / Header
        if self.active_submap is None:
            sx, sy = self.current_sector
            mw = self.world_macro.macro_width
            mh = self.world_macro.macro_height
            h_text = f"── \033[1;37mWorld Map\033[0m ── Sector: \033[36m({sx},{sy})\033[0m/{mw}x{mh} ──"
        else:
            poi_name = self.active_poi.name if self.active_poi else "Interior"
            h_text = f"── \033[1;37mSub-Map: {poi_name}\033[0m ──"

        lines.append(self._make_border_line("╭", h_text, "╮", self.map_width, fill_char="─"))

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

        lines.append(self._make_border_line("│", t_text, "│", self.map_width, fill_char=" "))

        # 3. Render Map Grid starting at row 3
        map_lines = ProceduralMapGenerator.render_ansi(
            curr_map,
            cursor_pos=(self.player_x, self.player_y),
        )
        for line in map_lines:
            lines.append(f"│{line}│")

        # 4. Bottom controls footer
        if self.active_submap is None:
            f_text = " \033[33m[↑↓←→]\033[0mMove  \033[33m[Enter]\033[0mEnter  \033[33m[M]\033[0mMenu "
        else:
            f_text = " \033[33m[↑↓←→]\033[0mMove  \033[33m[Enter]\033[0mLeave  \033[33m[M]\033[0mMenu "

        lines.append(self._make_border_line("╰", f_text, "╯", self.map_width, fill_char="─"))
        return lines

    def _render(self) -> None:
        """Atomic frame render of the procedural map, POI highlights, and telemetry HUD."""
        lines = self.generate_frame_lines()
        out: List[str] = [ATControlSequences.DrawOptimizeOn]

        for idx, line in enumerate(lines):
            out.append(ATCoordinates(1 + idx, 1).to_ansi())
            out.append(line)
            out.append(ATControlSequences.ClearLineToEnd)

        footer_y = len(lines)
        # Clear tail lines up to 40 (clears leftover rows from larger 80x40 screens)
        out.append(clear_buffer_tail(footer_y + 1, 40))

        out.append(ATControlSequences.DrawOptimizeOff)
        TerminalScreen.write("".join(out))
        TerminalScreen.flush()
