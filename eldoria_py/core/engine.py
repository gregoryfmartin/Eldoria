"""
Core game loop engine with 60 FPS fixed-timestep pacing, delta-time calculation, and state updates.
"""

from __future__ import annotations
import time
from typing import Optional
from .context import Context, ContextBroadcaster
from .fsm import SMStateMachine
from .janitor import Janitor
from ..terminal.input import InputManager
from ..terminal.screen import TerminalScreen


class GameCore:
    """
    Main game engine driving the 60 FPS tick loop, non-blocking input queue, and FSM.
    """

    def __init__(self, target_fps: int = 60) -> None:
        self.is_running: bool = True
        self.target_fps: int = target_fps
        self.target_frame_time: float = 1.0 / target_fps
        self.last_time: float = 0.0

        self.input_manager: InputManager = InputManager()
        self.janitor: Janitor = Janitor()
        self.context_broadcaster: ContextBroadcaster = ContextBroadcaster()
        self.game_state: Optional[SMStateMachine] = None

    def initialize_states(self) -> None:
        """To be overridden by game subclasses (e.g. EldoriaCore)."""
        pass

    def setup(self) -> None:
        """Initializes terminal raw mode, alternate buffer, and input listener."""
        TerminalScreen.enter()
        self.input_manager.start()
        self.initialize_states()

        if self.game_state is None:
            raise RuntimeError("No Game State Machine was initialized in initialize_states()!")

        self.last_time = time.perf_counter()

    def logic(self, delta_time: float) -> None:
        """Processes one frame of input and state machine updates."""
        keys_pressed = self.input_manager.drain_keys()

        # Check for global quit chord (e.g. Ctrl+C or Escape when unhandled)
        for key in keys_pressed:
            if key.raw == "\x03":
                self.is_running = False
                return

        if self.game_state is not None:
            context = Context([
                delta_time,       # Index 0: ContextDeltaTime
                keys_pressed,     # Index 1: ContextKeysPressed
                self,             # Index 2: ContextEngine
            ])
            self.game_state.update(context)

    def run(self) -> None:
        """Starts and executes the 60 FPS main game loop."""
        try:
            self.setup()

            while self.is_running:
                current_time = time.perf_counter()
                dt = current_time - self.last_time
                self.last_time = current_time

                self.logic(dt)

                # Regulate frame rate
                frame_work_time = time.perf_counter() - current_time
                sleep_time = self.target_frame_time - frame_work_time

                if sleep_time > 0:
                    time.sleep(sleep_time)

        finally:
            self.cleanup()

    def cleanup(self) -> None:
        """Restores terminal and stops input thread."""
        self.input_manager.stop()
        TerminalScreen.exit()


class EldoriaCore(GameCore):
    """Eldoria specialized game core orchestrating top-level game states."""

    def __init__(
        self,
        target_fps: int = 60,
        initial_state: str = "GSUiTestScreen",
        map_width: int = 54,
        map_height: int = 24,
    ) -> None:
        self.initial_target_state = initial_state
        self.map_width = map_width
        self.map_height = map_height
        super().__init__(target_fps=target_fps)

    def initialize_states(self) -> None:
        from ..states.game_init import GSInit
        from ..states.test_ui import GSUiTestScreen
        from ..states.test_soda_can import GSAnimatedSodaCanTestScreen
        from ..states.test_noise_map import GSNoiseMapTestScreen
        from ..states.combat_screen import GSNvNCombatScreen
        from .fsm import SMTransition

        self.game_state = SMStateMachine("GSInit")
        self.game_state.add_state(GSInit())
        self.game_state.add_state(GSUiTestScreen())
        self.game_state.add_state(GSAnimatedSodaCanTestScreen())
        self.game_state.add_state(GSNoiseMapTestScreen(map_width=self.map_width, map_height=self.map_height))
        self.game_state.add_state(GSNvNCombatScreen())

        # Match New New Engine: Boot straight from GSInit -> initial_target_state
        self.game_state.add_transition(
            SMTransition(
                from_state="GSInit",
                event_name="Ready",
                to_state=self.initial_target_state,
            )
        )

        # Transitions between test screens
        self.game_state.add_transition(SMTransition("GSUiTestScreen", "ToNoiseMap", "GSNoiseMapTestScreen"))
        self.game_state.add_transition(SMTransition("GSUiTestScreen", "ToSodaCan", "GSAnimatedSodaCanTestScreen"))
        self.game_state.add_transition(SMTransition("GSNoiseMapTestScreen", "ToUiTest", "GSUiTestScreen"))
        self.game_state.add_transition(SMTransition("GSNoiseMapTestScreen", "ToSodaCan", "GSAnimatedSodaCanTestScreen"))
        self.game_state.add_transition(SMTransition("GSNoiseMapTestScreen", "ToCombat", "GSNvNCombatScreen"))
        self.game_state.add_transition(SMTransition("GSNvNCombatScreen", "FromCombat", "GSNoiseMapTestScreen"))
        self.game_state.add_transition(SMTransition("GSNvNCombatScreen", "ToNoiseMap", "GSNoiseMapTestScreen"))
        self.game_state.add_transition(SMTransition("GSAnimatedSodaCanTestScreen", "ToUiTest", "GSUiTestScreen"))
        self.game_state.add_transition(SMTransition("GSAnimatedSodaCanTestScreen", "ToNoiseMap", "GSNoiseMapTestScreen"))
