"""
Unit tests for WorldMacroMap, algorithmic POI placement, sub-map generation,
and interactive overworld <-> sub-map warp transitions.
"""

from __future__ import annotations
import unittest
from typing import Tuple

from eldoria_py.core.context import Context
from eldoria_py.procgen.map_generator import BiomeType, MapTile
from eldoria_py.procgen.poi import POIType, WarpTarget
from eldoria_py.procgen.submap_generator import SubMapGenerator
from eldoria_py.procgen.world_macro import WorldMacroMap
from eldoria_py.states.test_noise_map import GSNoiseMapTestScreen
from eldoria_py.terminal.input import KeyEvent, KeyCode


class TestWorldMacroAndSubMaps(unittest.TestCase):
    """Test suite for 4x4 macro world, POIs, and warp navigation."""

    def setUp(self) -> None:
        self.macro_map = WorldMacroMap(
            seed=1337,
            macro_width=4,
            macro_height=4,
            sector_width=54,
            sector_height=24,
            frequency=0.035,
        )

    def test_macro_grid_dimensions(self) -> None:
        """Verify the world map initializes a 4x4 sector grid of 54x24 tiles."""
        self.assertEqual(len(self.macro_map.sectors), 4)
        for row in self.macro_map.sectors:
            self.assertEqual(len(row), 4)
            for sec in row:
                self.assertEqual(sec.width, 54)
                self.assertEqual(sec.height, 24)

    def test_global_coordinate_continuity(self) -> None:
        """
        Verify that elevation noise samples across sector boundaries are continuous:
        (53, y) in Sector (0, 0) and (0, y) in Sector (1, 0) are adjacent in global noise.
        """
        sec00 = self.macro_map.sectors[0][0]
        sec10 = self.macro_map.sectors[0][1]

        # In continuous noise sampling, the difference across adjacent integer coordinates is small
        diffs = []
        for y in range(24):
            elev_a = sec00.tiles[y][53].elevation
            elev_b = sec10.tiles[y][0].elevation
            diffs.append(abs(elev_a - elev_b))

        avg_diff = sum(diffs) / len(diffs)
        self.assertLess(avg_diff, 0.15, "Global elevation noise should be continuous across sector seams.")

    def test_poi_placement_in_three_distinct_sectors(self) -> None:
        """Verify Town, Castle, and Cave are placed in 3 separate sectors with valid descriptors."""
        town_poi = self.macro_map.get_poi(POIType.TOWN)
        castle_poi = self.macro_map.get_poi(POIType.CASTLE)
        cave_poi = self.macro_map.get_poi(POIType.CAVE)

        self.assertIsNotNone(town_poi)
        self.assertIsNotNone(castle_poi)
        self.assertIsNotNone(cave_poi)

        sector_coords = {town_poi.sector_coord, castle_poi.sector_coord, cave_poi.sector_coord}
        self.assertEqual(len(sector_coords), 3, "All 3 POIs must reside in distinct sectors.")

        # Check glyphs
        self.assertEqual(town_poi.glyph, "⌂")
        self.assertEqual(castle_poi.glyph, "C")
        self.assertEqual(cave_poi.glyph, "∩")

        # Verify POIs are stamped on the sector map tiles
        for poi in (town_poi, castle_poi, cave_poi):
            sec = self.macro_map.sectors[poi.sector_coord[1]][poi.sector_coord[0]]
            tile = sec.tiles[poi.local_pos[1]][poi.local_pos[0]]
            self.assertIsNotNone(tile.poi)
            self.assertEqual(tile.poi.name, poi.name)
            self.assertEqual(tile.custom_glyph, poi.glyph)
            self.assertIsNotNone(tile.warp_target)
            self.assertFalse(tile.warp_target.is_egress)

    def test_cave_mouth_adjacent_to_mountain(self) -> None:
        """Verify the Cave POI tile is adjacent to at least one Mountain or Snow tile."""
        cave_poi = self.macro_map.get_poi(POIType.CAVE)
        self.assertIsNotNone(cave_poi)

        sec = self.macro_map.sectors[cave_poi.sector_coord[1]][cave_poi.sector_coord[0]]
        cx, cy = cave_poi.local_pos
        cave_tile = sec.tiles[cy][cx]
        self.assertTrue(cave_tile.is_walkable, "Cave entrance tile must be walkable.")

        has_mountain_neighbor = False
        for dx, dy in ((0, 1), (0, -1), (1, 0), (-1, 0)):
            nx, ny = cx + dx, cy + dy
            if 0 <= nx < sec.width and 0 <= ny < sec.height:
                if sec.tiles[ny][nx].biome in (BiomeType.MOUNTAIN, BiomeType.SNOW):
                    has_mountain_neighbor = True
                    break

        self.assertTrue(has_mountain_neighbor, "Cave mouth must be directly adjacent to mountain rock.")

    def test_submap_generation_and_egress_tiles(self) -> None:
        """Verify SubMapGenerator creates valid 54x24 maps with egress WarpTargets."""
        town_map, town_spawn = SubMapGenerator.generate_town("Test Town", seed=100)
        self.assertEqual(town_map.width, 54)
        self.assertEqual(town_map.height, 24)
        self.assertTrue(town_map.tiles[town_spawn[1]][town_spawn[0]].is_walkable)

        # Check town egress gate
        egress_town = [
            tile for row in town_map.tiles for tile in row
            if tile.warp_target and tile.warp_target.is_egress
        ]
        self.assertEqual(len(egress_town), 1)
        self.assertEqual(egress_town[0].custom_glyph, "▼")

        # Castle sub-map
        castle_map, castle_spawn = SubMapGenerator.generate_castle("Test Castle", seed=200)
        self.assertEqual(castle_map.width, 54)
        self.assertEqual(castle_map.height, 24)
        self.assertTrue(castle_map.tiles[castle_spawn[1]][castle_spawn[0]].is_walkable)
        egress_castle = [
            tile for row in castle_map.tiles for tile in row
            if tile.warp_target and tile.warp_target.is_egress
        ]
        self.assertEqual(len(egress_castle), 1)

        # Cave sub-map
        cave_map, cave_spawn = SubMapGenerator.generate_cave("Test Cavern", seed=300)
        self.assertEqual(cave_map.width, 54)
        self.assertEqual(cave_map.height, 24)
        self.assertTrue(cave_map.tiles[cave_spawn[1]][cave_spawn[0]].is_walkable)
        egress_cave = [
            tile for row in cave_map.tiles for tile in row
            if tile.warp_target and tile.warp_target.is_egress
        ]
        self.assertEqual(len(egress_cave), 1)
        self.assertEqual(egress_cave[0].custom_glyph, "∩")

    def test_inter_sector_boundary_exit_reciprocity(self) -> None:
        """Verify border exits between adjacent sectors are strictly reciprocal."""
        # East/West reciprocity between Sector (0, 0) and Sector (1, 0)
        sec0 = self.macro_map.sectors[0][0]
        sec1 = self.macro_map.sectors[0][1]

        for y in range(24):
            exit_e = sec0.tiles[y][53].exits[MapTile.EXIT_EAST]
            exit_w = sec1.tiles[y][0].exits[MapTile.EXIT_WEST]
            self.assertEqual(
                exit_e, exit_w,
                f"Mismatch at horizontal seam y={y}: Sector0 East={exit_e}, Sector1 West={exit_w}"
            )

        # Outer world edges must have exits closed
        for y in range(24):
            # Far west
            self.assertFalse(self.macro_map.sectors[0][0].tiles[y][0].exits[MapTile.EXIT_WEST])
            # Far east
            self.assertFalse(self.macro_map.sectors[0][3].tiles[y][53].exits[MapTile.EXIT_EAST])

        for x in range(54):
            # Far north
            self.assertFalse(self.macro_map.sectors[0][0].tiles[0][x].exits[MapTile.EXIT_NORTH])
            # Far south
            self.assertFalse(self.macro_map.sectors[3][0].tiles[23][x].exits[MapTile.EXIT_SOUTH])

    def test_screen_warp_enter_and_egress_round_trip(self) -> None:
        """
        Verify that pressing Enter on a POI tile warps into its sub-map,
        and pressing Enter on the sub-map egress tile returns to the exact overworld tile.
        """
        screen = GSNoiseMapTestScreen(map_width=54, map_height=24)
        town_poi = screen.world_macro.get_poi(POIType.TOWN)
        self.assertIsNotNone(town_poi)

        # Place player directly on Town POI on overworld
        screen.current_sector = town_poi.sector_coord
        screen.player_x, screen.player_y = town_poi.local_pos
        self.assertIsNone(screen.active_submap)

        # Simulate pressing [Enter]
        context = Context()
        context.set(GSNoiseMapTestScreen.ContextKeysPressed, [KeyEvent(key=KeyCode.ENTER)])
        screen.update(context)

        # Player should now be inside Town sub-map
        self.assertIsNotNone(screen.active_submap)
        self.assertEqual(screen.active_poi.name, town_poi.name)
        self.assertEqual(len(screen.warp_stack), 1)
        self.assertEqual((screen.player_x, screen.player_y), town_poi.spawn_pos)

        # Find egress tile in the sub-map
        egress_pos = None
        for y in range(screen.active_submap.height):
            for x in range(screen.active_submap.width):
                t = screen.active_submap.tiles[y][x]
                if t.warp_target and t.warp_target.is_egress:
                    egress_pos = (x, y)
                    break
            if egress_pos:
                break

        self.assertIsNotNone(egress_pos)
        # Move player to egress tile
        screen.player_x, screen.player_y = egress_pos

        # Simulate pressing [Enter] on egress tile
        context.set(GSNoiseMapTestScreen.ContextKeysPressed, [KeyEvent(key=KeyCode.ENTER)])
        screen.update(context)

        # Player should now be back on Overworld at the exact Town POI tile!
        self.assertIsNone(screen.active_submap)
        self.assertEqual(len(screen.warp_stack), 0)
        self.assertEqual(screen.current_sector, town_poi.sector_coord)
        self.assertEqual((screen.player_x, screen.player_y), town_poi.local_pos)

    def test_castle_and_cave_warp_and_egress(self) -> None:
        """Verify Castle and Cave POIs also support complete warp entry and egress round-trip."""
        screen = GSNoiseMapTestScreen(map_width=54, map_height=24)
        context = Context()

        for poi_type in (POIType.CASTLE, POIType.CAVE):
            poi = screen.world_macro.get_poi(poi_type)
            self.assertIsNotNone(poi)

            # Move player to POI on world map
            screen.current_sector = poi.sector_coord
            screen.player_x, screen.player_y = poi.local_pos
            self.assertIsNone(screen.active_submap)

            # Press Enter -> Enter sub-map
            context.set(GSNoiseMapTestScreen.ContextKeysPressed, [KeyEvent(key=KeyCode.ENTER)])
            screen.update(context)

            self.assertIsNotNone(screen.active_submap)
            self.assertEqual(screen.active_poi.name, poi.name)

            # Find egress tile in sub-map
            egress_pos = None
            for y in range(screen.active_submap.height):
                for x in range(screen.active_submap.width):
                    t = screen.active_submap.tiles[y][x]
                    if t.warp_target and t.warp_target.is_egress:
                        egress_pos = (x, y)
                        break
                if egress_pos:
                    break

            self.assertIsNotNone(egress_pos)
            screen.player_x, screen.player_y = egress_pos

            # Press Enter -> Leave sub-map
            context.set(GSNoiseMapTestScreen.ContextKeysPressed, [KeyEvent(key=KeyCode.ENTER)])
            screen.update(context)

            # Returned to Overworld
            self.assertIsNone(screen.active_submap)
            self.assertEqual(screen.current_sector, poi.sector_coord)
            self.assertEqual((screen.player_x, screen.player_y), poi.local_pos)

    def test_screen_sector_boundary_crossing_movement(self) -> None:
        """Verify walking past sector boundaries transitions between sectors."""
        screen = GSNoiseMapTestScreen(map_width=54, map_height=24)
        # Set to Sector (0, 0)
        screen.current_sector = (0, 0)
        sec = screen.world_macro.get_sector(0, 0)
        sec_east = screen.world_macro.get_sector(1, 0)

        # Find a row where East exit is open
        walkable_y = None
        for y in range(24):
            if sec.tiles[y][53].exits[MapTile.EXIT_EAST]:
                walkable_y = y
                break

        if walkable_y is None:
            # Force a walkable corridor for testing
            walkable_y = 10
            sec.tiles[walkable_y][53].biome = BiomeType.ROAD
            sec_east.tiles[walkable_y][0].biome = BiomeType.ROAD
            sec.tiles[walkable_y][53].exits[MapTile.EXIT_EAST] = True
            sec_east.tiles[walkable_y][0].exits[MapTile.EXIT_WEST] = True

        screen.player_x = 53
        screen.player_y = walkable_y

        # Move East
        screen._try_move(1, 0, MapTile.EXIT_EAST)

        # Should now be in Sector (1, 0) at x=0
        self.assertEqual(screen.current_sector, (1, 0))
        self.assertEqual(screen.player_x, 0)
        self.assertEqual(screen.player_y, walkable_y)

        # Move West back to Sector (0, 0) at x=53
        screen._try_move(-1, 0, MapTile.EXIT_WEST)
        self.assertEqual(screen.current_sector, (0, 0))
        self.assertEqual(screen.player_x, 53)
        self.assertEqual(screen.player_y, walkable_y)


if __name__ == "__main__":
    unittest.main()
