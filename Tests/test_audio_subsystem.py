"""
Unit and integration tests for the Eldoria Audio Subsystem.
Tests streaming audio playback, BGM tracking, polyphonic SFX tracking,
volume hierarchy, crossfading transitions, and headless fallback.
"""

from __future__ import annotations

import array
import os
import unittest
from pathlib import Path
from unittest.mock import MagicMock, patch

from eldoria_py.audio import (
    AudioChannel,
    AudioEngine,
    AudioStream,
    AudioTrackInfo,
    MasterMixer,
    PlaybackState,
    get_audio_engine,
    resolve_audio_path,
)


class TestAudioAssets(unittest.TestCase):
    """Verifies external asset resolution for BGM and SFX across MP3 and WAV."""

    def test_resolve_existing_bgm_wav(self):
        path = resolve_audio_path("BGM", "Battle Theme A")
        self.assertIsNotNone(path)
        self.assertTrue(path.is_file())
        self.assertEqual(path.name, "Battle Theme A.wav")

    def test_resolve_existing_bgm_mp3(self):
        path = resolve_audio_path("BGM", "Title")
        self.assertIsNotNone(path)
        self.assertTrue(path.is_file())
        self.assertEqual(path.name, "Title.mp3")

    def test_resolve_existing_sfx_wav(self):
        path = resolve_audio_path("SFX", "UI Chevron Move")
        self.assertIsNotNone(path)
        self.assertTrue(path.is_file())
        self.assertEqual(path.name, "UI Chevron Move.wav")

    def test_resolve_with_explicit_extension(self):
        path = resolve_audio_path("SFX", "UI Selection Valid.wav")
        self.assertIsNotNone(path)
        self.assertTrue(path.is_file())

    def test_resolve_non_existent_returns_none(self):
        self.assertIsNone(resolve_audio_path("BGM", "NonExistentSong12345"))
        self.assertIsNone(resolve_audio_path("SFX", "FakeSFX999"))


class TestAudioStream(unittest.TestCase):
    """Verifies AudioStream frame chunk reading, looping, and state transitions."""

    def setUp(self):
        self.bgm_path = resolve_audio_path("BGM", "Battle Theme A")
        self.sfx_path = resolve_audio_path("SFX", "UI Chevron Move")

    def test_stream_metadata_and_initial_state(self):
        stream = AudioStream(self.bgm_path, loop=True, volume=0.8)
        self.assertEqual(stream.state, PlaybackState.PLAYING)
        self.assertEqual(stream.volume, 0.8)
        self.assertTrue(stream.duration_seconds > 0)
        self.assertTrue(stream.total_frames > 0)
        info = stream.get_info()
        self.assertEqual(info.name, "Battle Theme A")
        self.assertEqual(info.channel, AudioChannel.MUSIC)
        self.assertEqual(info.state, PlaybackState.PLAYING)
        stream.stop()

    def test_stream_read_frames(self):
        stream = AudioStream(self.sfx_path, loop=False, volume=1.0)
        chunk = stream.read_frames(512)
        self.assertIsNotNone(chunk)
        self.assertEqual(len(chunk), 1024)  # 512 frames * 2 channels
        self.assertEqual(stream.frames_played, 512)
        stream.stop()

    def test_stream_pause_and_resume(self):
        stream = AudioStream(self.bgm_path, loop=True)
        stream.pause()
        self.assertEqual(stream.state, PlaybackState.PAUSED)
        self.assertIsNone(stream.read_frames(512))

        stream.resume()
        self.assertEqual(stream.state, PlaybackState.PLAYING)
        chunk = stream.read_frames(512)
        self.assertIsNotNone(chunk)
        stream.stop()

    def test_stream_non_looping_stops_at_eof(self):
        stream = AudioStream(self.sfx_path, loop=False)
        total_read = 0
        guard = 0
        while stream.state == PlaybackState.PLAYING:
            guard += 1
            if guard > 100:
                self.fail("Infinite loop reading non-looping stream")
            chunk = stream.read_frames(2048)
            if chunk:
                total_read += len(chunk) // 2

        self.assertEqual(stream.state, PlaybackState.STOPPED)
        self.assertTrue(total_read > 0)


class TestMasterMixer(unittest.TestCase):
    """Verifies MasterMixer real-time mixing, saturation clipping, and crossfades."""

    def setUp(self):
        self.mixer = MasterMixer()
        self.bgm1_path = resolve_audio_path("BGM", "Battle Theme A")
        self.bgm2_path = resolve_audio_path("BGM", "Player Setup Theme A")
        self.sfx_path = resolve_audio_path("SFX", "UI Chevron Move")

    def test_initial_mixer_state(self):
        self.assertEqual(self.mixer.master_volume, 1.0)
        self.assertEqual(self.mixer.music_volume, 0.8)
        self.assertEqual(self.mixer.sfx_volume, 1.0)
        self.assertFalse(self.mixer.is_muted)
        self.assertIsNone(self.mixer.get_current_bgm_info())
        self.assertEqual(len(self.mixer.get_playing_sfx_info()), 0)

    def test_play_and_track_bgm(self):
        stream = AudioStream(self.bgm1_path, loop=True, volume=0.7)
        self.mixer.play_bgm(stream)
        info = self.mixer.get_current_bgm_info()
        self.assertIsNotNone(info)
        self.assertEqual(info.name, "Battle Theme A")
        self.assertEqual(info.state, PlaybackState.PLAYING)

        rendered = self.mixer.render_frames(256)
        self.assertEqual(len(rendered), 512)
        self.mixer.stop_bgm()
        self.assertIsNone(self.mixer.get_current_bgm_info())

    def test_play_and_track_sfx(self):
        stream = AudioStream(self.sfx_path, loop=False, volume=1.0)
        handle = self.mixer.play_sfx(stream)
        self.assertIsInstance(handle, int)
        self.assertTrue(self.mixer.is_sfx_playing(handle))

        sfx_list = self.mixer.get_playing_sfx_info()
        self.assertEqual(len(sfx_list), 1)
        self.assertEqual(sfx_list[0].handle_id, handle)

        self.mixer.stop_sfx(handle)
        self.assertFalse(self.mixer.is_sfx_playing(handle))

    def test_crossfade_transitions_cleanly(self):
        s1 = AudioStream(self.bgm1_path, loop=True, volume=1.0)
        s2 = AudioStream(self.bgm2_path, loop=True, volume=1.0)
        self.mixer.play_bgm(s1)

        fade_duration = 0.05  # 50ms for fast test execution (2205 frames)
        self.mixer.start_crossfade(s2, duration_seconds=fade_duration)
        self.assertEqual(self.mixer.fade_mode, "crossfade")

        total_frames = int(fade_duration * 44100) + 512
        frames_pumped = 0
        guard = 0
        while frames_pumped < total_frames and self.mixer.fade_mode is not None:
            guard += 1
            if guard > 50:
                self.fail("Crossfade did not finish within guard limit")
            self.mixer.render_frames(512)
            frames_pumped += 512

        self.assertIsNone(self.mixer.fade_mode)
        curr = self.mixer.get_current_bgm_info()
        self.assertIsNotNone(curr)
        self.assertEqual(curr.name, "Player Setup Theme A")

    def test_render_muted_outputs_silence(self):
        stream = AudioStream(self.bgm1_path, loop=True)
        self.mixer.play_bgm(stream)
        self.mixer.toggle_mute()
        self.assertTrue(self.mixer.is_muted)

        rendered = self.mixer.render_frames(512)
        self.assertTrue(all(x == 0 for x in rendered))


class TestAudioEngineFacade(unittest.TestCase):
    """Verifies AudioEngine high-level facade and volume controls."""

    def setUp(self):
        # Run in headless mode (no real device opened) for isolated unit testing
        self.engine = AudioEngine(autostart_device=False)

    def tearDown(self):
        self.engine.cleanup()

    def test_volume_controls(self):
        self.engine.set_master_volume(0.65)
        self.assertEqual(self.engine.get_master_volume(), 0.65)

        self.engine.adjust_master_volume(0.1)
        self.assertEqual(round(self.engine.get_master_volume(), 2), 0.75)

        self.engine.set_music_volume(0.5)
        self.assertEqual(self.engine.get_music_volume(), 0.5)

        self.engine.set_sfx_volume(0.9)
        self.assertEqual(self.engine.get_sfx_volume(), 0.9)

    def test_bgm_lifecycle(self):
        ok = self.engine.play_bgm("Battle Theme A", loop=True)
        self.assertTrue(ok)
        bgm = self.engine.get_current_bgm()
        self.assertIsNotNone(bgm)
        self.assertEqual(bgm.name, "Battle Theme A")

        self.engine.pause_bgm()
        self.assertEqual(self.engine.get_current_bgm().state, PlaybackState.PAUSED)

        self.engine.resume_bgm()
        self.assertEqual(self.engine.get_current_bgm().state, PlaybackState.PLAYING)

        self.engine.stop_bgm()
        self.assertIsNone(self.engine.get_current_bgm())

    def test_sfx_lifecycle(self):
        handle = self.engine.play_sfx("UI Chevron Move")
        self.assertIsNotNone(handle)
        self.assertTrue(self.engine.is_sfx_playing(handle))

        self.engine.stop_sfx(handle)
        self.assertFalse(self.engine.is_sfx_playing(handle))


if __name__ == "__main__":
    unittest.main()
