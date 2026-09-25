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
        )
