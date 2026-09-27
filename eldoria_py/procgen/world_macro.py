"""
WorldMacroMap: 4x4 Macro World Map Grid architecture with continuous global coordinates,
algorithmic Point of Interest (Town, Castle, Cave) placement, and sub-map linking.
"""

from __future__ import annotations
import math
import random
from typing import Any, Dict, List, Optional, Tuple, Union

from .map_generator import (
    BiomeType,
    BIOME_CONFIGS,
    Map,
    MapTile,
    ProceduralMapGenerator,
)
from .noise import FastNoiseLite, FractalType, NoiseType
from .poi import POIDescriptor, POIType, WarpTarget
from .submap_generator import SubMapGenerator
from ..terminal.color import TrueColor

TOWN_NAMES = [
    "Oakhaven Town",
    "Riverwood Settlement",
    "Highland Watch",
    "Sunshore Haven",
    "Ironford Outpost",
    "Mistral Village",
    "Falcon's Reach",
    "Eldermere Town",
]

CASTLE_NAMES = [
    "Highspire Castle",
    "Stormkeep Stronghold",
    "Dunmore Fortress",
    "Silverguard Keep",
    "Ravenhold Bastion",
]

CAVE_NAMES = [
    "Shadowfen Cavern",
    "Duskfall Grotto",
    "Blackstone Deep",
    "Echoing Chasm",
    "Whispering Depths",
    "Dragon's Maw",
    "Crystal Hollow",
    "Grimrock Abyss",
]


class WorldMacroMap:
    """
    Manages an interconnected macro grid of 54x24 sectors.
    Uses continuous global noise sampling:
        world_x = sector_x * 54 + x
        world_y = sector_y * 24 + y
    Ensures seamless biome borders, reciprocal boundary exits, and algorithmic
    placement of distinct POIs (Towns, Castles, Caves) into separate sectors.
    """

    def __init__(
        self,
        seed: int = 1337,
        macro_width: int = 4,
        macro_height: int = 4,
        sector_width: int = 54,
        sector_height: int = 24,
        frequency: float = 0.035,
        noise_type: NoiseType = NoiseType.OpenSimplex2,
        fractal_type: FractalType = FractalType.FBm,
        octaves: int = 4,
        lacunarity: float = 2.0,
        gain: float = 0.5,
        generate: bool = True,
    ) -> None:
        self.seed = seed
        self.macro_width = macro_width
        self.macro_height = macro_height
        self.sector_width = sector_width
        self.sector_height = sector_height
        self.frequency = frequency
        self.noise_type = noise_type
        self.fractal_type = fractal_type
        self.octaves = octaves
        self.lacunarity = lacunarity
        self.gain = gain

        self.generator = ProceduralMapGenerator(
            seed=self.seed,
            frequency=self.frequency,
            noise_type=self.noise_type,
            fractal_type=self.fractal_type,
            octaves=self.octaves,
            lacunarity=self.lacunarity,
            gain=self.gain,
        )

        self.sectors: List[List[Map]] = []
        self.pois: Dict[Union[POIType, str], POIDescriptor] = {}
        self.all_pois: List[POIDescriptor] = []
        self.starter_sector: Tuple[int, int] = (0, 0)
        self.starter_player_pos: Tuple[int, int] = (sector_width // 2, sector_height // 2)

        if generate:
            self.generate()

    def get_sector(self, sx: int, sy: int) -> Optional[Map]:
        """Returns the Map for sector (sx, sy), or None if out of bounds."""
        if 0 <= sy < self.macro_height and 0 <= sx < self.macro_width:
            return self.sectors[sy][sx]
        return None

    def get_poi(self, poi_type: Union[POIType, str]) -> Optional[POIDescriptor]:
        """Returns the POIDescriptor for the given POIType or POI name."""
        if poi_type in self.pois:
            return self.pois[poi_type]
        for poi in self.all_pois:
            if poi.poi_type == poi_type or poi.name == poi_type:
                return poi
        return None

    def reseed(self, new_seed: int) -> None:
        """Regenerates the entire 4x4 macro world with a new seed."""
        self.seed = new_seed
        self.generator.reseed(new_seed)
        self.generate()

    def generate(self) -> None:
        """Generates all 16 sectors, places POIs in distinct sectors, and links exits."""
        # 1. Generate 4x4 sectors with continuous global coordinates
        self.sectors = []
        for sy in range(self.macro_height):
            row: List[Map] = []
            for sx in range(self.macro_width):
                offset_x = sx * self.sector_width
                offset_y = sy * self.sector_height
                sec_map = self.generator.generate_map(
                    name=f"Sector_{sx}_{sy}",
                    width=self.sector_width,
                    height=self.sector_height,
                    create_road=False,
                    boundary_wrap=False,
                    offset_x=offset_x,
                    offset_y=offset_y,
                )
                row.append(sec_map)
            self.sectors.append(row)

        # 2. Algorithmic POI Selection & Placement
        self._place_pois()

        # 3. Carve Overworld Road through Town Sector
        self._carve_town_road()

        # 4. Re-calculate internal exits for any modified sectors
        for sy in range(self.macro_height):
            for sx in range(self.macro_width):
                ProceduralMapGenerator._calculate_exits(self.sectors[sy][sx])

        # 5. Link Inter-Sector Exits across boundaries with strict reciprocity
        self._link_sector_exits()

    def _place_pois(self) -> None:
        """Selects distinct sectors and places Town, Castle, and Cave POIs based on map size."""
        self.pois.clear()
        self.all_pois.clear()
        sector_stats = []

        # Analyze each sector's biome distribution
        for sy in range(self.macro_height):
            for sx in range(self.macro_width):
                sec = self.sectors[sy][sx]
                counts: Dict[BiomeType, int] = {b: 0 for b in BiomeType}
                for y in range(self.sector_height):
                    for x in range(self.sector_width):
                        counts[sec.tiles[y][x].biome] += 1

                walkable_count = (
                    counts[BiomeType.PLAINS]
                    + counts[BiomeType.FOREST]
                    + counts[BiomeType.COAST]
                    + counts[BiomeType.ROAD]
                )
                sector_stats.append({
                    "coord": (sx, sy),
                    "walkable": walkable_count,
                    "plains": counts[BiomeType.PLAINS],
                    "forest": counts[BiomeType.FOREST],
                    "mountain": counts[BiomeType.MOUNTAIN],
                    "snow": counts[BiomeType.SNOW],
                    "water": counts[BiomeType.WATER] + counts[BiomeType.DEEP_WATER],
                })

        used_sectors = set()

        total_sectors = self.macro_width * self.macro_height
        if total_sectors <= 16:
            n_towns, n_castles, n_caves = 1, 1, 1
        elif total_sectors <= 36:
            n_towns, n_castles, n_caves = 1, 1, 2
        elif total_sectors <= 144:
            n_towns, n_castles, n_caves = 3, 2, 4
        else:
            n_towns, n_castles, n_caves = 6, 4, 8

        # A. Towns
        town_candidates = sorted(
            [s for s in sector_stats if s["walkable"] >= 40],
            key=lambda s: s["plains"] * 2.0 + s["forest"] - s["water"] * 1.5,
            reverse=True,
        )
        town_sectors = []

        # Seeded RNG dedicated to POI placement to preserve determinism
        poi_rng = random.Random(self.seed + 101)

        if town_candidates:
            # Select starter town from top 3-5 viable candidates using weighted probability
            pool_size = min(5, len(town_candidates))
            starter_pool = town_candidates[:pool_size]
            weights = [max(1.0, s["plains"] * 2.0 + s["forest"] - s["water"] * 1.5) for s in starter_pool]

            chosen_starter = poi_rng.choices(starter_pool, weights=weights, k=1)[0]
            starter_coord = chosen_starter["coord"]
            town_sectors.append(starter_coord)
            used_sectors.add(starter_coord)

        # Place remaining towns (if any) respecting distance constraints
        for cand in town_candidates:
            if len(town_sectors) >= n_towns:
                break
            coord = cand["coord"]
            if coord not in used_sectors:
                if total_sectors > 16:
                    min_dist = min(abs(coord[0] - tc[0]) + abs(coord[1] - tc[1]) for tc in town_sectors)
                    if min_dist < 2 and len(town_candidates) > len(town_sectors) + 2:
                        continue
                town_sectors.append(coord)
                used_sectors.add(coord)

        while len(town_sectors) < n_towns:
            avail = [s["coord"] for s in sector_stats if s["coord"] not in used_sectors]
            if not avail:
                avail = [s["coord"] for s in sector_stats]
            pick = avail[0]
            town_sectors.append(pick)
            used_sectors.add(pick)

        # B. Castles
        castle_candidates = sorted(
            [s for s in sector_stats if s["coord"] not in used_sectors and s["walkable"] >= 30],
            key=lambda s: s["plains"] * 1.5 + s["forest"] * 0.8 - s["water"],
            reverse=True,
        )
        castle_sectors = []
        for cand in castle_candidates:
            coord = cand["coord"]
            if coord not in used_sectors:
                castle_sectors.append(coord)
                used_sectors.add(coord)
                if len(castle_sectors) >= n_castles:
                    break
        while len(castle_sectors) < n_castles:
            avail = [s["coord"] for s in sector_stats if s["coord"] not in used_sectors]
            if not avail:
                avail = [s["coord"] for s in sector_stats]
            pick = avail[0]
            castle_sectors.append(pick)
            used_sectors.add(pick)

        # C. Caves
        cave_candidates = sorted(
            [s for s in sector_stats if s["coord"] not in used_sectors and s["walkable"] >= 10],
            key=lambda s: s["mountain"] * 2.5 + s["snow"] - s["water"],
            reverse=True,
        )
        cave_sectors = []
        for cand in cave_candidates:
            coord = cand["coord"]
            if coord not in used_sectors:
                cave_sectors.append(coord)
                used_sectors.add(coord)
                if len(cave_sectors) >= n_caves:
                    break
        while len(cave_sectors) < n_caves:
            avail = [s["coord"] for s in sector_stats if s["coord"] not in used_sectors]
            if not avail:
                avail = [s["coord"] for s in sector_stats]
            pick = avail[0]
            cave_sectors.append(pick)
            used_sectors.add(pick)

        # -------------------------------------------------------------
        # 1. Place Towns
        # -------------------------------------------------------------
        for idx, coord in enumerate(town_sectors):
            name = TOWN_NAMES[idx] if idx < len(TOWN_NAMES) else f"Settlement {idx + 1}"
            town_map = self.sectors[coord[1]][coord[0]]
            town_pos = self._find_best_open_pos(town_map)
            town_submap, town_spawn = SubMapGenerator.generate_town(
                name=name,
                seed=self.seed + idx * 37,
            )
            town_poi = POIDescriptor.create_town(
                name=name,
                sector_coord=coord,
                local_pos=town_pos,
                spawn_pos=town_spawn,
            )
            town_poi.sub_map = town_submap
            self._stamp_poi_on_tile(town_map, town_pos, town_poi)
            self.all_pois.append(town_poi)
            self.pois[name] = town_poi
            if POIType.TOWN not in self.pois:
                self.pois[POIType.TOWN] = town_poi
                # Set default starter sector and player start position right at primary Town
                self.starter_sector = coord
                cand_x = min(self.sector_width - 1, town_pos[0] + 1)
                if town_map.tiles[town_pos[1]][cand_x].is_walkable:
                    self.starter_player_pos = (cand_x, town_pos[1])
                else:
                    self.starter_player_pos = town_pos

        # -------------------------------------------------------------
        # 2. Place Castles
        # -------------------------------------------------------------
        for idx, coord in enumerate(castle_sectors):
            name = CASTLE_NAMES[idx] if idx < len(CASTLE_NAMES) else f"Fortress {idx + 1}"
            castle_map = self.sectors[coord[1]][coord[0]]
            castle_pos = self._find_best_open_pos(castle_map)
            castle_submap, castle_spawn = SubMapGenerator.generate_castle(
                name=name,
                seed=self.seed + idx * 43,
            )
            castle_poi = POIDescriptor.create_castle(
                name=name,
                sector_coord=coord,
                local_pos=castle_pos,
                spawn_pos=castle_spawn,
            )
            castle_poi.sub_map = castle_submap
            self._stamp_poi_on_tile(castle_map, castle_pos, castle_poi)
            self.all_pois.append(castle_poi)
            self.pois[name] = castle_poi
            if POIType.CASTLE not in self.pois:
                self.pois[POIType.CASTLE] = castle_poi

        # -------------------------------------------------------------
        # 3. Place Caves
        # -------------------------------------------------------------
        for idx, coord in enumerate(cave_sectors):
            name = CAVE_NAMES[idx] if idx < len(CAVE_NAMES) else f"Cavern {idx + 1}"
            cave_map = self.sectors[coord[1]][coord[0]]
            cave_pos = self._find_cave_mouth_pos(cave_map)
            cave_submap, cave_spawn = SubMapGenerator.generate_cave(
                name=name,
                seed=self.seed + idx * 53,
            )
            cave_poi = POIDescriptor.create_cave(
                name=name,
                sector_coord=coord,
                local_pos=cave_pos,
                spawn_pos=cave_spawn,
            )
            cave_poi.sub_map = cave_submap
            self._stamp_poi_on_tile(cave_map, cave_pos, cave_poi)
            self.all_pois.append(cave_poi)
            self.pois[name] = cave_poi
            if POIType.CAVE not in self.pois:
                self.pois[POIType.CAVE] = cave_poi

    def _find_best_open_pos(self, sector_map: Map) -> Tuple[int, int]:
        """Finds a central walkable tile surrounded by walkable land."""
        center_x = self.sector_width // 2
        center_y = self.sector_height // 2

        best_pos = (center_x, center_y)
        best_dist = float("inf")

        for y in range(2, self.sector_height - 2):
            for x in range(2, self.sector_width - 2):
                tile = sector_map.tiles[y][x]
                if tile.is_walkable and tile.poi is None:
                    # Prefer tiles with walkable cardinal neighbors
                    walkable_neighbors = sum(
                        1 for dx, dy in ((0, 1), (0, -1), (1, 0), (-1, 0))
                        if sector_map.tiles[y + dy][x + dx].is_walkable
                    )
                    if walkable_neighbors >= 3:
                        dist = math.hypot(x - center_x, y - center_y)
                        if dist < best_dist:
                            best_dist = dist
                            best_pos = (x, y)

        if best_dist < float("inf"):
            return best_pos

        # Fallback to any walkable tile
        for y in range(self.sector_height):
            for x in range(self.sector_width):
                if sector_map.tiles[y][x].is_walkable and sector_map.tiles[y][x].poi is None:
                    return (x, y)

        # Extreme fallback: carve a plains tile
        sector_map.set_tile(center_x, center_y, MapTile(biome=BiomeType.PLAINS))
        return (center_x, center_y)

    def _find_cave_mouth_pos(self, sector_map: Map) -> Tuple[int, int]:
        """
        Finds a walkable tile directly adjacent to a Mountain tile,
        representing a cave mouth at the cliff base.
        """
        center_x = self.sector_width // 2
        center_y = self.sector_height // 2

        candidates = []
        for y in range(1, self.sector_height - 1):
            for x in range(1, self.sector_width - 1):
                tile = sector_map.tiles[y][x]
                if tile.is_walkable and tile.poi is None:
                    # Check if any 4-neighbor is Mountain
                    for dx, dy in ((0, 1), (0, -1), (1, 0), (-1, 0)):
                        n_tile = sector_map.tiles[y + dy][x + dx]
                        if n_tile.biome in (BiomeType.MOUNTAIN, BiomeType.SNOW):
                            dist = math.hypot(x - center_x, y - center_y)
                            candidates.append((dist, (x, y)))
                            break

        if candidates:
            candidates.sort(key=lambda c: c[0])
            return candidates[0][1]

        # If no walkable tile borders a mountain, find a walkable tile and place a mountain neighbor
        pos = self._find_best_open_pos(sector_map)
        px, py = pos
        # Convert north neighbor to mountain if in bounds
        if py > 0:
            m_tile = MapTile(biome=BiomeType.MOUNTAIN)
            m_tile.background_image = "Mountain"
            sector_map.set_tile(px, py - 1, m_tile)
        return pos

    def _stamp_poi_on_tile(self, sector_map: Map, pos: Tuple[int, int], poi: POIDescriptor) -> None:
        """Stamps the POI glyph, custom colors, and entry WarpTarget onto the sector tile."""
        x, y = pos
        tile = sector_map.tiles[y][x]
        tile.poi = poi
        tile.warp_target = WarpTarget(
            target_map_name=poi.name,
            target_pos=poi.spawn_pos,
            is_egress=False,
            prompt_label=poi.name,
        )
        tile.custom_glyph = poi.glyph
        tile.custom_fg = poi.fg_color
        poi_tag = f"POI:{poi.name}"
        if poi_tag not in tile.object_listing:
            tile.object_listing.append(poi_tag)

    def _carve_town_road(self) -> None:
        """Carves a cobblestone road across all Town sectors connecting West and East edges."""
        for poi in self.all_pois:
            if poi.poi_type != POIType.TOWN:
                continue
            sx, sy = poi.sector_coord
            sec_map = self.sectors[sy][sx]
            tx, ty = poi.local_pos
            w, h = self.sector_width, self.sector_height

            # Pick walkable start on left edge and end on right edge near town's y
            starts = [y for y in range(h) if sec_map.tiles[y][0].is_walkable]
            start_y = min(starts, key=lambda y: abs(y - ty)) if starts else ty

            ends = [y for y in range(h) if sec_map.tiles[y][w - 1].is_walkable]
            end_y = min(ends, key=lambda y: abs(y - ty)) if ends else ty

            # Path 1: From left edge (0, start_y) to Town (tx, ty)
            path1 = self._find_walkable_path(sec_map, (0, start_y), (tx, ty))
            # Path 2: From Town (tx, ty) to right edge (w - 1, end_y)
            path2 = self._find_walkable_path(sec_map, (tx, ty), (w - 1, end_y))

            road_tiles = set(path1 + path2)
            road_cfg = BIOME_CONFIGS[BiomeType.ROAD]

            for rx, ry in road_tiles:
                tile = sec_map.tiles[ry][rx]
                if tile.poi is None:  # Preserve POI glyph and warp target
                    tile.biome = BiomeType.ROAD
                    tile.background_image = "FieldRoad"
                    tile.battle_allowed = road_cfg.battle_allowed
                    tile.encounter_rate = road_cfg.encounter_rate
                    tile.region_code = road_cfg.region_code

    @staticmethod
    def _find_walkable_path(
        sec_map: Map,
        start: Tuple[int, int],
        goal: Tuple[int, int],
    ) -> List[Tuple[int, int]]:
        """Greedy cost pathfinding connecting start to goal."""
        w, h = sec_map.width, sec_map.height
        curr_x, curr_y = start
        gx, gy = goal
        visited = set()
        path = [(curr_x, curr_y)]
        visited.add((curr_x, curr_y))

        max_steps = w * h
        steps = 0
        while (curr_x, curr_y) != (gx, gy) and steps < max_steps:
            steps += 1
            candidates = []
            for dx, dy in [(1, 0), (-1, 0), (0, 1), (0, -1), (1, 1), (-1, 1), (1, -1), (-1, -1)]:
                nx, ny = curr_x + dx, curr_y + dy
                if 0 <= nx < w and 0 <= ny < h and (nx, ny) not in visited:
                    tile = sec_map.tiles[ny][nx]
                    base_cost = 1.0 if tile.is_walkable else 12.0
                    dist = math.hypot(nx - gx, ny - gy)
                    candidates.append((base_cost + dist * 2.0, nx, ny))

            if not candidates:
                break

            candidates.sort(key=lambda c: c[0])
            _, curr_x, curr_y = candidates[0]
            path.append((curr_x, curr_y))
            visited.add((curr_x, curr_y))

        return path

    def _link_sector_exits(self) -> None:
        """
        Calculates and links cardinal exits across sector boundaries.
        Guarantees reciprocal edge crossing:
        Moving East from Sector (X, Y) at x=53 connects to Sector (X+1, Y) at x=0.
        Moving South from Sector (X, Y) at y=23 connects to Sector (X, Y+1) at y=0.
        """
        mw = self.macro_width
        mh = self.macro_height
        sw = self.sector_width
        sh = self.sector_height

        for sy in range(mh):
            for sx in range(mw):
                sec = self.sectors[sy][sx]

                # 1. Horizontal Border Link (East/West)
                for y in range(sh):
                    # East border of current sector
                    if sx < mw - 1:
                        neighbor_sec = self.sectors[sy][sx + 1]
                        tile_a = sec.tiles[y][sw - 1]
                        tile_b = neighbor_sec.tiles[y][0]
                        can_cross = tile_a.is_walkable and tile_b.is_walkable
                        tile_a.exits[MapTile.EXIT_EAST] = can_cross
                        tile_b.exits[MapTile.EXIT_WEST] = can_cross
                    else:
                        # World eastern edge
                        sec.tiles[y][sw - 1].exits[MapTile.EXIT_EAST] = False

                    # World western edge
                    if sx == 0:
                        sec.tiles[y][0].exits[MapTile.EXIT_WEST] = False

                # 2. Vertical Border Link (South/North)
                for x in range(sw):
                    # South border of current sector
                    if sy < mh - 1:
                        neighbor_sec = self.sectors[sy + 1][sx]
                        tile_a = sec.tiles[sh - 1][x]
                        tile_b = neighbor_sec.tiles[0][x]
                        can_cross = tile_a.is_walkable and tile_b.is_walkable
                        tile_a.exits[MapTile.EXIT_SOUTH] = can_cross
                        tile_b.exits[MapTile.EXIT_NORTH] = can_cross
                    else:
                        # World southern edge
                        sec.tiles[sh - 1][x].exits[MapTile.EXIT_SOUTH] = False

                    # World northern edge
                    if sy == 0:
                        sec.tiles[0][x].exits[MapTile.EXIT_NORTH] = False

    def to_dict(self) -> Dict[str, Any]:
        """Serializes the entire world macro map, all sectors, and all POIs to a compact dictionary."""
        return {
            "macro_width": self.macro_width,
            "macro_height": self.macro_height,
            "sector_width": self.sector_width,
            "sector_height": self.sector_height,
            "seed": self.seed,
            "frequency": self.frequency,
            "noise_type": self.noise_type.name if hasattr(self.noise_type, "name") else str(self.noise_type),
            "fractal_type": self.fractal_type.name if hasattr(self.fractal_type, "name") else str(self.fractal_type),
            "octaves": self.octaves,
            "lacunarity": self.lacunarity,
            "gain": self.gain,
            "starter_sector": list(self.starter_sector),
            "starter_player_pos": list(self.starter_player_pos),
            "pois": [poi.to_dict() for poi in self.all_pois],
            "sectors": [
                [sec.to_compact_dict() for sec in row]
                for row in self.sectors
            ],
        }

    @classmethod
    def from_dict(cls, data: Dict[str, Any]) -> WorldMacroMap:
        """Hydrates a WorldMacroMap directly from serialized data without any FastNoiseLite generation."""
        noise_type_val = data.get("noise_type", "OpenSimplex2")
        fractal_type_val = data.get("fractal_type", "FBm")
        noise_type = NoiseType[noise_type_val] if noise_type_val in NoiseType.__members__ else NoiseType.OpenSimplex2
        fractal_type = FractalType[fractal_type_val] if fractal_type_val in FractalType.__members__ else FractalType.FBm

        macro = cls(
            seed=data.get("seed", 1337),
            macro_width=data.get("macro_width", 4),
            macro_height=data.get("macro_height", 4),
            sector_width=data.get("sector_width", 54),
            sector_height=data.get("sector_height", 24),
            frequency=data.get("frequency", 0.035),
            noise_type=noise_type,
            fractal_type=fractal_type,
            octaves=data.get("octaves", 4),
            lacunarity=data.get("lacunarity", 2.0),
            gain=data.get("gain", 0.5),
            generate=False,
        )
        macro.starter_sector = tuple(data.get("starter_sector", [0, 0]))
        macro.starter_player_pos = tuple(data.get("starter_player_pos", [27, 12]))

        # Reconstruct sectors from compact dict
        macro.sectors = []
        for row_data in data.get("sectors", []):
            sec_row = []
            for sec_data in row_data:
                if "rows" in sec_data:
                    sec_map = Map.from_compact_dict(sec_data)
                else:
                    sec_map = Map.from_dict(sec_data)
                sec_row.append(sec_map)
            macro.sectors.append(sec_row)

        # Reconstruct POIs
        macro.all_pois = []
        macro.pois = {}
        for poi_data in data.get("pois", []):
            poi = POIDescriptor.from_dict(poi_data)
            macro.all_pois.append(poi)
            macro.pois[poi.name] = poi
            if poi.poi_type not in macro.pois:
                macro.pois[poi.poi_type] = poi

            # Stamp onto sector map
            sx, sy = poi.sector_coord
            if 0 <= sy < macro.macro_height and 0 <= sx < macro.macro_width:
                sec_map = macro.sectors[sy][sx]
                macro._stamp_poi_on_tile(sec_map, poi.local_pos, poi)

        # Check if sectors were loaded with authoritative exits
        has_authoritative_exits = any(
            "exits" in sec_data
            for row in data.get("sectors", [])
            for sec_data in row
            if isinstance(sec_data, dict)
        )
        if not has_authoritative_exits:
            # Re-calculate internal exits for all sectors (legacy fallback)
            for sy in range(macro.macro_height):
                for sx in range(macro.macro_width):
                    ProceduralMapGenerator._calculate_exits(macro.sectors[sy][sx])

            # Re-link exits across sector boundaries
            macro._link_sector_exits()

        return macro

