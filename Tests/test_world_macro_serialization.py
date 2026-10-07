"""
Unit tests for WorldMacroMap serialization and multi-size POI scaling.
"""

from __future__ import annotations
import json
import unittest

from eldoria_py.procgen.map_generator import BiomeType
from eldoria_py.procgen.poi import POIType
from eldoria_py.procgen.world_macro import WorldMacroMap


class TestWorldMacroSerialization(unittest.TestCase):
    """Test suite for WorldMacroMap to_dict/from_dict serialization and POI scaling."""

    def test_legacy_4x4_roundtrip(self) -> None:
        """Verify 4x4 macro map serialization preserves all sectors, biomes, and POIs."""
        original = WorldMacroMap(seed=1337, macro_width=4, macro_height=4)
        self.assertEqual(len(original.sectors), 4)
        self.assertEqual(len(original.all_pois), 5)  # 1 town, 1 castle, 3 caves

        data = original.to_dict()
        # Verify JSON serializability
        json_str = json.dumps(data)
        self.assertIsInstance(json_str, str)

        hydrated = WorldMacroMap.from_dict(json.loads(json_str))

        self.assertEqual(hydrated.macro_width, 4)
        self.assertEqual(hydrated.macro_height, 4)
        self.assertEqual(hydrated.seed, 1337)
        self.assertEqual(hydrated.starter_sector, original.starter_sector)
        self.assertEqual(hydrated.starter_player_pos, original.starter_player_pos)
        self.assertEqual(len(hydrated.sectors), 4)
        self.assertEqual(len(hydrated.all_pois), 5)

        # Check POIs match
        for orig_poi in original.all_pois:
            hyd_poi = hydrated.get_poi(orig_poi.name)
            self.assertIsNotNone(hyd_poi)
            self.assertEqual(hyd_poi.poi_type, orig_poi.poi_type)
            self.assertEqual(hyd_poi.sector_coord, orig_poi.sector_coord)
            self.assertEqual(hyd_poi.local_pos, orig_poi.local_pos)
            self.assertEqual(hyd_poi.glyph, orig_poi.glyph)

            # Check stamped on sector map
            sx, sy = hyd_poi.sector_coord
            sec = hydrated.sectors[sy][sx]
            tile = sec.tiles[hyd_poi.local_pos[1]][hyd_poi.local_pos[0]]
            self.assertIsNotNone(tile.poi)
            self.assertEqual(tile.poi.name, orig_poi.name)

        # Check random tile matching
        for sy in range(4):
            for sx in range(4):
                orig_sec = original.sectors[sy][sx]
                hyd_sec = hydrated.sectors[sy][sx]
                for y in range(24):
                    for x in range(54):
                        self.assertEqual(
                            hyd_sec.tiles[y][x].biome,
                            orig_sec.tiles[y][x].biome,
                            f"Mismatch at sector ({sx},{sy}) pos ({x},{y})"
                        )

    def test_small_6x6_scaling(self) -> None:
        """Verify 6x6 world generates 8 Towns, 2 Castles, 11 Caves."""
        macro_6x6 = WorldMacroMap(seed=42, macro_width=6, macro_height=6)
        self.assertEqual(len(macro_6x6.sectors), 6)
        self.assertEqual(len(macro_6x6.sectors[0]), 6)

        towns = [p for p in macro_6x6.all_pois if p.poi_type == POIType.TOWN]
        castles = [p for p in macro_6x6.all_pois if p.poi_type == POIType.CASTLE]
        caves = [p for p in macro_6x6.all_pois if p.poi_type == POIType.CAVE]

        self.assertEqual(len(towns), 8)
        self.assertEqual(len(castles), 2)
        self.assertEqual(len(caves), 11)
        self.assertEqual(len(macro_6x6.all_pois), 21)

        # Test serialization round-trip
        data = macro_6x6.to_dict()
        hydrated = WorldMacroMap.from_dict(data)
        self.assertEqual(hydrated.macro_width, 6)
        self.assertEqual(hydrated.macro_height, 6)
        self.assertEqual(len(hydrated.all_pois), 21)

    def test_medium_12x12_scaling(self) -> None:
        """Verify 12x12 world generates 13 Towns, 2 Castles, 16 Caves."""
        macro_12x12 = WorldMacroMap(seed=100, macro_width=12, macro_height=12)
        self.assertEqual(len(macro_12x12.sectors), 12)
        self.assertEqual(len(macro_12x12.sectors[0]), 12)

        towns = [p for p in macro_12x12.all_pois if p.poi_type == POIType.TOWN]
        castles = [p for p in macro_12x12.all_pois if p.poi_type == POIType.CASTLE]
        caves = [p for p in macro_12x12.all_pois if p.poi_type == POIType.CAVE]

        self.assertEqual(len(towns), 13)
        self.assertEqual(len(castles), 2)
        self.assertEqual(len(caves), 16)
        self.assertEqual(len(macro_12x12.all_pois), 31)


if __name__ == "__main__":
    unittest.main()
