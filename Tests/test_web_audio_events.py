"""
Unit tests for Web Audio event emission via OSC 777 escape sequences.
Verifies that when ELDORIA_WEB_AUDIO=1 is enabled, AudioEngine emits
valid JSON payloads inside terminal OSC 777 sequences to stdout.
"""

import io
import json
import os
import re
import sys
import unittest
from unittest.mock import patch

from eldoria_py.audio.sound_engine import AudioEngine


class TestWebAudioEvents(unittest.TestCase):
    def setUp(self):
        os.environ["ELDORIA_WEB_AUDIO"] = "1"

    def tearDown(self):
        os.environ.pop("ELDORIA_WEB_AUDIO", None)

    def _extract_osc_events(self, output: str) -> list[dict]:
        """Extracts and parses all \033]777;eldoria-audio;{...}\007 payloads from stdout."""
        pattern = r"\x1b\]777;eldoria-audio;([^\x07]+)\x07"
        matches = re.findall(pattern, output)
        events = []
        for m in matches:
            try:
                events.append(json.loads(m))
            except Exception:
                pass
        return events

    def test_audio_engine_initializes_in_web_mode(self):
        engine = AudioEngine(autostart_device=True)
        self.assertTrue(engine.is_available)
        engine.cleanup()

    def test_bgm_events_emission(self):
        captured_stdout = io.StringIO()
        with patch("sys.stdout", captured_stdout):
            engine = AudioEngine(autostart_device=True)
            engine.play_bgm("Overworld", loop=True, volume=0.8)
            engine.pause_bgm()
            engine.resume_bgm()
            engine.fade_to_bgm("Battle Theme", duration_seconds=1.0)
            engine.fade_out_bgm(duration_seconds=0.5)
            engine.stop_bgm()
            engine.cleanup()

        events = self._extract_osc_events(captured_stdout.getvalue())
        actions = [e["action"] for e in events]

        self.assertIn("play_bgm", actions)
        self.assertIn("pause_bgm", actions)
        self.assertIn("resume_bgm", actions)
        self.assertIn("fade_to_bgm", actions)
        self.assertIn("fade_out_bgm", actions)
        self.assertIn("stop_bgm", actions)

        play_bgm_event = next(e for e in events if e["action"] == "play_bgm")
        self.assertEqual(play_bgm_event["track"], "Overworld")
        self.assertEqual(play_bgm_event["volume"], 0.8)
        self.assertTrue(play_bgm_event["loop"])

        fade_event = next(e for e in events if e["action"] == "fade_to_bgm")
        self.assertEqual(fade_event["track"], "Battle Theme")
        self.assertEqual(fade_event["duration"], 1.0)

    def test_sfx_and_volume_events_emission(self):
        captured_stdout = io.StringIO()
        with patch("sys.stdout", captured_stdout):
            engine = AudioEngine(autostart_device=True)
            engine.play_sfx("Attack", volume=0.7)
            engine.stop_sfx(42)
            engine.set_master_volume(0.5)
            engine.set_music_volume(0.6)
            engine.set_sfx_volume(0.9)
            engine.toggle_mute()
            engine.cleanup()

        events = self._extract_osc_events(captured_stdout.getvalue())
        actions = [e["action"] for e in events]

        self.assertIn("play_sfx", actions)
        self.assertIn("stop_sfx", actions)
        self.assertIn("set_master_volume", actions)
        self.assertIn("set_music_volume", actions)
        self.assertIn("set_sfx_volume", actions)
        self.assertIn("set_mute", actions)

        sfx_event = next(e for e in events if e["action"] == "play_sfx")
        self.assertEqual(sfx_event["sound"], "Attack")
        self.assertEqual(sfx_event["volume"], 0.7)

        vol_event = next(e for e in events if e["action"] == "set_master_volume")
        self.assertEqual(vol_event["volume"], 0.5)

    def test_multi_battle_bgm_lifecycle_state_tracking(self):
        """Verifies that in web audio mode, track state updates cleanly so pre_battle_bgm is preserved across multiple battles."""
        engine = AudioEngine(autostart_device=True)

        # 1. Start exploration on map
        engine.fade_to_bgm("World Map Smol", duration_seconds=1.5)
        current = engine.get_current_bgm()
        self.assertIsNotNone(current)
        self.assertEqual(current.name, "World Map Smol")

        # 2. Battle 1
        pre_battle_1 = engine.get_current_bgm().name
        self.assertEqual(pre_battle_1, "World Map Smol")
        engine.fade_out_bgm(duration_seconds=0.5)
        engine.play_bgm("Battle Theme")
        self.assertEqual(engine.get_current_bgm().name, "Battle Theme")
        engine.stop_bgm()
        engine.play_bgm("Battle Won")
        self.assertEqual(engine.get_current_bgm().name, "Battle Won")
        
        # Return to map after Battle 1
        engine.fade_to_bgm(pre_battle_1, duration_seconds=1.5)
        self.assertEqual(engine.get_current_bgm().name, "World Map Smol")

        # 3. Battle 2 (The bug previously occurred here because pre_battle became "Battle Won")
        pre_battle_2 = engine.get_current_bgm().name
        self.assertEqual(pre_battle_2, "World Map Smol")
        engine.fade_out_bgm(duration_seconds=0.5)
        engine.play_bgm("Battle Theme")
        self.assertEqual(engine.get_current_bgm().name, "Battle Theme")
        engine.stop_bgm()
        engine.play_bgm("Battle Won")
        self.assertEqual(engine.get_current_bgm().name, "Battle Won")

        # Return to map after Battle 2
        engine.fade_to_bgm(pre_battle_2, duration_seconds=1.5)
        self.assertEqual(engine.get_current_bgm().name, "World Map Smol")

        # 4. Battle 3
        pre_battle_3 = engine.get_current_bgm().name
        self.assertEqual(pre_battle_3, "World Map Smol")
        engine.cleanup()


if __name__ == "__main__":
    unittest.main()
