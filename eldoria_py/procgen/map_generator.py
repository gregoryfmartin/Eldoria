"""Procedural map generation for Eldoria integrating FastNoiseLite with Map and MapTile."""

from __future__ import annotations
import math
import random
from dataclasses import dataclass, field
from enum import Enum
from typing import Any, Dict, List, Optional, Tuple

from eldoria_py.procgen.noise import FastNoiseLite, NoiseType, FractalType
from eldoria_py.terminal.color import TrueColor, ColorLibrary
from eldoria_py.terminal.ansi import ATCoordinates, ATControlSequences


class BiomeType(str, Enum):
    DEEP_WATER = "DeepWater"
    WATER = "Water"
    COAST = "Coast"
    PLAINS = "Plains"
    FOREST = "Forest"
    MOUNTAIN = "Mountain"
    SNOW = "Snow"
    ROAD = "Road"
    BADLANDS = "Badlands"
    TUNDRA = "Tundra"
    SWAMP = "Swamp"


@dataclass
class BiomeConfig:
    name: str
    glyph: str
    fg_color: TrueColor
    bg_color: TrueColor
    walkable: bool
    battle_allowed: bool
    encounter_rate: float
    region_code: int


BIOME_CONFIGS: Dict[BiomeType, BiomeConfig] = {
    BiomeType.DEEP_WATER: BiomeConfig(
        name="Deep Water",
        glyph="~",
        fg_color=TrueColor(0x31, 0x82, 0xCE),  # light blue
        bg_color=TrueColor(0x0C, 0x1A, 0x30),  # deep navy
        walkable=False,
        battle_allowed=False,
        encounter_rate=0.0,
        region_code=0,
    ),
    BiomeType.WATER: BiomeConfig(
        name="Water",
        glyph="≈",
        fg_color=TrueColor(0x63, 0xB3, 0xED),  # azure
        bg_color=TrueColor(0x1A, 0x36, 0x5D),  # ocean blue
        walkable=False,
        battle_allowed=False,
        encounter_rate=0.0,
        region_code=0,
    ),
    BiomeType.COAST: BiomeConfig(
        name="Coast",
        glyph=".",
        fg_color=TrueColor(0xD6, 0x9E, 0x2E),  # sand gold
        bg_color=TrueColor(0x44, 0x3A, 0x1E),  # dark gold
        walkable=True,
        battle_allowed=True,
        encounter_rate=0.08,
        region_code=1,
    ),
    BiomeType.PLAINS: BiomeConfig(
        name="Plains",
        glyph=".",
        fg_color=TrueColor(0x68, 0xD3, 0x91),  # light green
        bg_color=TrueColor(0x1C, 0x3A, 0x27),  # dark field green
        walkable=True,
        battle_allowed=True,
        encounter_rate=0.10,
        region_code=1,
    ),
    BiomeType.FOREST: BiomeConfig(
        name="Forest",
        glyph="♣",
        fg_color=TrueColor(0x48, 0xBB, 0x78),  # emerald
        bg_color=TrueColor(0x13, 0x2F, 0x1B),  # deep forest
        walkable=True,
        battle_allowed=True,
        encounter_rate=0.16,
        region_code=2,
    ),
    BiomeType.MOUNTAIN: BiomeConfig(
        name="Mountain",
        glyph="▲",
        fg_color=TrueColor(0xA0, 0xAE, 0xC0),  # slate gray
        bg_color=TrueColor(0x2D, 0x37, 0x48),  # dark granite
        walkable=False,
        battle_allowed=False,
        encounter_rate=0.0,
        region_code=0,
    ),
    BiomeType.SNOW: BiomeConfig(
        name="Snow Peak",
        glyph="*",
        fg_color=TrueColor(0xFA, 0xFA, 0xFA),  # white
        bg_color=TrueColor(0x4A, 0x55, 0x68),  # cool slate
        walkable=False,
        battle_allowed=False,
        encounter_rate=0.0,
        region_code=0,
    ),
    BiomeType.ROAD: BiomeConfig(
        name="Cobblestone Road",
        glyph="#",
        fg_color=TrueColor(0xED, 0x89, 0x36),  # terra cotta
        bg_color=TrueColor(0x3B, 0x27, 0x1A),  # earth brown
        walkable=True,
        battle_allowed=True,
        encounter_rate=0.04,
        region_code=1,
    ),
    BiomeType.BADLANDS: BiomeConfig(
        name="Badlands",
        glyph="x",
        fg_color=TrueColor(0xD9, 0x77, 0x36),  # terracotta clay / rust
        bg_color=TrueColor(0x3E, 0x20, 0x14),  # dark arid russet
        walkable=True,
        battle_allowed=True,
        encounter_rate=0.16,  # Same as Forest
        region_code=2,
    ),
    BiomeType.TUNDRA: BiomeConfig(
        name="Tundra",
        glyph=",",
        fg_color=TrueColor(0xBA, 0xE6, 0xFD),  # glacial ice cyan
        bg_color=TrueColor(0x16, 0x4E, 0x63),  # arctic permafrost slate
        walkable=True,  # Walkable snow area
        battle_allowed=True,
        encounter_rate=0.10,  # Same as Plains
        region_code=1,
    ),
    BiomeType.SWAMP: BiomeConfig(
        name="Swamp",
        glyph="§",
        fg_color=TrueColor(0x84, 0xCC, 0x16),  # murky moss olive
        bg_color=TrueColor(0x1A, 0x2E, 0x16),  # stagnant mire green
        walkable=True,
        battle_allowed=True,
        encounter_rate=0.16,  # Same as Forest
        region_code=2,
    ),
}


class MapTile:
    """Represents a single square on an Eldoria map grid."""

    EXIT_NORTH = 0
    EXIT_SOUTH = 1
    EXIT_EAST = 2
    EXIT_WEST = 3

    def __init__(
        self,
        background_image: str = "Plains",
        biome: BiomeType = BiomeType.PLAINS,
        object_listing: Optional[List[str]] = None,
        exits: Optional[List[bool]] = None,
        battle_allowed: bool = False,
        encounter_rate: float = 0.5,
        region_code: int = 0,
        elevation: float = 0.0,
        moisture: float = 0.0,
        warp_target: Optional[Any] = None,
        poi: Optional[Any] = None,
        custom_glyph: Optional[str] = None,
        custom_fg: Optional[TrueColor] = None,
        custom_bg: Optional[TrueColor] = None,
        npc: Optional[Any] = None,
    ) -> None:
        self.background_image = background_image
        self.biome = biome
        self.object_listing: List[str] = list(object_listing) if object_listing else []
        self.exits: List[bool] = list(exits) if exits else [False, False, False, False]
        self.battle_allowed = battle_allowed
        self.encounter_rate = encounter_rate
        self.region_code = region_code
        self.elevation = elevation
        self.moisture = moisture
        self.warp_target = warp_target
        self.poi = poi
        self.custom_glyph = custom_glyph
        self.custom_fg = custom_fg
        self.custom_bg = custom_bg
        self.npc = npc

    @property
    def is_walkable(self) -> bool:
        config = BIOME_CONFIGS.get(self.biome)
        return config.walkable if config else False

    def to_dict(self) -> Dict[str, Any]:
        d: Dict[str, Any] = {
            "BackgroundImage": self.background_image,
            "Biome": self.biome.value,
            "ObjectListing": self.object_listing,
            "Exits": self.exits,
            "BattleAllowed": self.battle_allowed,
            "EncounterRate": self.encounter_rate,
            "RegionCode": self.region_code,
            "Elevation": round(self.elevation, 4),
            "Moisture": round(self.moisture, 4),
        }
        if self.custom_glyph:
            d["CustomGlyph"] = self.custom_glyph
        if self.custom_fg:
            d["CustomFG"] = [self.custom_fg.r, self.custom_fg.g, self.custom_fg.b]
        if self.custom_bg:
            d["CustomBG"] = [self.custom_bg.r, self.custom_bg.g, self.custom_bg.b]
        if self.warp_target and hasattr(self.warp_target, "to_dict"):
            d["WarpTarget"] = self.warp_target.to_dict()
        if self.npc and hasattr(self.npc, "to_dict"):
            d["NPC"] = self.npc.to_dict()
        return d

    @classmethod
    def from_dict(cls, data: Dict[str, Any]) -> MapTile:
        biome_str = data.get("Biome", data.get("BackgroundImage", "Plains"))
        try:
            biome = BiomeType(biome_str)
        except ValueError:
            biome = BiomeType.PLAINS
        custom_fg = TrueColor(*data["CustomFG"]) if "CustomFG" in data else None
        custom_bg = TrueColor(*data["CustomBG"]) if "CustomBG" in data else None
        warp_target = None
        if "WarpTarget" in data and data["WarpTarget"]:
            from .poi import WarpTarget
            warp_target = WarpTarget.from_dict(data["WarpTarget"])
        npc = None
        if "NPC" in data and data["NPC"]:
            from .npc import NPC
            npc = NPC.from_dict(data["NPC"])
        return cls(
            background_image=data.get("BackgroundImage", "Plains"),
            biome=biome,
            object_listing=data.get("ObjectListing", []),
            exits=data.get("Exits", [False, False, False, False]),
            battle_allowed=data.get("BattleAllowed", False),
            encounter_rate=data.get("EncounterRate", 0.5),
            region_code=data.get("RegionCode", 0),
            elevation=data.get("Elevation", 0.0),
            moisture=data.get("Moisture", 0.0),
            custom_glyph=data.get("CustomGlyph"),
            custom_fg=custom_fg,
            custom_bg=custom_bg,
            warp_target=warp_target,
            npc=npc,
        )


class Map:
    """Represents a full 2D grid map in Eldoria."""

    def __init__(
        self,
        name: str = "ProceduralMap",
        width: int = 54,
        height: int = 24,
        boundary_wrap: bool = False,
    ) -> None:
        self.name = name
        self.width = width
        self.height = height
        self.boundary_wrap = boundary_wrap
        self.tiles: List[List[MapTile]] = [
            [MapTile() for _ in range(width)] for _ in range(height)
        ]

    def get_tile(self, x: int, y: int) -> Optional[MapTile]:
        if 0 <= y < self.height and 0 <= x < self.width:
            return self.tiles[y][x]
        return None

    def set_tile(self, x: int, y: int, tile: MapTile) -> None:
        if 0 <= y < self.height and 0 <= x < self.width:
            self.tiles[y][x] = tile

    def to_dict(self) -> Dict[str, Any]:
        return {
            "MapName": self.name,
            "MapWidth": self.width,
            "MapHeight": self.height,
            "BoundaryWrap": self.boundary_wrap,
            "Tiles": [[tile.to_dict() for tile in row] for row in self.tiles],
        }

    @classmethod
    def from_dict(cls, data: Dict[str, Any]) -> Map:
        m = cls(
            name=data.get("MapName", "LoadedMap"),
            width=data.get("MapWidth", 0),
            height=data.get("MapHeight", 0),
            boundary_wrap=data.get("BoundaryWrap", data.get("BoundaryWarp", False)),
        )
        tiles_data = data.get("Tiles", [])
        m.tiles = [
            [MapTile.from_dict(tile_data) for tile_data in row]
            for row in tiles_data
        ]
        return m

    def to_compact_dict(self) -> Dict[str, Any]:
        """Compact serialization storing 2D rows of 1-char biome tokens, hex exit masks, and special overrides."""
        rows = []
        exit_rows = []
        specials = []
        for y in range(self.height):
            row_chars = []
            row_hex = []
            for x in range(self.width):
                tile = self.tiles[y][x]
                token = BIOME_TO_CHAR.get(tile.biome, ".")
                row_chars.append(token)

                # Encode 4-bit exit mask: N=1, S=2, E=4, W=8 -> hex char 0-f
                mask = (
                    (1 if tile.exits[MapTile.EXIT_NORTH] else 0)
                    | (2 if tile.exits[MapTile.EXIT_SOUTH] else 0)
                    | (4 if tile.exits[MapTile.EXIT_EAST] else 0)
                    | (8 if tile.exits[MapTile.EXIT_WEST] else 0)
                )
                row_hex.append(f"{mask:x}")

                # Check if tile has visual, battle, or asset overrides
                cfg = BIOME_CONFIGS.get(tile.biome)
                has_visual = (
                    tile.custom_glyph is not None
                    or tile.custom_fg is not None
                    or tile.custom_bg is not None
                    or bool(tile.object_listing)
                    or tile.warp_target is not None
                    or tile.npc is not None
                )
                has_battle = False
                has_bg_override = False
                if cfg:
                    if (
                        tile.battle_allowed != cfg.battle_allowed
                        or abs(tile.encounter_rate - cfg.encounter_rate) > 1e-4
                        or tile.region_code != cfg.region_code
                    ):
                        has_battle = True
                    expected_bg = cfg.name.replace(" ", "")
                    if tile.background_image and tile.background_image != expected_bg:
                        has_bg_override = True
                elif tile.battle_allowed or tile.region_code != 0:
                    has_battle = True

                if has_visual or has_battle or has_bg_override:
                    s_dict: Dict[str, Any] = {"x": x, "y": y}
                    if tile.custom_glyph:
                        s_dict["glyph"] = tile.custom_glyph
                    if tile.custom_fg:
                        s_dict["fg"] = [tile.custom_fg.r, tile.custom_fg.g, tile.custom_fg.b]
                    if tile.custom_bg:
                        s_dict["bg"] = [tile.custom_bg.r, tile.custom_bg.g, tile.custom_bg.b]
                    if tile.object_listing:
                        s_dict["obj"] = list(tile.object_listing)
                    if tile.warp_target and hasattr(tile.warp_target, "to_dict"):
                        s_dict["warp"] = tile.warp_target.to_dict()
                    if tile.npc and hasattr(tile.npc, "to_dict"):
                        s_dict["npc"] = tile.npc.to_dict()
                    if has_battle:
                        s_dict["battle_allowed"] = tile.battle_allowed
                        s_dict["encounter_rate"] = round(tile.encounter_rate, 4)
                        s_dict["region_code"] = tile.region_code
                    if has_bg_override:
                        s_dict["bg_img"] = tile.background_image
                    specials.append(s_dict)
            rows.append("".join(row_chars))
            exit_rows.append("".join(row_hex))

        return {
            "name": self.name,
            "width": self.width,
            "height": self.height,
            "boundary_wrap": self.boundary_wrap,
            "rows": rows,
            "exits": exit_rows,
            "specials": specials,
        }

    @classmethod
    def from_compact_dict(cls, data: Dict[str, Any]) -> Map:
        m = cls(
            name=data.get("name", "LoadedMap"),
            width=data.get("width", 54),
            height=data.get("height", 24),
            boundary_wrap=data.get("boundary_wrap", False),
        )
        rows = data.get("rows", [])
        for y, row_str in enumerate(rows):
            for x, char in enumerate(row_str):
                biome = CHAR_TO_BIOME.get(char, BiomeType.PLAINS)
                cfg = BIOME_CONFIGS.get(biome)
                m.tiles[y][x] = MapTile(
                    biome=biome,
                    background_image=cfg.name.replace(" ", "") if cfg else "Plains",
                    battle_allowed=cfg.battle_allowed if cfg else False,
                    encounter_rate=cfg.encounter_rate if cfg else 0.0,
                    region_code=cfg.region_code if cfg else 0,
                )

        specials = data.get("specials", [])
        for s in specials:
            x, y = s["x"], s["y"]
            if 0 <= y < m.height and 0 <= x < m.width:
                tile = m.tiles[y][x]
                if "glyph" in s:
                    tile.custom_glyph = s["glyph"]
                if "fg" in s:
                    tile.custom_fg = TrueColor(*s["fg"])
                if "bg" in s:
                    tile.custom_bg = TrueColor(*s["bg"])
                if "obj" in s:
                    tile.object_listing = list(s["obj"])
                if "warp" in s and s["warp"]:
                    from .poi import WarpTarget
                    tile.warp_target = WarpTarget.from_dict(s["warp"])
                if "npc" in s and s["npc"]:
                    from .npc import NPC
                    tile.npc = NPC.from_dict(s["npc"])
                if "battle_allowed" in s:
                    tile.battle_allowed = bool(s["battle_allowed"])
                if "encounter_rate" in s:
                    tile.encounter_rate = float(s["encounter_rate"])
                if "region_code" in s:
                    tile.region_code = int(s["region_code"])
                if "bg_img" in s:
                    tile.background_image = str(s["bg_img"])

        # Hydrate authoritative exits or fall back to calculation
        if "exits" in data:
            exit_rows = data["exits"]
            for y, row_hex in enumerate(exit_rows):
                if y < m.height:
                    for x, ch in enumerate(row_hex):
                        if x < m.width:
                            mask = int(ch, 16)
                            m.tiles[y][x].exits = [
                                bool(mask & 1),
                                bool(mask & 2),
                                bool(mask & 4),
                                bool(mask & 8),
                            ]
        else:
            # Legacy fallback: calculate exits based on walkability
            ProceduralMapGenerator._calculate_exits(m)

        return m


BIOME_TO_CHAR: Dict[BiomeType, str] = {
    BiomeType.DEEP_WATER: "~",
    BiomeType.WATER: "≈",
    BiomeType.COAST: "C",
    BiomeType.PLAINS: ".",
    BiomeType.FOREST: "♣",
    BiomeType.MOUNTAIN: "▲",
    BiomeType.SNOW: "*",
    BiomeType.ROAD: "#",
    BiomeType.BADLANDS: "B",
    BiomeType.TUNDRA: "T",
    BiomeType.SWAMP: "S",
}

CHAR_TO_BIOME: Dict[str, BiomeType] = {v: k for k, v in BIOME_TO_CHAR.items()}


class ProceduralMapGenerator:
    """Generates procedural RPG maps using FastNoiseLite and applies biome rules and road pathfinding."""

    def __init__(
        self,
        seed: int = 1337,
        frequency: float = 0.06,
        noise_type: NoiseType = NoiseType.OpenSimplex2,
        fractal_type: FractalType = FractalType.FBm,
        octaves: int = 4,
        lacunarity: float = 2.0,
        gain: float = 0.5,
    ) -> None:
        self.seed = seed
        self.frequency = frequency
        self.noise_type = noise_type
        self.fractal_type = fractal_type
        self.octaves = octaves
        self.lacunarity = lacunarity
        self.gain = gain

        # Primary elevation noise generator
        self.elev_noise = FastNoiseLite(seed=self.seed)
        self.elev_noise.noise_type = self.noise_type
        self.elev_noise.fractal_type = self.fractal_type
        self.elev_noise.fractal_octaves = self.octaves
        self.elev_noise.fractal_lacunarity = self.lacunarity
        self.elev_noise.fractal_gain = self.gain
        self.elev_noise.frequency = self.frequency

        # Secondary moisture noise generator
        self.moist_noise = FastNoiseLite(seed=self.seed + 1000)
        self.moist_noise.noise_type = NoiseType.Perlin
        self.moist_noise.fractal_type = FractalType.FBm
        self.moist_noise.fractal_octaves = 3
        self.moist_noise.frequency = self.frequency * 0.8

    def reseed(self, new_seed: int) -> None:
        self.seed = new_seed
        self.elev_noise.seed = new_seed
        self.moist_noise.seed = new_seed + 1000

    def generate_map(
        self,
        name: str = "ProceduralEldoria",
        width: int = 54,
        height: int = 24,
        create_road: bool = True,
        boundary_wrap: bool = False,
        offset_x: int = 0,
        offset_y: int = 0,
        total_world_width: Optional[int] = None,
        total_world_height: Optional[int] = None,
        badlands_side: Optional[str] = None,
    ) -> Map:
        """Generates a complete, interconnected Map with biomes, exits, and optional roads."""
        world_map = Map(name=name, width=width, height=height, boundary_wrap=boundary_wrap)

        world_w = total_world_width if total_world_width is not None else width
        world_h = total_world_height if total_world_height is not None else height
        b_side = badlands_side if badlands_side is not None else ("LEFT" if (self.seed % 2 == 0) else "RIGHT")

        # 1. Sample Elevation & Moisture to determine base biomes
        for y in range(height):
            for x in range(width):
                raw_e = self.elev_noise.get_noise_2d(float(offset_x + x), float(offset_y + y))
                raw_m = self.moist_noise.get_noise_2d(float(offset_x + x), float(offset_y + y))

                # Normalize from [-1.0, 1.0] to [0.0, 1.0]
                elevation = max(0.0, min(1.0, (raw_e + 1.0) * 0.5))
                moisture = max(0.0, min(1.0, (raw_m + 1.0) * 0.5))

                u = float(offset_x + x) / max(1.0, float(world_w - 1))
                v = float(offset_y + y) / max(1.0, float(world_h - 1))

                biome = self._classify_biome(
                    elevation=elevation,
                    moisture=moisture,
                    u=u,
                    v=v,
                    badlands_side=b_side,
                )
                config = BIOME_CONFIGS[biome]

                tile = MapTile(
                    background_image=config.name.replace(" ", ""),
                    biome=biome,
                    object_listing=self._generate_decorations(biome),
                    battle_allowed=config.battle_allowed,
                    encounter_rate=config.encounter_rate,
                    region_code=config.region_code,
                    elevation=elevation,
                    moisture=moisture,
                )
                world_map.set_tile(x, y, tile)

        # 2. Generate Road connecting West and East edges across walkable terrain
        if create_road:
            self._carve_road(world_map)

        # 3. Compute Cardinal Exits with strict reciprocity
        self._calculate_exits(world_map)

        return world_map

    @staticmethod
    def _classify_biome(
        elevation: float,
        moisture: float,
        u: float = 0.5,
        v: float = 0.5,
        badlands_side: str = "LEFT",
    ) -> BiomeType:
        if elevation < 0.28:
            return BiomeType.DEEP_WATER
        if elevation < 0.38:
            return BiomeType.WATER
        if elevation < 0.44:
            return BiomeType.COAST
        if elevation >= 0.85:
            return BiomeType.SNOW
        if elevation >= 0.70:
            return BiomeType.MOUNTAIN

        # Walkable land: 0.44 <= elevation < 0.70
        # Organic perturbation to avoid artificial laser-straight borders
        v_eff = v + (moisture - 0.5) * 0.12
        u_eff = u + (moisture - 0.5) * 0.12

        # 1. North portion: Tundra (walkable snow)
        if v_eff < 0.25:
            return BiomeType.TUNDRA

        # 2. South portion: Swamp (walkable bog/marsh)
        if v_eff > 0.75:
            return BiomeType.SWAMP

        # 3. Flank: Badlands (either extreme left or right, only one per map/world)
        side = badlands_side.upper()
        if side == "LEFT":
            if u_eff < 0.20 and 0.25 <= v_eff <= 0.75:
                return BiomeType.BADLANDS
        else:  # RIGHT
            if u_eff > 0.80 and 0.25 <= v_eff <= 0.75:
                return BiomeType.BADLANDS

        # 4. Core temperate zone: Forest vs Plains
        return BiomeType.FOREST if moisture > 0.48 else BiomeType.PLAINS

    @staticmethod
    def _generate_decorations(biome: BiomeType) -> List[str]:
        objs: List[str] = []
        if biome == BiomeType.FOREST:
            objs.append("MTOTree")
            if random.random() < 0.35:
                objs.append("MTOApple")
        elif biome == BiomeType.PLAINS:
            if random.random() < 0.20:
                objs.append("MTOTree")
            if random.random() < 0.15:
                objs.append("MTORock")
        elif biome == BiomeType.COAST:
            if random.random() < 0.20:
                objs.append("MTORock")
        elif biome == BiomeType.BADLANDS:
            if random.random() < 0.25:
                objs.append("MTORock")
        elif biome == BiomeType.TUNDRA:
            if random.random() < 0.15:
                objs.append("MTORock")
        elif biome == BiomeType.SWAMP:
            if random.random() < 0.20:
                objs.append("MTOTree")
            if random.random() < 0.15:
                objs.append("MTORock")
        return objs

    def _carve_road(self, world_map: Map) -> None:
        """Finds a walkable path from the left edge to the right edge and carves a cobblestone road."""
        w, h = world_map.width, world_map.height

        # Pick walkable start point on left edge (or closest walkable)
        starts = [y for y in range(h) if world_map.tiles[y][0].is_walkable]
        start_y = starts[len(starts) // 2] if starts else h // 2

        # Pick walkable end point on right edge
        ends = [y for y in range(h) if world_map.tiles[y][w - 1].is_walkable]
        end_y = ends[len(ends) // 2] if ends else h // 2

        # Simple greedy pathfinding / cost-based walk to connect the sides
        curr_x, curr_y = 0, start_y
        visited = set()

        road_tiles = []
        while curr_x < w - 1:
            road_tiles.append((curr_x, curr_y))
            visited.add((curr_x, curr_y))

            # Candidate next steps: East, North-East, South-East, North, South
            candidates = []
            for dx, dy in [(1, 0), (1, 1), (1, -1), (0, 1), (0, -1)]:
                nx, ny = curr_x + dx, curr_y + dy
                if 0 <= nx < w and 0 <= ny < h and (nx, ny) not in visited:
                    tile = world_map.tiles[ny][nx]
                    # Cost: water is very expensive, plains/forest low cost
                    base_cost = 1.0 if tile.is_walkable else 15.0
                    dist_to_end = math.hypot(nx - (w - 1), ny - end_y)
                    candidates.append((base_cost + dist_to_end * 1.5, nx, ny))

            if not candidates:
                break
            candidates.sort(key=lambda c: c[0])
            _, curr_x, curr_y = candidates[0]

        road_tiles.append((curr_x, curr_y))

        # Carve the road tiles
        road_cfg = BIOME_CONFIGS[BiomeType.ROAD]
        for rx, ry in road_tiles:
            tile = world_map.tiles[ry][rx]
            tile.biome = BiomeType.ROAD
            tile.background_image = "FieldRoad"
            tile.battle_allowed = road_cfg.battle_allowed
            tile.encounter_rate = road_cfg.encounter_rate
            tile.region_code = road_cfg.region_code

    @staticmethod
    def _calculate_exits(world_map: Map) -> None:
        """Calculates bidirectional cardinal exits for each tile based on walkability."""
        w, h = world_map.width, world_map.height

        for y in range(h):
            for x in range(w):
                curr_tile = world_map.tiles[y][x]
                if not curr_tile.is_walkable:
                    curr_tile.exits = [False, False, False, False]
                    continue

                # North
                exit_n = False
                if y > 0 and world_map.tiles[y - 1][x].is_walkable:
                    exit_n = True
                elif world_map.boundary_wrap and world_map.tiles[h - 1][x].is_walkable:
                    exit_n = True

                # South
                exit_s = False
                if y < h - 1 and world_map.tiles[y + 1][x].is_walkable:
                    exit_s = True
                elif world_map.boundary_wrap and world_map.tiles[0][x].is_walkable:
                    exit_s = True

                # East
                exit_e = False
                if x < w - 1 and world_map.tiles[y][x + 1].is_walkable:
                    exit_e = True
                elif world_map.boundary_wrap and world_map.tiles[y][0].is_walkable:
                    exit_e = True

                # West
                exit_w = False
                if x > 0 and world_map.tiles[y][x - 1].is_walkable:
                    exit_w = True
                elif world_map.boundary_wrap and world_map.tiles[y][w - 1].is_walkable:
                    exit_w = True

                curr_tile.exits = [exit_n, exit_s, exit_e, exit_w]

    @staticmethod
    def render_ansi(world_map: Map, cursor_pos: Optional[Tuple[int, int]] = None) -> List[str]:
        """Renders the map as a list of ANSI TrueColor formatted strings, one per row."""
        lines: List[str] = []
        for y, row in enumerate(world_map.tiles):
            row_chunks: List[str] = []
            for x, tile in enumerate(row):
                if cursor_pos and cursor_pos == (x, y):
                    # Player cursor glyph
                    row_chunks.append("\033[38;2;255;255;255m\033[48;2;220;38;38m@\033[0m")
                    continue

                if tile.poi is not None:
                    # Interactive POI landmark glyph
                    fg = tile.poi.fg_color.to_fg_ansi()
                    bg = tile.poi.bg_color.to_bg_ansi()
                    row_chunks.append(f"{fg}{bg}{tile.poi.glyph}\033[0m")
                    continue

                if tile.npc is not None:
                    # NPC glyph
                    fg = tile.npc.fg_color.to_fg_ansi()
                    bg = tile.npc.bg_color.to_bg_ansi()
                    row_chunks.append(f"{fg}{bg}{tile.npc.glyph}\033[0m")
                    continue

                if tile.custom_glyph is not None:
                    fg = tile.custom_fg.to_fg_ansi() if tile.custom_fg else "\033[38;2;255;255;255m"
                    bg = tile.custom_bg.to_bg_ansi() if tile.custom_bg else "\033[48;2;0;0;0m"
                    row_chunks.append(f"{fg}{bg}{tile.custom_glyph}\033[0m")
                    continue

                cfg = BIOME_CONFIGS.get(tile.biome, BIOME_CONFIGS[BiomeType.PLAINS])
                fg = cfg.fg_color.to_fg_ansi()
                bg = cfg.bg_color.to_bg_ansi()
                row_chunks.append(f"{fg}{bg}{cfg.glyph}\033[0m")
            lines.append("".join(row_chunks))
        return lines
