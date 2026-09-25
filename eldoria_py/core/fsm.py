"""
Finite State Machine (FSM) implementation matching Eldoria New New Engine.
"""

from __future__ import annotations
from typing import Callable, Dict, List, Optional
from .context import Context


class SMState:
    """A single state definition with lifecycle hooks."""

    ContextDeltaTime: int = 0
    ContextKeysPressed: int = 1
    ContextEldoriaCore: int = 2

    def __init__(
        self,
        name: str,
        on_enter: Optional[Callable[[Context], None]] = None,
        on_exit: Optional[Callable[[Context], None]] = None,
        on_update: Optional[Callable[[Context], None]] = None,
    ) -> None:
        self.name = name
        self.on_enter = on_enter
        self.on_exit = on_exit
        self.on_update = on_update

    def enter(self, context: Context) -> None:
        if self.on_enter is not None:
            self.on_enter(context)

    def exit(self, context: Context) -> None:
        if self.on_exit is not None:
            self.on_exit(context)

    def update(self, context: Context) -> None:
        if self.on_update is not None:
            self.on_update(context)

    def __repr__(self) -> str:
        return f"SMState(name={self.name!r})"


class SMTransition:
    """Defines a transition from one state to another triggered by an event."""

    def __init__(
        self,
        from_state: str,
        event_name: str,
        to_state: str,
        action: Optional[Callable[[Context], None]] = None,
    ) -> None:
        self.from_state = from_state
        self.event_name = event_name
        self.to_state = to_state
        self.action = action

    def __repr__(self) -> str:
        return f"SMTransition({self.from_state!r} --[{self.event_name}]--> {self.to_state!r})"


class SMStateMachine:
    """
    Finite State Machine managing current state, transitions, and update ticks.
    """

    def __init__(self, initial_state: str) -> None:
        self.current_state: str = initial_state
        self.states: Dict[str, SMState] = {}
        self.transitions: List[SMTransition] = []
        self._entered_initial: bool = False

    def add_state(self, state: SMState) -> None:
        self.states[state.name] = state

    def add_states(self, states: List[SMState]) -> None:
        for state in states:
            self.add_state(state)

    def add_transition(self, transition: SMTransition) -> None:
        self.transitions.append(transition)

    def add_transitions(self, transitions: List[SMTransition]) -> None:
        self.transitions.extend(transitions)

    def trigger(self, event_name: str, context: Optional[Context] = None) -> bool:
        ctx = context if context is not None else Context()
        for t in self.transitions:
            if t.from_state == self.current_state and t.event_name == event_name:
                # Exit current state
                current = self.states.get(self.current_state)
                if current:
                    current.exit(ctx)

                # Execute transition action if any
                if t.action:
                    t.action(ctx)

                # Enter new state
                self.current_state = t.to_state
                new_state = self.states.get(self.current_state)
                if new_state:
                    new_state.enter(ctx)
                return True
        return False

    def update(self, context: Context) -> None:
        current = self.states.get(self.current_state)
        if current:
            if not self._entered_initial:
                self._entered_initial = True
                current.enter(context)
            current.update(context)

    def get_current_state(self) -> Optional[SMState]:
        return self.states.get(self.current_state)
