"""
Point of Interest (POI) and WarpTarget definitions for Eldoria.
"""

from __future__ import annotations
from dataclasses import dataclass
from enum import Enum
from typing import Any, Optional, Tuple
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

    def to_dict(self) -> dict:
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
        )
        if data.get("sub_map"):
            from .map_generator import Map
            sub_data = data["sub_map"]
            if "rows" in sub_data:
                desc.sub_map = Map.from_compact_dict(sub_data)
            else:
                desc.sub_map = Map.from_dict(sub_data)
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
        is_locked: bool = False,
        required_key: Optional[str] = None,
        unlock_msg: str = "",
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
            description="A dark underground cavern descending into treacherous stone chambers.",
            is_locked=is_locked,
            required_key=required_key,
            unlock_msg=unlock_msg,
        )
