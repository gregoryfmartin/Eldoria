"""
Sub-Map procedural generators for Town, Cave, and Castle interiors.
"""

from __future__ import annotations
import random
from typing import Optional, Tuple
from .map_generator import Map, MapTile, BiomeType, BIOME_CONFIGS
from .noise import FastNoiseLite, NoiseType, FractalType
from .poi import WarpTarget
from ..terminal.color import TrueColor


class SubMapGenerator:
    """Generates 54x24 sub-maps for Towns, Caves, and Castles with guaranteed egress points."""

    @staticmethod
    def generate_town(name: str = "Oakhaven Town", seed: int = 1337) -> Tuple[Map, Tuple[int, int]]:
        """
        Generates a 54x24 town with perimeter walls, cobblestone main streets,
        building blocks, central town plaza/well, and a southern egress gate.
        Returns (Map, spawn_pos).
        """
        w, h = 54, 24
        town_map = Map(name=name, width=w, height=h)
        rng = random.Random(seed + 101)

        # 1. Fill base terrain with peaceful grass/plains
        for y in range(h):
            for x in range(w):
                tile = MapTile(biome=BiomeType.PLAINS)
                town_map.set_tile(x, y, tile)

        # 2. Outer boundary stone walls / tree hedge
        for x in range(w):
            town_map.set_tile(x, 0, MapTile(biome=BiomeType.FOREST))
            town_map.set_tile(x, h - 1, MapTile(biome=BiomeType.FOREST))
        for y in range(h):
            town_map.set_tile(0, y, MapTile(biome=BiomeType.FOREST))
            town_map.set_tile(w - 1, y, MapTile(biome=BiomeType.FOREST))

        # 3. Main Cobblestone Highway (North-South spine + East-West cross)
        center_x = w // 2  # 27
        center_y = h // 2  # 12
        for y in range(1, h - 1):
            town_map.tiles[y][center_x].biome = BiomeType.ROAD
            town_map.tiles[y][center_x + 1].biome = BiomeType.ROAD
        for x in range(6, w - 6):
            town_map.tiles[center_y][x].biome = BiomeType.ROAD
            town_map.tiles[center_y + 1][x].biome = BiomeType.ROAD

        # 4. Central Town Plaza & Fountain / Well
        for dy in range(-2, 3):
            for dx in range(-3, 4):
                town_map.tiles[center_y + dy][center_x + dx].biome = BiomeType.ROAD

        # Town Well at center
        well_tile = town_map.tiles[center_y][center_x]
        well_tile.custom_glyph = "O"
        well_tile.custom_fg = TrueColor(0x63, 0xB3, 0xED)  # Sky blue
        well_tile.custom_bg = TrueColor(0x2D, 0x37, 0x48)
        well_tile.object_listing.append("MTOWell")

        # 5. Build 4 Building Quadrants
        def build_house(left: int, top: int, width: int, height: int, b_name: str) -> None:
            for hy in range(top, top + height):
                for hx in range(left, left + width):
                    if hy == top or hy == top + height - 1 or hx == left or hx == left + width - 1:
                        # Wall
                        b_tile = MapTile(biome=BiomeType.MOUNTAIN, battle_allowed=False, encounter_rate=0.0, region_code=0)
                        b_tile.custom_glyph = "#"
                        b_tile.custom_fg = TrueColor(0xA0, 0xAE, 0xC0)
                        b_tile.custom_bg = TrueColor(0x2D, 0x37, 0x48)
                        town_map.set_tile(hx, hy, b_tile)
                    else:
                        # Interior floor
                        f_tile = MapTile(biome=BiomeType.ROAD, battle_allowed=False, encounter_rate=0.0, region_code=0)
                        f_tile.custom_glyph = "·"
                        f_tile.custom_fg = TrueColor(0xED, 0x89, 0x36)
                        f_tile.custom_bg = TrueColor(0x1A, 0x20, 0x2C)
                        town_map.set_tile(hx, hy, f_tile)
            # Door opening facing road
            door_x = left + width // 2
            door_y = top + height - 1
            d_tile = MapTile(biome=BiomeType.ROAD, battle_allowed=False, encounter_rate=0.0, region_code=0)
            d_tile.custom_glyph = "⌂"
            d_tile.custom_fg = TrueColor(0xFF, 0xD7, 0x00)
            d_tile.custom_bg = TrueColor(0x3B, 0x27, 0x1A)
            d_tile.object_listing.append(b_name)
            town_map.set_tile(door_x, door_y, d_tile)

        # North-West Inn
        build_house(6, 3, 16, 7, "MTOInn")
        # North-East Armory & Shop
        build_house(32, 3, 16, 7, "MTOBlacksmith")
        # South-West Town Hall
        build_house(6, 14, 16, 7, "MTOTownHall")
        # South-East Guild Hall
        build_house(32, 14, 16, 7, "MTOGuildHall")

        # Guarantee all town tiles are strictly safe zones
        for y in range(h):
            for x in range(w):
                t = town_map.tiles[y][x]
                t.battle_allowed = False
                t.encounter_rate = 0.0
                t.region_code = 0

        # 6. Southern Egress Gate (Exit to Overworld)
        egress_x = center_x
        egress_y = h - 1
        egress_tile = town_map.tiles[egress_y][egress_x]
        egress_tile.biome = BiomeType.ROAD
        egress_tile.custom_glyph = "▼"
        egress_tile.custom_fg = TrueColor(0xFF, 0xFF, 0x00)  # Bright Yellow
        egress_tile.custom_bg = TrueColor(0x3B, 0x27, 0x1A)
        egress_tile.warp_target = WarpTarget(
            target_map_name="OVERWORLD",
            is_egress=True,
            prompt_label="Overworld Gate",
        )

        # Recalculate walkable exits
        for y in range(h):
            for x in range(w):
                t = town_map.tiles[y][x]
                if t.is_walkable:
                    t.exits = [
                        y > 0 and town_map.tiles[y - 1][x].is_walkable,
                        y < h - 1 and town_map.tiles[y + 1][x].is_walkable,
                        x < w - 1 and town_map.tiles[y][x + 1].is_walkable,
                        x > 0 and town_map.tiles[y][x - 1].is_walkable,
                    ]

        spawn_pos = (egress_x, egress_y - 1)  # Walk right above gate
        return town_map, spawn_pos

    @staticmethod
    def generate_cave(name: str = "Shadowfen Cavern", seed: int = 2024) -> Tuple[Map, Tuple[int, int]]:
        """
        Generates a 54x24 underground cavern using FastNoiseLite Cellular / Simplex noise,
        with rock walls, open chambers, stalagmites, and an egress cave mouth.
        Returns (Map, spawn_pos).
        """
        w, h = 54, 24
        cave_map = Map(name=name, width=w, height=h)

        fnl = FastNoiseLite(seed=seed + 555)
        fnl.noise_type = NoiseType.Cellular
        fnl.frequency = 0.12
        fnl.fractal_octaves = 2

        # 1. Carve Cavern Floor & Walls based on Cellular noise threshold
        for y in range(h):
            for x in range(w):
                # Border ring is always solid impassable mountain
                if x == 0 or x == w - 1 or y == 0 or y == h - 1:
                    wall = MapTile(biome=BiomeType.MOUNTAIN)
                    wall.custom_glyph = "▲"
                    wall.custom_fg = TrueColor(0x4A, 0x55, 0x68)
                    wall.custom_bg = TrueColor(0x1A, 0x20, 0x2C)
                    cave_map.set_tile(x, y, wall)
                    continue

                noise_val = fnl.get_noise_2d(float(x), float(y))
                if noise_val < -0.05:
                    # Open cavern floor
                    floor_tile = MapTile(
                        biome=BiomeType.ROAD,
                        battle_allowed=True,
                        encounter_rate=0.20,
                        region_code=3,
                    )
                    floor_tile.custom_glyph = "·"
                    floor_tile.custom_fg = TrueColor(0x71, 0x80, 0x96)
                    floor_tile.custom_bg = TrueColor(0x17, 0x19, 0x23)
                    cave_map.set_tile(x, y, floor_tile)
                else:
                    # Solid rock wall
                    wall_tile = MapTile(
                        biome=BiomeType.MOUNTAIN,
                        battle_allowed=False,
                        encounter_rate=0.0,
                        region_code=0,
                    )
                    wall_tile.custom_glyph = "▲"
                    wall_tile.custom_fg = TrueColor(0x4A, 0x55, 0x68)
                    wall_tile.custom_bg = TrueColor(0x1A, 0x20, 0x2C)
                    cave_map.set_tile(x, y, wall_tile)

        # 2. Carve a central walking chamber ensuring a wide main path
        center_x = w // 2
        for y in range(2, h - 2):
            for dx in range(-2, 3):
                cx = center_x + dx
                if 1 <= cx < w - 1:
                    floor = MapTile(
                        biome=BiomeType.ROAD,
                        battle_allowed=True,
                        encounter_rate=0.20,
                        region_code=3,
                    )
                    floor.custom_glyph = "·"
                    floor.custom_fg = TrueColor(0x71, 0x80, 0x96)
                    floor.custom_bg = TrueColor(0x17, 0x19, 0x23)
                    cave_map.set_tile(cx, y, floor)

        # 3. Add decorative glowing mushrooms and stalagmites
        rng = random.Random(seed + 999)
        for y in range(2, h - 2):
            for x in range(2, w - 2):
                if cave_map.tiles[y][x].is_walkable:
                    r = rng.random()
                    if r < 0.04:
                        # Crystal / Stalagmite
                        c_tile = cave_map.tiles[y][x]
                        c_tile.custom_glyph = "*"
                        c_tile.custom_fg = TrueColor(0x90, 0xCD, 0xF4)  # Cyan crystal
                        c_tile.object_listing.append("MTOCrystal")
                    elif r < 0.08:
                        # Glowing Mushroom
                        m_tile = cave_map.tiles[y][x]
                        m_tile.custom_glyph = "♣"
                        m_tile.custom_fg = TrueColor(0x48, 0xBB, 0x78)  # Glowing green
                        m_tile.object_listing.append("MTOMushroom")

        # 4. Southern Cave Mouth Egress (Exit to Overworld)
        egress_x = center_x
        egress_y = h - 2
        egress_tile = cave_map.tiles[egress_y][egress_x]
        egress_tile.biome = BiomeType.ROAD
        egress_tile.custom_glyph = "∩"
        egress_tile.custom_fg = TrueColor(0xFF, 0xFF, 0x00)  # Yellow
        egress_tile.custom_bg = TrueColor(0x1A, 0x20, 0x2C)
        egress_tile.warp_target = WarpTarget(
            target_map_name="OVERWORLD",
            is_egress=True,
            prompt_label="Cavern Mouth Exit",
        )

        # Recalculate exits
        for y in range(h):
            for x in range(w):
                t = cave_map.tiles[y][x]
                if t.is_walkable:
                    t.exits = [
                        y > 0 and cave_map.tiles[y - 1][x].is_walkable,
                        y < h - 1 and cave_map.tiles[y + 1][x].is_walkable,
                        x < w - 1 and cave_map.tiles[y][x + 1].is_walkable,
                        x > 0 and cave_map.tiles[y][x - 1].is_walkable,
                    ]

        spawn_pos = (egress_x, egress_y - 1)
        return cave_map, spawn_pos

    @staticmethod
    def generate_castle(name: str = "Highspire Castle", seed: int = 777) -> Tuple[Map, Tuple[int, int]]:
        """
        Generates a 54x24 royal stone keep with fortified outer battlements,
        grand cobblestone courtyard, throne room with banners, and a southern portcullis egress.
        Returns (Map, spawn_pos).
        """
        w, h = 54, 24
        castle_map = Map(name=name, width=w, height=h)

        # 1. Fill base with stone flagstones
        for y in range(h):
            for x in range(w):
                tile = MapTile(biome=BiomeType.ROAD)
                tile.custom_glyph = " "
                tile.custom_bg = TrueColor(0x2D, 0x37, 0x48)  # Slate gray flagstone
                castle_map.set_tile(x, y, tile)

        # 2. Outer Stone Battlement Walls
        for x in range(w):
            for wall_y in (0, 1, h - 1):
                w_tile = MapTile(biome=BiomeType.MOUNTAIN)
                w_tile.custom_glyph = "#"
                w_tile.custom_fg = TrueColor(0x71, 0x80, 0x96)
                w_tile.custom_bg = TrueColor(0x1A, 0x20, 0x2C)
                castle_map.set_tile(x, wall_y, w_tile)
        for y in range(h):
            for wall_x in (0, 1, w - 2, w - 1):
                w_tile = MapTile(biome=BiomeType.MOUNTAIN)
                w_tile.custom_glyph = "#"
                w_tile.custom_fg = TrueColor(0x71, 0x80, 0x96)
                w_tile.custom_bg = TrueColor(0x1A, 0x20, 0x2C)
                castle_map.set_tile(wall_x, y, w_tile)

        # 3. North Wing: Royal Throne Room
        center_x = w // 2  # 27
        # Throne room walls at y=7
        for x in range(6, w - 6):
            if x not in (center_x - 1, center_x, center_x + 1):
                w_tile = MapTile(biome=BiomeType.MOUNTAIN)
                w_tile.custom_glyph = "#"
                w_tile.custom_fg = TrueColor(0xA0, 0xAE, 0xC0)
                w_tile.custom_bg = TrueColor(0x1A, 0x20, 0x2C)
                castle_map.set_tile(x, 7, w_tile)

        # Red Carpet running from throne (y=3) to courtyard (y=18)
        for y in range(3, 19):
            for dx in (-1, 0, 1):
                carpet_tile = castle_map.tiles[y][center_x + dx]
                carpet_tile.custom_glyph = "="
                carpet_tile.custom_fg = TrueColor(0xE5, 0x3E, 0x3E)  # Royal Red
                carpet_tile.custom_bg = TrueColor(0x74, 0x2A, 0x2A)  # Burgundy

        # Royal Throne at (center_x, 3)
        throne = castle_map.tiles[3][center_x]
        throne.custom_glyph = "C"
        throne.custom_fg = TrueColor(0xFF, 0xD7, 0x00)  # Gold
        throne.custom_bg = TrueColor(0x9B, 0x2C, 0x2C)  # Crimson
        throne.object_listing.append("MTOThrone")

        # Pillars in throne room
        for px in (center_x - 5, center_x + 5):
            for py in (4, 6):
                pillar = MapTile(biome=BiomeType.MOUNTAIN)
                pillar.custom_glyph = "O"
                pillar.custom_fg = TrueColor(0xFA, 0xFA, 0xFA)
                pillar.custom_bg = TrueColor(0x4A, 0x55, 0x68)
                castle_map.set_tile(px, py, pillar)

        # 4. Courtyard Guard Statues
        for sx in (center_x - 8, center_x + 8):
            for sy in (11, 15):
                statue = MapTile(biome=BiomeType.MOUNTAIN)
                statue.custom_glyph = "▲"
                statue.custom_fg = TrueColor(0x4A, 0x55, 0x68)
                statue.custom_bg = TrueColor(0x2D, 0x37, 0x48)
                castle_map.set_tile(sx, sy, statue)

        # 5. Southern Portcullis Egress Gate (Exit to Overworld)
        egress_x = center_x
        egress_y = h - 2
        egress_tile = castle_map.tiles[egress_y][egress_x]
        egress_tile.biome = BiomeType.ROAD
        egress_tile.custom_glyph = "▼"
        egress_tile.custom_fg = TrueColor(0xFF, 0xFF, 0x00)  # Bright Yellow
        egress_tile.custom_bg = TrueColor(0x1A, 0x20, 0x2C)
        egress_tile.warp_target = WarpTarget(
            target_map_name="OVERWORLD",
            is_egress=True,
            prompt_label="Castle Portcullis Gate",
        )

        # Guarantee all castle tiles are strictly safe zones
        for y in range(h):
            for x in range(w):
                t = castle_map.tiles[y][x]
                t.battle_allowed = False
                t.encounter_rate = 0.0
                t.region_code = 0

        # Recalculate exits
        for y in range(h):
            for x in range(w):
                t = castle_map.tiles[y][x]
                if t.is_walkable:
                    t.exits = [
                        y > 0 and castle_map.tiles[y - 1][x].is_walkable,
                        y < h - 1 and castle_map.tiles[y + 1][x].is_walkable,
                        x < w - 1 and castle_map.tiles[y][x + 1].is_walkable,
                        x > 0 and castle_map.tiles[y][x - 1].is_walkable,
                    ]

        spawn_pos = (egress_x, egress_y - 1)
        return castle_map, spawn_pos
