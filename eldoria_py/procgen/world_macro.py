"""
WorldMacroMap: 4x4 Macro World Map Grid architecture with continuous global coordinates,
algorithmic Point of Interest (Town, Castle, Cave) placement, and sub-map linking.
"""

from __future__ import annotations
import math
import random
from typing import Any, Callable, Dict, List, Optional, Tuple, Union

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
    "Silverbrook Crossing",
    "Galeshire Port",
    "Bramblewick Village",
    "Starfall Sanctum",
    "Aethelgard Haven",
    "Dawnspire Refuge",
    "Winterhold Outpost",
    "Verdant Glen",
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
    "Obsidian Pit",
    "Frostpeak Hollow",
    "Blighted Vault",
    "Nether Chasm",
    "Stormcrag Pit",
    "Brimstone Den",
    "Abyssal Sump",
    "Oblivion Citadel",
]


BOSS_CAVE_MAPPING: List[Tuple[str, int, str, List[str]]] = [
    # (boss_name, region, cave_name, preferred_biomes)
    ("Rattus", 1, "Shadowfen Cavern", ["Plains", "Road"]),
    ("Grumble", 1, "Duskfall Grotto", ["Forest"]),
    ("Brigand", 2, "Blackstone Deep", ["Plains", "Road"]),
    ("Fangclaw", 2, "Echoing Chasm", ["Forest"]),
    ("Broodfang", 3, "Whispering Depths", ["Cave", "Mountain"]),
    ("Craghorn", 3, "Dragon's Maw", ["Mountain"]),
    ("Tideclaw", 4, "Crystal Hollow", ["Coast"]),
    ("Ironhide", 4, "Grimrock Abyss", ["Plains", "Mountain"]),
    ("Venomtail", 5, "Obsidian Pit", ["Swamp", "Forest"]),
    ("Gargoyle", 5, "Frostpeak Hollow", ["Mountain"]),
    ("Frostfang", 6, "Blighted Vault", ["Tundra", "Snow"]),
    ("Magmadon", 6, "Brimstone Den", ["Badlands", "Cave", "Mountain"]),
    ("Stormlord", 7, "Stormcrag Pit", ["Mountain"]),
    ("Deathclaw", 7, "Nether Chasm", ["Cave"]),
    ("Archdemon", 8, "Abyssal Sump", ["Cave", "Citadel"]),
    ("Malakor", 9, "Oblivion Citadel", ["Citadel", "Cave"]),
]


def calculate_concentric_region_code(
    gx: int,
    gy: int,
    spawn_gx: int,
    spawn_gy: int,
    aspect_ratio: float = 2.0,
    max_region: int = 9,
    scale: float = 1.0,
) -> int:
    """Calculates non-equidistant concentric distance ring (1 to max_region) from spawn position.
    Compensates for terminal character aspect ratio (2:1 vertical).
    Bands:
    R1: 0 <= D < 18 (delta = 18) - Starter buffer
    R2: 18 <= D < 32 (delta = 14) - Outskirts
    R3: 32 <= D < 56 (delta = 24) - Midlands
    R4: 56 <= D < 76 (delta = 20) - Frontier
    R5: 76 <= D < 94 (delta = 18) - Wilds
    R6: 94 <= D < 114 (delta = 20) - Highlands
    R7: 114 <= D < 138 (delta = 24) - Hazard Wastes
    R8: 138 <= D < 160 (delta = 22) - Shadow Lands
    R9: D >= 160 - Periphery Citadel
    """
    dx = float(gx - spawn_gx)
    dy = float(gy - spawn_gy) * aspect_ratio
    d = math.hypot(dx, dy) / max(0.1, scale)

    if d < 18.0:
        raw = 1
    elif d < 32.0:
        raw = 2
    elif d < 56.0:
        raw = 3
    elif d < 76.0:
        raw = 4
    elif d < 94.0:
        raw = 5
    elif d < 114.0:
        raw = 6
    elif d < 138.0:
        raw = 7
    elif d < 160.0:
        raw = 8
    else:
        raw = 9
    return min(max_region, raw)


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
        max_region: Optional[int] = None,
        generate: bool = True,
        progress_callback: Optional[Callable[[float], None]] = None,
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

        total_sectors = self.macro_width * self.macro_height
        if max_region is not None:
            self.max_region = max_region
        elif total_sectors <= 16:
            self.max_region = 3
        elif total_sectors <= 36:
            self.max_region = 6
        else:
            self.max_region = 9

        if max(self.macro_width, self.macro_height) <= 6:
            self.region_scale = 1.0
        else:
            self.region_scale = max(1.0, max(self.macro_width, self.macro_height) / 4.5)

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
            self.generate(progress_callback=progress_callback)

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

    def reseed(self, new_seed: int, progress_callback: Optional[Callable[[float], None]] = None) -> None:
        """Regenerates the entire macro world with a new seed."""
        self.seed = new_seed
        self.generator.reseed(new_seed)
        self.generate(progress_callback=progress_callback)

    def generate(self, progress_callback: Optional[Callable[[float], None]] = None) -> None:
        """Generates all sectors, places POIs in distinct sectors, and links exits."""
        # 1. Generate sectors with continuous global coordinates
        self.sectors = []
        total_sectors = self.macro_width * self.macro_height
        total_world_width = self.macro_width * self.sector_width
        total_world_height = self.macro_height * self.sector_height
        badlands_side = "LEFT" if (self.seed % 2 == 0) else "RIGHT"

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
                    total_world_width=total_world_width,
                    total_world_height=total_world_height,
                    badlands_side=badlands_side,
                )
                row.append(sec_map)
                if progress_callback:
                    sec_idx = sy * self.macro_width + sx + 1
                    progress_callback(0.85 * (sec_idx / max(1, total_sectors)))
            self.sectors.append(row)

        # 2. Algorithmic POI Selection & Placement
        self._place_pois()
        if progress_callback:
            progress_callback(0.88)

        # 3. Carve Overworld Road through Town Sector
        self._carve_town_road()
        if progress_callback:
            progress_callback(0.91)

        # 4. Re-calculate internal exits for any modified sectors
        for sy in range(self.macro_height):
            for sx in range(self.macro_width):
                ProceduralMapGenerator._calculate_exits(self.sectors[sy][sx])

        # 5. Link Inter-Sector Exits across boundaries with strict reciprocity
        self._link_sector_exits()
        if progress_callback:
            progress_callback(0.93)

        # 6. Assign non-equidistant concentric danger regions (1-9) radiating from starter town
        self._assign_concentric_regions()
        if progress_callback:
            progress_callback(0.95)

    def _assign_concentric_regions(self) -> None:
        """Assigns non-equidistant concentric danger regions (1-max_region) radiating from starter town."""
        spawn_gx = self.starter_sector[0] * self.sector_width + self.starter_player_pos[0]
        spawn_gy = self.starter_sector[1] * self.sector_height + self.starter_player_pos[1]

        for sy in range(self.macro_height):
            for sx in range(self.macro_width):
                sec = self.sectors[sy][sx]
                for y in range(self.sector_height):
                    for x in range(self.sector_width):
                        tile = sec.tiles[y][x]
                        # Safe zones (towns/castles) and non-battle tiles remain 0; cave POIs preserve their danger region
                        if tile.poi is not None:
                            if tile.poi.poi_type != POIType.CAVE:
                                tile.region_code = 0
                            elif tile.region_code == 0:
                                gx = sx * self.sector_width + x
                                gy = sy * self.sector_height + y
                                tile.region_code = calculate_concentric_region_code(
                                    gx, gy, spawn_gx, spawn_gy, max_region=self.max_region, scale=self.region_scale
                                )
                        elif not tile.battle_allowed or tile.encounter_rate <= 0.0:
                            tile.region_code = 0
                        else:
                            gx = sx * self.sector_width + x
                            gy = sy * self.sector_height + y
                            tile.region_code = calculate_concentric_region_code(
                                gx, gy, spawn_gx, spawn_gy, max_region=self.max_region, scale=self.region_scale
                            )

    def _place_pois(self) -> None:
        """Selects distinct sectors and places Town, Castle, and Cave POIs based on map size and regional tiers."""
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
                    + counts[BiomeType.BADLANDS]
                    + counts[BiomeType.TUNDRA]
                    + counts[BiomeType.SWAMP]
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
            n_caves = 3
            n_towns = max(1, n_caves - 2)  # 1 town
            n_castles = 1
        elif total_sectors <= 36:
            n_caves = 11
            n_towns = n_caves - 3          # 8 towns
            n_castles = 2
        else:
            n_caves = 16
            n_towns = n_caves - 3          # 13 towns
            n_castles = 2

        # -------------------------------------------------------------
        # 1. Place Starter Town and Establish Concentric Regions
        # -------------------------------------------------------------
        town_candidates = sorted(
            [s for s in sector_stats if s["walkable"] >= 40],
            key=lambda s: s["plains"] * 2.0 + s["forest"] - s["water"] * 1.5,
            reverse=True,
        )

        # Seeded RNG dedicated to POI placement to preserve determinism
        poi_rng = random.Random(self.seed + 101)

        pool_size = min(5, len(town_candidates))
        starter_pool = town_candidates[:pool_size] if town_candidates else sector_stats[:pool_size]
        weights = [max(1.0, s["plains"] * 2.0 + s["forest"] - s["water"] * 1.5) for s in starter_pool]

        chosen_starter = poi_rng.choices(starter_pool, weights=weights, k=1)[0]
        starter_coord = chosen_starter["coord"]
        town_sectors = [starter_coord]
        used_sectors.add(starter_coord)
        self.starter_sector = starter_coord

        starter_map = self.sectors[starter_coord[1]][starter_coord[0]]
        town_pos = self._find_best_open_pos(starter_map)
        cand_x = min(self.sector_width - 1, town_pos[0] + 1)
        if starter_map.tiles[town_pos[1]][cand_x].is_walkable:
            self.starter_player_pos = (cand_x, town_pos[1])
        else:
            self.starter_player_pos = town_pos

        # Assign concentric regions immediately once starter position is anchored
        self._assign_concentric_regions()

        def get_sector_region(coord: Tuple[int, int]) -> int:
            center_gx = coord[0] * self.sector_width + self.sector_width // 2
            center_gy = coord[1] * self.sector_height + self.sector_height // 2
            spawn_gx = self.starter_sector[0] * self.sector_width + self.starter_player_pos[0]
            spawn_gy = self.starter_sector[1] * self.sector_height + self.starter_player_pos[1]
            return calculate_concentric_region_code(
                center_gx, center_gy, spawn_gx, spawn_gy, max_region=self.max_region, scale=self.region_scale
            )

        # Place Starter Town POI
        starter_name = TOWN_NAMES[0]
        starter_submap, starter_spawn = SubMapGenerator.generate_town(
            name=starter_name,
            seed=self.seed,
            region=1,
            is_endgame=False,
        )
        starter_poi = POIDescriptor.create_town(
            name=starter_name,
            sector_coord=starter_coord,
            local_pos=town_pos,
            spawn_pos=starter_spawn,
        )
        starter_poi.sub_map = starter_submap
        self._stamp_poi_on_tile(starter_map, town_pos, starter_poi)
        self.all_pois.append(starter_poi)
        self.pois[starter_name] = starter_poi
        self.pois[POIType.TOWN] = starter_poi

        # -------------------------------------------------------------
        # 2. Place Remaining Towns (Strictly Region <= 7, Varied Layouts)
        # -------------------------------------------------------------
        endgame_town_coord: Optional[Tuple[int, int]] = None

        if n_towns > 1:
            # If map spans Region 7, designate exactly 1 End-Game Town in Region 7
            if self.max_region >= 7:
                eg_candidates = [
                    s for s in sector_stats
                    if s["coord"] not in used_sectors
                    and get_sector_region(s["coord"]) == 7
                    and s["walkable"] >= 30
                ]
                eg_candidates.sort(
                    key=lambda s: s["plains"] * 2.0 + s["forest"] - s["water"] * 1.5,
                    reverse=True,
                )
                if eg_candidates:
                    eg_coord = eg_candidates[0]["coord"]
                    endgame_town_coord = eg_coord
                    town_sectors.append(eg_coord)
                    used_sectors.add(eg_coord)

            # Fill remaining towns in Regions 1 to min(7, max_region)
            max_town_reg = min(7, self.max_region)
            remaining_cands = [
                s for s in sector_stats
                if s["coord"] not in used_sectors
                and 1 <= get_sector_region(s["coord"]) <= max_town_reg
                and s["walkable"] >= 30
            ]
            remaining_cands.sort(
                key=lambda s: s["plains"] * 2.0 + s["forest"] - s["water"] * 1.5,
                reverse=True,
            )

            # First pass: enforce inter-town spacing >= 2 where available
            for cand in remaining_cands:
                if len(town_sectors) >= n_towns:
                    break
                coord = cand["coord"]
                if coord not in used_sectors:
                    min_dist = min(abs(coord[0] - tc[0]) + abs(coord[1] - tc[1]) for tc in town_sectors)
                    if min_dist < 2 and len(remaining_cands) > len(town_sectors) + 2:
                        continue
                    town_sectors.append(coord)
                    used_sectors.add(coord)

            # Second pass: relax spacing if needed to satisfy quota
            if len(town_sectors) < n_towns:
                for cand in remaining_cands:
                    if len(town_sectors) >= n_towns:
                        break
                    coord = cand["coord"]
                    if coord not in used_sectors:
                        town_sectors.append(coord)
                        used_sectors.add(coord)

            # Ultimate fallback if sector count is constrained
            while len(town_sectors) < n_towns:
                avail = [
                    s["coord"] for s in sector_stats
                    if s["coord"] not in used_sectors and get_sector_region(s["coord"]) <= max_town_reg
                ]
                if not avail:
                    break
                pick = avail[0]
                town_sectors.append(pick)
                used_sectors.add(pick)

            # Instantiate and stamp all remaining towns
            for idx in range(1, len(town_sectors)):
                coord = town_sectors[idx]
                name = TOWN_NAMES[idx] if idx < len(TOWN_NAMES) else f"Settlement {idx + 1}"
                town_map = self.sectors[coord[1]][coord[0]]
                town_pos = self._find_best_open_pos(town_map)
                reg = get_sector_region(coord)
                is_eg = (coord == endgame_town_coord)
                town_submap, town_spawn = SubMapGenerator.generate_town(
                    name=name,
                    seed=self.seed + idx * 37,
                    region=reg,
                    is_endgame=is_eg,
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

        # -------------------------------------------------------------
        # 3. Place Castles (1 for <=16 sectors, 2 for other sizes; Region <= 7)
        # -------------------------------------------------------------
        max_castle_reg = min(7, self.max_region)
        castle_candidates = [
            s for s in sector_stats
            if s["coord"] not in used_sectors
            and 1 <= get_sector_region(s["coord"]) <= max_castle_reg
            and s["walkable"] >= 30
        ]
        castle_candidates.sort(
            key=lambda s: s["plains"] * 1.5 + s["forest"] * 0.8 - s["water"],
            reverse=True,
        )

        castle_sectors = []
        for cand in castle_candidates:
            if len(castle_sectors) >= n_castles:
                break
            coord = cand["coord"]
            if coord not in used_sectors:
                if total_sectors > 16 and used_sectors:
                    min_dist = min(abs(coord[0] - tc[0]) + abs(coord[1] - tc[1]) for tc in used_sectors)
                    if min_dist < 2 and len(castle_candidates) > len(castle_sectors) + 2:
                        continue
                castle_sectors.append(coord)
                used_sectors.add(coord)

        while len(castle_sectors) < n_castles:
            avail = [
                s["coord"] for s in sector_stats
                if s["coord"] not in used_sectors and get_sector_region(s["coord"]) <= max_castle_reg
            ]
            if not avail:
                break
            pick = avail[0]
            castle_sectors.append(pick)
            used_sectors.add(pick)

        for idx, coord in enumerate(castle_sectors):
            name = CASTLE_NAMES[idx] if idx < len(CASTLE_NAMES) else f"Fortress {idx + 1}"
            castle_map = self.sectors[coord[1]][coord[0]]
            castle_pos = self._find_best_open_pos(castle_map)

            # Configure boss bounties tailored to castle tier
            if idx == 0:
                if self.max_region == 3:
                    bounties = ["Rattus", "Brigand", "Broodfang"]
                else:
                    bounties = ["Rattus", "Grumble", "Brigand"]
            else:
                bounties = ["Broodfang", "Craghorn", "Tideclaw", "Ironhide"]

            castle_submap, castle_spawn = SubMapGenerator.generate_castle(
                name=name,
                seed=self.seed + idx * 43,
                castle_idx=idx,
                bounties=bounties,
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
        # 4. Place Cave POIs for Requisite Bosses in Matching Regions
        # -------------------------------------------------------------
        if self.max_region == 3:
            # 4x4 (Classic / Prologue): Capped at Region 3 (3 bosses - 1 per region)
            active_bosses = [b for b in BOSS_CAVE_MAPPING if b[0] in ("Rattus", "Brigand", "Broodfang")]
        elif self.max_region == 6:
            # 6x6 (Quick Campaign): Capped at Region 6 (11 bosses)
            active_bosses = [b for b in BOSS_CAVE_MAPPING if b[1] <= 6 and b[0] != "Magmadon"]
        else:
            # 12x12 & 20x20 (Standard & Odyssey): Full campaign (all 16 bosses culminating in Malakor)
            active_bosses = BOSS_CAVE_MAPPING

        mountain_biomes = (BiomeType.MOUNTAIN, BiomeType.SNOW)
        water_biomes = (BiomeType.WATER, BiomeType.DEEP_WATER)

        for idx, (boss_name, boss_reg, cave_name, preferred_biomes) in enumerate(active_bosses):
            candidates = []
            avail_sectors = [
                (sx, sy)
                for sy in range(self.macro_height)
                for sx in range(self.macro_width)
                if (sx, sy) not in used_sectors
            ]

            # Item 1: Sector-level pre-filtering by danger region
            matching_sectors = [
                s for s in avail_sectors
                if abs(get_sector_region(s) - boss_reg) <= 1
            ]
            primary_targets = matching_sectors if matching_sectors else avail_sectors
            target_sectors = primary_targets if primary_targets else [
                (sx, sy)
                for sy in range(self.macro_height)
                for sx in range(self.macro_width)
            ]

            # Item 2: Pre-extract POI world coordinates once per boss placement
            poi_coords = [
                (p.sector_coord[0] * self.sector_width + p.local_pos[0],
                 p.sector_coord[1] * self.sector_height + p.local_pos[1])
                for p in self.all_pois
            ]
            needs_coast = "Coast" in preferred_biomes
            needs_mountain_or_cave = "Mountain" in preferred_biomes or "Cave" in preferred_biomes

            for search_pass in (1, 2):
                for (sx, sy) in target_sectors:
                    sec = self.sectors[sy][sx]
                    sec_tiles = sec.tiles
                    is_used_sec = (sx, sy) in used_sectors
                    sec_bonus = 0.0 if is_used_sec else 1000.0

                    for y in range(1, self.sector_height - 1):
                        row = sec_tiles[y]
                        row_up = sec_tiles[y - 1]
                        row_dn = sec_tiles[y + 1]

                        for x in range(1, self.sector_width - 1):
                            t = row[x]
                            if not t.is_walkable or t.poi is not None:
                                continue

                            gx = sx * self.sector_width + x
                            gy = sy * self.sector_height + y

                            # Early-exit buffer check on squared distance (8.0^2 = 64.0)
                            too_close = False
                            min_sq = 1e9
                            for px, py in poi_coords:
                                dx = float(gx - px)
                                dy = float(gy - py) * 2.0
                                dsq = dx * dx + dy * dy
                                if dsq < 64.0:
                                    too_close = True
                                    break
                                if dsq < min_sq:
                                    min_sq = dsq

                            if too_close:
                                continue

                            min_poi_dist = math.sqrt(min_sq)

                            # Unrolled 4-way adjacent mountain/snow border check
                            borders_mountain = (
                                row_up[x].biome in mountain_biomes
                                or row_dn[x].biome in mountain_biomes
                                or row[x - 1].biome in mountain_biomes
                                or row[x + 1].biome in mountain_biomes
                            )

                            b_score = 0.0
                            tb = t.biome
                            if tb == BiomeType.FOREST and "Forest" in preferred_biomes:
                                b_score += 50.0
                            if tb == BiomeType.PLAINS and "Plains" in preferred_biomes:
                                b_score += 40.0
                            if borders_mountain and needs_mountain_or_cave:
                                b_score += 60.0
                            if tb == BiomeType.SNOW and "Snow" in preferred_biomes:
                                b_score += 80.0
                            if needs_coast and (
                                tb == BiomeType.COAST
                                or row_up[x].biome in water_biomes
                                or row_dn[x].biome in water_biomes
                                or row[x - 1].biome in water_biomes
                                or row[x + 1].biome in water_biomes
                            ):
                                b_score += 70.0
                            if tb == BiomeType.BADLANDS and "Badlands" in preferred_biomes:
                                b_score += 60.0
                            if tb == BiomeType.TUNDRA and ("Tundra" in preferred_biomes or "Snow" in preferred_biomes):
                                b_score += 75.0
                            if tb == BiomeType.SWAMP and ("Swamp" in preferred_biomes or "Forest" in preferred_biomes):
                                b_score += 65.0

                            reg_diff = abs(t.region_code - boss_reg) if t.region_code > 0 else 5
                            score = sec_bonus - reg_diff * 100.0 + b_score + min_poi_dist * 0.1
                            candidates.append((score, (sx, sy), (x, y), borders_mountain))

                if candidates or target_sectors is avail_sectors:
                    break
                # Fallback to all available sectors if region-filtered search yielded no candidate
                target_sectors = avail_sectors if avail_sectors else [
                    (sx, sy)
                    for sy in range(self.macro_height)
                    for sx in range(self.macro_width)
                ]


            if candidates:
                candidates.sort(key=lambda c: c[0], reverse=True)
                _, best_coord, cave_pos, borders_mountain = candidates[0]
                sec_map = self.sectors[best_coord[1]][best_coord[0]]
                if not borders_mountain and cave_pos[1] > 0:
                    bx, by = cave_pos
                    m_tile = MapTile(biome=BiomeType.MOUNTAIN)
                    m_tile.background_image = "Mountain"
                    sec_map.set_tile(bx, by - 1, m_tile)
            else:
                avail = [s["coord"] for s in sector_stats if s["coord"] not in used_sectors]
                best_coord = avail[0] if avail else (0, 0)
                sec_map = self.sectors[best_coord[1]][best_coord[0]]
                cave_pos = self._find_cave_mouth_pos(sec_map, target_region=boss_reg)

            used_sectors.add(best_coord)

            cave_submap, cave_spawn = SubMapGenerator.generate_cave(
                name=cave_name,
                seed=self.seed + idx * 53,
                floor_level=0,
                base_region=boss_reg,
                boss_name=boss_name,
            )
            cave_poi = POIDescriptor.create_cave(
                name=cave_name,
                sector_coord=best_coord,
                local_pos=cave_pos,
                spawn_pos=cave_spawn,
                description=f"A dark underground cavern harboring the dread threat of {boss_name}.",
            )
            cave_poi.sub_map = cave_submap
            self._stamp_poi_on_tile(sec_map, cave_pos, cave_poi)
            sec_map.tiles[cave_pos[1]][cave_pos[0]].region_code = boss_reg

            self.all_pois.append(cave_poi)
            self.pois[cave_name] = cave_poi
            if POIType.CAVE not in self.pois:
                self.pois[POIType.CAVE] = cave_poi
            used_sectors.add(best_coord)

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

    def _find_cave_mouth_pos(
        self,
        sector_map: Map,
        target_region: Optional[int] = None,
        min_dist_from_pois: int = 6,
    ) -> Tuple[int, int]:
        """
        Finds a walkable tile directly adjacent to a Mountain tile,
        representing a cave mouth at the cliff base.
        Prioritizes tiles matching target_region and maintaining separation from other POIs.
        """
        center_x = self.sector_width // 2
        center_y = self.sector_height // 2

        existing_poi_pos = [
            (x, y)
            for y in range(self.sector_height)
            for x in range(self.sector_width)
            if sector_map.tiles[y][x].poi is not None
        ]

        candidates = []
        for y in range(1, self.sector_height - 1):
            for x in range(1, self.sector_width - 1):
                tile = sector_map.tiles[y][x]
                if not tile.is_walkable or tile.poi is not None:
                    continue

                if existing_poi_pos:
                    dist_to_poi = min(math.hypot(x - px, y - py) for px, py in existing_poi_pos)
                    if dist_to_poi < min_dist_from_pois:
                        continue

                borders_mountain = any(
                    sector_map.tiles[y + dy][x + dx].biome in (BiomeType.MOUNTAIN, BiomeType.SNOW)
                    for dx, dy in ((0, 1), (0, -1), (1, 0), (-1, 0))
                )

                reg_diff = abs(tile.region_code - target_region) if target_region and tile.region_code > 0 else 0
                dist_to_center = math.hypot(x - center_x, y - center_y)

                score = (0 if borders_mountain else 100) + reg_diff * 25 + dist_to_center
                candidates.append((score, (x, y), borders_mountain))

        if candidates:
            candidates.sort(key=lambda c: c[0])
            best_pos = candidates[0][1]
            if not candidates[0][2]:
                bx, by = best_pos
                if by > 0:
                    m_tile = MapTile(biome=BiomeType.MOUNTAIN)
                    m_tile.background_image = "Mountain"
                    sector_map.set_tile(bx, by - 1, m_tile)
            return best_pos

        pos = self._find_best_open_pos(sector_map)
        px, py = pos
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
            "max_region": self.max_region,
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
            max_region=data.get("max_region", None),
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

