"""
Context reference container and event broadcaster system.
"""

from __future__ import annotations
from typing import Any, Callable, Dict, List, Optional


class Context:
    """
    Context container passed throughout state machine updates, transitions, and UI events.
    Supports both index-based access (mirroring PowerShell References[i]) and named properties.
    """

    # Standard context index constants (matching SMState indices in New New Engine)
    DELTA_TIME: int = 0
    KEYS_PRESSED: int = 1
    ENGINE: int = 2

    def __init__(self, references: Optional[List[Any]] = None) -> None:
        self.references: List[Any] = list(references) if references is not None else []
        self.properties: Dict[str, Any] = {}

    @property
    def delta_time(self) -> float:
        if len(self.references) > self.DELTA_TIME:
            return float(self.references[self.DELTA_TIME])
        return 0.0

    @property
    def keys_pressed(self) -> list:
        if len(self.references) > self.KEYS_PRESSED:
            return self.references[self.KEYS_PRESSED]
        return []

    @property
    def engine(self) -> Any:
        if len(self.references) > self.ENGINE:
            return self.references[self.ENGINE]
        return None

    def get(self, key: int | str, default: Any = None) -> Any:
        """Safely retrieves a reference by integer index or named property by string key."""
        if isinstance(key, int):
            if 0 <= key < len(self.references):
                return self.references[key]
            return default
        return self.properties.get(str(key), default)

    def set(self, key: int | str, value: Any) -> None:
        """Sets a reference by index or named property by string key."""
        if isinstance(key, int):
            while len(self.references) <= key:
                self.references.append(None)
            self.references[key] = value
        else:
            self.properties[str(key)] = value

    def __getitem__(self, key: int | str) -> Any:
        if isinstance(key, int):
            return self.references[key]
        return self.properties[str(key)]

    def __setitem__(self, key: int | str, value: Any) -> None:
        self.set(key, value)

    def __len__(self) -> int:
        return len(self.references)

    def __repr__(self) -> str:
        return f"Context(references={self.references!r}, properties={self.properties!r})"


class ContextBroadcaster:
    """
    Pub/Sub event broadcaster for system-level and engine events.
    """

    def __init__(self) -> None:
        self._subscribers: Dict[str, List[Callable[[str, Any, Context], None]]] = {}

    def subscribe(self, event_name: str, callback: Callable[[str, Any, Context], None]) -> None:
        if event_name not in self._subscribers:
            self._subscribers[event_name] = []
        self._subscribers[event_name].append(callback)

    def unsubscribe(self, event_name: str, callback: Callable[[str, Any, Context], None]) -> None:
        if event_name in self._subscribers:
            self._subscribers[event_name] = [cb for cb in self._subscribers[event_name] if cb != callback]

    def broadcast(self, event_name: str, sender: Any, context: Optional[Context] = None) -> None:
        ctx = context if context is not None else Context()
        if event_name in self._subscribers:
            for callback in self._subscribers[event_name]:
                try:
                    callback(event_name, sender, ctx)
                except Exception as ex:
                    import sys
                    print(f"Error in subscriber for {event_name}: {ex}", file=sys.stderr)
