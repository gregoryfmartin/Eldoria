"""
Point of Interest (POI) and WarpTarget definitions for Eldoria.
"""

from __future__ import annotations
from dataclasses import dataclass, field
from enum import Enum
import math
from typing import Any, List, Optional, Tuple
from ..terminal.color import TrueColor


class POIType(str, Enum):
    TOWN = "Town"
    CASTLE = "Castle"
    CAVE = "Cave"


@dataclass
class WarpTarget:
    """Represents a warp destination between Overworld sectors and Sub-Maps."""

    target_map_name: str
    target_pos: Optional[Tuple[int, int]] = None
    is_egress: bool = False
    prompt_label: str = ""

    def to_dict(self) -> dict:
        return {
            "target_map_name": self.target_map_name,
            "target_pos": list(self.target_pos) if self.target_pos else None,
            "is_egress": self.is_egress,
            "prompt_label": self.prompt_label,
        }

    @classmethod
    def from_dict(cls, data: dict) -> WarpTarget:
        return cls(
            target_map_name=data["target_map_name"],
            target_pos=tuple(data["target_pos"]) if data.get("target_pos") else None,
            is_egress=data.get("is_egress", False),
            prompt_label=data.get("prompt_label", ""),
        )


@dataclass
class POIDescriptor:
    """Descriptor for an interactive Point of Interest landmark on the world map."""

    poi_type: POIType
    name: str
    glyph: str
    fg_color: TrueColor
    bg_color: TrueColor
    sector_coord: Tuple[int, int]
    local_pos: Tuple[int, int]
    sub_map: Optional[Any] = None
    description: str = ""
    spawn_pos: Tuple[int, int] = (27, 21)
    is_locked: bool = False
    required_key: Optional[str] = None
    unlock_msg: str = ""
    floors: List[Any] = field(default_factory=list)
    current_floor: int = 0
    boss_name: Optional[str] = None
    cave_tier: int = 1
    required_tier: int = 0

    def get_floor(self, floor_idx: int) -> Optional[Any]:
        """Returns the Map for floor_idx, or None if out of bounds."""
        if self.floors and 0 <= floor_idx < len(self.floors):
            return self.floors[floor_idx]
        return self.sub_map if floor_idx == 0 else None

    def set_current_floor(self, floor_idx: int) -> None:
        """Sets the active cave floor index and syncs sub_map."""
        if self.floors and 0 <= floor_idx < len(self.floors):
            self.current_floor = floor_idx
            self.sub_map = self.floors[floor_idx]

    def to_dict(self) -> dict:
        serialized_floors = []
        if self.floors:
            for f in self.floors:
                if hasattr(f, "to_compact_dict"):
                    serialized_floors.append(f.to_compact_dict())
                elif hasattr(f, "to_dict"):
                    serialized_floors.append(f.to_dict())

        return {
            "poi_type": self.poi_type.value,
            "name": self.name,
            "glyph": self.glyph,
            "fg_color": [self.fg_color.r, self.fg_color.g, self.fg_color.b],
            "bg_color": [self.bg_color.r, self.bg_color.g, self.bg_color.b],
            "sector_coord": list(self.sector_coord),
            "local_pos": list(self.local_pos),
            "spawn_pos": list(self.spawn_pos),
            "description": self.description,
            "is_locked": self.is_locked,
            "required_key": self.required_key,
            "unlock_msg": self.unlock_msg,
            "sub_map": (
                self.sub_map.to_compact_dict()
                if self.sub_map and hasattr(self.sub_map, "to_compact_dict")
                else (self.sub_map.to_dict() if self.sub_map and hasattr(self.sub_map, "to_dict") else None)
            ),
            "floors": serialized_floors,
            "current_floor": self.current_floor,
            "boss_name": self.boss_name,
            "cave_tier": self.cave_tier,
            "required_tier": self.required_tier,
        }

    @classmethod
    def from_dict(cls, data: dict) -> POIDescriptor:
        desc = cls(
            poi_type=POIType(data["poi_type"]),
            name=data["name"],
            glyph=data["glyph"],
            fg_color=TrueColor(*data["fg_color"]),
            bg_color=TrueColor(*data["bg_color"]),
            sector_coord=tuple(data["sector_coord"]),
            local_pos=tuple(data["local_pos"]),
            spawn_pos=tuple(data.get("spawn_pos", (27, 21))),
            description=data.get("description", ""),
            is_locked=data.get("is_locked", False),
            required_key=data.get("required_key", None),
            unlock_msg=data.get("unlock_msg", ""),
            boss_name=data.get("boss_name", None),
            cave_tier=data.get("cave_tier", 1),
            required_tier=data.get("required_tier", 0),
        )
        if data.get("floors"):
            from .map_generator import Map
            desc.floors = []
            for fd in data["floors"]:
                if "rows" in fd:
                    desc.floors.append(Map.from_compact_dict(fd))
                else:
                    desc.floors.append(Map.from_dict(fd))
            desc.current_floor = max(0, min(len(desc.floors) - 1, data.get("current_floor", 0)))
            if desc.floors:
                desc.sub_map = desc.floors[desc.current_floor]
        elif data.get("sub_map"):
            from .map_generator import Map
            sub_data = data["sub_map"]
            if "rows" in sub_data:
                desc.sub_map = Map.from_compact_dict(sub_data)
            else:
                desc.sub_map = Map.from_dict(sub_data)
            desc.floors = [desc.sub_map]
            desc.current_floor = 0
        return desc

    @classmethod
    def create_town(
        cls,
        name: str = "Oakhaven Town",
        sector_coord: Tuple[int, int] = (0, 0),
        local_pos: Tuple[int, int] = (27, 12),
        spawn_pos: Tuple[int, int] = (27, 22),
    ) -> POIDescriptor:
        return cls(
            poi_type=POIType.TOWN,
            name=name,
            glyph="⌂",
            fg_color=TrueColor(0xFF, 0xD7, 0x00),  # Gold
            bg_color=TrueColor(0x3D, 0x28, 0x17),  # Dark timber
            sector_coord=sector_coord,
            local_pos=local_pos,
            spawn_pos=spawn_pos,
            description="A thriving trading town with cobblestone roads, inns, and merchants.",
        )

    @classmethod
    def create_castle(
        cls,
        name: str = "Highspire Castle",
        sector_coord: Tuple[int, int] = (1, 1),
        local_pos: Tuple[int, int] = (27, 12),
        spawn_pos: Tuple[int, int] = (27, 21),
    ) -> POIDescriptor:
        return cls(
            poi_type=POIType.CASTLE,
            name=name,
            glyph="C",
            fg_color=TrueColor(0xE2, 0xE8, 0xF0),  # Stone Silver
            bg_color=TrueColor(0x2D, 0x37, 0x48),  # Fortress Slate
            sector_coord=sector_coord,
            local_pos=local_pos,
            spawn_pos=spawn_pos,
            description="A grand stone fortress protecting the kingdom with high battlements.",
        )

    @classmethod
    def create_cave(
        cls,
        name: str = "Shadowfen Cavern",
        sector_coord: Tuple[int, int] = (2, 2),
        local_pos: Tuple[int, int] = (27, 12),
        spawn_pos: Tuple[int, int] = (27, 21),
        description: str = "A dark underground cavern descending into treacherous stone chambers.",
        is_locked: bool = False,
        required_key: Optional[str] = None,
        unlock_msg: str = "",
        boss_name: Optional[str] = None,
        cave_tier: int = 1,
        required_tier: int = 0,
    ) -> POIDescriptor:
        return cls(
            poi_type=POIType.CAVE,
            name=name,
            glyph="∩",
            fg_color=TrueColor(0xFC, 0x81, 0x81),  # Amber Crimson
            bg_color=TrueColor(0x1A, 0x20, 0x2C),  # Deep Cavern Black
            sector_coord=sector_coord,
            local_pos=local_pos,
            spawn_pos=spawn_pos,
            description=description,
            is_locked=is_locked,
            required_key=required_key,
            unlock_msg=unlock_msg,
            boss_name=boss_name,
            cave_tier=cave_tier,
            required_tier=required_tier,
        )


def get_direction_to_poi(
    origin_sector: Tuple[int, int],
    target_sector: Tuple[int, int],
    origin_local: Optional[Tuple[int, int]] = None,
    target_local: Optional[Tuple[int, int]] = None,
) -> str:
    """
    Computes one of the eight named directions from origin to target based on sector delta.
    If origin and target share the same sector, uses local coordinates as a tie-breaker.
    
    Directions returned:
    'north', 'south', 'east', 'west', 'north-east', 'north-west', 'south-east', 'south-west'
    """
    dx = target_sector[0] - origin_sector[0]
    dy = target_sector[1] - origin_sector[1]

    if dx == 0 and dy == 0 and origin_local is not None and target_local is not None:
        dx = target_local[0] - origin_local[0]
        dy = target_local[1] - origin_local[1]

    if dx == 0 and dy == 0:
        return "north"

    angle_deg = (math.degrees(math.atan2(dy, dx)) + 360.0) % 360.0
    octant = int((angle_deg + 22.5) // 45.0) % 8
    directions = [
        "east",
        "south-east",
        "south",
        "south-west",
        "west",
        "north-west",
        "north",
        "north-east",
    ]
    return directions[octant]


def find_nearest_cave_direction(
    origin_sector: Tuple[int, int],
    world_macro: Any,
    origin_local: Optional[Tuple[int, int]] = None,
    defeated_bosses: Optional[set[str]] = None,
    allow_cleared: bool = False,
) -> Optional[str]:
    """
    Identifies the nearest active cave POI across world_macro and returns its named direction.
    If allow_cleared is False, filters out caves whose boss has already been defeated.
    Prioritizes grottos in the party's current lowest incomplete cave tier.
    Returns None if no qualifying caves remain (e.g. all campaign bosses vanquished).
    """
    if not world_macro:
        return None
    pois = getattr(world_macro, "all_pois", getattr(world_macro, "pois", None))
    if pois is None:
        return None
    caves = [p for p in pois if getattr(p, "poi_type", None) == POIType.CAVE]
    if not caves:
        return None

    if defeated_bosses is None:
        defeated_bosses = set()

    candidates = caves
    if not allow_cleared:
        candidates = [c for c in caves if not (c.boss_name and c.boss_name in defeated_bosses)]
        if not candidates:
            return None

        # Prioritize caves in the lowest active/accessible tier
        min_tier = min(getattr(c, "cave_tier", 1) for c in candidates)
        tier_candidates = [c for c in candidates if getattr(c, "cave_tier", 1) == min_tier]
        if tier_candidates:
            candidates = tier_candidates

    px, py = origin_sector
    lx, ly = origin_local if origin_local is not None else (0, 0)

    def _dist(c: POIDescriptor):
        cx, cy = c.sector_coord
        s_dist = math.hypot(cx - px, cy - py)
        l_dist = math.hypot(c.local_pos[0] - lx, c.local_pos[1] - ly) if origin_local else 0.0
        return (s_dist, l_dist)

    nearest = min(candidates, key=_dist)
    return get_direction_to_poi(
        origin_sector=origin_sector,
        target_sector=nearest.sector_coord,
        origin_local=origin_local,
        target_local=nearest.local_pos,
    )
