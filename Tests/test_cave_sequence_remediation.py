"""
Unit and Integration Tests for Cave Out-of-Sequence Softlock Remediation:
- Step 1: Retroactive Quest Progression & Out-of-Order Cascading
- Step 2: Tiered Regional Seals & Dynamic Ward Dispelling
- Step 3: Intelligent Divination (Compass Conch Guidance & Peace State)

CRITICAL RULE: NEVER run Tests/test_audio_subsystem.py.
"""
import unittest
from unittest.mock import MagicMock, patch

from eldoria_py.combat.entities import Party, create_default_party
from eldoria_py.procgen.poi import (
    POIDescriptor,
    POIType,
    WarpTarget,
    find_nearest_cave_direction,
)
from eldoria_py.procgen.world_macro import WorldMacroMap, BOSS_CAVE_MAPPING
from eldoria_py.procgen.map_generator import Map, MapTile, BiomeType
from eldoria_py.quests.step import QuestStep, QuestStepType
from eldoria_py.quests.quest import LinearQuest
from eldoria_py.quests.questline import StorylineQuestline
from eldoria_py.quests.manager import QuestManager
from eldoria_py.quests.generator import build_storyline_questline
from eldoria_py.states.test_noise_map import GSNoiseMapTestScreen
from eldoria_py.terminal.color import TrueColor


class TestRetroactiveQuestProgression(unittest.TestCase):
    """Verifies that out-of-order boss defeats pre-credit future steps and cascade cleanly."""

    def setUp(self):
        self.party = create_default_party()

    def test_out_of_order_boss_defeat_credits_future_step(self):
        """Defeating Step 1's boss while Step 0 is active should pre-credit Step 1."""
        step0 = QuestStep("s0", "Defeat Rattus", QuestStepType.DEFEAT_ENEMY, target_name="Rattus", target_count=1)
        step1 = QuestStep("s1", "Defeat Grumble", QuestStepType.DEFEAT_ENEMY, target_name="Grumble", target_count=1)
        step2 = QuestStep("s2", "Defeat Brigand", QuestStepType.DEFEAT_ENEMY, target_name="Brigand", target_count=1)

        quest = LinearQuest("q_story", "Scourge of the Realm", steps=[step0, step1, step2])
        questline = StorylineQuestline("storyline_main", "Main Story", quests=[quest])
        qm = QuestManager(storyline=questline)
        self.party.quest_manager = qm

        # Step 0 is active initially
        self.assertEqual(quest.active_step_index, 0)
        self.assertFalse(step0.is_completed)
        self.assertFalse(step1.is_completed)

        # Defeat Grumble out of order
        self.party.record_boss_defeat("Grumble")
        qm.notify_enemy_defeated("Grumble", party=self.party)

        # Step 0 should still be active, but Step 1 is pre-credited!
        self.assertEqual(quest.active_step_index, 0)
        self.assertFalse(step0.is_completed)
        self.assertTrue(step1.is_completed)
        self.assertEqual(step1.current_progress, 1)

    def test_linear_quest_cascades_past_precompleted_steps(self):
        """When active step completes, quest should auto-cascade past pre-completed future steps."""
        step0 = QuestStep("s0", "Defeat Rattus", QuestStepType.DEFEAT_ENEMY, target_name="Rattus", target_count=1)
        step1 = QuestStep("s1", "Defeat Grumble", QuestStepType.DEFEAT_ENEMY, target_name="Grumble", target_count=1)
        step2 = QuestStep("s2", "Defeat Brigand", QuestStepType.DEFEAT_ENEMY, target_name="Brigand", target_count=1)

        quest = LinearQuest("q_story", "Scourge of the Realm", steps=[step0, step1, step2])
        questline = StorylineQuestline("storyline_main", "Main Story", quests=[quest])
        qm = QuestManager(storyline=questline)
        self.party.quest_manager = qm

        # Pre-defeat Grumble
        self.party.record_boss_defeat("Grumble")
        qm.notify_enemy_defeated("Grumble", party=self.party)
        self.assertTrue(step1.is_completed)

        # Now defeat Rattus (active Step 0)
        self.party.record_boss_defeat("Rattus")
        qm.notify_enemy_defeated("Rattus", party=self.party)

        # Step 0 is completed, and Step 1 was already completed -> cascades straight to Step 2!
        self.assertTrue(step0.is_completed)
        self.assertTrue(step1.is_completed)
        self.assertEqual(quest.active_step_index, 2)
        self.assertEqual(quest.active_step, step2)
        self.assertFalse(quest.is_completed)

    def test_reverse_order_campaign_clearing(self):
        """Defeating all bosses in completely reversed order must cleanly cascade to game completion."""
        storyline = build_storyline_questline("classic")
        quest = storyline.quests[0]
        boss_names = [s.target_name for s in quest.steps]
        self.assertEqual(boss_names, ["Rattus", "Brigand", "Broodfang"])

        qm = QuestManager(storyline=storyline)
        self.party.quest_manager = qm

        # Defeat bosses in reverse order: Broodfang, then Brigand, then Rattus
        for boss in reversed(boss_names):
            self.party.record_boss_defeat(boss)
            qm.notify_enemy_defeated(boss, party=self.party)

        # All steps should be completed and the game should be won
        for step in quest.steps:
            self.assertTrue(step.is_completed, f"Step {step.target_name} should be completed")
        self.assertTrue(quest.is_completed)
        self.assertTrue(storyline.is_completed)
        self.assertTrue(qm.is_game_completed)

    def test_party_defeated_bosses_persistence(self):
        """Party defeated_bosses set must serialize and deserialize properly."""
        self.party.record_boss_defeat("Rattus")
        self.party.record_boss_defeat("Broodfang")

        self.assertTrue(self.party.has_defeated_boss("Rattus"))
        self.assertTrue(self.party.has_defeated_boss("Broodfang"))
        self.assertFalse(self.party.has_defeated_boss("Malakor"))

        data = self.party.to_dict()
        self.assertIn("defeated_bosses", data)
        self.assertEqual(set(data["defeated_bosses"]), {"Rattus", "Broodfang"})

        reloaded = Party.from_dict(data)
        self.assertEqual(reloaded.defeated_bosses, {"Rattus", "Broodfang"})
        self.assertTrue(reloaded.has_defeated_boss("Rattus"))
        self.assertFalse(reloaded.has_defeated_boss("Malakor"))


class TestTieredCaveSeals(unittest.TestCase):
    """Verifies dungeon tier gating generation and interactive ward dispelling."""

    def test_tiered_cave_seals_generation(self):
        """WorldMacroMap must generate Tier 1 as open, and Tier 2 / 3 as sealed by wards."""
        macro = WorldMacroMap(macro_width=4, macro_height=4, seed=42, max_region=3)
        macro.generate()

        caves = [p for p in macro.all_pois if p.poi_type == POIType.CAVE]
        self.assertGreater(len(caves), 0)

        for cave in caves:
            # Look up region from BOSS_CAVE_MAPPING
            boss_info = next((b for b in BOSS_CAVE_MAPPING if b[0] == cave.boss_name), None)
            self.assertIsNotNone(boss_info, f"Unknown boss for cave {cave.name}")
            boss_reg = boss_info[1]

            if boss_reg <= 2:
                self.assertEqual(cave.cave_tier, 1)
                self.assertEqual(cave.required_tier, 0)
                self.assertFalse(cave.is_locked, f"Tier 1 cave {cave.name} should be unlocked")
            elif boss_reg <= 5:
                self.assertEqual(cave.cave_tier, 2)
                self.assertEqual(cave.required_tier, 1)
                self.assertTrue(cave.is_locked, f"Tier 2 cave {cave.name} should be sealed")
                self.assertIn("runic seal", cave.unlock_msg.lower())
            else:
                self.assertEqual(cave.cave_tier, 3)
                self.assertEqual(cave.required_tier, 2)
                self.assertTrue(cave.is_locked, f"Tier 3 cave {cave.name} should be sealed")
                self.assertIn("abyssal void ward", cave.unlock_msg.lower())

    def test_cave_ward_dispels_when_prereqs_met(self):
        """Sealed cave bars player until required tier bosses are slain, then shatters ward and enters."""
        screen = GSNoiseMapTestScreen(map_width=54, map_height=24)
        screen.party = create_default_party()

        # Mock WorldMacro with 2 Tier 1 caves and 1 Tier 2 cave
        c1 = POIDescriptor.create_cave(name="Cave 1", boss_name="Rattus", cave_tier=1, required_tier=0, is_locked=False)
        c2 = POIDescriptor.create_cave(name="Cave 2", boss_name="Grumble", cave_tier=1, required_tier=0, is_locked=False)
        c3 = POIDescriptor.create_cave(
            name="Whispering Depths",
            boss_name="Broodfang",
            cave_tier=2,
            required_tier=1,
            is_locked=True,
            unlock_msg="An ancient runic seal bars the entrance.",
        )
        dummy_submap = Map(width=10, height=10)
        c3.sub_map = dummy_submap
        c3.spawn_pos = (5, 5)

        # Place player on overworld tile with warp to c3
        overworld_map = Map(width=10, height=10)
        tile = overworld_map.tiles[2][2]
        tile.poi = c3
        tile.warp_target = WarpTarget(target_map_name=c3.name)

        class MockMacro:
            all_pois = [c1, c2, c3]
            pois = {"Whispering Depths": c3}
            sectors = [[overworld_map]]
            def get_sector(self, x, y):
                return overworld_map

        screen.world_macro = MockMacro()
        screen.sectors = [[overworld_map]]
        screen.current_sector = (0, 0)
        screen.player_x = 2
        screen.player_y = 2
        screen.active_submap = None

        # 1. Attempt entry with 0 bosses defeated -> Entry blocked, unlock message displayed
        screen._handle_interact()
        self.assertTrue(c3.is_locked)
        self.assertIsNone(screen.active_submap)
        self.assertEqual(screen.last_status_msg, c3.unlock_msg)

        # 2. Defeat 1 Tier 1 boss (threshold requires 2) -> Still blocked
        screen.party.record_boss_defeat("Rattus")
        screen._handle_interact()
        self.assertTrue(c3.is_locked)
        self.assertIsNone(screen.active_submap)

        # 3. Defeat second Tier 1 boss -> Ward shatters, cave unsealed, entered!
        screen.party.record_boss_defeat("Grumble")
        screen._handle_interact()
        self.assertFalse(c3.is_locked)
        self.assertIsNotNone(screen.active_submap)
        self.assertEqual(screen.active_poi, c3)
        self.assertIn("ancient ward shatters into ethereal sparks", screen.last_status_msg)


class TestCompassConchGuidance(unittest.TestCase):
    """Verifies that the Compass Conch skips cleared grottos and announces peace when all are cleared."""

    def test_compass_conch_skips_cleared_caves_and_prioritizes_active_tier(self):
        cave_a = POIDescriptor.create_cave(
            name="Shadowfen Cavern",
            boss_name="Rattus",
            sector_coord=(1, 1),
            cave_tier=1,
        )
        cave_b = POIDescriptor.create_cave(
            name="Duskfall Grotto",
            boss_name="Grumble",
            sector_coord=(1, 0),
            cave_tier=1,
        )
        cave_c = POIDescriptor.create_cave(
            name="Whispering Depths",
            boss_name="Broodfang",
            sector_coord=(2, 2),
            cave_tier=2,
        )

        class MockMacro:
            all_pois = [cave_a, cave_b, cave_c]

        macro = MockMacro()

        # At origin (1, 1) with 0 bosses defeated: nearest is cave_a (same sector)
        dir1 = find_nearest_cave_direction(
            origin_sector=(1, 1),
            world_macro=macro,
            origin_local=(20, 20),
            defeated_bosses=set(),
        )
        # Tie-breaker default or cardinal for (1, 1) -> (1, 1)
        self.assertIsNotNone(dir1)

        # Defeat Rattus (cleared cave_a): Conch skips cave_a and points to cave_b (north)
        dir2 = find_nearest_cave_direction(
            origin_sector=(1, 1),
            world_macro=macro,
            origin_local=(20, 20),
            defeated_bosses={"Rattus"},
        )
        self.assertEqual(dir2, "north")

        # Defeat Grumble (cleared cave_b): Tier 1 complete! Conch prioritizes Tier 2 cave_c (south-east)
        dir3 = find_nearest_cave_direction(
            origin_sector=(1, 1),
            world_macro=macro,
            origin_local=(20, 20),
            defeated_bosses={"Rattus", "Grumble"},
        )
        self.assertEqual(dir3, "south-east")

    def test_compass_conch_all_caves_cleared_shows_peace(self):
        """When all campaign bosses are slain, Conch reports tranquil peace."""
        screen = GSNoiseMapTestScreen(map_width=54, map_height=24)
        screen.party = create_default_party()
        screen.party.add_item("Compass Conch", 2)

        cave = POIDescriptor.create_cave(
            name="Shadowfen Cavern",
            boss_name="Rattus",
            sector_coord=(1, 0),
            cave_tier=1,
        )

        class MockMacro:
            all_pois = [cave]

        screen.world_macro = MockMacro()
        screen.party.record_boss_defeat("Rattus")

        with patch("eldoria_py.states.test_noise_map.get_audio_engine") as mock_audio:
            mock_engine = MagicMock()
            mock_audio.return_value = mock_engine

            success = screen.use_compass_conch()
            self.assertTrue(success)
            self.assertEqual(screen.party.get_item_count("Compass Conch"), 1)
            self.assertTrue(screen.is_conch_modal_active)
            self.assertEqual(screen.conch_dialog_text[0], "The winds whisper of peace…")
            self.assertEqual(screen.conch_dialog_text[1], "No malevolent presence stirs in the realm.")


if __name__ == "__main__":
    unittest.main()
