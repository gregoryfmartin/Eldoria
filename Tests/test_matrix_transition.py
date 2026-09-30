"""
Comprehensive unit and integration tests for GSMatrixTransitionScreen.
Verifies:
1. Visible width invariance of all wipe shade blocks (█, ▓, ▒, ░, ' ').
2. Buffer dimension coverage across all 80 columns and 40 rows.
3. Horizontal wipe progression (left-to-right) and lifecycle: DISSOLVE (~0.40s) -> HOLD_BLACK (0.75s) -> FINISHED.
4. Input swallowing: keyboard events are cleared every frame.
5. End-to-end FSM routing from GSNoiseMapTestScreen to GSNvNCombatScreen.
6. End-to-end FSM routing from GSNvNCombatScreen (Victory/Defeat) to GSNoiseMapTestScreen.
7. Safe boundary rendering across all 40 rows without line wrapping.
"""

from __future__ import annotations
import unittest
from unittest.mock import MagicMock

from eldoria_py.core.context import Context
from eldoria_py.core.fsm import SMStateMachine, SMState, SMTransition
from eldoria_py.combat.entities import create_default_party
from eldoria_py.combat.encounters import generate_encounter
from eldoria_py.combat.engine import CombatPhase
from eldoria_py.states.matrix_transition import GSMatrixTransitionScreen, WIPE_SHADE_BLOCKS, MATRIX_GLYPHS
from eldoria_py.states.test_noise_map import GSNoiseMapTestScreen
from eldoria_py.states.combat_screen import GSNvNCombatScreen
from eldoria_py.terminal.box import visible_width
from eldoria_py.terminal.input import KeyCode, KeyEvent


class TestMatrixTransition(unittest.TestCase):
    """Test suite for horizontal white bar wipe battle transition."""

    def setUp(self) -> None:
        self.transition = GSMatrixTransitionScreen(
            screen_width=80,
            screen_height=40,
            dissolve_duration=0.40,
            black_hold_duration=0.75,
        )
        self.mock_core = MagicMock()
        self.mock_game_state = MagicMock()
        self.mock_core.game_state = self.mock_game_state
        self.context = Context([0.016, [], self.mock_core])

    def test_glyph_visible_width_invariance(self) -> None:
        """All shading blocks must have strictly visible_width == 1 to prevent layout wrapping."""
        self.assertIn("█", WIPE_SHADE_BLOCKS)
        self.assertIn("▓", WIPE_SHADE_BLOCKS)
        self.assertIn("▒", WIPE_SHADE_BLOCKS)
        self.assertIn("░", WIPE_SHADE_BLOCKS)
        self.assertIn(" ", WIPE_SHADE_BLOCKS)
        for char in WIPE_SHADE_BLOCKS:
            self.assertEqual(
                visible_width(char),
                1,
                f"Block '{char}' (U+{ord(char):04X}) has width {visible_width(char)}, expected 1",
            )

    def test_initialization_and_buffer_dimensions(self) -> None:
        """Verifies full 80x40 allowable buffer coverage and dynamic configuration."""
        self.assertEqual(self.transition.screen_width, 80)
        self.assertEqual(self.transition.screen_height, 40)
        self.assertAlmostEqual(self.transition.dissolve_duration, 0.40)
        self.assertAlmostEqual(self.transition.black_hold_duration, 0.75)

        # Enforces minimum 80x40 even if smaller values are requested
        small_trans = GSMatrixTransitionScreen(screen_width=50, screen_height=20)
        self.assertEqual(small_trans.screen_width, 80)
        self.assertEqual(small_trans.screen_height, 40)

        sample_lines = ["Line 1", "Line 2"]
        self.transition.configure(
            source_lines=sample_lines,
            target_event="CustomEvent",
            target_state="CustomState",
            dissolve_duration=0.30,
            black_hold_duration=0.50,
        )
        self.assertEqual(self.transition.source_lines, sample_lines)
        self.assertEqual(self.transition.target_event, "CustomEvent")
        self.assertEqual(self.transition.target_state, "CustomState")
        self.assertAlmostEqual(self.transition.dissolve_duration, 0.30)
        self.assertAlmostEqual(self.transition.black_hold_duration, 0.50)

    def test_horizontal_wipe_progression_timing(self) -> None:
        """
        Verifies horizontal sweep from left to right, 0.75s HOLD_BLACK, and FINISHED triggering.
        """
        self.transition.configure(
            source_lines=["Test row " * 8 for _ in range(24)],
            target_event="EnterCombat",
            target_state="GSNvNCombatScreen",
            dissolve_duration=0.40,
            black_hold_duration=0.75,
        )
        self.transition.enter(self.context)
        self.assertEqual(self.transition.phase, "DISSOLVE")
        self.assertEqual(self.transition.head_x, -1.0)
        self.assertEqual(len(self.transition.source_grid), 40)

        # 1. Update during DISSOLVE phase: head_x advances to the right
        self.context.set(SMState.ContextDeltaTime, 0.10)
        self.transition.update(self.context)
        self.assertEqual(self.transition.phase, "DISSOLVE")
        self.assertGreater(self.transition.head_x, 0.0)
        self.mock_game_state.trigger.assert_not_called()

        # 2. Advance time until head_x completely crosses column 79 and trail exits
        self.context.set(SMState.ContextDeltaTime, 0.50)
        self.transition.update(self.context)
        self.assertEqual(self.transition.phase, "HOLD_BLACK")
        self.assertAlmostEqual(self.transition.black_elapsed, 0.0)
        self.mock_game_state.trigger.assert_not_called()

        # 3. During HOLD_BLACK phase: 0.5s passed, still holding black
        self.context.set(SMState.ContextDeltaTime, 0.50)
        self.transition.update(self.context)
        self.assertEqual(self.transition.phase, "HOLD_BLACK")
        self.assertAlmostEqual(self.transition.black_elapsed, 0.50)
        self.mock_game_state.trigger.assert_not_called()

        # 4. Another 0.30s passed (total 0.80s >= 0.75s): triggers target event!
        self.context.set(SMState.ContextDeltaTime, 0.30)
        self.transition.update(self.context)
        self.assertEqual(self.transition.phase, "FINISHED")
        self.mock_game_state.trigger.assert_called_once_with("EnterCombat", self.context)

    def test_buffer_coverage_all_40_rows(self) -> None:
        """Confirms that 24-row inputs are expanded to 40 rows and all 40 rows are swept."""
        source_24 = [f"Row {r:02d}: " + ("x" * 60) for r in range(24)]
        self.transition.configure(source_lines=source_24)
        self.transition.enter(self.context)

        # Source grid must have exactly 40 rows, each 80 characters wide
        self.assertEqual(len(self.transition.source_grid), 40)
        for r in range(40):
            self.assertEqual(len(self.transition.source_grid[r]), 80)
            if r >= 24:
                # Rows 25..40 are blank padded
                self.assertEqual(self.transition.source_grid[r], [" "] * 80)

        # Render frame without error across all 40 rows
        self.transition._render_frame()

    def test_input_swallowing(self) -> None:
        """All user keystrokes during DISSOLVE and HOLD_BLACK must be discarded."""
        self.transition.configure(
            target_event="EnterCombat",
            dissolve_duration=0.40,
            black_hold_duration=0.75,
        )
        self.transition.enter(self.context)

        # Feed key during DISSOLVE
        keys = [KeyEvent(key=KeyCode.ENTER, char="\r")]
        self.context.set(SMState.ContextKeysPressed, keys)
        self.transition.update(self.context)
        self.assertEqual(len(keys), 0, "Keys must be swallowed during DISSOLVE")

        # Force phase to HOLD_BLACK
        self.transition.phase = "HOLD_BLACK"
        keys = [KeyEvent(key=KeyCode.SPACE, char=" "), KeyEvent(key=KeyCode.CHAR, char="a")]
        self.context.set(SMState.ContextKeysPressed, keys)
        self.transition.update(self.context)
        self.assertEqual(len(keys), 0, "Keys must be swallowed during HOLD_BLACK")

    def test_fsm_noise_map_to_combat_end_to_end(self) -> None:
        """
        End-to-end integration: GSNoiseMapTestScreen encounter triggers GSMatrixTransitionScreen,
        which sweeps horizontally and enters GSNvNCombatScreen.
        """
        party = create_default_party()
        noise_screen = GSNoiseMapTestScreen(map_width=54, map_height=24)
        noise_screen.party = party
        combat_screen = GSNvNCombatScreen()
        trans_screen = GSMatrixTransitionScreen(screen_width=80, screen_height=40)

        fsm = SMStateMachine("GSNoiseMapTestScreen")
        fsm.add_state(noise_screen)
        fsm.add_state(trans_screen)
        fsm.add_state(combat_screen)

        fsm.add_transition(SMTransition("GSNoiseMapTestScreen", "ToCombat", "GSMatrixTransitionScreen"))
        fsm.add_transition(SMTransition("GSMatrixTransitionScreen", "EnterCombat", "GSNvNCombatScreen"))

        mock_core = MagicMock()
        mock_core.game_state = fsm
        ctx = Context([0.016, [], mock_core])

        # Force encounter trigger on map
        curr_map = noise_screen._current_map()
        tile = curr_map.tiles[noise_screen.player_y][noise_screen.player_x]
        tile.battle_allowed = True
        tile.encounter_rate = 1.0
        tile.region_code = 1
        noise_screen.steps_since_battle = 10

        triggered = noise_screen._check_step_encounter(ctx)
        self.assertTrue(triggered)

        # FSM should now be in GSMatrixTransitionScreen
        self.assertEqual(fsm.current_state, "GSMatrixTransitionScreen")
        self.assertEqual(trans_screen.target_event, "EnterCombat")
        self.assertGreater(len(trans_screen.source_lines), 0)

        # Run through transition dissolution and 0.75s black hold
        trans_screen.enter(ctx)
        ctx.set(SMState.ContextDeltaTime, 1.0)
        fsm.update(ctx)  # Wipes and moves to HOLD_BLACK
        self.assertEqual(trans_screen.phase, "HOLD_BLACK")

        ctx.set(SMState.ContextDeltaTime, 0.8)
        fsm.update(ctx)  # Finishes hold and triggers EnterCombat
        self.assertEqual(fsm.current_state, "GSNvNCombatScreen")

    def test_fsm_combat_victory_to_noise_map_end_to_end(self) -> None:
        """
        End-to-end integration: GSNvNCombatScreen victory exits to GSMatrixTransitionScreen,
        which sweeps horizontally and returns to GSNoiseMapTestScreen.
        """
        party = create_default_party()
        noise_screen = GSNoiseMapTestScreen(map_width=54, map_height=24)
        noise_screen.party = party
        combat_screen = GSNvNCombatScreen()
        trans_screen = GSMatrixTransitionScreen(screen_width=80, screen_height=40)

        fsm = SMStateMachine("GSNvNCombatScreen")
        fsm.add_state(noise_screen)
        fsm.add_state(trans_screen)
        fsm.add_state(combat_screen)

        fsm.add_transition(SMTransition("GSNvNCombatScreen", "FromCombat", "GSMatrixTransitionScreen"))
        fsm.add_transition(SMTransition("GSMatrixTransitionScreen", "EnterNoiseMap", "GSNoiseMapTestScreen"))

        mock_core = MagicMock()
        mock_core.game_state = fsm

        # Start combat and simulate victory
        squad = generate_encounter(1)
        combat_screen.start_encounter(party, squad)
        combat_screen.engine.phase = CombatPhase.BATTLE_VICTORY

        # Press Enter on victory screen
        keys = [KeyEvent(key=KeyCode.ENTER, char="\r")]
        ctx = Context([0.016, keys, mock_core])
        combat_screen.update(ctx)

        # FSM should now be in GSMatrixTransitionScreen
        self.assertEqual(fsm.current_state, "GSMatrixTransitionScreen")
        self.assertEqual(trans_screen.target_event, "EnterNoiseMap")

        # Run through transition
        trans_screen.enter(ctx)
        ctx.set(SMState.ContextDeltaTime, 1.0)
        fsm.update(ctx)
        self.assertEqual(trans_screen.phase, "HOLD_BLACK")

        ctx.set(SMState.ContextDeltaTime, 0.8)
        fsm.update(ctx)
        self.assertEqual(fsm.current_state, "GSNoiseMapTestScreen")

    def test_generate_frame_lines_support(self) -> None:
        """Verifies generate_frame_lines() method on both map and combat screens."""
        noise_screen = GSNoiseMapTestScreen(map_width=54, map_height=24)
        lines = noise_screen.generate_frame_lines()
        self.assertGreater(len(lines), 20)
        self.assertIn("World Map", lines[0])

        combat_screen = GSNvNCombatScreen()
        party = create_default_party()
        squad = generate_encounter(1)
        combat_screen.start_encounter(party, squad)
        c_lines = combat_screen.generate_frame_lines()
        self.assertEqual(len(c_lines), 24)
        self.assertIn("ENEMY SQUAD", c_lines[0])


if __name__ == "__main__":
    unittest.main()
