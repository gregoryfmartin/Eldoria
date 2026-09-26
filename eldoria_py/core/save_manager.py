"""
SaveManager: Comprehensive save/load system for Eldoria.
Supports isolated slot directories, immutable baked world maps,
atomic file writes, and fast metadata header inspection.
"""

from __future__ import annotations
from dataclasses import dataclass
from datetime import datetime
import gzip
import json
import os
from pathlib import Path
import random
import shutil
from typing import Any, Dict, List, Optional, Tuple

from ..combat.entities import Party
from ..procgen.poi import POIType
from ..procgen.world_macro import WorldMacroMap


@dataclass
class SaveSlotHeader:
    """Fast preview metadata for save slots shown in menus."""

    slot_index: int
    party_leader_name: str
    party_leader_class: str
    party_leader_level: int
    party_count: int
    world_size_label: str
    macro_width: int
    macro_height: int
    current_location: str
    playtime_seconds: int
    timestamp: str

    def formatted_playtime(self) -> str:
        """Returns HH:MM:SS format."""
        h = self.playtime_seconds // 3600
        m = (self.playtime_seconds % 3600) // 60
        s = self.playtime_seconds % 60
        return f"{h:02d}:{m:02d}:{s:02d}"

    def to_dict(self) -> Dict[str, Any]:
        return {
            "slot_index": self.slot_index,
            "party_leader_name": self.party_leader_name,
            "party_leader_class": self.party_leader_class,
            "party_leader_level": self.party_leader_level,
            "party_count": self.party_count,
            "world_size_label": self.world_size_label,
            "macro_width": self.macro_width,
            "macro_height": self.macro_height,
            "current_location": self.current_location,
            "playtime_seconds": self.playtime_seconds,
            "timestamp": self.timestamp,
        }

    @classmethod
    def from_dict(cls, data: Dict[str, Any]) -> SaveSlotHeader:
        return cls(
            slot_index=data.get("slot_index", 1),
            party_leader_name=data.get("party_leader_name", "Unknown"),
            party_leader_class=data.get("party_leader_class", "Hero"),
            party_leader_level=data.get("party_leader_level", 1),
            party_count=data.get("party_count", 1),
            world_size_label=data.get("world_size_label", "Medium (12x12)"),
            macro_width=data.get("macro_width", 12),
            macro_height=data.get("macro_height", 12),
            current_location=data.get("current_location", "Oakhaven Town"),
            playtime_seconds=data.get("playtime_seconds", 0),
            timestamp=data.get("timestamp", ""),
        )


def _write_gzip_json(path: Path, data: Any) -> None:
    """Atomically writes data to a gzip-compressed JSON file."""
    tmp_path = path.with_suffix(path.suffix + ".tmp")
    with gzip.open(tmp_path, "wt", encoding="utf-8") as f:
        json.dump(data, f)
    os.replace(tmp_path, path)


def _write_json(path: Path, data: Any) -> None:
    """Atomically writes data to an uncompressed JSON file."""
    tmp_path = path.with_suffix(path.suffix + ".tmp")
    with open(tmp_path, "w", encoding="utf-8") as f:
        json.dump(data, f, indent=2)
    os.replace(tmp_path, path)


def _read_gzip_json(path: Path) -> Any:
    """Reads and parses a gzip-compressed JSON file."""
    with gzip.open(path, "rt", encoding="utf-8") as f:
        return json.load(f)


def _read_json(path: Path) -> Any:
    """Reads and parses an uncompressed JSON file."""
    with open(path, "r", encoding="utf-8") as f:
        return json.load(f)


class SaveManager:
    """
    Manages slot-isolated save files (header.json, state.sav, world.map)
    with atomic writes and immutable baked world map caching.
    """

    def __init__(self, save_dir: str = "saves") -> None:
        self.save_dir = Path(save_dir)
        self.save_dir.mkdir(parents=True, exist_ok=True)

    def get_slot_dir(self, slot_idx: int) -> Path:
        """Returns the directory Path for the specified slot index."""
        return self.save_dir / f"slot_{slot_idx}"

    def list_save_slots(self, max_slots: int = 3) -> List[Optional[SaveSlotHeader]]:
        """Returns a list of SaveSlotHeader for slots 1..max_slots (None if empty or invalid)."""
        headers: List[Optional[SaveSlotHeader]] = []
        for i in range(1, max_slots + 1):
            slot_dir = self.get_slot_dir(i)
            header_path = slot_dir / "header.json"
            if header_path.is_file():
                try:
                    data = _read_json(header_path)
                    headers.append(SaveSlotHeader.from_dict(data))
                except Exception:
                    headers.append(None)
            else:
                headers.append(None)
        return headers

    def create_new_game(
        self,
        slot_idx: int,
        party: Party,
        macro_size: str = "medium",
        seed: Optional[int] = None,
    ) -> Tuple[WorldMacroMap, Dict[str, Any]]:
        """
        Initializes a brand-new adventure in slot_idx:
        1. Generates WorldMacroMap once based on chosen size.
        2. Bakes and saves immutable world.map.
        3. Initializes state.sav with starter coordinates and party.
        4. Writes header.json preview.
        """
        if seed is None:
            seed = random.randint(1000, 999999)

        size_key = macro_size.lower().strip()
        if "quick" in size_key or "small" in size_key or "6" in size_key:
            mw, mh, label = 6, 6, "Quick"
        elif "odyssey" in size_key or "large" in size_key or "20" in size_key:
            mw, mh, label = 20, 20, "Odyssey"
        elif "4" in size_key or "classic" in size_key:
            mw, mh, label = 4, 4, "Classic"
        else:
            mw, mh, label = 12, 12, "Standard"

        # Generate world macro map once
        world_macro = WorldMacroMap(seed=seed, macro_width=mw, macro_height=mh, generate=True)

        slot_dir = self.get_slot_dir(slot_idx)
        slot_dir.mkdir(parents=True, exist_ok=True)

        # 1. Write immutable world.map
        world_map_path = slot_dir / "world.map"
        _write_gzip_json(world_map_path, world_macro.to_dict())

        # 2. Build initial exploration state
        primary_town = world_macro.get_poi(POIType.TOWN)
        starter_loc_name = primary_town.name if primary_town else "Oakhaven Town"
        exploration_state: Dict[str, Any] = {
            "current_sector": list(world_macro.starter_sector),
            "player_pos": list(world_macro.starter_player_pos),
            "current_map_name": "Overworld",
            "active_submap_poi": None,
            "visited_sectors": [list(world_macro.starter_sector)],
            "flags": {},
        }

        now_str = datetime.now().strftime("%Y-%m-%d %H:%M")

        # 3. Write initial state.sav
        state_data: Dict[str, Any] = {
            "slot_index": slot_idx,
            "party": party.to_dict(),
            "exploration_state": exploration_state,
            "playtime_seconds": 0,
            "created_at": now_str,
            "saved_at": now_str,
        }
        state_path = slot_dir / "state.sav"
        _write_gzip_json(state_path, state_data)

        # 4. Write initial header.json
        leader = party.members[0] if party.members else None
        leader_class = (leader.job_class.value if hasattr(leader.job_class, "value") else str(leader.job_class)) if leader else "Warrior"
        header = SaveSlotHeader(
            slot_index=slot_idx,
            party_leader_name=leader.name if leader else "Hero",
            party_leader_class=leader_class,
            party_leader_level=leader.level if leader else 1,
            party_count=len(party.members),
            world_size_label=label,
            macro_width=mw,
            macro_height=mh,
            current_location=starter_loc_name,
            playtime_seconds=0,
            timestamp=now_str,
        )
        header_path = slot_dir / "header.json"
        _write_json(header_path, header.to_dict())

        return world_macro, exploration_state

    def save_game(
        self,
        slot_idx: int,
        party: Party,
        exploration_state: Dict[str, Any],
        playtime_seconds: int = 0,
        world_macro: Optional[WorldMacroMap] = None,
    ) -> None:
        """
        Saves ongoing game state to slot_idx atomically.
        Only touches state.sav and header.json; world.map is never rewritten.
        """
        slot_dir = self.get_slot_dir(slot_idx)
        slot_dir.mkdir(parents=True, exist_ok=True)

        header_path = slot_dir / "header.json"
        existing_header: Optional[SaveSlotHeader] = None
        if header_path.is_file():
            try:
                existing_header = SaveSlotHeader.from_dict(_read_json(header_path))
            except Exception:
                pass

        # If world.map doesn't exist yet and world_macro is provided, write it
        world_map_path = slot_dir / "world.map"
        if world_macro is not None and not world_map_path.is_file():
            _write_gzip_json(world_map_path, world_macro.to_dict())

        now_str = datetime.now().strftime("%Y-%m-%d %H:%M")

        # 1. Write state.sav
        state_data: Dict[str, Any] = {
            "slot_index": slot_idx,
            "party": party.to_dict(),
            "exploration_state": exploration_state,
            "playtime_seconds": playtime_seconds,
            "saved_at": now_str,
        }
        state_path = slot_dir / "state.sav"
        _write_gzip_json(state_path, state_data)

        # 2. Determine display location
        loc_name = exploration_state.get("current_map_name", "Overworld")
        if loc_name == "Overworld":
            sec = exploration_state.get("current_sector", [0, 0])
            loc_name = f"Overworld ({sec[0]}, {sec[1]})"

        leader = party.members[0] if party.members else None
        leader_class = (leader.job_class.value if hasattr(leader.job_class, "value") else str(leader.job_class)) if leader else "Warrior"
        mw = existing_header.macro_width if existing_header else (world_macro.macro_width if world_macro else 12)
        mh = existing_header.macro_height if existing_header else (world_macro.macro_height if world_macro else 12)
        default_size_label = "Quick" if mw == 6 else ("Odyssey" if mw == 20 else ("Classic" if mw == 4 else "Standard"))
        size_label = existing_header.world_size_label if existing_header else default_size_label

        header = SaveSlotHeader(
            slot_index=slot_idx,
            party_leader_name=leader.name if leader else "Hero",
            party_leader_class=leader_class,
            party_leader_level=leader.level if leader else 1,
            party_count=len(party.members),
            world_size_label=size_label,
            macro_width=mw,
            macro_height=mh,
            current_location=loc_name,
            playtime_seconds=playtime_seconds,
            timestamp=now_str,
        )
        _write_json(header_path, header.to_dict())

    def load_game(
        self,
        slot_idx: int,
    ) -> Tuple[Party, WorldMacroMap, Dict[str, Any]]:
        """
        Loads slot_idx without procedural generation:
        Hydrates immutable world.map and dynamic state.sav.
        Returns (party, world_macro, exploration_state).
        """
        slot_dir = self.get_slot_dir(slot_idx)
        world_map_path = slot_dir / "world.map"
        state_path = slot_dir / "state.sav"

        if not world_map_path.is_file():
            raise FileNotFoundError(f"Missing world.map in save slot {slot_idx}")
        if not state_path.is_file():
            raise FileNotFoundError(f"Missing state.sav in save slot {slot_idx}")

        world_data = _read_gzip_json(world_map_path)
        world_macro = WorldMacroMap.from_dict(world_data)

        state_data = _read_gzip_json(state_path)
        party = Party.from_dict(state_data["party"])
        exploration_state = state_data.get("exploration_state", {})
        exploration_state["playtime_seconds"] = state_data.get("playtime_seconds", 0)

        return party, world_macro, exploration_state

    def delete_slot(self, slot_idx: int) -> bool:
        """Deletes all save files for slot_idx."""
        slot_dir = self.get_slot_dir(slot_idx)
        if slot_dir.is_dir():
            shutil.rmtree(slot_dir)
            return True
        return False
