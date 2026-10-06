"""
Centralized asset and resource path resolution for Eldoria.

Supports execution across multiple environments:
1. Local development source tree (python main.py / unittest).
2. Standalone compiled binaries (Nuitka onefile / standalone).
3. System installations (/usr/local/share, ~/.local/share, or ELDORIA_RESOURCES_PATH).
4. Finder / GUI launcher launches where cwd defaults to $HOME.
"""
from __future__ import annotations

import logging
import os
import sys
from pathlib import Path
from typing import Optional

logger = logging.getLogger("eldoria.assets")


def get_resource_dir() -> Path:
    """
    Locates the canonical Resources directory across source, test,
    and compiled binary environments.

    Resolution Priority:
    1. Environment Variable: ELDORIA_RESOURCES_PATH (if set and exists)
    2. Nuitka Onefile Parent: $NUITKA_ONEFILE_BINARY
    3. Executable Directory: Canonical realpath of sys.argv[0]
    4. Python Interpreter / Binary Directory: Canonical realpath of sys.executable
    5. User & System Share Paths:
       - ~/.local/share/eldoria/Resources
       - /usr/local/share/eldoria/Resources
       - /usr/share/eldoria/Resources
    6. Current Working Directory: Path.cwd() / "Resources"
    7. Source Repository Root: relative to eldoria_py/core/assets.py

    Returns:
        Path: The resolved directory path to Resources.
    """
    candidates = []

    # 1. Environment variable override
    env_override = os.environ.get("ELDORIA_RESOURCES_PATH")
    if env_override:
        p = Path(env_override).expanduser().resolve()
        if p.is_dir():
            return p
        logger.warning("ELDORIA_RESOURCES_PATH is set to '%s' but is not a directory.", env_override)

    # 2. Nuitka onefile executable parent directory
    nuitka_binary = os.environ.get("NUITKA_ONEFILE_BINARY")
    if nuitka_binary:
        candidates.append(Path(nuitka_binary).resolve().parent / "Resources")

    # 3. Canonical directory of sys.argv[0] (handles symlinks and direct invocation)
    if sys.argv and sys.argv[0]:
        try:
            argv_path = Path(os.path.realpath(sys.argv[0])).resolve()
            candidates.append(argv_path.parent / "Resources")
        except Exception:
            pass

    # 4. Canonical directory of sys.executable (for standalone distributions)
    if sys.executable:
        try:
            exe_path = Path(os.path.realpath(sys.executable)).resolve()
            candidates.append(exe_path.parent / "Resources")
        except Exception:
            pass

    # 5. Standard user and system share paths
    candidates.append(Path.home() / ".local" / "share" / "eldoria" / "Resources")
    candidates.append(Path("/usr/local/share/eldoria/Resources"))
    candidates.append(Path("/usr/share/eldoria/Resources"))

    # 6. Current working directory
    candidates.append(Path.cwd() / "Resources")

    # 7. Source repository root (relative to eldoria_py/core/assets.py)
    candidates.append(Path(__file__).resolve().parent.parent.parent / "Resources")

    for candidate in candidates:
        try:
            if candidate.is_dir():
                return candidate
        except (PermissionError, OSError):
            continue

    # Fallback to working directory default if none found
    fallback = Path.cwd() / "Resources"
    logger.debug("Resources directory could not be found among candidates; falling back to: %s", fallback)
    return fallback


def get_resource_path(*subpaths: str) -> Path:
    """
    Returns the resolved Path to an asset or subfolder inside Resources/.

    Example:
        get_resource_path("MapData", "SampleSI.json")
        get_resource_path("BGM", "Title Theme A.wav")
    """
    return get_resource_dir().joinpath(*subpaths)


def resource_exists(*subpaths: str) -> bool:
    """
    Returns True if the specified resource exists on disk.
    Safe, non-throwing check.
    """
    try:
        return get_resource_path(*subpaths).exists()
    except (OSError, PermissionError):
        return False


def read_resource_text(*subpaths: str, encoding: str = "utf-8") -> Optional[str]:
    """
    Reads a text resource file from Resources/.
    Returns None if the file does not exist or cannot be read.
    """
    target = get_resource_path(*subpaths)
    try:
        return target.read_text(encoding=encoding)
    except Exception as exc:
        logger.warning("Failed to read text resource '%s': %s", target, exc)
        return None


def read_resource_bytes(*subpaths: str) -> Optional[bytes]:
    """
    Reads a binary resource file from Resources/.
    Returns None if the file does not exist or cannot be read.
    """
    target = get_resource_path(*subpaths)
    try:
        return target.read_bytes()
    except Exception as exc:
        logger.warning("Failed to read binary resource '%s': %s", target, exc)
        return None
