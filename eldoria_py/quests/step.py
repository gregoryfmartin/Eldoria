"""
QuestStep primitive for Eldoria's Questing Subsystem.
Tracks individual gates/objectives, baseline metrics, and completion state.
"""
from __future__ import annotations
from enum import Enum
from typing import Any, Dict, Optional


class QuestStepType(str, Enum):
    """Categorical types of Quest Steps."""
    OBTAIN_GOLD = "OBTAIN_GOLD"          # Counted from time step started
    SPEND_GOLD = "SPEND_GOLD"            # Counted from time step started
    OBTAIN_ITEM = "OBTAIN_ITEM"          # General inventory analysis at any time
    OBTAIN_ITEMS = "OBTAIN_ITEMS"        # Collection of items in inventory
    DEFEAT_ENEMY = "DEFEAT_ENEMY"        # Checked from time step started
    DEFEAT_ENEMIES = "DEFEAT_ENEMIES"    # Collection of enemies defeated from start
    DEAL_DAMAGE = "DEAL_DAMAGE"          # Damage dealt from time step started


class QuestStep:
    """
    Smallest workable primitive in the questing subsystem.
    Contains exactly one objective/gate and tracks its own completion state.
    """

    def __init__(
        self,
        step_id: str,
        description: str,
        step_type: QuestStepType,
        target_name: str = "",
        target_count: int = 1,
        target_dict: Optional[Dict[str, int]] = None,
        current_progress: int = 0,
        progress_dict: Optional[Dict[str, int]] = None,
        baseline_value: int = 0,
        is_completed: bool = False,
        is_active: bool = False,
        lore: str = "",
        title: str = "",
    ) -> None:
        self.step_id: str = step_id
        self.description: str = description
        if title:
            self.title: str = title
        elif step_id.startswith("step_boss_"):
            boss = target_name or step_id.replace("step_boss_", "").capitalize()
            self.title = f"Defeat {boss}"
        else:
            self.title = description
        self.step_type: QuestStepType = (
            step_type if isinstance(step_type, QuestStepType) else QuestStepType(step_type)
        )
        self.target_name: str = target_name
        self.target_count: int = target_count
        self.target_dict: Dict[str, int] = dict(target_dict) if target_dict else {}
        self.current_progress: int = current_progress
        self.progress_dict: Dict[str, int] = dict(progress_dict) if progress_dict else {}
        self.baseline_value: int = baseline_value
        self.is_completed: bool = is_completed
        self.is_active: bool = is_active
        self.lore: str = lore

        # Initialize progress_dict keys if multi-target
        if self.target_dict and not self.progress_dict:
            self.progress_dict = {k: 0 for k in self.target_dict}

    def activate(self, party: Optional[Any] = None) -> None:
        """Activates this step, snapshotting baselines if starting freshly."""
        if not self.is_active:
            self.is_active = True
        if self.is_completed:
            return

        # Immediate inventory verification for item-based steps
        if party is not None and self.step_type in (QuestStepType.OBTAIN_ITEM, QuestStepType.OBTAIN_ITEMS):
            self.check_inventory(party)

    def check_inventory(self, party: Any) -> bool:
        """Evaluates inventory items at any time against target requirements."""
        if self.is_completed or not self.is_active:
            return self.is_completed

        if self.step_type == QuestStepType.OBTAIN_ITEM:
            count = party.get_item_count(self.target_name) if hasattr(party, "get_item_count") else 0
            self.current_progress = count
            if self.current_progress >= self.target_count:
                self.is_completed = True
                return True

        elif self.step_type == QuestStepType.OBTAIN_ITEMS:
            all_satisfied = True
            for item_name, req_qty in self.target_dict.items():
                count = party.get_item_count(item_name) if hasattr(party, "get_item_count") else 0
                self.progress_dict[item_name] = count
                if count < req_qty:
                    all_satisfied = False
            if all_satisfied and self.target_dict:
                self.is_completed = True
                return True

        return False

    def evaluate_event(self, event_type: str, payload: Dict[str, Any], party: Optional[Any] = None) -> bool:
        """
        Processes a dispatched game event.
        Returns True if progress changed or the step became completed.
        """
        if self.is_completed or not self.is_active:
            return False

        changed = False

        if event_type == "ENEMY_DEFEATED":
            enemy_name = payload.get("enemy_name", "")
            count = payload.get("count", 1)

            if self.step_type == QuestStepType.DEFEAT_ENEMY:
                if enemy_name.lower() == self.target_name.lower():
                    self.current_progress += count
                    changed = True
                    if self.current_progress >= self.target_count:
                        self.is_completed = True

            elif self.step_type == QuestStepType.DEFEAT_ENEMIES:
                for target_k in self.target_dict:
                    if enemy_name.lower() == target_k.lower():
                        self.progress_dict[target_k] = self.progress_dict.get(target_k, 0) + count
                        changed = True
                # Check if all target enemy quotas met
                if all(self.progress_dict.get(k, 0) >= v for k, v in self.target_dict.items()):
                    self.is_completed = True

        elif event_type == "DAMAGE_DEALT":
            if self.step_type == QuestStepType.DEAL_DAMAGE:
                damage = payload.get("damage", 0)
                if damage > 0:
                    self.current_progress += damage
                    changed = True
                    if self.current_progress >= self.target_count:
                        self.is_completed = True

        elif event_type == "GOLD_CHANGED":
            delta = payload.get("delta", 0)
            is_gain = payload.get("is_gain", True)

            if self.step_type == QuestStepType.OBTAIN_GOLD and is_gain and delta > 0:
                self.current_progress += delta
                changed = True
                if self.current_progress >= self.target_count:
                    self.is_completed = True

            elif self.step_type == QuestStepType.SPEND_GOLD and not is_gain and delta > 0:
                self.current_progress += delta
                changed = True
                if self.current_progress >= self.target_count:
                    self.is_completed = True

        elif event_type == "INVENTORY_CHANGED":
            if party is not None and self.step_type in (QuestStepType.OBTAIN_ITEM, QuestStepType.OBTAIN_ITEMS):
                old_done = self.is_completed
                self.check_inventory(party)
                if self.is_completed != old_done:
                    changed = True

        return changed

    @property
    def formatted_progress(self) -> str:
        """Returns human-readable progress string."""
        if self.is_completed:
            return "✔ Completed"

        if self.step_type in (QuestStepType.OBTAIN_GOLD, QuestStepType.SPEND_GOLD):
            return f"{self.current_progress}/{self.target_count} Gold"

        if self.step_type == QuestStepType.DEAL_DAMAGE:
            return f"{self.current_progress}/{self.target_count} Damage"

        if self.step_type in (QuestStepType.OBTAIN_ITEM, QuestStepType.DEFEAT_ENEMY):
            return f"{self.current_progress}/{self.target_count}"

        if self.step_type in (QuestStepType.OBTAIN_ITEMS, QuestStepType.DEFEAT_ENEMIES):
            parts = [f"{k}: {self.progress_dict.get(k, 0)}/{req}" for k, req in self.target_dict.items()]
            return " | ".join(parts)

        return f"{self.current_progress}/{self.target_count}"

    def to_dict(self) -> Dict[str, Any]:
        """Serializes QuestStep to dictionary."""
        return {
            "step_id": self.step_id,
            "description": self.description,
            "step_type": self.step_type.value,
            "target_name": self.target_name,
            "target_count": self.target_count,
            "target_dict": dict(self.target_dict),
            "current_progress": self.current_progress,
            "progress_dict": dict(self.progress_dict),
            "baseline_value": self.baseline_value,
            "is_completed": self.is_completed,
            "is_active": self.is_active,
            "lore": self.lore,
            "title": self.title,
        }

    @classmethod
    def from_dict(cls, data: Dict[str, Any]) -> QuestStep:
        """Hydrates QuestStep from dictionary."""
        return cls(
            step_id=data["step_id"],
            description=data.get("description", ""),
            step_type=QuestStepType(data.get("step_type", QuestStepType.DEFEAT_ENEMY.value)),
            target_name=data.get("target_name", ""),
            target_count=data.get("target_count", 1),
            target_dict=data.get("target_dict"),
            current_progress=data.get("current_progress", 0),
            progress_dict=data.get("progress_dict"),
            baseline_value=data.get("baseline_value", 0),
            is_completed=data.get("is_completed", False),
            is_active=data.get("is_active", False),
            lore=data.get("lore", ""),
            title=data.get("title", ""),
        )
