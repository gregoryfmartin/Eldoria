"""
Tests for Multi-Floor Caves, Ladder Linking, Boss Encounters, and Escape Rope System.

CRITICAL RULE: NEVER run Tests/test_audio_subsystem.py under any circumstances.
"""

import unittest
from unittest.mock import MagicMock, patch

from eldoria_py.procgen.map_generator import Map, MapTile, BiomeType
from eldoria_py.procgen.submap_generator import SubMapGenerator
from eldoria_py.procgen.poi import POIDescriptor, POIType, WarpTarget
from eldoria_py.procgen.world_macro import WorldMacroMap
from eldoria_py.terminal.color import TrueColor
from eldoria_py.states.test_noise_map import GSNoiseMapTestScreen
from eldoria_py.combat.entities import create_default_party
from eldoria_py.core.context import Context


class TestMultiFloorCaveGeneration(unittest.TestCase):
    """Verifies floor scaling, ladder invariants, and boss placement in cave procedural generation."""

    def test_cave_floor_count_scaling(self):
        """Tests that cave depth strictly satisfies 3 <= N <= 9 across regions 1-9."""
        for reg in range(1, 10):
            for seed in (0, 42, 101, 777, 9999):
                floors_count = SubMapGenerator.calculate_cave_floors(reg, seed)
                self.assertGreaterEqual(floors_count, 3, f"Region {reg} seed {seed} below 3 floors")
                self.assertLessEqual(floors_count, 9, f"Region {reg} seed {seed} above 9 floors")

                if reg == 1:
                    self.assertEqual(floors_count, 3)
                elif reg == 2:
                    self.assertIn(floors_count, (3, 4))
                elif reg in (3, 4, 5):
                    self.assertIn(floors_count, (4, 5, 6))
                else:
                    self.assertIn(floors_count, (7, 8, 9))

    def test_ladder_invariants_per_floor(self):
        """
        Tests structural POI ladder rules:
        - Top Floor (B1F): exactly 1 Ladder Down, 0 Ladder Up, 1 Cavern Mouth Egress ('∩').
        - Middle Floors (B2F to B{N-1}F): exactly 1 Ladder Up, 1 Ladder Down (distinct tiles).
        - Bottom Floor (B{N}F): exactly 1 Ladder Up, 0 Ladder Down, and the Boss altar.
        """
        for base_reg in (1, 3, 7):
            floors, spawn_pos = SubMapGenerator.generate_cave_complex(
                name="Test Cave",
                seed=42 + base_reg,
                base_region=base_reg,
                boss_name="TestBoss",
            )
            n_floors = len(floors)
            self.assertGreaterEqual(n_floors, 3)
            self.assertLessEqual(n_floors, 9)

            # Top floor (index 0)
            top = floors[0]
            top_down_ladders = []
            top_up_ladders = []
            top_egresses = []
            for y in range(top.height):
                for x in range(top.width):
                    tile = top.tiles[y][x]
                    if "MTOLadderDown" in tile.object_listing:
                        top_down_ladders.append((x, y))
                    if "MTOLadderUp" in tile.object_listing:
                        top_up_ladders.append((x, y))
                    if tile.warp_target and tile.warp_target.is_egress:
                        top_egresses.append((x, y))

            self.assertEqual(len(top_down_ladders), 1, "Top floor must have exactly 1 Ladder Down")
            self.assertEqual(len(top_up_ladders), 0, "Top floor must have 0 Ladder Up")
            self.assertEqual(len(top_egresses), 1, "Top floor must have exactly 1 egress (cavern mouth)")
            self.assertEqual(top.tiles[top_egresses[0][1]][top_egresses[0][0]].custom_glyph, "∩")

            # Middle floors (indices 1 to n_floors - 2)
            for k in range(1, n_floors - 1):
                mid = floors[k]
                mid_down = []
                mid_up = []
                for y in range(mid.height):
                    for x in range(mid.width):
                        tile = mid.tiles[y][x]
                        if "MTOLadderDown" in tile.object_listing:
                            mid_down.append((x, y))
                        if "MTOLadderUp" in tile.object_listing:
                            mid_up.append((x, y))
                self.assertEqual(len(mid_up), 1, f"Middle floor {k} must have exactly 1 Ladder Up")
                self.assertEqual(len(mid_down), 1, f"Middle floor {k} must have exactly 1 Ladder Down")
                self.assertNotEqual(mid_up[0], mid_down[0], f"Middle floor {k} ladder up and down must be on distinct tiles")

            # Bottom floor (index n_floors - 1)
            bot = floors[-1]
            bot_down = []
            bot_up = []
            bot_boss = []
            for y in range(bot.height):
                for x in range(bot.width):
                    tile = bot.tiles[y][x]
                    if "MTOLadderDown" in tile.object_listing:
                        bot_down.append((x, y))
                    if "MTOLadderUp" in tile.object_listing:
                        bot_up.append((x, y))
                    if any(obj.startswith("Boss:") for obj in tile.object_listing):
                        bot_boss.append((x, y))

            self.assertEqual(len(bot_up), 1, "Bottom floor must have exactly 1 Ladder Up")
            self.assertEqual(len(bot_down), 0, "Bottom floor must have 0 Ladder Down")
            self.assertEqual(len(bot_boss), 1, "Bottom floor must have exactly 1 Boss altar")
            self.assertEqual(bot.tiles[bot_boss[0][1]][bot_boss[0][0]].custom_glyph, "Ω")

    def test_ladder_glyph_and_properties(self):
        """Verifies glyph '≡', colors, walkable status, and WarpTarget linkage."""
        floors, _ = SubMapGenerator.generate_cave_complex(
            name="Shadow Cavern",
            seed=123,
            base_region=2,
            boss_name="Rattus",
        )
        # Check Floor 0 Ladder Down
        top = floors[0]
        f0_down_pos = None
        for y in range(top.height):
            for x in range(top.width):
                if "MTOLadderDown" in top.tiles[y][x].object_listing:
                    f0_down_pos = (x, y)
                    break
            if f0_down_pos:
                break

        self.assertIsNotNone(f0_down_pos)
        f0_tile = top.tiles[f0_down_pos[1]][f0_down_pos[0]]
        self.assertEqual(f0_tile.custom_glyph, "≡")
        self.assertEqual(f0_tile.custom_fg, TrueColor(0xED, 0x89, 0x36))  # Amber Gold
        self.assertTrue(f0_tile.is_walkable)
        self.assertFalse(f0_tile.battle_allowed)
        self.assertEqual(f0_tile.warp_target.prompt_label, "Ladder Down (B2F)")

        # Target of Floor 0 Ladder Down should be Floor 1 Ladder Up
        f1 = floors[1]
        f1_up_pos = f0_tile.warp_target.target_pos
        self.assertIsNotNone(f1_up_pos)
        f1_tile = f1.tiles[f1_up_pos[1]][f1_up_pos[0]]
        self.assertIn("MTOLadderUp", f1_tile.object_listing)
        self.assertEqual(f1_tile.custom_glyph, "≡")
        self.assertEqual(f1_tile.custom_fg, TrueColor(0xA0, 0xAE, 0xC0))  # Slate Silver
        self.assertEqual(f1_tile.warp_target.target_pos, f0_down_pos)
        self.assertEqual(f1_tile.warp_target.prompt_label, "Ladder Up (B1F)")

    def test_boss_on_bottom_floor_only(self):
        """Verifies boss encounter is placed exclusively on the bottom floor."""
        floors, _ = SubMapGenerator.generate_cave_complex(
            name="Wyrm Cavern",
            seed=555,
            base_region=4,
            boss_name="Grumble",
        )
        # Check upper floors have no boss
        for idx in range(len(floors) - 1):
            f = floors[idx]
            for row in f.tiles:
                for tile in row:
                    for obj in tile.object_listing:
                        self.assertFalse(obj.startswith("Boss:"), f"Boss found on upper floor {idx}")

        # Check bottom floor has boss
        bot = floors[-1]
        found_boss = False
        for row in bot.tiles:
            for tile in row:
                if "Boss:Grumble" in tile.object_listing:
                    found_boss = True
                    self.assertEqual(tile.custom_glyph, "Ω")
                    self.assertEqual(tile.custom_fg, TrueColor(0xFF, 0x45, 0x00))
        self.assertTrue(found_boss, "Boss:Grumble missing from bottom floor")


class TestMultiFloorCaveExploration(unittest.TestCase):
    """Verifies state machine traversal, ladder interactions, save/load, and escape rope mechanics."""

    def setUp(self):
        self.screen = GSNoiseMapTestScreen()
        self.screen.party = create_default_party()

    def test_inter_floor_traversal(self):
        """Tests navigating down and up ladders using _handle_interact."""
        floors, spawn_pos = SubMapGenerator.generate_cave_complex(
            name="Deep Cave",
            seed=789,
            base_region=2,
            boss_name="Brigand",
        )
        poi = POIDescriptor.create_cave(
            name="Deep Cave",
            sector_coord=(0, 0),
            local_pos=(10, 10),
            spawn_pos=spawn_pos,
            boss_name="Brigand",
        )
        poi.floors = floors
        poi.current_floor = 0
        poi.sub_map = floors[0]

        # Enter cave
        self.screen.active_poi = poi
        self.screen.active_submap = floors[0]
        self.screen.player_x, self.screen.player_y = spawn_pos

        # Find Floor 0 Ladder Down tile
        f0_down = None
        for y in range(floors[0].height):
            for x in range(floors[0].width):
                if "MTOLadderDown" in floors[0].tiles[y][x].object_listing:
                    f0_down = (x, y)
                    break
            if f0_down:
                break

        # Move player to ladder down
        self.screen.player_x, self.screen.player_y = f0_down
        self.screen._handle_interact()

        # Should now be on Floor 1
        self.assertEqual(poi.current_floor, 1)
        self.assertIs(self.screen.active_submap, floors[1])
        self.assertIn("Descended to Deep Cave (B2F)", self.screen.last_status_msg)

        # Player should be positioned on Floor 1 Ladder Up
        f1_curr_tile = floors[1].tiles[self.screen.player_y][self.screen.player_x]
        self.assertIn("MTOLadderUp", f1_curr_tile.object_listing)

        # Ascend back up
        self.screen._handle_interact()
        self.assertEqual(poi.current_floor, 0)
        self.assertIs(self.screen.active_submap, floors[0])
        self.assertIn("Ascended to Deep Cave (B1F)", self.screen.last_status_msg)
        self.assertEqual((self.screen.player_x, self.screen.player_y), f0_down)

    def test_escape_rope_unlock_and_teleportation(self):
        """Tests unlocking Escape Rope POI on boss defeat and teleporting back to overworld."""
        floors, spawn_pos = SubMapGenerator.generate_cave_complex(
            name="Grumble Den",
            seed=444,
            base_region=2,
            boss_name="Grumble",
        )
        poi = POIDescriptor.create_cave(
            name="Grumble Den",
            sector_coord=(1, 1),
            local_pos=(15, 12),
            spawn_pos=spawn_pos,
            boss_name="Grumble",
        )
        poi.floors = floors
        poi.current_floor = len(floors) - 1  # Bottom floor
        poi.sub_map = floors[-1]

        bottom_map = floors[-1]
        self.screen.active_poi = poi
        self.screen.active_submap = bottom_map
        self.screen.warp_stack.append(((1, 1), (15, 12)))

        center_x = bottom_map.width // 2
        rope_x, rope_y = getattr(bottom_map, "designated_rope_pos", (center_x, 5))

        # Before boss defeat: tile is regular floor
        tile_before = bottom_map.tiles[rope_y][rope_x]
        self.assertNotIn("MTORope", tile_before.object_listing)
        self.assertNotEqual(tile_before.custom_glyph, "§")

        # Defeat boss
        self.screen.exploration_flags["boss_defeated_Grumble"] = True
        self.screen._cleanse_defeated_boss_tiles(bottom_map)

        # Rope should now be unlocked on bottom floor
        tile_after = bottom_map.tiles[rope_y][rope_x]
        self.assertIn("MTORope", tile_after.object_listing)
        self.assertEqual(tile_after.custom_glyph, "§")
        self.assertEqual(tile_after.custom_fg, TrueColor(0xD6, 0x9E, 0x2E))
        self.assertIsNotNone(tile_after.warp_target)
        self.assertTrue(tile_after.warp_target.is_egress)

        # Stand on rope tile and interact
        self.screen.player_x, self.screen.player_y = rope_x, rope_y
        self.screen._handle_interact()

        # Player should now be back on the overworld
        self.assertIsNone(self.screen.active_submap)
        self.assertIsNone(self.screen.active_poi)
        self.assertEqual(self.screen.current_sector, (1, 1))
        self.assertEqual(len(self.screen.warp_stack), 0)
        self.assertIn("Scaled the escape rope", self.screen.last_status_msg)

    def test_save_and_restore_multi_floor(self):
        """Verifies active_submap_floor is persisted and correctly restored."""
        floors, spawn_pos = SubMapGenerator.generate_cave_complex(
            name="Ancient Grotto",
            seed=888,
            base_region=3,
            boss_name="Broodfang",
        )
        poi = POIDescriptor.create_cave(
            name="Ancient Grotto",
            sector_coord=(2, 1),
            local_pos=(20, 10),
            spawn_pos=spawn_pos,
            boss_name="Broodfang",
        )
        poi.floors = floors
        poi.set_current_floor(2)  # Floor index 2 (B3F)

        # Save exploration state simulation
        self.screen.active_poi = poi
        self.screen.active_submap = poi.sub_map
        self.screen.player_x, self.screen.player_y = (18, 14)

        # Test POIDescriptor serialization/deserialization
        p_dict = poi.to_dict()
        self.assertEqual(p_dict["current_floor"], 2)
        self.assertEqual(len(p_dict["floors"]), len(floors))
        self.assertEqual(p_dict["boss_name"], "Broodfang")

        loaded_poi = POIDescriptor.from_dict(p_dict)
        self.assertEqual(loaded_poi.current_floor, 2)
        self.assertEqual(len(loaded_poi.floors), len(floors))
        self.assertEqual(loaded_poi.boss_name, "Broodfang")
        self.assertIs(loaded_poi.sub_map, loaded_poi.floors[2])

        # Test screen context restore
        new_screen = GSNoiseMapTestScreen()
        new_screen.world_macro = WorldMacroMap(seed=1, macro_width=4, macro_height=4, generate=False)
        new_screen.world_macro.all_pois = [loaded_poi]
        new_screen.world_macro.pois[loaded_poi.name] = loaded_poi

        ctx = Context()
        ctx.set("party", create_default_party())
        ctx.set("world_macro", new_screen.world_macro)
        ctx.set("exploration_state", {
            "current_sector": [2, 1],
            "player_pos": [18, 14],
            "active_submap_poi": "Ancient Grotto",
            "active_submap_floor": 2,
            "flags": {},
        })
        new_screen.enter(ctx)

        self.assertIsNotNone(new_screen.active_poi)
        self.assertEqual(new_screen.active_poi.current_floor, 2)
        self.assertEqual(new_screen.player_x, 18)
        self.assertEqual(new_screen.player_y, 14)

        # HUD header should display (B3F/NF)
        frame_lines = new_screen.generate_frame_lines()
        top_border = frame_lines[0]
        tot_floors = len(loaded_poi.floors)
        self.assertIn(f"Sub-Map: Ancient Grotto (B3F/{tot_floors}F)", top_border)

    def test_ladder_reachability(self):
        """Verifies that all ladders and key POIs on each floor are reachable via BFS."""
        for base_reg in (1, 4, 8):
            floors, spawn_pos = SubMapGenerator.generate_cave_complex(
                name="Reachability Test",
                seed=321 + base_reg,
                base_region=base_reg,
                boss_name="TestBoss",
            )
            for idx, f_map in enumerate(floors):
                w, h = f_map.width, f_map.height
                center_x = w // 2
                reachable = set(SubMapGenerator._get_connected_walkable_tiles(f_map, (center_x, h // 2)))

                # Check all ladder positions are within reachable set
                for y in range(h):
                    for x in range(w):
                        tile = f_map.tiles[y][x]
                        if "MTOLadderDown" in tile.object_listing or "MTOLadderUp" in tile.object_listing:
                            self.assertIn((x, y), reachable, f"Floor {idx} ladder at ({x},{y}) is not reachable!")

    def test_hud_telemetry_ladder_prompts(self):
        """Verifies row 2 telemetry prompts for Ladder Down, Ladder Up, and Escape Rope."""
        floors, spawn_pos = SubMapGenerator.generate_cave_complex(
            name="Prompt Cavern",
            seed=777,
            base_region=2,
            boss_name="Rattus",
        )
        poi = POIDescriptor.create_cave(
            name="Prompt Cavern",
            sector_coord=(0, 0),
            local_pos=(10, 10),
            spawn_pos=spawn_pos,
            boss_name="Rattus",
        )
        poi.floors = floors
        poi.current_floor = 0
        poi.sub_map = floors[0]

        self.screen.active_poi = poi
        self.screen.active_submap = floors[0]

        # Locate ladder down on floor 0
        f0_down = None
        for y in range(floors[0].height):
            for x in range(floors[0].width):
                if "MTOLadderDown" in floors[0].tiles[y][x].object_listing:
                    f0_down = (x, y)
                    break
            if f0_down:
                break

        self.screen.player_x, self.screen.player_y = f0_down
        lines = self.screen.generate_frame_lines()
        row2 = lines[1]
        self.assertIn("Ladder Down (B2F)", row2)
        self.assertIn("Descend", row2)

        # Move to floor 1
        poi.set_current_floor(1)
        self.screen.active_submap = floors[1]
        f1_up = None
        for y in range(floors[1].height):
            for x in range(floors[1].width):
                if "MTOLadderUp" in floors[1].tiles[y][x].object_listing:
                    f1_up = (x, y)
                    break
            if f1_up:
                break
        self.screen.player_x, self.screen.player_y = f1_up
        lines = self.screen.generate_frame_lines()
        row2 = lines[1]
        self.assertIn("Ladder Up (B1F)", row2)
        self.assertIn("Ascend", row2)

        # Move to bottom floor and unlock rope
        poi.set_current_floor(len(floors) - 1)
        self.screen.active_submap = floors[-1]
        self.screen.exploration_flags["boss_defeated_Rattus"] = True
        self.screen._ensure_bottom_floor_rope_poi(poi)

        rope_pos = getattr(floors[-1], "designated_rope_pos", (27, 5))
        self.screen.player_x, self.screen.player_y = rope_pos
        lines = self.screen.generate_frame_lines()
        row2 = lines[1]
        self.assertIn("Escape Rope", row2)
        self.assertIn("Climb to Surface", row2)

    def test_backwards_compatibility_single_floor_poi(self):
        """Verifies that deserializing a legacy single-floor POIDescriptor initializes floors list."""
        legacy_data = {
            "poi_type": "Cave",
            "name": "Legacy Cave",
            "glyph": "∩",
            "fg_color": [255, 255, 255],
            "bg_color": [0, 0, 0],
            "sector_coord": [1, 1],
            "local_pos": [10, 10],
            "spawn_pos": [27, 21],
            "description": "Old style single floor cave",
            "sub_map": Map(name="Legacy Cave", width=54, height=24).to_compact_dict(),
        }
        poi = POIDescriptor.from_dict(legacy_data)
        self.assertEqual(len(poi.floors), 1)
        self.assertEqual(poi.current_floor, 0)
        self.assertIsNotNone(poi.sub_map)
        self.assertIs(poi.floors[0], poi.sub_map)

    def test_world_macro_integration(self):
        """Verifies WorldMacroMap procedural generation places multi-floor caves."""
        macro = WorldMacroMap(
            seed=42,
            macro_width=4,
            macro_height=4,
            sector_width=54,
            sector_height=24,
            generate=True,
        )
        cave_pois = [p for p in macro.all_pois if p.poi_type == POIType.CAVE]
        self.assertGreater(len(cave_pois), 0)

        for c_poi in cave_pois:
            self.assertIsNotNone(c_poi.floors, f"Cave {c_poi.name} has no floors")
            n = len(c_poi.floors)
            self.assertGreaterEqual(n, 3, f"Cave {c_poi.name} has fewer than 3 floors ({n})")
            self.assertLessEqual(n, 9, f"Cave {c_poi.name} has more than 9 floors ({n})")
            self.assertEqual(c_poi.current_floor, 0)
            self.assertIs(c_poi.sub_map, c_poi.floors[0])

            # Bottom floor must have the boss
            bot = c_poi.floors[-1]
            found_boss = False
            for row in bot.tiles:
                for tile in row:
                    if any(obj.startswith("Boss:") for obj in tile.object_listing):
                        found_boss = True
                        break
                if found_boss:
                    break
            self.assertTrue(found_boss, f"Cave {c_poi.name} bottom floor missing boss altar!")


if __name__ == "__main__":
    unittest.main()
