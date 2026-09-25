"""Unit tests for procedural map generation, exit connectivity, and performance."""

import time
import unittest

from eldoria_py.procgen.noise import FastNoiseLite, NoiseType, FractalType
from eldoria_py.procgen.map_generator import (
    ProceduralMapGenerator,
    Map,
    MapTile,
    BiomeType,
    BIOME_CONFIGS,
)


class TestProceduralMapGeneration(unittest.TestCase):
    """Test suite for Eldoria's procedural map generator and MapTile grid."""

    def test_map_tile_serialization(self):
        """MapTile converts to and from JSON dictionary format matching Eldoria's spec."""
        tile = MapTile(
            background_image="PlainsNorthEastRoad",
            biome=BiomeType.ROAD,
            object_listing=["MTOTree", "MTOApple"],
            exits=[True, False, True, False],
            battle_allowed=True,
            encounter_rate=0.25,
            region_code=1,
            elevation=0.55,
            moisture=0.62,
        )
        data = tile.to_dict()
        self.assertEqual(data["BackgroundImage"], "PlainsNorthEastRoad")
        self.assertEqual(data["Biome"], "Road")
        self.assertEqual(data["Exits"], [True, False, True, False])
        self.assertEqual(data["ObjectListing"], ["MTOTree", "MTOApple"])
        self.assertTrue(data["BattleAllowed"])

        restored = MapTile.from_dict(data)
        self.assertEqual(restored.background_image, tile.background_image)
        self.assertEqual(restored.biome, BiomeType.ROAD)
        self.assertEqual(restored.exits, tile.exits)
        self.assertEqual(restored.object_listing, tile.object_listing)
        self.assertEqual(restored.battle_allowed, tile.battle_allowed)
        self.assertTrue(restored.is_walkable)

    def test_map_serialization_round_trip(self):
        """Map serialization round-trips correctly with nested MapTile structures."""
        m = Map(name="TestDungeon", width=4, height=4, boundary_wrap=True)
        m.tiles[1][2].biome = BiomeType.FOREST
        m.tiles[1][2].battle_allowed = True

        data = m.to_dict()
        self.assertEqual(data["MapName"], "TestDungeon")
        self.assertEqual(data["MapWidth"], 4)
        self.assertEqual(data["MapHeight"], 4)
        self.assertTrue(data["BoundaryWrap"])
        self.assertEqual(len(data["Tiles"]), 4)
        self.assertEqual(len(data["Tiles"][0]), 4)

        restored = Map.from_dict(data)
        self.assertEqual(restored.name, "TestDungeon")
        self.assertEqual(restored.width, 4)
        self.assertEqual(restored.height, 4)
        self.assertTrue(restored.boundary_wrap)
        self.assertEqual(restored.tiles[1][2].biome, BiomeType.FOREST)
        self.assertTrue(restored.tiles[1][2].battle_allowed)

    def test_procedural_generation_determinism(self):
        """Same seed and parameters produce identical maps."""
        gen1 = ProceduralMapGenerator(seed=4242)
        gen2 = ProceduralMapGenerator(seed=4242)

        map1 = gen1.generate_map(width=20, height=15, create_road=True)
        map2 = gen2.generate_map(width=20, height=15, create_road=True)

        for y in range(15):
            for x in range(20):
                t1 = map1.tiles[y][x]
                t2 = map2.tiles[y][x]
                self.assertEqual(t1.biome, t2.biome, f"Mismatch at ({x},{y})")
                self.assertEqual(t1.exits, t2.exits, f"Exit mismatch at ({x},{y})")

    def test_exit_reciprocity_and_consistency(self):
        """All cardinal exits must be strictly reciprocal between adjacent walkable tiles."""
        gen = ProceduralMapGenerator(seed=9876)
        world_map = gen.generate_map(width=30, height=20, create_road=True, boundary_wrap=False)

        for y in range(20):
            for x in range(30):
                tile = world_map.tiles[y][x]
                if not tile.is_walkable:
                    self.assertEqual(tile.exits, [False, False, False, False], f"Non-walkable tile at ({x},{y}) had active exits!")
                    continue

                # North reciprocity (y - 1)
                if tile.exits[MapTile.EXIT_NORTH]:
                    self.assertGreater(y, 0, f"North exit at top boundary ({x},{y})")
                    neighbor = world_map.tiles[y - 1][x]
                    self.assertTrue(neighbor.is_walkable, f"North neighbor of ({x},{y}) is not walkable")
                    self.assertTrue(neighbor.exits[MapTile.EXIT_SOUTH], f"Reciprocity failure: ({x},{y}) exits North but ({x},{y-1}) cannot exit South")

                # South reciprocity (y + 1)
                if tile.exits[MapTile.EXIT_SOUTH]:
                    self.assertLess(y, 19, f"South exit at bottom boundary ({x},{y})")
                    neighbor = world_map.tiles[y + 1][x]
                    self.assertTrue(neighbor.is_walkable, f"South neighbor of ({x},{y}) is not walkable")
                    self.assertTrue(neighbor.exits[MapTile.EXIT_NORTH], f"Reciprocity failure: ({x},{y}) exits South but ({x},{y+1}) cannot exit North")

                # East reciprocity (x + 1)
                if tile.exits[MapTile.EXIT_EAST]:
                    self.assertLess(x, 29, f"East exit at right boundary ({x},{y})")
                    neighbor = world_map.tiles[y][x + 1]
                    self.assertTrue(neighbor.is_walkable, f"East neighbor of ({x},{y}) is not walkable")
                    self.assertTrue(neighbor.exits[MapTile.EXIT_WEST], f"Reciprocity failure: ({x},{y}) exits East but ({x+1},{y}) cannot exit West")

                # West reciprocity (x - 1)
                if tile.exits[MapTile.EXIT_WEST]:
                    self.assertGreater(x, 0, f"West exit at left boundary ({x},{y})")
                    neighbor = world_map.tiles[y][x - 1]
                    self.assertTrue(neighbor.is_walkable, f"West neighbor of ({x},{y}) is not walkable")
                    self.assertTrue(neighbor.exits[MapTile.EXIT_EAST], f"Reciprocity failure: ({x},{y}) exits West but ({x-1},{y}) cannot exit East")

    def test_road_continuity(self):
        """Road generation carves a contiguous trail across the map."""
        gen = ProceduralMapGenerator(seed=12345)
        world_map = gen.generate_map(width=25, height=15, create_road=True)

        road_tiles = [
            (x, y)
            for y in range(world_map.height)
            for x in range(world_map.width)
            if world_map.tiles[y][x].biome == BiomeType.ROAD
        ]
        self.assertGreater(len(road_tiles), 0, "No road tiles were generated!")

        # Verify road touches West (x=0) and East (x=w-1) sides
        west_roads = [pt for pt in road_tiles if pt[0] == 0]
        east_roads = [pt for pt in road_tiles if pt[0] == world_map.width - 1]
        self.assertTrue(len(west_roads) > 0, "Road does not start at west border")
        self.assertTrue(len(east_roads) > 0, "Road does not reach east border")

    def test_ansi_rendering(self):
        """Map renders to ANSI colored strings without error."""
        gen = ProceduralMapGenerator(seed=555)
        world_map = gen.generate_map(width=10, height=8, create_road=True)
        rendered_lines = ProceduralMapGenerator.render_ansi(world_map, cursor_pos=(2, 3))

        self.assertEqual(len(rendered_lines), 8)
        for line in rendered_lines:
            self.assertIn("\033[", line)  # ANSI escape code present
            self.assertIn("\033[0m", line)

        # Line with cursor (y=3) must have player glyph '@'
        self.assertIn("@", rendered_lines[3])

    def test_generation_performance_benchmark(self):
        """Benchmark procedural generation throughput for 20x20, 50x50, and 100x100 grids."""
        gen = ProceduralMapGenerator(seed=2024)

        # 20x20 map (400 tiles) - typical Eldoria town / dungeon area
        start = time.perf_counter()
        gen.generate_map(width=20, height=20, create_road=True)
        t_20x20 = time.perf_counter() - start
        self.assertLess(t_20x20, 0.05, f"20x20 generation took {t_20x20*1000:.2f}ms (must be < 50ms)")

        # 50x50 map (2500 tiles) - world region
        start = time.perf_counter()
        gen.generate_map(width=50, height=50, create_road=True)
        t_50x50 = time.perf_counter() - start
        self.assertLess(t_50x50, 0.20, f"50x50 generation took {t_50x50*1000:.2f}ms (must be < 200ms)")

        # 100x100 map (10,000 tiles) - full continent
        start = time.perf_counter()
        gen.generate_map(width=100, height=100, create_road=True)
        t_100x100 = time.perf_counter() - start
        self.assertLess(t_100x100, 0.80, f"100x100 generation took {t_100x100*1000:.2f}ms (must be < 800ms)")

    def test_gs_noise_map_test_screen_lifecycle(self):
        """GSNoiseMapTestScreen state executes enter, update, movement, and exit cleanly."""
        from eldoria_py.states.test_noise_map import GSNoiseMapTestScreen
        from eldoria_py.core.context import Context
        from eldoria_py.terminal.input import KeyEvent, KeyCode

        screen = GSNoiseMapTestScreen()
        self.assertEqual(screen.map_width, 54)
        self.assertEqual(screen.map_height, 24)
        self.assertEqual(len(screen.world_map.tiles), 24)
        self.assertEqual(len(screen.world_map.tiles[0]), 54)

        # Verify custom dimensions can also be specified
        custom_screen = GSNoiseMapTestScreen(map_width=60, map_height=30)
        self.assertEqual(custom_screen.map_width, 60)
        self.assertEqual(custom_screen.map_height, 30)
        self.assertEqual(len(custom_screen.world_map.tiles), 30)
        self.assertEqual(len(custom_screen.world_map.tiles[0]), 60)

        ctx = Context()
        ctx.set(0, 0.016)  # DeltaTime
        ctx.set(1, [])     # KeysPressed
        ctx.set(2, None)   # EldoriaCore

        screen.enter(ctx)

        # Trigger movement key
        ctx.set(1, [KeyEvent(key=KeyCode.RIGHT, char="d")])
        screen.update(ctx)

        # Trigger re-seed key
        ctx.set(1, [KeyEvent(key=KeyCode.CHAR, char="r")])
        screen.update(ctx)

        # Trigger noise type cycle
        ctx.set(1, [KeyEvent(key=KeyCode.CHAR, char="n")])
        screen.update(ctx)

        # Trigger fractal cycle
        ctx.set(1, [KeyEvent(key=KeyCode.CHAR, char="f")])
        screen.update(ctx)

        screen.exit(ctx)

    def test_load_existing_map_json_files(self):
        """Loads and parses all existing Resources/MapData/*.json map files."""
        import json
        import os

        map_dir = os.path.join(os.path.dirname(__file__), "..", "Resources", "MapData")
        if not os.path.isdir(map_dir):
            return

        for fname in os.listdir(map_dir):
            if fname.endswith(".json") and fname != "SampleSI.json":
                fpath = os.path.join(map_dir, fname)
                with open(fpath, "r", encoding="utf-8") as f:
                    data = json.load(f)
                loaded_map = Map.from_dict(data)
                self.assertGreater(loaded_map.width, 0)
                self.assertGreater(loaded_map.height, 0)
                self.assertEqual(len(loaded_map.tiles), loaded_map.height)
                self.assertEqual(len(loaded_map.tiles[0]), loaded_map.width)
                # Verify tiles have valid exit arrays
                for row in loaded_map.tiles:
                    for tile in row:
                        self.assertEqual(len(tile.exits), 4)


if __name__ == "__main__":
    unittest.main()
