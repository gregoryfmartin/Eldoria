"""
Tests for the Compass Conch item, directional POI calculations,
audio engine jingle pause/resume orchestration, and UI modal dialogues.

CRITICAL RULE: NEVER run Tests/test_audio_subsystem.py.
"""
import unittest
from unittest.mock import MagicMock, patch

from eldoria_py.combat.items import (
    get_item,
    ItemEffectType,
    ITEM_CATALOG,
)
from eldoria_py.combat.stats import TargetScope
from eldoria_py.combat.entities import Party, PartyMember, create_default_party
from eldoria_py.procgen.poi import (
    POIDescriptor,
    POIType,
    get_direction_to_poi,
    find_nearest_cave_direction,
)
from eldoria_py.procgen.npc import generate_item_shop_inventory
from eldoria_py.terminal.color import TrueColor, ColorLibrary
from eldoria_py.audio.sound_engine import AudioEngine, AudioChannel
from eldoria_py.states.test_noise_map import GSNoiseMapTestScreen
from eldoria_py.states.main_menu_screen import GSMainMenuScreen
from eldoria_py.terminal.input import KeyEvent, KeyCode


class TestCompassConchItem(unittest.TestCase):
    """Verifies item catalog definition, pricing, and shop stocking."""

    def test_item_definition(self):
        item = get_item("Compass Conch")
        self.assertIsNotNone(item)
        self.assertEqual(item.name, "Compass Conch")
        self.assertEqual(item.price, 500)
        self.assertEqual(item.sell_price, 100)
        self.assertTrue(item.consumed_on_use)
        self.assertTrue(item.usable_in_field)
        self.assertFalse(item.usable_in_battle)
        self.assertEqual(item.effect_type, ItemEffectType.LOCATE_CAVE)
        self.assertEqual(item.target_scope, TargetScope.NONE)

    def test_item_aliases(self):
        self.assertEqual(get_item("compass_conch"), get_item("Compass Conch"))
        self.assertEqual(get_item("conch"), get_item("Compass Conch"))
        self.assertEqual(get_item("compass"), get_item("Compass Conch"))

    def test_shop_inventory_stocking_all_regions(self):
        for tier in range(1, 10):
            shop_items = generate_item_shop_inventory(region_tier=tier)
            conch_entries = [i for i in shop_items if i["item_id"] == "Compass Conch"]
            self.assertEqual(len(conch_entries), 1, f"Compass Conch missing in region tier {tier}")
            self.assertEqual(conch_entries[0]["price"], 500)
            self.assertEqual(conch_entries[0]["qty"], 99)


class TestDirectionalCalculations(unittest.TestCase):
    """Verifies 8-octant trigonometry and cave distance calculations."""

    def test_eight_cardinal_and_ordinal_directions(self):
        center = (2, 2)
        # North: delta y < 0
        self.assertEqual(get_direction_to_poi(center, (2, 0)), "north")
        # South: delta y > 0
        self.assertEqual(get_direction_to_poi(center, (2, 4)), "south")
        # East: delta x > 0
        self.assertEqual(get_direction_to_poi(center, (4, 2)), "east")
        # West: delta x < 0
        self.assertEqual(get_direction_to_poi(center, (0, 2)), "west")
        # North-East: delta x > 0, delta y < 0
        self.assertEqual(get_direction_to_poi(center, (4, 0)), "north-east")
        # North-West: delta x < 0, delta y < 0
        self.assertEqual(get_direction_to_poi(center, (0, 0)), "north-west")
        # South-East: delta x > 0, delta y > 0
        self.assertEqual(get_direction_to_poi(center, (4, 4)), "south-east")
        # South-West: delta x < 0, delta y > 0
        self.assertEqual(get_direction_to_poi(center, (0, 4)), "south-west")

    def test_same_sector_tie_breaking(self):
        sector = (1, 1)
        origin_loc = (20, 20)
        self.assertEqual(get_direction_to_poi(sector, sector, origin_loc, (20, 10)), "north")
        self.assertEqual(get_direction_to_poi(sector, sector, origin_loc, (20, 30)), "south")
        self.assertEqual(get_direction_to_poi(sector, sector, origin_loc, (30, 20)), "east")
        self.assertEqual(get_direction_to_poi(sector, sector, origin_loc, (10, 20)), "west")
        self.assertEqual(get_direction_to_poi(sector, sector, origin_loc, (30, 10)), "north-east")
        self.assertEqual(get_direction_to_poi(sector, sector, origin_loc, (10, 10)), "north-west")
        self.assertEqual(get_direction_to_poi(sector, sector, origin_loc, (30, 30)), "south-east")
        self.assertEqual(get_direction_to_poi(sector, sector, origin_loc, (10, 30)), "south-west")

    def test_find_nearest_cave_direction(self):
        class MockMacro:
            def __init__(self, pois):
                self.pois = pois

        town_poi = POIDescriptor(
            poi_type=POIType.TOWN,
            name="Oakhaven",
            glyph="T",
            fg_color=ColorLibrary.AppleCyanLight,
            bg_color=ColorLibrary.Black,
            sector_coord=(1, 1),
            local_pos=(10, 10),
        )
        far_cave = POIDescriptor(
            poi_type=POIType.CAVE,
            name="Distant Grotto",
            glyph="C",
            fg_color=ColorLibrary.AppleRedLight,
            bg_color=ColorLibrary.Black,
            sector_coord=(3, 3),
            local_pos=(20, 20),
        )
        near_cave = POIDescriptor(
            poi_type=POIType.CAVE,
            name="Whispering Hollow",
            glyph="C",
            fg_color=ColorLibrary.AppleRedLight,
            bg_color=ColorLibrary.Black,
            sector_coord=(1, 0),
            local_pos=(15, 15),
        )

        world_macro = MockMacro([town_poi, far_cave, near_cave])
        # Origin sector (1, 1). Nearest cave is near_cave at (1, 0) -> North.
        direction = find_nearest_cave_direction((1, 1), world_macro, (10, 10))
        self.assertEqual(direction, "north")

        # Now test when nearest cave is south-east
        world_macro = MockMacro([town_poi, far_cave])
        direction = find_nearest_cave_direction((1, 1), world_macro, (10, 10))
        self.assertEqual(direction, "south-east")


class TestAudioEngineJingle(unittest.TestCase):
    """Verifies audio engine play_jingle pauses BGM and streams SFX."""

    @patch("eldoria_py.audio.sound_engine._emit_web_audio_event")
    @patch.object(AudioEngine, "pause_bgm")
    def test_play_jingle_pauses_bgm_and_plays_sfx(self, mock_pause, mock_web):
        engine = AudioEngine(autostart_device=False)
        engine.mixer = MagicMock()
        engine.mixer.play_sfx.return_value = 42

        handle = engine.play_jingle("Resources/BGM/Compass Conch.mp3")

        mock_pause.assert_called_once()
        self.assertEqual(handle, 42)
        engine.mixer.play_sfx.assert_called_once()
        stream_arg = engine.mixer.play_sfx.call_args[0][0]
        self.assertEqual(stream_arg.channel, AudioChannel.SFX)
        self.assertFalse(stream_arg.loop)


class TestNoiseMapConchInteraction(unittest.TestCase):
    """Verifies world map screen usage and submap restriction."""

    def setUp(self):
        self.screen = GSNoiseMapTestScreen(map_width=60, map_height=30)
        self.screen.party = create_default_party()
        self.screen.party.add_item("Compass Conch", 2)

    @patch("eldoria_py.states.test_noise_map.get_audio_engine")
    @patch("eldoria_py.states.test_noise_map.find_nearest_cave_direction")
    def test_overworld_use_compass_conch(self, mock_find_cave, mock_get_audio):
        mock_find_cave.return_value = "south-west"
        mock_audio = MagicMock()
        mock_audio.play_jingle.return_value = 99
        mock_get_audio.return_value = mock_audio

        # Player is on the overworld (active_poi is None)
        self.assertIsNone(self.screen.active_poi)
        initial_qty = self.screen.party.get_item_count("Compass Conch")

        success = self.screen.use_compass_conch()
        self.assertTrue(success)

        # Conch was consumed
        self.assertEqual(self.screen.party.get_item_count("Compass Conch"), initial_qty - 1)
        # Modal is active and not restricted
        self.assertTrue(self.screen.is_conch_modal_active)
        self.assertFalse(self.screen.conch_is_restricted)
        # Dialog contents
        self.assertEqual(self.screen.conch_dialog_text[0], "The winds have whispered…")
        self.assertEqual(self.screen.conch_dialog_text[1], "Danger lies due south-west")

        # Audio jingle played
        mock_audio.play_jingle.assert_called_once_with("Resources/BGM/Compass Conch.mp3")
        self.assertTrue(self.screen.conch_jingle_active)
        self.assertEqual(self.screen.conch_jingle_handle, 99)

        # Modal dismissal via key press resumes BGM if jingle was active
        self.screen._dismiss_conch_modal()
        self.assertFalse(self.screen.is_conch_modal_active)
        mock_audio.stop_sfx.assert_called_once_with(99)
        mock_audio.resume_bgm.assert_called_once()

    @patch("eldoria_py.states.test_noise_map.get_audio_engine")
    def test_submap_restricted_compass_conch(self, mock_get_audio):
        mock_audio = MagicMock()
        mock_get_audio.return_value = mock_audio

        # Simulate inside a town/cave/castle
        self.screen.active_poi = POIDescriptor(
            poi_type=POIType.TOWN,
            name="Test Town",
            glyph="T",
            fg_color=ColorLibrary.AppleCyanLight,
            bg_color=ColorLibrary.Black,
            sector_coord=(0, 0),
            local_pos=(5, 5),
        )
        initial_qty = self.screen.party.get_item_count("Compass Conch")

        success = self.screen.use_compass_conch()
        self.assertFalse(success)

        # Conch was NOT consumed
        self.assertEqual(self.screen.party.get_item_count("Compass Conch"), initial_qty)
        # Modal active with restriction message
        self.assertTrue(self.screen.is_conch_modal_active)
        self.assertTrue(self.screen.conch_is_restricted)
        self.assertEqual(self.screen.conch_dialog_text[0], "The winds are silent here.")
        self.assertEqual(self.screen.conch_dialog_text[1], "You cannot use that item here.")

        # Jingle not played
        mock_audio.play_jingle.assert_not_called()

        # Modal dismissal
        self.screen._dismiss_conch_modal()
        self.assertFalse(self.screen.is_conch_modal_active)


class TestMainMenuConchInteraction(unittest.TestCase):
    """Verifies main menu screen usage, rendering, and modal dismissal."""

    def setUp(self):
        self.party = create_default_party()
        self.party.add_item("Compass Conch", 2)
        self.menu = GSMainMenuScreen(party=self.party)
        self.menu.category_idx = self.menu.CATEGORIES.index("Items")

    @patch("eldoria_py.states.main_menu_screen.get_audio_engine")
    @patch("eldoria_py.states.main_menu_screen.find_nearest_cave_direction")
    def test_menu_overworld_use_compass_conch(self, mock_find_cave, mock_get_audio):
        mock_find_cave.return_value = "east"
        mock_audio = MagicMock()
        mock_audio.play_jingle.return_value = 101
        mock_get_audio.return_value = mock_audio

        mock_noise_map = MagicMock()
        mock_noise_map.active_poi = None
        mock_noise_map.world_macro = MagicMock()
        mock_noise_map.player_x = 10
        mock_noise_map.player_y = 10

        self.menu.configure_menu(
            party=self.party,
            noise_map_screen=mock_noise_map,
            sector_coords=(1, 1),
        )

        item = get_item("Compass Conch")
        initial_qty = self.party.get_item_count("Compass Conch")

        success = self.menu._use_compass_conch(item)
        self.assertTrue(success)

        # Conch consumed
        self.assertEqual(self.party.get_item_count("Compass Conch"), initial_qty - 1)
        self.assertEqual(self.menu.item_modal_mode, "CONCH_MODAL")
        self.assertEqual(self.menu.focus_mode, "MODAL")
        self.assertFalse(self.menu.conch_is_restricted)
        self.assertEqual(self.menu.conch_dialog_text[1], "Danger lies due east")

        mock_audio.play_jingle.assert_called_once_with("Resources/BGM/Compass Conch.mp3")

        # Modal render test
        rendered_lines = self.menu._render_item_modal_card()
        self.assertTrue(any("Danger lies due east" in line for line in rendered_lines))

        # Close modal with key event
        key = KeyEvent(key=KeyCode.ENTER, char="\r")
        self.menu._handle_modal_input(key, MagicMock(), MagicMock())
        self.assertEqual(self.menu.item_modal_mode, "NONE")
        self.assertEqual(self.menu.focus_mode, "SUBMENU")
        mock_audio.stop_sfx.assert_called_once_with(101)
        mock_audio.resume_bgm.assert_called_once()

    @patch("eldoria_py.states.main_menu_screen.get_audio_engine")
    def test_menu_submap_restricted_compass_conch(self, mock_get_audio):
        mock_audio = MagicMock()
        mock_get_audio.return_value = mock_audio

        mock_noise_map = MagicMock()
        mock_noise_map.active_poi = MagicMock()  # Inside submap

        self.menu.configure_menu(
            party=self.party,
            noise_map_screen=mock_noise_map,
            sector_coords=(0, 0),
        )

        item = get_item("Compass Conch")
        initial_qty = self.party.get_item_count("Compass Conch")

        success = self.menu._use_compass_conch(item)
        self.assertFalse(success)

        # Conch NOT consumed
        self.assertEqual(self.party.get_item_count("Compass Conch"), initial_qty)
        self.assertEqual(self.menu.item_modal_mode, "CONCH_MODAL")
        self.assertTrue(self.menu.conch_is_restricted)
        self.assertEqual(self.menu.conch_dialog_text[0], "The winds are silent here.")

        mock_audio.play_jingle.assert_not_called()

        # Modal render test
        rendered_lines = self.menu._render_item_modal_card()
        self.assertTrue(any("The winds are silent here." in line for line in rendered_lines))


if __name__ == "__main__":
    unittest.main()
