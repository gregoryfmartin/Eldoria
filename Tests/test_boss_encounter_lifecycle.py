"""
Unit and integration tests for boss encounter lifecycle, victory persistence,
tile cleansing, and retrigger prevention.
"""
from __future__ import annotations
import unittest

from eldoria_py.core.context import Context
from eldoria_py.core.fsm import SMState, SMStateMachine, SMTransition
from eldoria_py.procgen.map_generator import Map, MapTile, BiomeType
from eldoria_py.procgen.submap_generator import SubMapGenerator
from eldoria_py.combat.entities import create_default_party, EnemySquad
from eldoria_py.combat.encounters import create_boss_encounter
from eldoria_py.combat.engine import CombatPhase
from eldoria_py.states.combat_screen import GSNvNCombatScreen
from eldoria_py.states.test_noise_map import GSNoiseMapTestScreen
from eldoria_py.terminal.input import KeyCode, KeyEvent


class TestBossEncounterLifecycle(unittest.TestCase):
    """Test suite ensuring defeated bosses cannot re-trigger fights."""

    def setUp(self) -> None:
        self.map_screen = GSNoiseMapTestScreen(map_width=54, map_height=24)
        self.map_screen.party = create_default_party()

        # Generate a test cave with a boss
        self.cave_map, self.spawn_pos = SubMapGenerator.generate_cave(
            name="Shadowfen Cavern",
            seed=101,
            floor_level=0,
            base_region=1,
            boss_name="Rattus",
        )
        self.map_screen.active_submap = self.cave_map
        self.map_screen.player_x, self.map_screen.player_y = self.spawn_pos

        # Find the boss tile coordinates
        self.boss_x = None
        self.boss_y = None
        for y, row in enumerate(self.cave_map.tiles):
            for x, tile in enumerate(row):
                if any(obj == "Boss:Rattus" for obj in tile.object_listing):
                    self.boss_x = x
                    self.boss_y = y
                    break
            if self.boss_x is not None:
                break

        self.assertIsNotNone(self.boss_x)
        self.assertIsNotNone(self.boss_y)

        # Set up combat screen and state machine
        self.combat_screen = GSNvNCombatScreen(party=self.map_screen.party)
        self.fsm = SMStateMachine("GSNoiseMapTestScreen")
        self.fsm.add_state(self.map_screen)
        self.fsm.add_state(self.combat_screen)
        self.fsm.add_transition(SMTransition("GSNoiseMapTestScreen", "ToCombat", "GSNvNCombatScreen"))
        self.fsm.add_transition(SMTransition("GSNvNCombatScreen", "FromCombat", "GSNoiseMapTestScreen"))

        class MockCore:
            def __init__(self, game_state):
                self.game_state = game_state
                self.is_running = True

        self.mock_core = MockCore(self.fsm)

    def test_boss_tile_initial_state(self) -> None:
        """Pristine cave boss tile has Ω glyph, red coloring, and Boss:Rattus object listing."""
        boss_tile = self.cave_map.tiles[self.boss_y][self.boss_x]
        self.assertEqual(boss_tile.custom_glyph, "Ω")
        self.assertIn("Boss:Rattus", boss_tile.object_listing)
        self.assertFalse(self.map_screen.exploration_flags.get("boss_defeated_Rattus", False))

    def test_stepping_on_boss_tile_triggers_encounter(self) -> None:
        """Stepping on the boss tile when undefeated triggers combat."""
        self.map_screen.player_x = self.boss_x
        self.map_screen.player_y = self.boss_y

        ctx = Context()
        ctx.set(SMState.ContextEldoriaCore, self.mock_core)

        triggered = self.map_screen._check_step_encounter(ctx)
        self.assertTrue(triggered)
        self.assertEqual(self.map_screen.pending_boss_fight, "Rattus")
        self.assertEqual(self.combat_screen.active_boss, "Rattus")
        self.assertEqual(self.combat_screen.last_battle_result, "IN_PROGRESS")

    def test_boss_victory_cleanses_tile_and_sets_flag(self) -> None:
        """Defeating the boss sets exploration flag, victory message, and cleanses the map tile."""
        # 1. Trigger boss encounter
        self.map_screen.player_x = self.boss_x
        self.map_screen.player_y = self.boss_y
        ctx = Context()
        ctx.set(SMState.ContextEldoriaCore, self.mock_core)
        self.map_screen._check_step_encounter(ctx)

        # 2. Simulate combat victory
        self.combat_screen.engine.phase = CombatPhase.BATTLE_VICTORY
        self.combat_screen.last_battle_result = "VICTORY"

        # 3. Return to map screen
        self.map_screen.enter(ctx)

        # Assert exploration flag and victory banner
        self.assertTrue(self.map_screen.exploration_flags.get("boss_defeated_Rattus", False))
        self.assertIn("VICTORY! Rattus has been defeated!", self.map_screen.last_status_msg)
        self.assertIsNone(self.map_screen.pending_boss_fight)

        # Assert tile is cleansed
        boss_tile = self.cave_map.tiles[self.boss_y][self.boss_x]
        self.assertNotIn("Boss:Rattus", boss_tile.object_listing)
        self.assertIsNone(boss_tile.custom_glyph)
        self.assertIsNone(boss_tile.custom_fg)
        self.assertIsNone(boss_tile.custom_bg)

    def test_stepping_on_defeated_boss_tile_does_not_retrigger(self) -> None:
        """After boss is defeated, walking onto or over the boss tile does not trigger combat."""
        # Mark Rattus as defeated
        self.map_screen.exploration_flags["boss_defeated_Rattus"] = True
        self.map_screen._cleanse_defeated_boss_tiles(self.cave_map)

        # Move onto boss tile
        self.map_screen.player_x = self.boss_x
        self.map_screen.player_y = self.boss_y

        ctx = Context()
        ctx.set(SMState.ContextEldoriaCore, self.mock_core)

        triggered = self.map_screen._check_step_encounter(ctx)
        self.assertFalse(triggered)
        self.assertIsNone(self.map_screen.pending_boss_fight)

    def test_defensive_cleansing_on_uncleansed_tile_when_flag_set(self) -> None:
        """If tile still has Boss:Rattus but flag is set, _check_step_encounter cleanses and returns False."""
        self.map_screen.exploration_flags["boss_defeated_Rattus"] = True
        boss_tile = self.cave_map.tiles[self.boss_y][self.boss_x]
        # Leave tile uncleansed intentionally
        self.assertIn("Boss:Rattus", boss_tile.object_listing)

        self.map_screen.player_x = self.boss_x
        self.map_screen.player_y = self.boss_y
        ctx = Context()
        ctx.set(SMState.ContextEldoriaCore, self.mock_core)

        triggered = self.map_screen._check_step_encounter(ctx)
        self.assertFalse(triggered)
        # Verify defensive cleansing occurred
        self.assertNotIn("Boss:Rattus", boss_tile.object_listing)
        self.assertIsNone(boss_tile.custom_glyph)

    def test_fleeing_does_not_defeat_boss(self) -> None:
        """Fleeing from a boss battle does not mark boss as defeated and keeps tile intact."""
        self.map_screen.player_x = self.boss_x
        self.map_screen.player_y = self.boss_y
        ctx = Context()
        ctx.set(SMState.ContextEldoriaCore, self.mock_core)
        self.map_screen._check_step_encounter(ctx)

        # Simulate fleeing
        self.combat_screen.last_battle_result = "FLED"
        self.combat_screen.engine.phase = CombatPhase.COMMAND_PHASE

        self.map_screen.enter(ctx)

        self.assertFalse(self.map_screen.exploration_flags.get("boss_defeated_Rattus", False))
        boss_tile = self.cave_map.tiles[self.boss_y][self.boss_x]
        self.assertIn("Boss:Rattus", boss_tile.object_listing)
        self.assertEqual(boss_tile.custom_glyph, "Ω")

    def test_submap_entry_cleanses_defeated_boss(self) -> None:
        """Entering a submap automatically cleanses any bosses that were previously defeated."""
        new_cave, _ = SubMapGenerator.generate_cave(
            name="Shadowfen Cavern",
            seed=202,
            boss_name="Rattus",
        )
        self.map_screen.exploration_flags["boss_defeated_Rattus"] = True
        self.map_screen._cleanse_defeated_boss_tiles(new_cave)

        for row in new_cave.tiles:
            for tile in row:
                self.assertNotIn("Boss:Rattus", tile.object_listing)
                self.assertNotEqual(tile.custom_glyph, "Ω")


if __name__ == "__main__":
    unittest.main()
