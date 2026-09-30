"""
GSInit initial state.
"""

from __future__ import annotations
from ..core.fsm import SMState
from ..core.context import Context


class GSInit(SMState):
    """
    Initial state that performs one-time initialization and transitions to the next screen.
    """

    def __init__(self) -> None:
        super().__init__(
            name="GSInit",
            on_enter=self._on_enter,
            on_exit=self._on_exit,
            on_update=self._on_update,
        )

    def _on_enter(self, context: Context) -> None:
        pass

    def _on_exit(self, context: Context) -> None:
        pass

    def _on_update(self, context: Context) -> None:
        # Trigger Ready event to transition to active screen (e.g. GSUiTestScreen)
        engine = context.engine
        if engine and engine.game_state:
            engine.game_state.trigger("Ready", context)
