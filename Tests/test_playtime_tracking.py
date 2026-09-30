"""
Comprehensive unit tests for campaign elapsed playtime tracking.
Verifies:
1. High-precision sub-second accumulation on Party.
2. Safety clamping against large anomalous jumps.
3. HH:MM:SS formatting and zero-padding.
4. Active accumulation across GSNoiseMapTestScreen, GSNvNCombatScreen, and GSMainMenuScreen.
5. Cross-state continuity through campaign transitions.
6. Save file payload and SaveSlotHeader serialization/deserialization.
"""
import unittest
from unittest.mock import MagicMock

from eldoria_py.combat.entities import Party, create_default_party, create_bat_squad
from eldoria_py.core.context import Context
from eldoria_py.core.fsm import SMState
from eldoria_py.core.save_manager import SaveManager
from eldoria_py.states.test_noise_map import GSNoiseMapTestScreen
from eldoria_py.states.combat_screen import GSNvNCombatScreen
from eldoria_py.states.main_menu_screen import GSMainMenuScreen
from eldoria_py.combat.encounters import EnemySquad
from eldoria_py.terminal.box import strip_ansi


class TestPlaytimeTracking(unittest.TestCase):
    def setUp(self):
        self.party = create_default_party()

    def test_party_subsecond_accumulation(self):
        """Verifies that 60 frames of ~0.0166s accumulate into exactly 1 second."""
        p = Party()
        self.assertEqual(p.playtime_seconds, 0)

        # 59 frames of 1/60s = 0.9833s -> still 0 seconds
        dt = 1.0 / 60.0
        for _ in range(59):
            p.add_playtime(dt)
        self.assertEqual(p.playtime_seconds, 0)

        # 60th frame pushes it over 1.0s -> exactly 1 second
        p.add_playtime(dt)
        self.assertEqual(p.playtime_seconds, 1)

        # Another 60 frames -> exactly 2 seconds
        for _ in range(60):
            p.add_playtime(dt)
        self.assertEqual(p.playtime_seconds, 2)

    def test_large_jump_safety_clamping(self):
        """Verifies that anomalous large delta_time (e.g. system sleep) is clamped to 1.0s."""
        p = Party()
        p.add_playtime(3600.0)  # 1 hour jump
        self.assertEqual(p.playtime_seconds, 1)
        self.assertAlmostEqual(p._playtime_accumulator, 0.0)

    def test_formatted_playtime_strings(self):
        """Tests HH:MM:SS zero padding and unit rollovers."""
        p = Party()
        self.assertEqual(p.formatted_playtime, "00:00:00")

        p.playtime_seconds = 59
        self.assertEqual(p.formatted_playtime, "00:00:59")

        p.playtime_seconds = 60
        self.assertEqual(p.formatted_playtime, "00:01:00")

        p.playtime_seconds = 3665
        self.assertEqual(p.formatted_playtime, "01:01:05")

        p.playtime_seconds = 86400  # 24 hours
        self.assertEqual(p.formatted_playtime, "24:00:00")

    def test_party_serialization_deserialization(self):
        """Verifies playtime_seconds round-trips through to_dict and from_dict."""
        self.party.playtime_seconds = 1234
        data = self.party.to_dict()
        self.assertEqual(data["playtime_seconds"], 1234)

        restored = Party.from_dict(data)
        self.assertEqual(restored.playtime_seconds, 1234)

    def test_noise_map_exploration_accumulates_playtime(self):
        """Verifies that GSNoiseMapTestScreen.update advances party playtime via ContextDeltaTime."""
        screen = GSNoiseMapTestScreen()
        screen.party = self.party
        screen.playtime_seconds = 10
        self.assertEqual(screen.playtime_seconds, 10)
        self.assertEqual(self.party.playtime_seconds, 10)

        context = Context([0.5, [], None])  # Index 0 is ContextDeltaTime = 0.5s
        screen.update(context)
        self.assertEqual(screen.playtime_seconds, 10)

        screen.update(context)  # Total 1.0s added
        self.assertEqual(screen.playtime_seconds, 11)
        self.assertEqual(self.party.playtime_seconds, 11)

    def test_combat_screen_accumulates_playtime(self):
        """Verifies that GSNvNCombatScreen.update advances party playtime during battles."""
        squad = create_bat_squad(size=2)
        screen = GSNvNCombatScreen(party=self.party, squad=squad)
        self.party.playtime_seconds = 50

        context = Context([0.5, [], None])
        screen.update(context)
        screen.update(context)

        self.assertEqual(self.party.playtime_seconds, 51)

    def test_main_menu_screen_accumulates_and_displays_playtime(self):
        """Verifies that GSMainMenuScreen updates playtime and displays live time in left rail telemetry."""
        menu = GSMainMenuScreen(party=self.party)
        self.party.playtime_seconds = 75  # 00:01:15

        # Check telemetry line before ticking
        left_lines = menu._render_left_rail()
        time_lines = [strip_ansi(l) for l in left_lines if "Time:" in strip_ansi(l)]
        self.assertEqual(len(time_lines), 1)
        self.assertIn("Time:    00:01:15", time_lines[0])

        # Tick 1 second in menu update
        context = Context([1.0, [], None])
        menu.update(context)

        # Check telemetry line after ticking
        self.assertEqual(menu.playtime_seconds, 76)
        self.assertEqual(self.party.playtime_seconds, 76)
        left_lines = menu._render_left_rail()
        time_lines = [strip_ansi(l) for l in left_lines if "Time:" in strip_ansi(l)]
        self.assertIn("Time:    00:01:16", time_lines[0])

    def test_cross_state_playtime_continuity(self):
        """Verifies uninterrupted playtime progression across exploration -> combat -> menu."""
        # Start exploration at 100s
        self.party.playtime_seconds = 100
        noise_map = GSNoiseMapTestScreen()
        noise_map.party = self.party

        # 1. Overworld exploration for 5 seconds
        for _ in range(5):
            noise_map.update(Context([1.0, [], None]))
        self.assertEqual(self.party.playtime_seconds, 105)

        # 2. Enter combat for 10 seconds
        squad = create_bat_squad(size=2)
        combat = GSNvNCombatScreen(party=self.party, squad=squad)
        for _ in range(10):
            combat.update(Context([1.0, [], None]))
        self.assertEqual(self.party.playtime_seconds, 115)

        # 3. Open main menu for 3 seconds
        menu = GSMainMenuScreen(party=self.party)
        menu.noise_map_screen = noise_map
        for _ in range(3):
            menu.update(Context([1.0, [], None]))
        self.assertEqual(self.party.playtime_seconds, 118)

        # 4. Resume exploration and verify noise_map is synced
        menu._resume_exploration(Context(), None)
        self.assertEqual(noise_map.playtime_seconds, 118)

    def test_save_manager_playtime_persistence(self):
        """Verifies that SaveManager records and restores exact playtime in headers and payloads."""
        import tempfile
        with tempfile.TemporaryDirectory() as tmpdir:
            sm = SaveManager(save_dir=tmpdir)
            world_macro, exploration_state = sm.create_new_game(
                slot_idx=1,
                party=self.party,
                macro_size="small",
                seed=42,
            )
            self.party.playtime_seconds = 3723  # 01:02:03

            sm.save_game(
                slot_idx=1,
                party=self.party,
                exploration_state=exploration_state,
                playtime_seconds=self.party.playtime_seconds,
                world_macro=world_macro,
            )

            # Check header
            headers = sm.list_save_slots(1)
            self.assertEqual(len(headers), 1)
            h = headers[0]
            self.assertIsNotNone(h)
            self.assertEqual(h.playtime_seconds, 3723)
            self.assertEqual(h.formatted_playtime(), "01:02:03")

            # Check loaded state
            loaded_party, _, loaded_exp = sm.load_game(1)
            self.assertEqual(loaded_exp.get("playtime_seconds"), 3723)
            self.assertEqual(loaded_party.playtime_seconds, 3723)


if __name__ == "__main__":
    unittest.main()
