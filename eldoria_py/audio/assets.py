"""
Asset path resolution for Eldoria audio resources.
Supports external assets outside the game binary and dual MP3/WAV formats.
"""

from __future__ import annotations

import logging
from pathlib import Path
from typing import Optional, Union

from eldoria_py.core.assets import get_resource_path

logger = logging.getLogger("eldoria.audio.assets")

SUPPORTED_EXTENSIONS = (".mp3", ".wav", ".ogg", ".flac")


def resolve_audio_path(category: str, name_or_path: Union[str, Path]) -> Optional[Path]:
    """
    Resolves an audio asset path within Resources/<category>/ or absolute filesystem.
    
    Resolution Priority:
    1. Direct filesystem check if name_or_path points to an existing file.
    2. Exact filename match inside Resources/<category>/.
    3. Supported extension search prioritizing .mp3, then .wav.
    
    Args:
        category: "BGM" or "SFX"
        name_or_path: Track name (e.g. "Title Theme A") or file path.
        
    Returns:
        Path if resolved and exists, None otherwise.
    """
    p = Path(name_or_path)
    if p.is_file():
        return p.resolve()

    # Check exact match inside category directory
    exact = get_resource_path(category, str(p))
    if exact.is_file():
        return exact

    # Stem-based search prioritizing .mp3, then .wav
    stem = p.stem
    for ext in SUPPORTED_EXTENSIONS:
        cand = get_resource_path(category, f"{stem}{ext}")
        if cand.is_file():
            return cand

    logger.debug("Could not resolve audio asset '%s' under category '%s'", name_or_path, category)
    return None
