"""
GSNoiseMapTestScreen: Interactive terminal visualizer for procedural noise maps,
4x4 macro world map exploration, POI sub-map entry/egress, and tile navigation.
"""

from __future__ import annotations
import random
import re
from typing import List, Optional, Tuple, Union

from ..audio import get_audio_engine, PlaybackState
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
from ..procgen.npc import NPC, NPCRole, DialogCategory
from ..procgen.world_macro import WorldMacroMap
from ..core.save_manager import SaveManager
from ..terminal.ansi import ATCoordinates, ATControlSequences
from ..terminal.color import ColorLibrary, TrueColor
from ..terminal.input import KeyCode
from ..terminal.screen import TerminalScreen
from ..terminal.box import (
    visible_width,
    truncate_ansi,
    clear_buffer_tail,
    make_border_row,
    make_box_row,
    wrap_text,
)
from ..ui.panel import UIPanel
from ..ui.container import UIContainer
from ..ui.npc_dialog import NPCDialogModal, DialogChoice
from ..combat import (
    StatId,
    Party,
    create_default_party,
    generate_encounter,
)
from ..combat.items import is_key_item


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
        self.danger_counter: float = 0.0
        self.danger_threshold: float = self._roll_danger_threshold()
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
        self.exploration_flags: dict[str, Any] = {}

        # POI Item Picker modal state (UIPanel)
        self.is_item_picker_active: bool = False
        self.item_picker_cursor: int = 0
        self.locked_poi_target: Optional[POIDescriptor] = None
        self.item_picker_panel: UIPanel = UIPanel(
            left_top=ATCoordinates(10, 16),
            right_bottom=ATCoordinates(20, 64),
            title="Use Item to Unlock",
            has_border=True,
        )
        self.item_picker_panel.current_window_designs = dict(UIContainer.WINDOW_DESIGN_SQUARE)

        # NPC Dialogue Modal (7 rows high at bottom of screen)
        self.npc_dialog: NPCDialogModal = NPCDialogModal(
            screen_width=self.map_width,
            screen_height=self.map_height + 3,
        )

        # Tracked Quest quick modal overlay state
        self.is_quest_modal_active: bool = False

        # Boss encounter persistence
        self.pending_boss_fight: Optional[str] = None

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
        self.danger_counter = 0.0
        self.danger_threshold = self._roll_danger_threshold()
        self.last_status_msg = ""
        TerminalScreen.clear_screen()
        TerminalScreen.flush()

    def enter(self, context: Context) -> None:
        super().enter(context)
        TerminalScreen.write(ATControlSequences.CursorHide)
        TerminalScreen.clear_screen()
        TerminalScreen.flush()

        # World Map background music: fade in World Map Smol if not already playing
        try:
            audio_engine = get_audio_engine(autostart_device=False)
            bgm_info = audio_engine.get_current_bgm()
            if bgm_info is None or bgm_info.name != "World Map Smol" or bgm_info.state == PlaybackState.STOPPED:
                audio_engine.fade_to_bgm("World Map Smol", duration_seconds=1.5, loop=True)
        except Exception:
            pass

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

            if "flags" in ctx_exp and isinstance(ctx_exp["flags"], dict):
                self.exploration_flags = dict(ctx_exp["flags"])

            if "danger_counter" in ctx_exp:
                self.danger_counter = float(ctx_exp["danger_counter"])
            if "danger_threshold" in ctx_exp:
                self.danger_threshold = float(ctx_exp["danger_threshold"])
            if "steps_since_battle" in ctx_exp:
                self.steps_since_battle = int(ctx_exp["steps_since_battle"])

        self._ensure_walkable_player_pos()
        if self.active_submap is not None:
            self._cleanse_defeated_boss_tiles(self.active_submap)

        # Check if returning from a boss encounter
        self.is_quest_modal_active = False
        boss_name = self.pending_boss_fight or context.get("active_boss_fight")
        if boss_name:
            core = context.get(SMState.ContextEldoriaCore)
            combat_state = core.game_state.states.get("GSNvNCombatScreen") if core and hasattr(core, "game_state") else None
            from ..combat.engine import CombatPhase
            is_victory = False
            if combat_state:
                if getattr(combat_state, "last_battle_result", "") == "VICTORY":
                    is_victory = True
                elif hasattr(combat_state, "engine") and combat_state.engine.phase == CombatPhase.BATTLE_VICTORY:
                    is_victory = True
            elif not self.party.is_wiped:
                is_victory = True

            if is_victory and not self.party.is_wiped:
                self.exploration_flags[f"boss_defeated_{boss_name}"] = True
                self.last_status_msg = f"★ VICTORY! {boss_name} has been defeated!"
                qm = getattr(self.party, "quest_manager", None)
                if qm:
                    qm.notify_enemy_defeated(boss_name, count=1, party=self.party)
                self._cleanse_defeated_boss_tiles(self._current_map())
            self.pending_boss_fight = None
            context.set("active_boss_fight", None)

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
            self.danger_counter = 0.0
            self.danger_threshold = self._roll_danger_threshold()
            self.last_status_msg = "Revived!"
        TerminalScreen.flush()

    def exit(self, context: Context) -> None:
        super().exit(context)
        self.is_quest_modal_active = False
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

        if getattr(self, "is_quest_modal_active", False):
            if isinstance(keys_pressed, list) and len(keys_pressed) > 0:
                for key_info in list(keys_pressed):
                    if key_info.key == KeyCode.ESCAPE or key_info.char in ("q", "Q"):
                        self.is_quest_modal_active = False
                        keys_pressed.remove(key_info)
                        break
                    elif key_info.char in ("m", "M") or key_info.key == KeyCode.TAB or key_info.char == "\t":
                        self.is_quest_modal_active = False
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
                                if "Quests" in menu_state.CATEGORIES:
                                    menu_state.category_idx = menu_state.CATEGORIES.index("Quests")
                                    menu_state._enter_submenu()
                            core.game_state.trigger("ToMenu", context)
                        return
                    else:
                        keys_pressed.remove(key_info)
            self._render()
            return

        if hasattr(self, "npc_dialog") and self.npc_dialog.is_active:
            if isinstance(keys_pressed, list) and len(keys_pressed) > 0:
                for key_info in list(keys_pressed):
                    handled = self.npc_dialog.handle_key(key_info)
                    if handled:
                        keys_pressed.remove(key_info)
                        break
            self._render()
            return

        if self.is_item_picker_active:
            picker_items = self._get_picker_items()
            if isinstance(keys_pressed, list) and len(keys_pressed) > 0:
                for key_info in list(keys_pressed):
                    if key_info.key == KeyCode.UP:
                        if self.item_picker_cursor > 0:
                            self.item_picker_cursor -= 1
                        keys_pressed.remove(key_info)
                        break
                    elif key_info.key == KeyCode.DOWN:
                        if self.item_picker_cursor < len(picker_items) - 1:
                            self.item_picker_cursor += 1
                        keys_pressed.remove(key_info)
                        break
                    elif key_info.key == KeyCode.ESCAPE or key_info.char in ("q", "Q"):
                        self.is_item_picker_active = False
                        self.locked_poi_target = None
                        self.last_status_msg = "Decided not to unlock."
                        keys_pressed.remove(key_info)
                        break
                    elif key_info.key == KeyCode.ENTER or key_info.char in ("\r", "\n"):
                        keys_pressed.remove(key_info)
                        if 0 <= self.item_picker_cursor < len(picker_items):
                            chosen_item_id, _ = picker_items[self.item_picker_cursor]
                            poi = self.locked_poi_target
                            if poi and (poi.required_key is None or chosen_item_id == poi.required_key):
                                poi.is_locked = False
                                unlock_text = poi.unlock_msg or f"The lock clicks open with {chosen_item_id}!"
                                self.last_status_msg = f"★ Used {chosen_item_id}! {unlock_text}"
                                self.is_item_picker_active = False
                                self.locked_poi_target = None
                            else:
                                self.last_status_msg = f"Tried {chosen_item_id}: It doesn't fit the lock."
                        break
            self._render()
            return

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

                # Tracked Quest quick modal trigger ([Q])
                elif key_info.char in ("q", "Q"):
                    keys_pressed.remove(key_info)
                    self.is_quest_modal_active = True
                    self._render()
                    return

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

    def _ensure_walkable_player_pos(self) -> None:
        """Validates that the current player coordinates are on a walkable tile with no NPC.
        If unwalkable or trapped, safely relocates the player to the closest walkable tile in the sector.
        """
        curr_map = self._current_map()
        self.player_x = max(0, min(curr_map.width - 1, self.player_x))
        self.player_y = max(0, min(curr_map.height - 1, self.player_y))

        curr_tile = curr_map.tiles[self.player_y][self.player_x]
        if curr_tile.is_walkable and curr_tile.npc is None and any(curr_tile.exits):
            return

        max_dist = max(curr_map.width, curr_map.height)
        best_candidate: Optional[Tuple[int, int]] = None
        for radius in range(1, max_dist):
            for dy in range(-radius, radius + 1):
                for dx in range(-radius, radius + 1):
                    if abs(dx) != radius and abs(dy) != radius:
                        continue
                    nx = self.player_x + dx
                    ny = self.player_y + dy
                    if 0 <= ny < curr_map.height and 0 <= nx < curr_map.width:
                        cand = curr_map.tiles[ny][nx]
                        if cand.is_walkable and cand.npc is None:
                            if any(cand.exits):
                                self.player_x = nx
                                self.player_y = ny
                                return
                            elif best_candidate is None:
                                best_candidate = (nx, ny)
        if best_candidate is not None:
            self.player_x, self.player_y = best_candidate

    def _try_move(self, dx: int, dy: int, exit_dir: int) -> bool:
        """Handles player movement and seamless sector boundary crossing. Returns True if moved."""
        curr_map = self._current_map()
        curr_tile = curr_map.tiles[self.player_y][self.player_x]

        # Standard exit check, with emergency unstuck fallback if player is trapped on an unwalkable tile
        is_trapped = (not curr_tile.is_walkable) or (not any(curr_tile.exits))
        if not curr_tile.exits[exit_dir] and not is_trapped:
            return False

        nx = self.player_x + dx
        ny = self.player_y + dy

        # Sub-map movement
        if self.active_submap is not None:
            if 0 <= nx < self.map_width and 0 <= ny < self.map_height:
                dest_tile = self.active_submap.tiles[ny][nx]
                if not dest_tile.is_walkable or dest_tile.npc is not None:
                    return False
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
                if next_sec and next_sec.tiles[ny][0].is_walkable and next_sec.tiles[ny][0].npc is None:
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
                if next_sec and next_sec.tiles[ny][self.map_width - 1].is_walkable and next_sec.tiles[ny][self.map_width - 1].npc is None:
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
                if next_sec and next_sec.tiles[0][nx].is_walkable and next_sec.tiles[0][nx].npc is None:
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
                if next_sec and next_sec.tiles[self.map_height - 1][nx].is_walkable and next_sec.tiles[self.map_height - 1][nx].npc is None:
                    self.current_sector = (sx, sy - 1)
                    self.player_x = nx
                    self.player_y = self.map_height - 1
                    TerminalScreen.clear_screen()
                    TerminalScreen.flush()
                    return True
            return False

        # Regular move within the same sector: strictly require destination to be walkable & free of NPCs
        dest_tile = curr_map.tiles[ny][nx]
        if not dest_tile.is_walkable or dest_tile.npc is not None:
            return False
        self.player_x = nx
        self.player_y = ny
        return True

    def _roll_danger_threshold(self) -> float:
        """Rolls a random danger threshold between 26.0 and 44.0 points."""
        return random.uniform(26.0, 44.0)

    def _cleanse_defeated_boss_tiles(self, map_obj: Optional[Map]) -> None:
        """Removes Boss objects and custom glyphs from tiles of defeated bosses."""
        if not map_obj:
            return
        for row in map_obj.tiles:
            for tile in row:
                for obj in list(tile.object_listing):
                    if obj.startswith("Boss:"):
                        boss_name = obj.split(":", 1)[1]
                        if self.exploration_flags.get(f"boss_defeated_{boss_name}", False):
                            tile.object_listing = [o for o in tile.object_listing if o != obj]
                            tile.custom_glyph = None
                            tile.custom_fg = None
                            tile.custom_bg = None

    def _check_step_encounter(self, context: Context) -> bool:
        """Evaluates step-based random encounter rolls using danger accumulator. Returns True if encounter triggered."""
        self.steps_since_battle += 1

        curr_map = self._current_map()
        curr_tile = curr_map.tiles[self.player_y][self.player_x]

        # Check for Boss encounter tile
        for obj in list(curr_tile.object_listing):
            if obj.startswith("Boss:"):
                boss_name = obj.split(":", 1)[1]
                boss_flag = f"boss_defeated_{boss_name}"
                if self.exploration_flags.get(boss_flag, False):
                    # Cleanse defeated boss tile and prevent retrigger
                    curr_tile.object_listing = [o for o in curr_tile.object_listing if o != obj]
                    curr_tile.custom_glyph = None
                    curr_tile.custom_fg = None
                    curr_tile.custom_bg = None
                    return False
                return self._trigger_boss_encounter(context, boss_name)

        # Warp tiles, egress tiles, safe tiles never accumulate danger or trigger encounters
        if curr_tile.warp_target is not None:
            return False

        if not curr_tile.battle_allowed or curr_tile.encounter_rate <= 0.0:
            return False

        if curr_tile.region_code == 0:
            return False

        # Danger Accumulator logic:
        # Step danger scales with tile encounter_rate (x10)
        # e.g., Road (0.04) -> 0.4, Coast (0.08) -> 0.8, Plains (0.10) -> 1.0, Forest (0.16) -> 1.6, Cave (0.20) -> 2.0
        step_danger = max(0.1, curr_tile.encounter_rate * 10.0)
        if curr_tile.encounter_rate >= 1.0:
            self.danger_counter = max(self.danger_counter, self.danger_threshold)
        else:
            self.danger_counter += step_danger

        # Trigger encounter once accumulated danger meets threshold and minimum grace steps have passed
        if self.steps_since_battle >= self.min_grace_steps and self.danger_counter >= self.danger_threshold:
            return self._trigger_encounter(context, curr_tile.biome, curr_tile.region_code)

        return False

    def _trigger_boss_encounter(self, context: Context, boss_name: str) -> bool:
        """Spawns a solo boss encounter and transitions to GSNvNCombatScreen."""
        from eldoria_py.combat.encounters import create_boss_encounter
        squad = create_boss_encounter(boss_name)
        if squad is None:
            return False

        core = context.get(SMState.ContextEldoriaCore)
        if not core or not hasattr(core, "game_state"):
            return False

        combat_state = core.game_state.states.get("GSNvNCombatScreen")
        if not combat_state:
            return False

        self.steps_since_battle = 0
        self.danger_counter = 0.0
        self.danger_threshold = self._roll_danger_threshold()
        self.pending_boss_fight = boss_name
        context.set("active_boss_fight", boss_name)
        combat_state.start_encounter(self.party, squad, boss_name=boss_name)
        transition_state = core.game_state.states.get("GSMatrixTransitionScreen")
        if transition_state:
            transition_state.configure(
                source_lines=self.generate_frame_lines(),
                target_event="EnterCombat",
                target_state="GSNvNCombatScreen",
            )
        try:
            get_audio_engine(autostart_device=False).fade_out_bgm(duration_seconds=1.0)
        except Exception:
            pass
        core.game_state.trigger("ToCombat", context)
        return True

    def _trigger_encounter(self, context: Context, biome: Union[BiomeType, int], region_code: Optional[int] = None) -> bool:
        """Spawns an enemy squad for biome and region_code and transitions to GSNvNCombatScreen."""
        if region_code is None and isinstance(biome, int):
            squad = generate_encounter(biome)
        else:
            squad = generate_encounter(biome, region_code)
        if squad is None:
            return False

        core = context.get(SMState.ContextEldoriaCore)
        if not core or not hasattr(core, "game_state"):
            return False

        combat_state = core.game_state.states.get("GSNvNCombatScreen")
        if not combat_state:
            return False

        self.steps_since_battle = 0
        self.danger_counter = 0.0
        self.danger_threshold = self._roll_danger_threshold()
        combat_state.start_encounter(self.party, squad)
        transition_state = core.game_state.states.get("GSMatrixTransitionScreen")
        if transition_state:
            transition_state.configure(
                source_lines=self.generate_frame_lines(),
                target_event="EnterCombat",
                target_state="GSNvNCombatScreen",
            )
        try:
            get_audio_engine(autostart_device=False).fade_out_bgm(duration_seconds=1.0)
        except Exception:
            pass
        core.game_state.trigger("ToCombat", context)
        return True

    def _save_to_slot(self, slot_idx: int) -> None:
        """Atomically saves game state to the designated slot."""
        self._ensure_walkable_player_pos()
        exploration_state = {
            "current_sector": list(self.current_sector),
            "player_pos": [self.player_x, self.player_y],
            "current_map_name": self.active_poi.name if self.active_poi else "Overworld",
            "active_submap_poi": self.active_poi.name if self.active_poi else None,
            "visited_sectors": [list(self.current_sector)],
            "flags": dict(self.exploration_flags),
            "danger_counter": round(self.danger_counter, 2),
            "danger_threshold": round(self.danger_threshold, 2),
            "steps_since_battle": self.steps_since_battle,
        }
        self.save_manager.save_game(
            slot_idx=slot_idx,
            party=self.party,
            exploration_state=exploration_state,
            playtime_seconds=self.playtime_seconds,
            world_macro=self.world_macro,
        )

    def _get_adjacent_npcs(self) -> List[Tuple[NPC, str]]:
        """Returns list of (NPC, direction_label) adjacent to player's current position."""
        curr_map = self._current_map()
        x, y = self.player_x, self.player_y
        adjacent: List[Tuple[NPC, str]] = []

        directions = [
            (0, -1, "North"),
            (0, 1, "South"),
            (1, 0, "East"),
            (-1, 0, "West"),
        ]

        for dx, dy, dir_label in directions:
            nx, ny = x + dx, y + dy
            if 0 <= ny < curr_map.height and 0 <= nx < curr_map.width:
                tile = curr_map.tiles[ny][nx]
                if tile.npc is not None:
                    adjacent.append((tile.npc, dir_label))

        return adjacent

    def _start_npc_dialog(self, npc: NPC) -> None:
        """Opens dialogue modal with the specified NPC and configures choice actions."""
        self.npc_dialog.screen_width = self.map_width
        self.npc_dialog.screen_height = self.map_height + 3

        choices: Optional[List[DialogChoice]] = None

        # Check for NPC Side Questline offering
        qm = getattr(self.party, "quest_manager", None)
        sq_idx = getattr(npc, "side_quest_template_idx", None)
        if qm is not None and sq_idx is not None and npc.role not in (
            NPCRole.KING, NPCRole.INNKEEPER, NPCRole.ITEM_SHOPKEEPER, NPCRole.EQUIP_SHOPKEEPER
        ):
            from ..quests.generator import create_side_quest_for_npc
            loc_name = self.active_poi.name if self.active_poi else "Town"
            sq, dialogues = create_side_quest_for_npc(
                npc_id=npc.npc_id,
                npc_name=npc.name,
                location_name=loc_name,
                template_idx=sq_idx,
            )
            status = qm.get_npc_quest_status(npc.npc_id)

            if status == "NOT_REGISTERED":
                npc.dialogue = dialogues["offer"]
                npc.category = DialogCategory.CHOICE

                def on_quest_yes():
                    qm.register_side_questline(sq, party=self.party)
                    self.last_status_msg = f"★ Quest Accepted: {sq.title}!"
                    npc.dialogue = dialogues["in_progress"]
                    npc.category = DialogCategory.STANDARD

                def on_quest_no():
                    self.last_status_msg = f"Declined quest from {npc.name}."

                choices = [
                    DialogChoice(label="Yes", action=on_quest_yes),
                    DialogChoice(label="No", action=on_quest_no),
                ]
            elif status == "IN_PROGRESS":
                npc.dialogue = dialogues["in_progress"]
                npc.category = DialogCategory.STANDARD
                choices = None
            elif status == "READY_TO_TURN_IN":
                npc.dialogue = dialogues["turn_in"]
                npc.category = DialogCategory.STANDARD
                choices = None
                qm.claim_side_quest_rewards(sq.questline_id, party=self.party)
                self.last_status_msg = f"★ Quest Completed: {sq.title}! ({sq.rewards.formatted_summary()})"
            elif status == "COMPLETED":
                npc.dialogue = dialogues["completed"]
                npc.category = DialogCategory.STANDARD
                choices = None

        elif npc.category == DialogCategory.CHOICE:
            if npc.role == NPCRole.INNKEEPER:
                fee = getattr(npc, "inn_fee", 20)

                def on_inn_yes():
                    for m in self.party.members:
                        m.stats[StatId.HIT_POINTS].current = m.max_hp
                        m.stats[StatId.MAGIC_POINTS].current = m.max_mp
                    slot = self.active_slot or 1
                    self._save_to_slot(slot)
                    self.last_status_msg = f"★ Stayed at the Inn! Party fully restored & saved to Slot {slot}."

                def on_inn_no():
                    self.last_status_msg = "Decided not to take a room."

                choices = [
                    DialogChoice(label="Yes", action=on_inn_yes),
                    DialogChoice(label="No", action=on_inn_no),
                ]
            elif npc.role in (NPCRole.ITEM_SHOPKEEPER, NPCRole.EQUIP_SHOPKEEPER):
                def on_shop_yes():
                    self.last_status_msg = f"★ {npc.name}'s shop will open in a future update! (Wares preview available in inventory)."

                def on_shop_no():
                    self.last_status_msg = "Decided not to browse wares."

                choices = [
                    DialogChoice(label="Yes", action=on_shop_yes),
                    DialogChoice(label="No", action=on_shop_no),
                ]

        self.npc_dialog.start_dialog(
            npc=npc,
            choices=choices,
        )

    def _handle_interact(self) -> None:
        """Handles Enter key interaction: adjacent NPCs, POI entry, resting, or egress."""
        # 1. Adjacent NPC detection & interaction
        adjacent_npcs = self._get_adjacent_npcs()
        if len(adjacent_npcs) == 1:
            npc, _ = adjacent_npcs[0]
            self._start_npc_dialog(npc)
            return
        elif len(adjacent_npcs) >= 2:
            self.npc_dialog.screen_width = self.map_width
            self.npc_dialog.screen_height = self.map_height + 3
            self.npc_dialog.start_target_selection(
                adjacent_npcs=adjacent_npcs,
                on_select=self._start_npc_dialog,
            )
            return

        curr_map = self._current_map()
        curr_tile = curr_map.tiles[self.player_y][self.player_x]

        # Check for healing interactables (Inn or Well)
        if any(obj in curr_tile.object_listing for obj in ("MTOInn", "MTOWell")):
            for m in self.party.members:
                m.stats[StatId.HIT_POINTS].current = m.max_hp
                m.stats[StatId.MAGIC_POINTS].current = m.max_mp
            self.steps_since_battle = 0
            self.danger_counter = 0.0
            self.danger_threshold = self._roll_danger_threshold()
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
                if poi:
                    if poi.is_locked:
                        picker_items = self._get_picker_items()
                        if not picker_items:
                            req = poi.required_key or "a Key"
                            self.last_status_msg = f"Locked! Entrance requires {req}, but party has no keys."
                            return
                        self.is_item_picker_active = True
                        self.item_picker_cursor = 0
                        self.locked_poi_target = poi
                        return

                    if poi.sub_map:
                        # Push return sector and position to warp stack
                        self.warp_stack.append((self.current_sector, (self.player_x, self.player_y)))
                        self.active_submap = poi.sub_map
                        self.active_poi = poi
                        self.player_x, self.player_y = poi.spawn_pos
                        self._cleanse_defeated_boss_tiles(self.active_submap)
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

    def _get_picker_items(self) -> List[Tuple[str, int]]:
        """Returns list of usable keys/items from party inventory for the item picker."""
        if not self.party or not self.party.inventory:
            return []
        items: List[Tuple[str, int]] = []
        if isinstance(self.party.inventory, dict):
            for k, v in self.party.inventory.items():
                if v > 0 and (is_key_item(k) or "key" in str(k).lower() or "crest" in str(k).lower()):
                    items.append((str(k), int(v)))
        else:
            for entry in self.party.inventory:
                item_id = entry.get("item_id") or entry.get("name", "")
                qty = entry.get("qty", 1)
                item_type = entry.get("type", "")
                if qty > 0 and (is_key_item(item_id) or item_type == "key" or "key" in item_id.lower() or "crest" in item_id.lower()):
                    items.append((item_id, qty))
        return items

    def _render_item_picker(self) -> None:
        """Populates item picker modal UIPanel with key/inventory choices."""
        self.item_picker_panel.labels.clear()
        target_name = self.locked_poi_target.name if self.locked_poi_target else "Lock"
        self.item_picker_panel.add_label(
            ATCoordinates(11, 18),
            f"\033[1;36mSelect item to unlock {target_name}:\033[0m",
        )
        picker_items = self._get_picker_items()
        if not picker_items:
            self.item_picker_panel.add_label(
                ATCoordinates(13, 18),
                "\033[31mNo suitable keys or tools found in inventory.\033[0m",
            )
        else:
            for idx, (item_id, qty) in enumerate(picker_items[:6]):
                row = 13 + idx
                prefix = " \033[1;33m►\033[0m " if idx == self.item_picker_cursor else "   "
                self.item_picker_panel.add_label(
                    ATCoordinates(row, 18),
                    f"{prefix}\033[1;37m{item_id:<22}\033[0m \033[36mx{qty:>2}\033[0m",
                )
        self.item_picker_panel.add_label(
            ATCoordinates(19, 18),
            "\033[33m[↑/↓]\033[0m Select  \033[33m[Enter]\033[0m Use  \033[33m[Esc]\033[0m Cancel",
        )

    def _render_quest_modal(self) -> List[Tuple[int, int, str]]:
        """
        Renders the Tracked Quest temporary modal overlay centered on the screen.
        Displays active questline, quest, active step, directive narrative, and spoils.
        """
        qm = getattr(self.party, "quest_manager", None)
        target_ql, target_q, target_s = qm.get_tracked_artifact() if qm else (None, None, None)

        modal_w = min(48, max(36, self.map_width - 4))
        modal_h = 12
        left_c = max(2, (self.map_width - modal_w) // 2 + 1)
        total_rows = self.map_height + 3
        top_r = max(2, (total_rows - modal_h) // 2 + 1)

        border_col = "\033[1;36m"
        bg = "\033[48;2;16;22;34m"

        def _make_border(title: str, left: str, fill: str, right: str) -> str:
            inner_w = modal_w - 2
            if title:
                t_vis = visible_width(title)
                rem = max(0, inner_w - t_vis - 2)
                lp = rem // 2
                rp = rem - lp
                safe_title = title.replace("\033[0m", f"\033[0m{bg}{border_col}")
                return f"{border_col}{left}{bg}{fill * lp} {safe_title}\033[0m{bg}{border_col} {fill * rp}{right}\033[0m"
            return f"{border_col}{left}{bg}{fill * inner_w}{right}\033[0m"

        def _make_row(text: str) -> str:
            inner_w = modal_w - 4
            t_vis = visible_width(text)
            if t_vis > inner_w:
                text = truncate_ansi(text, inner_w)
                t_vis = visible_width(text)
            pad = " " * max(0, inner_w - t_vis)
            safe_text = text.replace("\033[0m", f"\033[0m{bg}")
            return f"{border_col}│{bg} {safe_text}\033[0m{bg}{pad} {border_col}│\033[0m"

        rows: List[str] = []
        # Row 0: Top border with title
        rows.append(_make_border(" \033[1;33m★ Tracked Quest\033[0m ", "╭", "─", "╮"))

        if target_q is not None and target_ql is not None:
            # Row 1: Questline header
            badge = "\033[1;33m◆ STORYLINE:\033[0m" if target_ql.is_storyline else "\033[1;36m◇ SIDE QUEST:\033[0m"
            ql_title = target_ql.title[: modal_w - 18]
            rows.append(_make_row(f"{badge} \033[1;37m{ql_title}\033[0m"))

            # Row 2: Divider
            rows.append(_make_border("", "├", "─", "┤"))

            # Row 3: Quest Title (without step counter)
            q_title = target_q.title[: modal_w - 12]
            rows.append(_make_row(f"\033[1;33mQuest:\033[0m \033[1;37m{q_title}\033[0m"))

            # Row 4: Step / Objective Title
            if target_s:
                step_title = getattr(target_s, "title", "") or target_s.description
                rows.append(_make_row(f"\033[1;33mStep:\033[0m  \033[37m{step_title[: modal_w - 12]}\033[0m"))
            else:
                rows.append(_make_row("\033[90mAll steps completed\033[0m"))

            # Row 5: Directive header
            rows.append(_make_row("\033[1;33mDirective:\033[0m"))

            # Rows 6 & 7: Directive narrative (wrapped)
            desc_text = target_s.description if target_s else "No further active objectives."
            wrapped = wrap_text(desc_text, modal_w - 6)
            line1 = f"  \033[37m{wrapped[0]}\033[0m" if len(wrapped) > 0 else ""
            line2 = f"  \033[37m{wrapped[1]}\033[0m" if len(wrapped) > 1 else ""
            rows.append(_make_row(line1))
            rows.append(_make_row(line2))

            # Row 8: Origin or Spoils (for side quests), line 3 if long, or blank
            if not target_ql.is_storyline and hasattr(target_ql, "originator_name"):
                orig_name = getattr(target_ql, "originator_name", "")
                orig_loc = getattr(target_ql, "originator_location", "")
                rows.append(_make_row(f"\033[90mOrigin: {orig_name[:16]} ({orig_loc[:16]})\033[0m"))
            elif len(wrapped) > 2:
                rows.append(_make_row(f"  \033[37m{wrapped[2]}\033[0m"))
            else:
                rows.append(_make_row(""))

        else:
            # Empty / No quest tracked state
            rows.append(_make_row("\033[1;33m◆ TRACKER:\033[0m \033[90mNo Quest Pinned\033[0m"))
            rows.append(_make_border("", "├", "─", "┤"))
            rows.append(_make_row("\033[37mThere is no active quest currently tracked.\033[0m"))
            rows.append(_make_row(""))
            rows.append(_make_row("\033[36mOpen the Main Menu [M] -> Quests to browse\033[0m"))
            rows.append(_make_row("\033[36myour journal and track an active quest.\033[0m"))
            rows.append(_make_row(""))
            rows.append(_make_row("\033[90mTrack a quest with [T] or [Space] in Journal.\033[0m"))

        # Row 9: Divider
        rows.append(_make_border("", "├", "─", "┤"))

        # Row 10: Footer / Dismiss controls
        rows.append(_make_row("\033[33m[Q / Esc]\033[0m Dismiss      \033[33m[M]\033[0m Open Journal"))

        # Row 11: Bottom border
        rows.append(_make_border("", "╰", "─", "╯"))

        commands: List[Tuple[int, int, str]] = []
        for idx, row_str in enumerate(rows):
            commands.append((top_r + idx, left_c, row_str))

        return commands

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

        adjacent_npcs = self._get_adjacent_npcs()

        if self.last_status_msg:
            t_text = f" {party_badge} \033[1;36m{self.last_status_msg}\033[0m"
        elif adjacent_npcs:
            if len(adjacent_npcs) == 1:
                t_text = (
                    f" ({self.player_x:02d},{self.player_y:02d}) {party_badge} "
                    f"\033[1;32m★ Talk to {adjacent_npcs[0][0].name}\033[0m \033[1;33m[Enter]\033[0m"
                )
            else:
                t_text = (
                    f" ({self.player_x:02d},{self.player_y:02d}) {party_badge} "
                    f"\033[1;32m★ Talk to NPCs ({len(adjacent_npcs)})\033[0m \033[1;33m[Enter]\033[0m"
                )
        elif self.active_submap is None:
            if curr_tile.warp_target and not curr_tile.warp_target.is_egress:
                lock_badge = " \033[1;31m[Locked]\033[0m" if (curr_tile.poi and curr_tile.poi.is_locked) else ""
                t_text = (
                    f" ({self.player_x:02d},{self.player_y:02d}) {party_badge} "
                    f"\033[1;32m★ {curr_tile.warp_target.prompt_label}\033[0m{lock_badge} "
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
        if adjacent_npcs:
            f_text = " \033[33m[↑↓←→]\033[0mMove  \033[33m[Enter]\033[0mTalk  \033[33m[M]\033[0mMenu  \033[33m[Q]\033[0mQuest "
        elif self.active_submap is None:
            f_text = " \033[33m[↑↓←→]\033[0mMove  \033[33m[Enter]\033[0mEnter  \033[33m[M]\033[0mMenu  \033[33m[Q]\033[0mQuest "
        else:
            f_text = " \033[33m[↑↓←→]\033[0mMove  \033[33m[Enter]\033[0mLeave  \033[33m[M]\033[0mMenu  \033[33m[Q]\033[0mQuest "

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

        # Overlay item picker modal if active
        if self.is_item_picker_active:
            self._render_item_picker()
            panel_lines = self.item_picker_panel.render_lines()
            for p_idx, p_line in enumerate(panel_lines):
                out.append(ATCoordinates(10 + p_idx, 16).to_ansi())
                out.append(p_line)

        # Overlay NPC Dialogue modal if active
        if hasattr(self, "npc_dialog") and self.npc_dialog.is_active:
            dialog_cmds = self.npc_dialog.render_overlay()
            for d_row, d_col, d_text in dialog_cmds:
                out.append(ATCoordinates(d_row, d_col).to_ansi())
                out.append(d_text)

        # Overlay Tracked Quest modal if active
        if getattr(self, "is_quest_modal_active", False):
            modal_cmds = self._render_quest_modal()
            for m_row, m_col, m_text in modal_cmds:
                out.append(ATCoordinates(m_row, m_col).to_ansi())
                out.append(m_text)

        footer_y = len(lines)
        # Clear tail lines up to 40 (clears leftover rows from larger 80x40 screens)
        out.append(clear_buffer_tail(footer_y + 1, 40))

        out.append(ATControlSequences.DrawOptimizeOff)
        TerminalScreen.write("".join(out))
        TerminalScreen.flush()
