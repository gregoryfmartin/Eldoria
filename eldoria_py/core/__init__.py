"""
Core engine subsystem: game loop, finite state machine, context event bus, and janitor checks.
"""

from .context import Context, ContextBroadcaster
from .fsm import SMState, SMTransition, SMStateMachine
from .janitor import Janitor, SystemCheckError
from .engine import GameCore, EldoriaCore
from .assets import (
    get_resource_dir,
    get_resource_path,
    resource_exists,
    read_resource_text,
    read_resource_bytes,
)

__all__ = [
    "Context",
    "ContextBroadcaster",
    "SMState",
    "SMTransition",
    "SMStateMachine",
    "Janitor",
    "SystemCheckError",
    "GameCore",
    "EldoriaCore",
    "get_resource_dir",
    "get_resource_path",
    "resource_exists",
    "read_resource_text",
    "read_resource_bytes",
]

