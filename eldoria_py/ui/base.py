"""
UIBase: Base component for all interactive and visual UI elements in Eldoria.
"""

from __future__ import annotations
from typing import Any, Callable, Dict, List, Optional, Union
from ..core.context import Context
from ..core.fsm import SMState, SMTransition, SMStateMachine
from ..terminal.ansi import ATString, ATCoordinates, ATDecoration
from ..terminal.color import TrueColor


class SMUiElementStateMachine(SMStateMachine):
    """FSM for individual UI elements managing Init, Inactive, Active, Focused, Deinit."""

    def __init__(self, owner: UIBase) -> None:
        super().__init__("SMUiElementInit")
        self.owner = owner

        # Define element states
        init_state = SMState(
            "SMUiElementInit",
            on_exit=lambda ctx: self.owner.publish("SMUiElementInit_OnExit", ctx),
            on_update=lambda ctx: self.owner.publish("SMUiElementInit_OnUpdate", ctx),
        )
        inactive_state = SMState(
            "SMUiElementInactive",
            on_enter=lambda ctx: self.owner.publish("SMUiElementInactive_OnEnter", ctx),
            on_exit=lambda ctx: self.owner.publish("SMUiElementInactive_OnExit", ctx),
            on_update=lambda ctx: self.owner.publish("SMUiElementInactive_OnUpdate", ctx),
        )
        active_state = SMState(
            "SMUiElementActive",
            on_enter=lambda ctx: self.owner.publish("SMUiElementActive_OnEnter", ctx),
            on_exit=lambda ctx: self.owner.publish("SMUiElementActive_OnExit", ctx),
            on_update=lambda ctx: self.owner.publish("SMUiElementActive_OnUpdate", ctx),
        )
        focused_state = SMState(
            "SMUiElementFocused",
            on_enter=lambda ctx: self.owner.publish("SMUiElementFocused_OnEnter", ctx),
            on_exit=lambda ctx: self.owner.publish("SMUiElementFocused_OnExit", ctx),
            on_update=lambda ctx: self.owner.publish("SMUiElementFocused_OnUpdate", ctx),
        )
        deinit_state = SMState(
            "SMUiElementDeinit",
            on_enter=lambda ctx: self.owner.publish("SMUiElementDeinit_OnEnter", ctx),
            on_exit=lambda ctx: self.owner.publish("SMUiElementDeinit_OnExit", ctx),
            on_update=lambda ctx: self.owner.publish("SMUiElementDeinit_OnUpdate", ctx),
        )

        self.add_states([init_state, inactive_state, active_state, focused_state, deinit_state])

        # Define transitions
        self.add_transitions([
            SMTransition("SMUiElementInit", "Ready", "SMUiElementInactive"),
            SMTransition("SMUiElementInit", "Activate", "SMUiElementActive"),
            SMTransition("SMUiElementInactive", "Activate", "SMUiElementActive"),
            SMTransition("SMUiElementActive", "Deactivate", "SMUiElementInactive"),
            SMTransition("SMUiElementActive", "Focus", "SMUiElementFocused"),
            SMTransition("SMUiElementFocused", "Unfocus", "SMUiElementActive"),
            SMTransition("SMUiElementInactive", "Focus", "SMUiElementFocused"),
            SMTransition("SMUiElementFocused", "Deactivate", "SMUiElementInactive"),
            SMTransition("SMUiElementInactive", "Destroy", "SMUiElementDeinit"),
            SMTransition("SMUiElementActive", "Destroy", "SMUiElementDeinit"),
            SMTransition("SMUiElementFocused", "Destroy", "SMUiElementDeinit"),
        ])


class UIElementBehavior:
    """Encapsulates common state flags for UI elements."""

    def __init__(self) -> None:
        self.can_have_focus: bool = False
        self.has_focus: bool = False
        self.active: bool = False
        self.group_identifier: str = ""


class UIBase(ATString):
    """
    Base class for all UI elements. Combines formatted string output with an
    internal lifecycle FSM, pub/sub event dispatching, and dirty-rect tracking.
    """

    def __init__(
        self,
        text: str = "",
        coordinates: Optional[ATCoordinates] = None,
        fg_color: Optional[TrueColor] = None,
        bg_color: Optional[TrueColor] = None,
        decorations: Optional[ATDecoration] = None,
    ) -> None:
        super().__init__(text, coordinates, fg_color, bg_color, decorations)
        self.user_data: str = text
        self.blank: str = " " * len(text) if text else " "
        self.dirty: bool = True
        self.behavior: UIElementBehavior = UIElementBehavior()
        self.state_events: Dict[str, List[Callable[[Context], None]]] = {}
        self.base_state_machine: SMUiElementStateMachine = SMUiElementStateMachine(self)

        # Move to Ready / Inactive state by default
        self.base_state_machine.trigger("Ready", Context([self]))

    def set_user_data(self, data: str) -> None:
        """Sets the display text and adjusts blank erase buffer."""
        if data is not None:
            if len(self.blank) < len(data):
                self.set_blank_size(len(data))
            self.user_data = data
            self.text = data
            self.dirty = True

    def set_blank_size(self, size: int) -> None:
        if size <= 0:
            self.blank = " "
        else:
            self.blank = " " * size

    def subscribe(self, events: Union[str, Dict[str, Callable[[Context], None]]], callback: Optional[Callable[[Context], None]] = None) -> None:
        """Subscribes a callback to an element event or accepts a dictionary of event->callback."""
        if isinstance(events, dict):
            for event_name, cb in events.items():
                if event_name not in self.state_events:
                    self.state_events[event_name] = []
                self.state_events[event_name].append(cb)
        elif isinstance(events, str) and callback is not None:
            if events not in self.state_events:
                self.state_events[events] = []
            self.state_events[events].append(callback)

    def publish(self, event_name: str, context: Optional[Context]) -> None:
        """Invokes all subscribers for this event."""
        if event_name in self.state_events:
            ctx = context if context is not None else Context([self])
            for cb in self.state_events[event_name]:
                cb(ctx)

    def activate(self, context: Optional[Context] = None) -> bool:
        self.behavior.active = True
        self.dirty = True
        return self.base_state_machine.trigger("Activate", context)

    def deactivate(self, context: Optional[Context] = None) -> bool:
        self.behavior.active = False
        self.behavior.has_focus = False
        return self.base_state_machine.trigger("Deactivate", context)

    def focus(self, context: Optional[Context] = None) -> bool:
        self.behavior.has_focus = True
        return self.base_state_machine.trigger("Focus", context)

    def unfocus(self, context: Optional[Context] = None) -> bool:
        self.behavior.has_focus = False
        return self.base_state_machine.trigger("Unfocus", context)

    def toggle_focus(self) -> None:
        if self.behavior.has_focus:
            self.unfocus()
        else:
            self.focus()

    def toggle_active(self, context: Optional[Context] = None) -> None:
        if self.is_active():
            self.deactivate(context)
        else:
            self.activate(context)

    def is_focused(self) -> bool:
        return self.base_state_machine.current_state == "SMUiElementFocused"

    def is_active(self) -> bool:
        return self.base_state_machine.current_state in ("SMUiElementActive", "SMUiElementFocused")

    def update(self, context: Context) -> None:
        """Updates internal FSM and element state."""
        self.base_state_machine.update(context)

    def to_ansi_control_sequence_string(self) -> str:
        """Renders coordinates, blank padding, and formatted ANSI string."""
        coord_seq = self.coordinates.to_ansi() if self.coordinates else ""
        return f"{coord_seq}{self.blank}{super().render()}"

    def draw(self) -> None:
        """Outputs rendered ANSI string to TerminalScreen if dirty and clears dirty flag."""
        if self.dirty:
            from ..terminal.screen import TerminalScreen
            TerminalScreen.write(self.to_ansi_control_sequence_string())
            self.dirty = False

