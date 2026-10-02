"""
Questline primitives for Eldoria's Questing Subsystem:
- QuestRewards (Spoils specification)
- Questline (Base ordered collection of Quests)
- StorylineQuestline (Specialization representing the main campaign win condition)
- SideQuestline (Specialization representing optional NPC side quests conferring spoils)
"""
from __future__ import annotations
from typing import Any, Dict, List, Optional, Tuple
from .quest import Quest, LinearQuest, NonlinearQuest
from .step import QuestStep


class QuestRewards:
    """Represents spoils, gold, items, and experience conferred by completing a Side Questline."""

    def __init__(
        self,
        gold: int = 0,
        xp: int = 0,
        items: Optional[List[Tuple[str, int]]] = None,
    ) -> None:
        self.gold: int = gold
        self.xp: int = xp
        self.items: List[Tuple[str, int]] = list(items) if items else []

    def apply_to_party(self, party: Any) -> Dict[str, Any]:
        """Awards the rewards to the player party."""
        summary: Dict[str, Any] = {
            "gold_awarded": self.gold,
            "xp_awarded": self.xp,
            "items_awarded": list(self.items),
        }
        if hasattr(party, "gold") and self.gold > 0:
            party.gold += self.gold
        if hasattr(party, "members") and self.xp > 0:
            for m in party.members:
                if hasattr(m, "award_experience"):
                    m.award_experience(self.xp)
        if hasattr(party, "add_item") and self.items:
            for item_name, qty in self.items:
                party.add_item(item_name, qty)
        return summary

    def formatted_summary(self) -> str:
        """Returns concise single-line summary of rewards."""
        parts = []
        if self.gold > 0:
            parts.append(f"{self.gold} Gold")
        if self.xp > 0:
            parts.append(f"{self.xp} EXP")
        if self.items:
            item_strs = [f"{qty}x {name}" for name, qty in self.items]
            parts.extend(item_strs)
        return ", ".join(parts) if parts else "No rewards"

    def to_dict(self) -> Dict[str, Any]:
        return {
            "gold": self.gold,
            "xp": self.xp,
            "items": [list(item_pair) for item_pair in self.items],
        }

    @classmethod
    def from_dict(cls, data: Dict[str, Any]) -> QuestRewards:
        items = [(item[0], int(item[1])) for item in data.get("items", []) if len(item) >= 2]
        return cls(
            gold=data.get("gold", 0),
            xp=data.get("xp", 0),
            items=items,
        )


class Questline:
    """
    Ordered collection of Quests.
    Quests must be completed in order. Tracks its own completion state.
    """

    def __init__(
        self,
        questline_id: str,
        title: str,
        description: str = "",
        quests: Optional[List[Quest]] = None,
        is_completed: bool = False,
        is_storyline: bool = False,
    ) -> None:
        self.questline_id: str = questline_id
        self.title: str = title
        self.description: str = description
        self.quests: List[Quest] = list(quests) if quests else []
        self.is_completed: bool = is_completed
        self.is_storyline: bool = is_storyline

    def get_active_quest(self) -> Optional[Quest]:
        """Returns the first uncompleted Quest in the ordered sequence."""
        if self.is_completed:
            return None
        for q in self.quests:
            if not q.is_completed:
                return q
        return None

    def get_active_step(self) -> Optional[QuestStep]:
        """Returns the active QuestStep of the currently active Quest."""
        active_q = self.get_active_quest()
        return active_q.get_active_step() if active_q else None

    def check_completion(self) -> bool:
        """Evaluates whether all Quests in the Questline are marked completed."""
        if not self.quests:
            self.is_completed = True
            return True
        if all(q.is_completed for q in self.quests):
            self.is_completed = True
            return True
        return False

    def notify(self, event_type: str, payload: Dict[str, Any], party: Optional[Any] = None) -> bool:
        """Dispatches an event to the currently active Quest."""
        if self.is_completed:
            return False

        active_q = self.get_active_quest()
        if not active_q:
            self.check_completion()
            return False

        changed = active_q.notify(event_type, payload, party=party)
        if active_q.is_completed:
            self.check_completion()
            changed = True

        return changed

    def to_dict(self) -> Dict[str, Any]:
        return {
            "questline_id": self.questline_id,
            "title": self.title,
            "description": self.description,
            "is_storyline": self.is_storyline,
            "is_completed": self.is_completed,
            "quests": [q.to_dict() for q in self.quests],
        }

    @classmethod
    def from_dict(cls, data: Dict[str, Any]) -> Questline:
        is_story = data.get("is_storyline", False)
        quests = [Quest.from_dict(q) for q in data.get("quests", [])]

        if is_story:
            return StorylineQuestline(
                questline_id=data["questline_id"],
                title=data.get("title", ""),
                description=data.get("description", ""),
                quests=quests,
                is_completed=data.get("is_completed", False),
            )
        else:
            rewards_data = data.get("rewards", {})
            rewards = QuestRewards.from_dict(rewards_data) if rewards_data else QuestRewards()
            return SideQuestline(
                questline_id=data["questline_id"],
                title=data.get("title", ""),
                description=data.get("description", ""),
                originator_npc_id=data.get("originator_npc_id", ""),
                originator_name=data.get("originator_name", ""),
                originator_location=data.get("originator_location", ""),
                rewards=rewards,
                quests=quests,
                is_completed=data.get("is_completed", False),
                is_reward_claimed=data.get("is_reward_claimed", False),
            )


class StorylineQuestline(Questline):
    """
    Specialization representing Quests that work towards game completion.
    The game is considered finished when the StorylineQuestline has completed.
    There can only be one StorylineQuestline in the game; it cannot be removed.
    """

    def __init__(
        self,
        questline_id: str = "storyline_main",
        title: str = "The Fall of Malakor",
        description: str = "Liberate the realm of Eldoria by vanquishing the territorial bosses.",
        quests: Optional[List[Quest]] = None,
        is_completed: bool = False,
    ) -> None:
        super().__init__(
            questline_id=questline_id,
            title=title,
            description=description,
            quests=quests,
            is_completed=is_completed,
            is_storyline=True,
        )


class SideQuestline(Questline):
    """
    Specialization representing optional Quests that confer benefits and spoils to the player.
    Originates from NPC POIs in towns or castles.
    """

    def __init__(
        self,
        questline_id: str,
        title: str,
        description: str = "",
        originator_npc_id: str = "",
        originator_name: str = "",
        originator_location: str = "",
        rewards: Optional[QuestRewards] = None,
        quests: Optional[List[Quest]] = None,
        is_completed: bool = False,
        is_reward_claimed: bool = False,
    ) -> None:
        super().__init__(
            questline_id=questline_id,
            title=title,
            description=description,
            quests=quests,
            is_completed=is_completed,
            is_storyline=False,
        )
        self.originator_npc_id: str = originator_npc_id
        self.originator_name: str = originator_name
        self.originator_location: str = originator_location
        self.rewards: QuestRewards = rewards if rewards is not None else QuestRewards()
        self.is_reward_claimed: bool = is_reward_claimed

    def claim_rewards(self, party: Any) -> Dict[str, Any]:
        """Awards spoils to the party and marks them as claimed."""
        if not self.is_completed or self.is_reward_claimed:
            return {}
        summary = self.rewards.apply_to_party(party)
        self.is_reward_claimed = True
        return summary

    def to_dict(self) -> Dict[str, Any]:
        d = super().to_dict()
        d["originator_npc_id"] = self.originator_npc_id
        d["originator_name"] = self.originator_name
        d["originator_location"] = self.originator_location
        d["rewards"] = self.rewards.to_dict()
        d["is_reward_claimed"] = self.is_reward_claimed
        return d
