"""
Quest primitives for Eldoria's Questing Subsystem:
- Quest (Base)
- LinearQuest (Sequential gating)
- NonlinearQuest (Parallel gating)
"""
from __future__ import annotations
from typing import Any, Dict, List, Optional
from .step import QuestStep


class Quest:
    """Base class for Quests representing a collection of QuestSteps."""

    def __init__(
        self,
        quest_id: str,
        title: str,
        description: str = "",
        steps: Optional[List[QuestStep]] = None,
        is_completed: bool = False,
    ) -> None:
        self.quest_id: str = quest_id
        self.title: str = title
        self.description: str = description
        self.steps: List[QuestStep] = list(steps) if steps else []
        self.is_completed: bool = is_completed

    def get_active_steps(self) -> List[QuestStep]:
        """Returns the list of currently active QuestSteps."""
        raise NotImplementedError

    def get_active_step(self) -> Optional[QuestStep]:
        """Returns the primary active QuestStep for tracking."""
        active = self.get_active_steps()
        return active[0] if active else None

    def notify(self, event_type: str, payload: Dict[str, Any], party: Optional[Any] = None) -> bool:
        """Dispatches an event to active steps and checks overall quest completion."""
        raise NotImplementedError

    def check_completion(self) -> bool:
        """Checks if all steps are completed and updates quest completion state."""
        if not self.steps:
            self.is_completed = True
            return True
        if all(s.is_completed for s in self.steps):
            self.is_completed = True
            return True
        return False

    def to_dict(self) -> Dict[str, Any]:
        """Serializes Quest to dictionary."""
        return {
            "quest_id": self.quest_id,
            "title": self.title,
            "description": self.description,
            "quest_type": "GENERIC",
            "is_completed": self.is_completed,
            "steps": [s.to_dict() for s in self.steps],
        }

    @classmethod
    def from_dict(cls, data: Dict[str, Any]) -> Quest:
        """Hydrates concrete Quest (Linear or Nonlinear) from dictionary."""
        q_type = data.get("quest_type", "LINEAR").upper()
        steps = [QuestStep.from_dict(s) for s in data.get("steps", [])]

        if q_type == "NONLINEAR":
            return NonlinearQuest(
                quest_id=data["quest_id"],
                title=data.get("title", ""),
                description=data.get("description", ""),
                steps=steps,
                is_completed=data.get("is_completed", False),
            )
        else:
            return LinearQuest(
                quest_id=data["quest_id"],
                title=data.get("title", ""),
                description=data.get("description", ""),
                steps=steps,
                is_completed=data.get("is_completed", False),
            )


class LinearQuest(Quest):
    """
    Specialization of Quest where QuestSteps must be completed in strict sequential order.
    Lower-order QuestSteps cannot be completed until higher-order steps have completed.
    """

    def __init__(
        self,
        quest_id: str,
        title: str,
        description: str = "",
        steps: Optional[List[QuestStep]] = None,
        is_completed: bool = False,
    ) -> None:
        super().__init__(
            quest_id=quest_id,
            title=title,
            description=description,
            steps=steps,
            is_completed=is_completed,
        )
        self._sync_active_step()

    def _sync_active_step(self, party: Optional[Any] = None) -> None:
        """Probes for the first uncompleted step and ensures it is marked active."""
        if self.is_completed:
            for s in self.steps:
                s.is_active = False
            return

        found_active = False
        for s in self.steps:
            if not s.is_completed and not found_active:
                if not s.is_active:
                    s.activate(party=party)
                found_active = True
            elif not s.is_completed:
                s.is_active = False

        if not found_active and self.steps:
            self.is_completed = True

    def get_active_steps(self) -> List[QuestStep]:
        """Returns the single active QuestStep in the sequence, if any."""
        if self.is_completed:
            return []
        self._sync_active_step()
        for s in self.steps:
            if not s.is_completed and s.is_active:
                return [s]
        return []

    def notify(self, event_type: str, payload: Dict[str, Any], party: Optional[Any] = None) -> bool:
        """Evaluates event strictly against the single currently active QuestStep."""
        if self.is_completed:
            return False

        active_steps = self.get_active_steps()
        if not active_steps:
            return False

        active_step = active_steps[0]
        changed = active_step.evaluate_event(event_type, payload, party=party)

        if active_step.is_completed:
            # Advance to next step in sequence
            self._sync_active_step(party=party)
            self.check_completion()
            changed = True

        return changed

    def to_dict(self) -> Dict[str, Any]:
        d = super().to_dict()
        d["quest_type"] = "LINEAR"
        return d


class NonlinearQuest(Quest):
    """
    Specialization of Quest where QuestSteps can be completed in any order,
    regardless of how they are arranged.
    """

    def __init__(
        self,
        quest_id: str,
        title: str,
        description: str = "",
        steps: Optional[List[QuestStep]] = None,
        is_completed: bool = False,
    ) -> None:
        super().__init__(
            quest_id=quest_id,
            title=title,
            description=description,
            steps=steps,
            is_completed=is_completed,
        )
        self._activate_all_uncompleted()

    def _activate_all_uncompleted(self, party: Optional[Any] = None) -> None:
        """Marks all uncompleted steps as active."""
        if self.is_completed:
            for s in self.steps:
                s.is_active = False
            return

        for s in self.steps:
            if not s.is_completed and not s.is_active:
                s.activate(party=party)

        self.check_completion()

    def get_active_steps(self) -> List[QuestStep]:
        """Returns all uncompleted active QuestSteps."""
        if self.is_completed:
            return []
        return [s for s in self.steps if not s.is_completed]

    def notify(self, event_type: str, payload: Dict[str, Any], party: Optional[Any] = None) -> bool:
        """Dispatches event across all concurrent active QuestSteps."""
        if self.is_completed:
            return False

        changed = False
        for s in list(self.get_active_steps()):
            if s.evaluate_event(event_type, payload, party=party):
                changed = True

        if changed:
            self.check_completion()

        return changed

    def to_dict(self) -> Dict[str, Any]:
        d = super().to_dict()
        d["quest_type"] = "NONLINEAR"
        return d
