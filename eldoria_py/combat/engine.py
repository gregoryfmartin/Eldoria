"""NvN Party-based Combat Engine with advance command planning and initiative resolution."""
from __future__ import annotations
import random
from dataclasses import dataclass
from enum import Enum
from typing import Optional
from eldoria_py.combat.stats import (
    StatId,
    BattleActionType,
    BattleActionResultType,
    TargetScope,
    AffinityEffect,
)
from eldoria_py.combat.actions import BattleAction, ACTIONS, ActionCategory
from eldoria_py.combat.damage import calculate_damage, DamageResult
from eldoria_py.combat.entities import Combatant, PartyMember, EnemyCombatant, Party, EnemySquad


class CombatPhase(str, Enum):
    """Lifecycle states of an NvN combat encounter."""
    COMMAND_PHASE = "CommandPhase"         # Player issuing commands for party members in advance
    EXECUTION_PHASE = "ExecutionPhase"     # Step-by-step resolution of initiative-sorted actions
    BATTLE_VICTORY = "BattleVictory"       # Enemy squad defeated
    BATTLE_DEFEAT = "BattleDefeat"         # Player party wiped


@dataclass
class QueuedAction:
    """An action committed for execution in the current round."""
    actor: Combatant
    action: BattleAction
    target: Combatant
    initiative: float = 0.0

    def __repr__(self) -> str:
        return f"<Action {self.actor.name} -> {self.action.name} on {self.target.name} (init={self.initiative:.1f})>"


class NvNCombatEngine:
    """Orchestrates NvN party-vs-squad combat with advance planning and speed initiative."""

    def __init__(
        self,
        party: Party,
        squad: EnemySquad,
        rng: Optional[random.Random] = None,
    ):
        self.party: Party = party
        self.squad: EnemySquad = squad
        self.rng: random.Random = rng if rng is not None else random.Random()

        self.phase: CombatPhase = CombatPhase.COMMAND_PHASE
        self.round_number: int = 1
        self.planned_actions: dict[int, QueuedAction] = {}  # party_member_index -> QueuedAction
        self.round_queue: list[QueuedAction] = []
        self.execution_index: int = 0
        self.combat_log: list[str] = [f"Battle began! Round {self.round_number} Command Phase."]
        self.spoils_xp: int = 0
        self.spoils_gold: int = 0

    def log(self, text: str) -> None:
        """Appends a message to the battle log."""
        self.combat_log.append(text)
        if len(self.combat_log) > 60:
            self.combat_log.pop(0)

    # -------------------------------------------------------------------------
    # Command Planning Phase
    # -------------------------------------------------------------------------
    def plan_member_action(self, member_index: int, action: BattleAction, target: Combatant) -> bool:
        """Assign an action and target to a specific party member."""
        member = self.party.get_member(member_index)
        if member is None or not member.is_alive:
            return False

        queued = QueuedAction(actor=member, action=action.copy(), target=target)
        self.planned_actions[member_index] = queued
        return True

    def get_planned_action(self, member_index: int) -> Optional[QueuedAction]:
        """Returns the currently planned action for a party member, if any."""
        return self.planned_actions.get(member_index)

    def clear_member_plan(self, member_index: int) -> None:
        """Clears planned action for a party member."""
        if member_index in self.planned_actions:
            del self.planned_actions[member_index]

    def is_planning_complete(self) -> bool:
        """True if every living party member has an action assigned."""
        alive_indices = [i for i, m in enumerate(self.party.members) if m.is_alive]
        return all(i in self.planned_actions for i in alive_indices)

    def finalize_planning(self) -> bool:
        """Locks in party actions, generates enemy AI actions, sorts initiative queue."""
        if not self.is_planning_complete():
            return False

        all_actions: list[QueuedAction] = []

        # 1. Add all planned party actions
        for idx, queued in self.planned_actions.items():
            member = self.party.get_member(idx)
            if member and member.is_alive:
                spd = member.get_stat(StatId.SPEED)
                lck = member.get_stat(StatId.LUCK)
                init_val = (spd * queued.action.speed_priority) + (self.rng.random() * lck * 0.1)
                queued.initiative = init_val
                all_actions.append(queued)

        # 2. Generate actions for all living enemies
        alive_party = self.party.alive_members
        alive_squad = self.squad.alive_enemies

        for enemy in alive_squad:
            action, chosen_target = enemy.choose_action(
                party_targets=alive_party,
                ally_targets=alive_squad,
                rng=self.rng,
            )
            spd = enemy.get_stat(StatId.SPEED)
            lck = enemy.get_stat(StatId.LUCK)
            init_val = (spd * action.speed_priority) + (self.rng.random() * lck * 0.1)
            all_actions.append(
                QueuedAction(
                    actor=enemy,
                    action=action.copy(),
                    target=chosen_target,
                    initiative=init_val,
                )
            )

        # 3. Sort descending by initiative
        all_actions.sort(key=lambda q: q.initiative, reverse=True)
        self.round_queue = all_actions
        self.execution_index = 0
        self.phase = CombatPhase.EXECUTION_PHASE
        self.log(f"--- Round {self.round_number} Execution ({len(self.round_queue)} actions queued) ---")
        return True

    # -------------------------------------------------------------------------
    # Execution Phase
    # -------------------------------------------------------------------------
    def step_execution(self) -> Optional[QueuedAction]:
        """Resolves the next action in the initiative queue with smart retargeting."""
        if self.phase != CombatPhase.EXECUTION_PHASE:
            return None

        # Check battle end conditions first
        if self.squad.is_wiped:
            self._trigger_victory()
            return None
        if self.party.is_wiped:
            self._trigger_defeat()
            return None

        if self.execution_index >= len(self.round_queue):
            self._end_round()
            return None

        queued = self.round_queue[self.execution_index]
        self.execution_index += 1

        actor = queued.actor
        action = queued.action
        target = queued.target

        # 1. Is actor alive?
        if not actor.is_alive:
            self.log(f"{actor.name} was defeated and cannot act.")
            return queued

        # 2. Defend action handling
        if action.category.value == "Defend":
            actor.is_defending = True
            self.log(f"🛡 {actor.name} braces and enters defensive stance!")
            return queued

        # 3. MP Cost verification or Item verification
        is_player_acting = isinstance(actor, PartyMember)
        if action.category == ActionCategory.ITEM and is_player_acting:
            if not self.party.has_item(action.name):
                self.log(f"{actor.name} reached for {action.name}, but none remained in inventory!")
                return queued
            self.party.remove_item(action.name, 1)
        elif action.mp_cost > 0:
            if not actor.spend_mp(action.mp_cost):
                self.log(f"{actor.name} attempted {action.name} but lacked MP ({actor.mp}/{action.mp_cost})!")
                return queued

        # 4. Resolve Targets & Smart Retargeting
        is_revive = (action.category == ActionCategory.ITEM and action.name == "Revive Herb")
        if is_revive:
            if not target.is_alive:
                target.stats[StatId.HIT_POINTS].current = min(target.max_hp, action.effect_value)
                self.log(f"🌱 {actor.name} uses Revive Herb on {target.name}! Revived with {target.hp} HP!")
            else:
                self.log(f"{actor.name} used Revive Herb on {target.name}, but {target.name} is already alive!")
            return queued

        targets_to_hit: list[Combatant] = []

        if action.target_scope == TargetScope.ALL_ENEMIES:
            opponents = self.squad.alive_enemies if is_player_acting else self.party.alive_members
            targets_to_hit = list(opponents)
        elif action.target_scope == TargetScope.ALL_ALLIES:
            allies = self.party.alive_members if is_player_acting else self.squad.alive_enemies
            targets_to_hit = list(allies)
        elif action.target_scope == TargetScope.SELF:
            targets_to_hit = [actor]
        else:
            # Single Target: Check if target is alive; if dead, retarget
            if not target.is_alive:
                is_friendly_action = action.target_scope == TargetScope.SINGLE_ALLY
                if is_friendly_action:
                    pool = self.party.alive_members if is_player_acting else self.squad.alive_enemies
                else:
                    pool = self.squad.alive_enemies if is_player_acting else self.party.alive_members

                if not pool:
                    self.log(f"{actor.name}'s target was lost and no targets remain.")
                    return queued

                # Smart retarget: pick the first living combatant
                target = pool[0]
                queued.target = target
                self.log(f"{actor.name} retargets {action.name} to {target.name}!")

            targets_to_hit = [target]

        if not targets_to_hit:
            self.log(f"{actor.name}'s {action.name} has no valid targets.")
            return queued

        # 5. Apply action to all selected targets
        target_count = len(targets_to_hit)
        for t in targets_to_hit:
            result = calculate_damage(
                attacker_stats=actor.get_all_stat_totals(),
                target_stats=t.get_all_stat_totals(),
                action_type=action.action_type,
                power=action.effect_value,
                accuracy=action.accuracy,
                target_affinity=t.affinity,
                target_count=target_count,
                explicit_absorbs=t.explicit_absorbs,
                explicit_immunes=t.explicit_immunes,
                rng=self.rng,
            )

            if action.category == ActionCategory.ITEM:
                if result.is_healing:
                    healed = t.heal(abs(result.final_damage))
                    self.log(f"💚 {actor.name} uses {action.name} on {t.name}: +{healed} HP! ({t.hp}/{t.max_hp})")
                else:
                    dmg_taken = t.take_damage(result.final_damage)
                    self.log(f"💥 {actor.name} uses {action.name} on {t.name}: {dmg_taken} dmg ({t.hp}/{t.max_hp})")
                    if not t.is_alive:
                        self.log(f"☠ {t.name} was defeated!")
                continue

            if result.is_healing:
                healed = t.heal(abs(result.final_damage))
                self.log(f"💚 {actor.name} casts {action.name} on {t.name}: +{healed} HP! ({t.hp}/{t.max_hp})")
            elif not result.hit:
                self.log(f"💨 {actor.name} used {action.name} on {t.name}, but it missed!")
            elif result.result_type == BattleActionResultType.IMMUNE:
                self.log(f"🛡 {t.name} is immune to {actor.name}'s {action.name}!")
            else:
                dmg_taken = t.take_damage(result.final_damage)
                crit_tag = " [★ CRIT]" if result.is_critical else ""
                weak_tag = " [★ WEAKNESS]" if result.affinity_effect == AffinityEffect.WEAK else ""
                res_tag = " [Resisted]" if result.affinity_effect == AffinityEffect.RESIST else ""
                self.log(
                    f"⚔ {actor.name} uses {action.name} on {t.name}{crit_tag}{weak_tag}{res_tag}: {dmg_taken} dmg ({t.hp}/{t.max_hp})"
                )

                if not t.is_alive:
                    self.log(f"☠ {t.name} was defeated!")

        # 6. Re-check battle end condition after damage
        if self.squad.is_wiped:
            self._trigger_victory()
        elif self.party.is_wiped:
            self._trigger_defeat()

        return queued

    def execute_all_steps(self) -> None:
        """Executes the entire round or until combat ends."""
        while self.phase == CombatPhase.EXECUTION_PHASE:
            self.step_execution()

    def _end_round(self) -> None:
        """Finishes the round, updates turn buffers, advances round number."""
        self.party.update_turn()
        self.squad.update_turn()
        self.round_number += 1
        self.planned_actions.clear()
        self.round_queue.clear()
        self.execution_index = 0
        self.phase = CombatPhase.COMMAND_PHASE
        self.log(f"=== Round {self.round_number} Command Phase ===")

    def _trigger_victory(self) -> None:
        """Handles party victory and calculates rewards."""
        self.phase = CombatPhase.BATTLE_VICTORY
        self.spoils_xp = self.squad.total_xp()
        self.spoils_gold = self.squad.total_gold()
        self.log(f"🏆 VICTORY! Enemy squad eliminated!")
        self.log(f"Gained {self.spoils_xp} XP and {self.spoils_gold} Gold.")

    def _trigger_defeat(self) -> None:
        """Handles party wipeout."""
        self.phase = CombatPhase.BATTLE_DEFEAT
        self.log("💀 DEFEAT! All party members have fallen in battle...")
