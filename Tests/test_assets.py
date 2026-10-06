"""
Unit tests for eldoria_py.core.assets path resolution and asset access.
"""
from __future__ import annotations

import os
import sys
import tempfile
import unittest
from pathlib import Path
from unittest.mock import patch

from eldoria_py.core.assets import (
    get_resource_dir,
    get_resource_path,
    resource_exists,
    read_resource_text,
    read_resource_bytes,
)


class TestAssets(unittest.TestCase):
    """Test suite for asset path resolution across environments."""

    def test_default_resolution_in_repo(self) -> None:
        """Verify get_resource_dir locates the existing Resources folder in repo."""
        res_dir = get_resource_dir()
        self.assertTrue(res_dir.is_dir(), f"Expected directory at {res_dir}")
        self.assertTrue((res_dir / "MapData").is_dir(), "Expected MapData subfolder in Resources")
        self.assertTrue((res_dir / "BGM").is_dir(), "Expected BGM subfolder in Resources")

    def test_get_resource_path(self) -> None:
        """Verify get_resource_path joins subpaths correctly."""
        map_path = get_resource_path("MapData")
        self.assertTrue(map_path.is_dir())

        bgm_path = get_resource_path("BGM", "Title Theme A.wav")
        self.assertTrue(bgm_path.is_file())

    def test_resource_exists(self) -> None:
        """Verify resource_exists returns True for existing and False for nonexistent assets."""
        self.assertTrue(resource_exists("MapData"))
        self.assertTrue(resource_exists("BGM", "Title Theme A.wav"))
        self.assertFalse(resource_exists("NonExistentFolder_12345"))
        self.assertFalse(resource_exists("BGM", "MissingTrack.wav"))

    def test_read_resource_text_and_bytes(self) -> None:
        """Verify read_resource_text and read_resource_bytes safely read assets."""
        # Read known SFX license text
        license_text = read_resource_text("SFX", "LICENSE.txt")
        self.assertIsNotNone(license_text)
        self.assertIn("LICENSE", license_text)

        # Read known binary audio bytes
        audio_bytes = read_resource_bytes("SFX", "Battle Intro.wav")
        self.assertIsNotNone(audio_bytes)
        self.assertTrue(audio_bytes.startswith(b"RIFF"))

        # Nonexistent files return None gracefully without raising
        self.assertIsNone(read_resource_text("Missing", "fake.txt"))
        self.assertIsNone(read_resource_bytes("Missing", "fake.bin"))

    def test_env_var_override(self) -> None:
        """Verify ELDORIA_RESOURCES_PATH takes highest precedence when set and valid."""
        with tempfile.TemporaryDirectory() as tmpdir:
            custom_res = (Path(tmpdir) / "CustomResources").resolve()
            custom_res.mkdir()
            (custom_res / "marker.txt").write_text("custom_marker", encoding="utf-8")

            with patch.dict(os.environ, {"ELDORIA_RESOURCES_PATH": str(custom_res)}):
                resolved = get_resource_dir().resolve()
                self.assertEqual(resolved, custom_res)
                self.assertTrue(resource_exists("marker.txt"))
                self.assertEqual(read_resource_text("marker.txt"), "custom_marker")

    def test_invalid_env_var_falls_back(self) -> None:
        """Verify an invalid ELDORIA_RESOURCES_PATH logs a warning and falls back."""
        with patch.dict(os.environ, {"ELDORIA_RESOURCES_PATH": "/path/that/does/not/exist_12345"}):
            resolved = get_resource_dir()
            self.assertTrue(resolved.is_dir())

    def test_simulated_nuitka_onefile_resolution(self) -> None:
        """Verify NUITKA_ONEFILE_BINARY points to an adjacent Resources directory."""
        with tempfile.TemporaryDirectory() as tmpdir:
            fake_bin = (Path(tmpdir) / "eldoria").resolve()
            fake_bin.touch()
            fake_res = (Path(tmpdir) / "Resources").resolve()
            fake_res.mkdir()
            (fake_res / "onefile_marker.txt").write_text("onefile_ok", encoding="utf-8")

            env = {"NUITKA_ONEFILE_BINARY": str(fake_bin)}
            # Clear ELDORIA_RESOURCES_PATH if present
            if "ELDORIA_RESOURCES_PATH" in os.environ:
                del env["ELDORIA_RESOURCES_PATH"]

            with patch.dict(os.environ, env, clear=False):
                resolved = get_resource_dir().resolve()
                self.assertEqual(resolved, fake_res)
                self.assertTrue(resource_exists("onefile_marker.txt"))

    def test_simulated_argv0_resolution(self) -> None:
        """Verify sys.argv[0] realpath resolution when not in Nuitka onefile mode."""
        with tempfile.TemporaryDirectory() as tmpdir:
            fake_bin = (Path(tmpdir) / "eldoria").resolve()
            fake_bin.touch()
            fake_res = (Path(tmpdir) / "Resources").resolve()
            fake_res.mkdir()
            (fake_res / "argv0_marker.txt").write_text("argv0_ok", encoding="utf-8")

            env = {k: v for k, v in os.environ.items() if k not in ("ELDORIA_RESOURCES_PATH", "NUITKA_ONEFILE_BINARY")}

            with patch.dict(os.environ, env, clear=True), patch.object(sys, "argv", [str(fake_bin)]):
                resolved = get_resource_dir().resolve()
                self.assertEqual(resolved, fake_res)
                self.assertTrue(resource_exists("argv0_marker.txt"))


    def test_simulated_finder_cwd_home(self) -> None:
        """Verify that when cwd is changed to a different directory (like $HOME in Finder),
        get_resource_dir still discovers the repo Resources via __file__ fallback."""
        with tempfile.TemporaryDirectory() as foreign_dir:
            orig_cwd = os.getcwd()
            try:
                os.chdir(foreign_dir)
                # Clear env overrides and simulate an empty/unrelated argv
                env = {k: v for k, v in os.environ.items() if k not in ("ELDORIA_RESOURCES_PATH", "NUITKA_ONEFILE_BINARY")}
                with patch.dict(os.environ, env, clear=True), patch.object(sys, "argv", ["/usr/bin/python3"]):
                    resolved = get_resource_dir()
                    self.assertTrue(resolved.is_dir())
                    self.assertTrue((resolved / "MapData").is_dir())
            finally:
                os.chdir(orig_cwd)


if __name__ == "__main__":
    unittest.main()
