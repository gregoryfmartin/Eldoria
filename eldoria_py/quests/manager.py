"""
QuestManager governor object for Eldoria's Questing Subsystem.
Manages the Storyline Questline and registered Side Questlines, tracks the active
artifact, and dispatches real-time game events to all active objectives.
"""
from __future__ import annotations
from typing import Any, Dict, List, Optional, Tuple
from .step import QuestStep
from .quest import Quest
from .questline import Questline, StorylineQuestline, SideQuestline, QuestRewards


class QuestManager:
    """
    Governor object managing all Questlines.
    Tracks the persistent Storyline Questline and all active/completed Side Questlines.
    """

    def __init__(
        self,
        storyline: Optional[StorylineQuestline] = None,
        side_questlines: Optional[List[SideQuestline]] = None,
        tracked_questline_id: Optional[str] = None,
        tracked_quest_id: Optional[str] = None,
        tracked_step_id: Optional[str] = None,
    ) -> None:
        self.storyline: StorylineQuestline = (
            storyline if storyline is not None else StorylineQuestline()
        )
        self.side_questlines: List[SideQuestline] = (
            list(side_questlines) if side_questlines else []
        )
        self.tracked_questline_id: Optional[str] = tracked_questline_id or self.storyline.questline_id
        self.tracked_quest_id: Optional[str] = tracked_quest_id
        self.tracked_step_id: Optional[str] = tracked_step_id

    # -------------------------------------------------------------------------
    # Questline Registration & Management
    # -------------------------------------------------------------------------
    def register_side_questline(self, questline: SideQuestline, party: Optional[Any] = None) -> bool:
        """
        Registers a new Side Questline offered by an NPC.
        Rejects duplicates and previously completed side questlines.
        """
        if questline.is_storyline:
            return False

        # Check existing side questlines
        for existing in self.side_questlines:
            if existing.questline_id == questline.questline_id:
                return False

        # Activate initial quest/step if party present
        active_q = questline.get_active_quest()
        if active_q and party:
            for s in active_q.get_active_steps():
                s.activate(party=party)

        self.side_questlines.append(questline)
        return True

    def get_questline(self, questline_id: str) -> Optional[Questline]:
        """Looks up a questline by ID (Storyline or Side)."""
        if self.storyline.questline_id == questline_id:
            return self.storyline
        for sq in self.side_questlines:
            if sq.questline_id == questline_id:
                return sq
        return None

    def get_all_questlines(self) -> List[Questline]:
        """Returns all questlines with storyline first."""
        return [self.storyline] + list(self.side_questlines)

    @property
    def is_game_completed(self) -> bool:
        """The campaign is finished when the Storyline Questline is marked completed."""
        return self.storyline.is_completed

    # -------------------------------------------------------------------------
    # Currently Tracked Artifact
    # -------------------------------------------------------------------------
    def get_tracked_artifact(self) -> Tuple[Optional[Questline], Optional[Quest], Optional[QuestStep]]:
        """
        Resolves the 3-tier Currently Tracked Artifact:
        (Active Questline, Active Quest, Active Quest Step).
        """
        target_ql = self.get_questline(self.tracked_questline_id or "")
        if target_ql is None:
            target_ql = self.storyline

        # Resolve Quest within Questline
        target_q: Optional[Quest] = None
        if self.tracked_quest_id:
            for q in target_ql.quests:
                if q.quest_id == self.tracked_quest_id:
                    target_q = q
                    break
        if target_q is None:
            target_q = target_ql.get_active_quest()

        # Resolve Step within Quest
        target_s: Optional[QuestStep] = None
        if target_q is not None:
            if self.tracked_step_id:
                for s in target_q.steps:
                    if s.step_id == self.tracked_step_id:
                        target_s = s
                        break
            if target_s is None:
                target_s = target_q.get_active_step()

        return target_ql, target_q, target_s

    def set_tracked_artifact(
        self,
        questline_id: str,
        quest_id: Optional[str] = None,
        step_id: Optional[str] = None,
    ) -> None:
        """Sets the currently tracked artifact hierarchy."""
        self.tracked_questline_id = questline_id
        self.tracked_quest_id = quest_id
        self.tracked_step_id = step_id

    # -------------------------------------------------------------------------
    # Event Dispatching
    # -------------------------------------------------------------------------
    def notify_enemy_defeated(self, enemy_name: str, count: int = 1, party: Optional[Any] = None) -> bool:
        """Dispatches an enemy defeat event across the Storyline and all registered Side Questlines."""
        payload = {"enemy_name": enemy_name, "count": count}
        changed = False

        if self.storyline.notify("ENEMY_DEFEATED", payload, party=party):
            changed = True

        for sq in self.side_questlines:
            if not sq.is_completed:
                if sq.notify("ENEMY_DEFEATED", payload, party=party):
                    changed = True

        return changed

    def notify_damage_dealt(self, damage: int, party: Optional[Any] = None) -> bool:
        """Dispatches damage dealt event to all active quest steps."""
        payload = {"damage": damage}
        changed = False

        if self.storyline.notify("DAMAGE_DEALT", payload, party=party):
            changed = True

        for sq in self.side_questlines:
            if not sq.is_completed:
                if sq.notify("DAMAGE_DEALT", payload, party=party):
                    changed = True

        return changed

    def notify_gold_changed(
        self,
        delta: int,
        is_gain: bool,
        current_gold: int = 0,
        party: Optional[Any] = None,
    ) -> bool:
        """Dispatches gold acquisition or spending events."""
        payload = {"delta": delta, "is_gain": is_gain, "current_gold": current_gold}
        changed = False

        if self.storyline.notify("GOLD_CHANGED", payload, party=party):
            changed = True

        for sq in self.side_questlines:
            if not sq.is_completed:
                if sq.notify("GOLD_CHANGED", payload, party=party):
                    changed = True

        return changed

    def notify_inventory_changed(self, party: Any) -> bool:
        """Re-evaluates inventory item quotas across all active steps."""
        payload: Dict[str, Any] = {}
        changed = False

        if self.storyline.notify("INVENTORY_CHANGED", payload, party=party):
            changed = True

        for sq in self.side_questlines:
            if not sq.is_completed:
                if sq.notify("INVENTORY_CHANGED", payload, party=party):
                    changed = True

        return changed

    # -------------------------------------------------------------------------
    # NPC Quest Lifecycle Helpers
    # -------------------------------------------------------------------------
    def get_side_quest_by_originator(self, npc_id: str) -> Optional[SideQuestline]:
        """Finds a registered side questline originated by the specified NPC ID."""
        for sq in self.side_questlines:
            if sq.originator_npc_id == npc_id:
                return sq
        return None

    def get_npc_quest_status(self, npc_id: str) -> str:
        """
        Determines the quest status for an NPC:
        - "NOT_REGISTERED": The player has not yet accepted a quest from this NPC.
        - "IN_PROGRESS": The quest is accepted and active, but not all objectives are complete.
        - "READY_TO_TURN_IN": All objectives are complete, awaiting player turn-in for spoils.
        - "COMPLETED": Turn-in is finished and rewards claimed. Cannot be reactivated.
        """
        sq = self.get_side_quest_by_originator(npc_id)
        if sq is None:
            return "NOT_REGISTERED"

        if sq.is_reward_claimed:
            return "COMPLETED"

        if sq.is_completed:
            return "READY_TO_TURN_IN"

        return "IN_PROGRESS"

    def claim_side_quest_rewards(self, questline_id: str, party: Any) -> Dict[str, Any]:
        """Claims rewards for a completed side questline."""
        for sq in self.side_questlines:
            if sq.questline_id == questline_id:
                return sq.claim_rewards(party)
        return {}

    # -------------------------------------------------------------------------
    # Serialization
    # -------------------------------------------------------------------------
    def to_dict(self) -> Dict[str, Any]:
        """Serializes full QuestManager state for save games."""
        return {
            "storyline": self.storyline.to_dict(),
            "side_questlines": [sq.to_dict() for sq in self.side_questlines],
            "tracked_questline_id": self.tracked_questline_id,
            "tracked_quest_id": self.tracked_quest_id,
            "tracked_step_id": self.tracked_step_id,
        }

    @classmethod
    def from_dict(cls, data: Dict[str, Any]) -> QuestManager:
        """Restores QuestManager state from save game dictionary."""
        story_data = data.get("storyline", {})
        storyline = (
            StorylineQuestline.from_dict(story_data)
            if story_data
            else StorylineQuestline()
        )
        side_qls = [
            SideQuestline.from_dict(sq) for sq in data.get("side_questlines", [])
        ]
        return cls(
            storyline=storyline,
            side_questlines=side_qls,
            tracked_questline_id=data.get("tracked_questline_id"),
            tracked_quest_id=data.get("tracked_quest_id"),
            tracked_step_id=data.get("tracked_step_id"),
        )
