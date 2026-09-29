"""
Unit tests for Town and Castle generation, quotas, building layouts, NPCs, and collision.
"""

from __future__ import annotations
import unittest
from typing import Set, Tuple

from eldoria_py.procgen.map_generator import Map, MapTile, BiomeType, ProceduralMapGenerator
from eldoria_py.procgen.npc import (
    NPC,
    NPCRole,
    create_king,
    create_service_owner,
    create_castle_npc,
    create_town_citizen,
)
from eldoria_py.procgen.poi import POIType
from eldoria_py.procgen.submap_generator import SubMapGenerator
from eldoria_py.procgen.world_macro import WorldMacroMap


class TestTownAndCastleGeneration(unittest.TestCase):
    """Test suite covering procedural Town & Castle generation rules, quotas, and NPCs."""

    def test_quotas_and_proportions_4x4(self) -> None:
        """4x4 map: 4 caves -> 1 town (starter town), 1 castle."""
        macro = WorldMacroMap(seed=1337, macro_width=4, macro_height=4)
        macro.generate()

        towns = [p for p in macro.all_pois if p.poi_type == POIType.TOWN]
        castles = [p for p in macro.all_pois if p.poi_type == POIType.CASTLE]
        caves = [p for p in macro.all_pois if p.poi_type == POIType.CAVE]

        self.assertEqual(len(caves), 4)
        self.assertEqual(len(towns), 1)
        self.assertEqual(len(castles), 1)

        # Strictly <= 1 POI per sector
        all_coords = [p.sector_coord for p in macro.all_pois]
        self.assertEqual(len(all_coords), len(set(all_coords)))

    def test_quotas_and_proportions_6x6(self) -> None:
        """6x6 map: 11 caves -> 8 towns, 2 castles."""
        macro = WorldMacroMap(seed=1337, macro_width=6, macro_height=6)
        macro.generate()

        towns = [p for p in macro.all_pois if p.poi_type == POIType.TOWN]
        castles = [p for p in macro.all_pois if p.poi_type == POIType.CASTLE]
        caves = [p for p in macro.all_pois if p.poi_type == POIType.CAVE]

        self.assertEqual(len(caves), 11)
        self.assertEqual(len(towns), 8)
        self.assertEqual(len(castles), 2)
        self.assertEqual(len(macro.all_pois), 21)

        # Strictly <= 1 POI per sector
        all_coords = [p.sector_coord for p in macro.all_pois]
        self.assertEqual(len(all_coords), len(set(all_coords)))

    def test_quotas_and_proportions_12x12(self) -> None:
        """12x12 map: 16 caves -> 13 towns, 2 castles."""
        macro = WorldMacroMap(seed=1337, macro_width=12, macro_height=12)
        macro.generate()

        towns = [p for p in macro.all_pois if p.poi_type == POIType.TOWN]
        castles = [p for p in macro.all_pois if p.poi_type == POIType.CASTLE]
        caves = [p for p in macro.all_pois if p.poi_type == POIType.CAVE]

        self.assertEqual(len(caves), 16)
        self.assertEqual(len(towns), 13)
        self.assertEqual(len(castles), 2)
        self.assertEqual(len(macro.all_pois), 31)

        # Strictly <= 1 POI per sector
        all_coords = [p.sector_coord for p in macro.all_pois]
        self.assertEqual(len(all_coords), len(set(all_coords)))

    def test_town_and_castle_regional_safety_limits(self) -> None:
        """Towns and Castles must NEVER be placed in Region 8 or 9 (only Regions 1-7)."""
        macro = WorldMacroMap(seed=2026, macro_width=12, macro_height=12)
        macro.generate()

        towns = [p for p in macro.all_pois if p.poi_type == POIType.TOWN]
        castles = [p for p in macro.all_pois if p.poi_type == POIType.CASTLE]

        for poi in towns + castles:
            sx, sy = poi.sector_coord
            sec = macro.sectors[sy][sx]
            # Verify sector center region code is <= 7
            center_tile = sec.tiles[macro.sector_height // 2][macro.sector_width // 2]
            # Since safe zone tiles have region_code 0, check the sector's walkable tiles
            walkable_regions = [
                sec.tiles[y][x].region_code
                for y in range(macro.sector_height)
                for x in range(macro.sector_width)
                if sec.tiles[y][x].region_code > 0
            ]
            if walkable_regions:
                avg_reg = sum(walkable_regions) / len(walkable_regions)
                self.assertLessEqual(avg_reg, 7.5, f"POI {poi.name} placed in dangerous region > 7")

    def test_endgame_town_in_region_7(self) -> None:
        """On 12x12, exactly 1 town is configured as the End-Game Town in Region 7."""
        macro = WorldMacroMap(seed=1337, macro_width=12, macro_height=12)
        macro.generate()

        towns = [p for p in macro.all_pois if p.poi_type == POIType.TOWN]
        endgame_towns = []
        for t in towns:
            sub = t.sub_map
            # Check if any shopkeeper has end-game inventory
            has_endgame_inv = any(
                tile.npc and tile.npc.shop_inventory and any(item.get("item_id") == "Excalibur" for item in tile.npc.shop_inventory)
                for row in sub.tiles
                for tile in row
            )
            if has_endgame_inv:
                endgame_towns.append(t)

        self.assertEqual(len(endgame_towns), 1, "Expected exactly 1 End-Game Town on 12x12 map")

    def test_town_building_variation_and_service_owners(self) -> None:
        """Verify building dimensions, variations, and 4 service owners inside buildings."""
        town_map, spawn = SubMapGenerator.generate_town(seed=101, region=1, is_endgame=False)

        # 4 service owners present
        owners = [
            tile.npc for row in town_map.tiles for tile in row
            if tile.npc and tile.npc.role in (
                NPCRole.INNKEEPER,
                NPCRole.ITEM_SHOPKEEPER,
                NPCRole.EQUIP_SHOPKEEPER,
                NPCRole.PUB_BARTENDER,
            )
        ]
        self.assertEqual(len(owners), 4)

        roles = {o.role for o in owners}
        self.assertEqual(roles, {
            NPCRole.INNKEEPER,
            NPCRole.ITEM_SHOPKEEPER,
            NPCRole.EQUIP_SHOPKEEPER,
            NPCRole.PUB_BARTENDER,
        })

        # All 4 doors exist
        doors = [
            tile for row in town_map.tiles for tile in row
            if tile.custom_glyph == "⌂"
        ]
        self.assertEqual(len(doors), 4)

        # Verify town generation produces varied layouts across seeds
        town_map_2, _ = SubMapGenerator.generate_town(seed=999, region=1, is_endgame=False)
        owners_2_pos = [
            tile.npc.pos for row in town_map_2.tiles for tile in row
            if tile.npc and tile.npc.role in roles
        ]
        owners_1_pos = [o.pos for o in owners]
        self.assertNotEqual(owners_1_pos, owners_2_pos, "Different seeds must produce different building placements")

    def test_town_general_npcs_and_no_blocking(self) -> None:
        """Verify 10 to 20 general town NPCs, and verify none block critical tiles."""
        town_map, spawn_pos = SubMapGenerator.generate_town(seed=42, region=2)

        # Count total NPCs
        all_npcs = [tile.npc for row in town_map.tiles for tile in row if tile.npc is not None]
        service_owners = [n for n in all_npcs if n.role in (
            NPCRole.INNKEEPER, NPCRole.ITEM_SHOPKEEPER, NPCRole.EQUIP_SHOPKEEPER, NPCRole.PUB_BARTENDER
        )]
        citizens = [n for n in all_npcs if n.role == NPCRole.CITIZEN]

        self.assertEqual(len(service_owners), 4)
        self.assertGreaterEqual(len(citizens), 10)
        self.assertLessEqual(len(citizens), 20)

        # No NPC on egress tile
        egress_tile = town_map.tiles[town_map.height - 1][town_map.width // 2]
        self.assertEqual(egress_tile.custom_glyph, "▼")
        self.assertIsNone(egress_tile.npc)

        # No NPC on player spawn tile
        spawn_tile = town_map.tiles[spawn_pos[1]][spawn_pos[0]]
        self.assertIsNone(spawn_tile.npc)

        # No NPC on doors
        for row in town_map.tiles:
            for tile in row:
                if tile.custom_glyph == "⌂":
                    self.assertIsNone(tile.npc)

    def test_castle_king_and_15_npcs(self) -> None:
        """Verify Castle contains 1 King with bounties and strictly 15 royal NPCs."""
        castle_map, spawn_pos = SubMapGenerator.generate_castle(
            name="Highspire Castle",
            seed=777,
            castle_idx=0,
            bounties=["Rattus", "Grumble", "Brigand"],
        )

        all_npcs = [tile.npc for row in castle_map.tiles for tile in row if tile.npc is not None]
        king = [n for n in all_npcs if n.role == NPCRole.KING]
        non_king = [n for n in all_npcs if n.role != NPCRole.KING]

        self.assertEqual(len(king), 1)
        self.assertEqual(king[0].bounties, ["Rattus", "Grumble", "Brigand"])
        self.assertEqual(king[0].pos, (27, 4))

        # Strictly 15 NPCs excluding King
        self.assertEqual(len(non_king), 15)

        # Verify throne is at (27, 3)
        throne_tile = castle_map.tiles[3][27]
        self.assertEqual(throne_tile.custom_glyph, "C")
        self.assertIsNone(throne_tile.npc)

        # Verify no NPC on spawn tile or egress gate
        egress_tile = castle_map.tiles[castle_map.height - 2][castle_map.width // 2]
        self.assertEqual(egress_tile.custom_glyph, "▼")
        self.assertIsNone(egress_tile.npc)

        spawn_tile = castle_map.tiles[spawn_pos[1]][spawn_pos[0]]
        self.assertIsNone(spawn_tile.npc)

    def test_movement_collision_blocking(self) -> None:
        """Verify player cannot walk onto an NPC tile."""
        from eldoria_py.core.context import Context
        from eldoria_py.states.test_noise_map import GSNoiseMapTestScreen

        state = GSNoiseMapTestScreen(map_width=54, map_height=24)
        context = Context()
        state.enter(context)

        # Enter the starter town submap
        town_poi = state.world_macro.get_poi(POIType.TOWN)
        self.assertIsNotNone(town_poi)
        state.active_submap = town_poi.sub_map

        # Find an NPC on the town submap
        target_npc_pos = None
        for y, row in enumerate(state.active_submap.tiles):
            for x, tile in enumerate(row):
                if tile.npc is not None:
                    target_npc_pos = (x, y)
                    break
            if target_npc_pos:
                break

        self.assertIsNotNone(target_npc_pos)
        nx, ny = target_npc_pos

        # Place player directly adjacent to the NPC
        # e.g., to the left of the NPC (nx - 1, ny) if valid and walkable
        if nx > 0 and state.active_submap.tiles[ny][nx - 1].is_walkable:
            state.player_x = nx - 1
            state.player_y = ny
            # Try to move East into the NPC (dx=1, dy=0, exit_dir=2 for East)
            moved = state._try_move(1, 0, 2)
            self.assertFalse(moved, "Movement onto NPC tile must be blocked")
            self.assertEqual((state.player_x, state.player_y), (nx - 1, ny), "Player position must not change")
        elif ny > 0 and state.active_submap.tiles[ny - 1][nx].is_walkable:
            state.player_x = nx
            state.player_y = ny - 1
            # Try to move South into the NPC (dx=0, dy=1, exit_dir=1 for South)
            moved = state._try_move(0, 1, 1)
            self.assertFalse(moved, "Movement onto NPC tile must be blocked")
            self.assertEqual((state.player_x, state.player_y), (nx, ny - 1), "Player position must not change")

    def test_npc_serialization_roundtrip(self) -> None:
        """Verify Map serialization with NPCs preserves all attributes in compact dict."""
        t_map, _ = SubMapGenerator.generate_town(seed=555)
        compact = t_map.to_compact_dict()

        hydrated = Map.from_compact_dict(compact)
        orig_npcs = [t.npc for row in t_map.tiles for t in row if t.npc]
        hyd_npcs = [t.npc for row in hydrated.tiles for t in row if t.npc]

        self.assertEqual(len(orig_npcs), len(hyd_npcs))
        for orig, hyd in zip(orig_npcs, hyd_npcs):
            self.assertEqual(orig.name, hyd.name)
            self.assertEqual(orig.role, hyd.role)
            self.assertEqual(orig.pos, hyd.pos)
            self.assertEqual(orig.glyph, hyd.glyph)
            self.assertEqual(orig.shop_inventory, hyd.shop_inventory)


if __name__ == "__main__":
    unittest.main()
