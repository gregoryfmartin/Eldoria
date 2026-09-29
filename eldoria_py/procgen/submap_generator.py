"""
Sub-Map procedural generators for Town, Cave, and Castle interiors.
"""

from __future__ import annotations
import random
from typing import List, Optional, Set, Tuple
from .map_generator import Map, MapTile, BiomeType, BIOME_CONFIGS
from .noise import FastNoiseLite, NoiseType, FractalType
from .npc import (
    NPCRole,
    NPC,
    create_king,
    create_service_owner,
    create_castle_npc,
    create_town_citizen,
    MONARCH_NAMES,
    KNIGHT_NAMES,
    SERVANT_NAMES,
    ADVISOR_NAMES,
    INNKEEPER_NAMES,
    ITEM_SHOP_NAMES,
    EQUIP_SHOP_NAMES,
    PUB_BARTENDER_NAMES,
    CITIZEN_NAMES,
)
from .poi import WarpTarget
from ..terminal.color import TrueColor


class SubMapGenerator:
    """Generates 54x24 sub-maps for Towns, Caves, and Castles with guaranteed egress points."""

    @staticmethod
    def generate_town(
        name: str = "Oakhaven Town",
        seed: int = 1337,
        region: int = 1,
        is_endgame: bool = False,
    ) -> Tuple[Map, Tuple[int, int]]:
        """
        Generates a 54x24 town with perimeter walls, cobblestone main streets,
        procedurally varied building blocks (Inn, Item Shop, Equip Shop, Pub),
        central town plaza/well, southern egress gate, service owners, and roaming NPCs.
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
        for x in range(2, w - 2):
            town_map.tiles[center_y - 1][x].biome = BiomeType.ROAD
            town_map.tiles[center_y][x].biome = BiomeType.ROAD

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

        # 5. Southern Egress Gate (Exit to Overworld)
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
        spawn_pos = (egress_x, egress_y - 1)

        # 6. Procedurally Sized & Placed Buildings in 4 Quadrants
        used_sizes: Set[Tuple[int, int]] = set()

        def pick_building_size() -> Tuple[int, int]:
            for _ in range(100):
                bw = rng.randint(11, 17)
                bh = rng.randint(6, 8)
                if (bw, bh) not in used_sizes:
                    used_sizes.add((bw, bh))
                    return bw, bh
            return rng.randint(11, 17), rng.randint(6, 8)

        building_rects: List[Tuple[int, int, int, int]] = []
        door_positions: List[Tuple[int, int]] = []
        door_fronts: List[Tuple[int, int]] = []

        def build_service_building(
            left: int,
            top: int,
            bw: int,
            bh: int,
            b_name: str,
            door_on_bottom: bool,
            role: NPCRole,
            owner_name: str,
        ) -> None:
            building_rects.append((left, top, bw, bh))
            for hy in range(top, top + bh):
                for hx in range(left, left + bw):
                    if hy == top or hy == top + bh - 1 or hx == left or hx == left + bw - 1:
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

            # Door opening facing central crossroad
            door_x = left + bw // 2
            door_y = top + bh - 1 if door_on_bottom else top
            door_positions.append((door_x, door_y))

            d_tile = MapTile(biome=BiomeType.ROAD, battle_allowed=False, encounter_rate=0.0, region_code=0)
            d_tile.custom_glyph = "⌂"
            d_tile.custom_fg = TrueColor(0xFF, 0xD7, 0x00)
            d_tile.custom_bg = TrueColor(0x3B, 0x27, 0x1A)
            d_tile.object_listing.append(b_name)
            town_map.set_tile(door_x, door_y, d_tile)

            # Walkway connecting door to road
            if door_on_bottom:
                door_fronts.append((door_x, door_y + 1))
                for cy in range(door_y + 1, center_y - 1):
                    town_map.tiles[cy][door_x].biome = BiomeType.ROAD
                ox, oy = door_x, top + 2
            else:
                door_fronts.append((door_x, door_y - 1))
                for cy in range(center_y + 1, door_y):
                    town_map.tiles[cy][door_x].biome = BiomeType.ROAD
                ox, oy = door_x, top + bh - 3

            owner = create_service_owner(
                role=role,
                name=owner_name,
                pos=(ox, oy),
                is_endgame=is_endgame,
            )
            town_map.tiles[oy][ox].npc = owner

        # NW Quadrant: Inn
        nw_w, nw_h = pick_building_size()
        nw_left = rng.randint(2, max(2, 23 - nw_w))
        nw_top = rng.randint(2, max(2, 10 - nw_h))
        build_service_building(
            left=nw_left,
            top=nw_top,
            bw=nw_w,
            bh=nw_h,
            b_name="MTOInn",
            door_on_bottom=True,
            role=NPCRole.INNKEEPER,
            owner_name=rng.choice(INNKEEPER_NAMES),
        )

        # NE Quadrant: Item Shop
        ne_w, ne_h = pick_building_size()
        ne_left = rng.randint(31, max(31, 51 - ne_w))
        ne_top = rng.randint(2, max(2, 10 - ne_h))
        build_service_building(
            left=ne_left,
            top=ne_top,
            bw=ne_w,
            bh=ne_h,
            b_name="MTOItemShop",
            door_on_bottom=True,
            role=NPCRole.ITEM_SHOPKEEPER,
            owner_name=rng.choice(ITEM_SHOP_NAMES),
        )

        # SW Quadrant: Equipment Shop
        sw_w, sw_h = pick_building_size()
        sw_left = rng.randint(2, max(2, 23 - sw_w))
        sw_top = rng.randint(14, max(14, 22 - sw_h))
        build_service_building(
            left=sw_left,
            top=sw_top,
            bw=sw_w,
            bh=sw_h,
            b_name="MTOEquipShop",
            door_on_bottom=False,
            role=NPCRole.EQUIP_SHOPKEEPER,
            owner_name=rng.choice(EQUIP_SHOP_NAMES),
        )

        # SE Quadrant: Pub
        se_w, se_h = pick_building_size()
        se_left = rng.randint(31, max(31, 51 - se_w))
        se_top = rng.randint(14, max(14, 22 - se_h))
        build_service_building(
            left=se_left,
            top=se_top,
            bw=se_w,
            bh=se_h,
            b_name="MTOPub",
            door_on_bottom=False,
            role=NPCRole.PUB_BARTENDER,
            owner_name=rng.choice(PUB_BARTENDER_NAMES),
        )

        # 7. General Town NPCs (10 to 20 roaming citizens)
        forbidden: Set[Tuple[int, int]] = set()
        for (l, t, bw, bh) in building_rects:
            for by in range(t, t + bh):
                for bx in range(l, l + bw):
                    forbidden.add((bx, by))
        for dp in door_positions:
            forbidden.add(dp)
        for df in door_fronts:
            forbidden.add(df)
        forbidden.add((egress_x, egress_y))
        forbidden.add(spawn_pos)
        forbidden.add((center_x, center_y))

        candidate_tiles: List[Tuple[int, int]] = []
        for y in range(1, h - 1):
            for x in range(1, w - 1):
                if (
                    (x, y) not in forbidden
                    and town_map.tiles[y][x].is_walkable
                    and town_map.tiles[y][x].npc is None
                ):
                    candidate_tiles.append((x, y))

        rng.shuffle(candidate_tiles)
        n_citizens = rng.randint(10, 20)
        for cx, cy in candidate_tiles[:n_citizens]:
            c_name = rng.choice(CITIZEN_NAMES)
            citizen = create_town_citizen(
                name=c_name,
                pos=(cx, cy),
                seed=rng.randint(1, 999999),
            )
            town_map.tiles[cy][cx].npc = citizen

        # Guarantee all town tiles are strictly safe zones
        for y in range(h):
            for x in range(w):
                t = town_map.tiles[y][x]
                t.battle_allowed = False
                t.encounter_rate = 0.0
                t.region_code = 0

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

        return town_map, spawn_pos

    @staticmethod
    def generate_cave(
        name: str = "Shadowfen Cavern",
        seed: int = 2024,
        floor_level: int = 0,
        base_region: int = 3,
        boss_name: Optional[str] = None,
    ) -> Tuple[Map, Tuple[int, int]]:
        """
        Generates a 54x24 underground cavern using FastNoiseLite Cellular / Simplex noise,
        with rock walls, open chambers, stalagmites, and an egress cave mouth.
        Floor depth scales danger tier:
          Floor 0: base_region
          Floors 1-2: base_region + 1
          Floors 3-4: base_region + 2
          Floors 5+: base_region + 3 (capped at 9)
        Returns (Map, spawn_pos).
        """
        w, h = 54, 24
        cave_map = Map(name=name, width=w, height=h)

        if floor_level <= 0:
            cave_region = max(1, min(9, base_region))
        elif floor_level in (1, 2):
            cave_region = min(9, base_region + 1)
        elif floor_level in (3, 4):
            cave_region = min(9, base_region + 2)
        else:
            cave_region = min(9, base_region + 3)

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
                        region_code=cave_region,
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
                        region_code=cave_region,
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

        # 5. Place Boss Altar / Encounter Tile if lowest floor of cave/dungeon
        if boss_name:
            boss_x = center_x
            boss_y = 3
            boss_tile = cave_map.tiles[boss_y][boss_x]
            boss_tile.custom_glyph = "Ω"
            boss_tile.custom_fg = TrueColor(0xFF, 0x45, 0x00)
            boss_tile.custom_bg = TrueColor(0x3D, 0x1A, 0x1A)
            boss_tile.object_listing.append(f"Boss:{boss_name}")
            boss_tile.battle_allowed = True
            boss_tile.region_code = cave_region

        spawn_pos = (egress_x, egress_y - 1)
        return cave_map, spawn_pos

    @staticmethod
    def generate_castle(
        name: str = "Highspire Castle",
        seed: int = 777,
        castle_idx: int = 0,
        bounties: Optional[List[str]] = None,
    ) -> Tuple[Map, Tuple[int, int]]:
        """
        Generates a 54x24 royal stone keep with fortified outer battlements,
        grand cobblestone courtyard, throne room with banners, southern portcullis egress,
        a King offering boss bounties, and exactly 15 royal castle NPCs.
        Returns (Map, spawn_pos).
        """
        w, h = 54, 24
        castle_map = Map(name=name, width=w, height=h)
        rng = random.Random(seed + 202 + castle_idx * 17)

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
        spawn_pos = (egress_x, egress_y - 1)

        # 6. King & Boss Bounties
        if bounties is None:
            if castle_idx == 0:
                bounties = ["Rattus", "Grumble", "Brigand"]
            else:
                bounties = ["Broodfang", "Craghorn", "Tideclaw"]

        king_name = MONARCH_NAMES[castle_idx % len(MONARCH_NAMES)]
        king = create_king(
            name=king_name,
            pos=(center_x, 4),
            bounties=bounties,
        )
        castle_map.tiles[4][center_x].npc = king

        # 7. Exactly 15 Castle NPCs (flanking guards, advisor, knights, servants, squires)
        # Station 5 fixed atmospheric NPCs:
        fixed_stations = [
            (center_x - 2, 4, NPCRole.ROYAL_GUARD, "Guard Vance"),
            (center_x + 2, 4, NPCRole.ROYAL_GUARD, "Guard Cole"),
            (center_x - 3, 5, NPCRole.COURT_ADVISOR, rng.choice(ADVISOR_NAMES)),
            (center_x - 2, 8, NPCRole.ROYAL_GUARD, "Sentry Roland"),
            (center_x + 2, 8, NPCRole.ROYAL_GUARD, "Sentry Percival"),
        ]
        forbidden_castle_coords: Set[Tuple[int, int]] = {
            (center_x, 3),  # Throne
            (center_x, 4),  # King
            (center_x, 5),  # In front of King
            (egress_x, egress_y),
            spawn_pos,
            (egress_x, egress_y - 2),
        }

        for fx, fy, f_role, f_name in fixed_stations:
            guard = create_castle_npc(role=f_role, name=f_name, pos=(fx, fy))
            castle_map.tiles[fy][fx].npc = guard
            forbidden_castle_coords.add((fx, fy))

        # Station remaining 10 NPCs: 4 Knights, 4 Servants, 2 Squires
        roaming_roles = (
            [(NPCRole.KNIGHT, rng.choice(KNIGHT_NAMES)) for _ in range(4)]
            + [(NPCRole.SERVANT, rng.choice(SERVANT_NAMES)) for _ in range(4)]
            + [(NPCRole.SQUIRE, rng.choice(SERVANT_NAMES)) for _ in range(2)]
        )

        castle_candidates: List[Tuple[int, int]] = []
        for y in range(2, h - 2):
            for x in range(2, w - 2):
                if (
                    (x, y) not in forbidden_castle_coords
                    and castle_map.tiles[y][x].is_walkable
                    and castle_map.tiles[y][x].npc is None
                ):
                    castle_candidates.append((x, y))

        rng.shuffle(castle_candidates)
        for (r_role, r_name), (rx, ry) in zip(roaming_roles, castle_candidates[:10]):
            c_npc = create_castle_npc(role=r_role, name=r_name, pos=(rx, ry))
            castle_map.tiles[ry][rx].npc = c_npc

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

        return castle_map, spawn_pos
