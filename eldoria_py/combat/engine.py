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
        self.spoils_items: list[tuple[str, int]] = []

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
            force_crit = False if (t.is_defending and getattr(t, "negate_crits_when_defending", False)) else None
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
                force_crit=force_crit,
            )

            if action.category == ActionCategory.ITEM:
                if "Ether" in action.name:
                    restored = t.restore_mp(action.effect_value)
                    self.log(f"🔷 {actor.name} uses {action.name} on {t.name}: +{restored} MP! ({t.mp}/{t.max_mp})")
                elif action.name == "Elixir":
                    healed = t.heal(t.max_hp)
                    restored = t.restore_mp(t.max_mp)
                    self.log(f"✨ {actor.name} uses {action.name} on {t.name}: Fully restored HP & MP!")
                elif action.name == "Antidote":
                    self.log(f"🧪 {actor.name} uses Antidote on {t.name}! Cured of toxins.")
                elif action.name == "Sleep Powder":
                    self.log(f"💤 {actor.name} uses {action.name} on {t.name}! {t.name} fell asleep.")
                elif result.is_healing:
                    healed = t.heal(abs(result.final_damage))
                    self.log(f"💚 {actor.name} uses {action.name} on {t.name}: +{healed} HP!")
                else:
                    dmg_taken = t.take_damage(result.final_damage)
                    crit_tag = " [★ CRIT]" if result.is_critical else ""
                    weak_tag = " [★ WEAKNESS]" if result.affinity_effect == AffinityEffect.WEAK else ""
                    res_tag = " [Resisted]" if result.affinity_effect == AffinityEffect.RESIST else ""
                    self.log(f"💥 {actor.name} uses {action.name} on {t.name}{crit_tag}{weak_tag}{res_tag}: {dmg_taken} dmg")
                    if not t.is_alive:
                        self.log(f"☠ {t.name} was defeated!")
                continue

            if result.is_healing:
                healed = t.heal(abs(result.final_damage))
                self.log(f"💚 {actor.name} casts {action.name} on {t.name}: +{healed} HP!")
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
                    f"⚔ {actor.name} uses {action.name} on {t.name}{crit_tag}{weak_tag}{res_tag}: {dmg_taken} dmg"
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
        base_xp = self.squad.total_xp()
        self.spoils_gold = self.squad.total_gold()

        survivors = self.party.alive_members
        ko_members = [m for m in self.party.members if not m.is_alive]

        # Calculate average party and squad levels to apply tiered level-gap penalty
        avg_party_level = sum(m.level for m in survivors) / max(1, len(survivors)) if survivors else 1.0
        avg_squad_level = sum(e.level for e in self.squad.enemies) / max(1, len(self.squad.enemies)) if self.squad.enemies else 1.0
        level_gap = int(round(avg_party_level - avg_squad_level))

        if level_gap <= 3:
            xp_multiplier = 1.0
        elif 4 <= level_gap <= 6:
            xp_multiplier = 0.60
        elif 7 <= level_gap <= 10:
            xp_multiplier = 0.25
        else:  # level_gap > 10
            xp_multiplier = 0.05

        raw_spoils = int(round(base_xp * xp_multiplier))
        # Ensure at least 1 XP per defeated enemy
        self.spoils_xp = max(len(self.squad.enemies), raw_spoils) if base_xp > 0 else 0

        self.log(f"🏆 VICTORY! Enemy squad eliminated!")
        self.log(f"Gained {self.spoils_xp} XP and {self.spoils_gold} Gold.")

        # Credit spoils gold to party
        if hasattr(self.party, "gold"):
            self.party.gold += self.spoils_gold

        # Resolve item loot drops from defeated enemies
        self.spoils_items = []
        from eldoria_py.combat.items import is_key_item
        dropped_summary: list[str] = []
        for enemy in self.squad.enemies:
            drop_table = getattr(enemy, "drop_table", [])
            for drop in drop_table:
                # Absolute invariant: Enemies should NEVER drop key items
                if is_key_item(drop.item_id):
                    continue
                # Bosses have 100% guaranteed drop rate; regular enemies roll against drop.chance
                is_drop = True if getattr(enemy, "is_boss", False) else (self.rng.random() < drop.chance)
                if is_drop:
                    min_q = getattr(drop, "min_qty", 1)
                    max_q = getattr(drop, "max_qty", 1)
                    qty = self.rng.randint(min_q, max_q) if max_q >= min_q else min_q
                    if hasattr(self.party, "add_item"):
                        actual_added = self.party.add_item(drop.item_id, qty)
                        if actual_added > 0:
                            self.spoils_items.append((drop.item_id, actual_added))
                            dropped_summary.append(f"{drop.item_id} x{actual_added}")

        if dropped_summary:
            self.log(f"🎁 Spoils: Obtained {', '.join(dropped_summary)}!")

        if not survivors:
            return

        share_xp = self.spoils_xp // len(survivors)
        if ko_members:
            ko_names = ", ".join(m.name for m in ko_members)
            self.log(f"☠ {ko_names} was KO'd and received no XP ({share_xp} XP each to survivors).")

        STAT_SHORT_NAMES = {
            StatId.HIT_POINTS: "HP",
            StatId.MAGIC_POINTS: "MP",
            StatId.ATTACK: "ATK",
            StatId.DEFENSE: "DEF",
            StatId.MAGIC_ATTACK: "MAT",
            StatId.MAGIC_DEFENSE: "MDF",
            StatId.SPEED: "SPD",
            StatId.LUCK: "LCK",
            StatId.ACCURACY: "ACC",
        }

        for survivor in survivors:
            if hasattr(survivor, "add_xp"):
                summaries = survivor.add_xp(share_xp)
                for s in summaries:
                    gains_dict = s.get("gains", {})
                    gain_parts = []
                    for sid in (
                        StatId.HIT_POINTS,
                        StatId.MAGIC_POINTS,
                        StatId.ATTACK,
                        StatId.DEFENSE,
                        StatId.MAGIC_ATTACK,
                        StatId.MAGIC_DEFENSE,
                        StatId.SPEED,
                        StatId.LUCK,
                        StatId.ACCURACY,
                    ):
                        if sid in gains_dict:
                            gain_parts.append(f"{STAT_SHORT_NAMES.get(sid, sid.name)} +{gains_dict[sid]}")
                    gains_str = ", ".join(gain_parts) if gain_parts else "Stats increased"
                    self.log(f"★ {survivor.name} reached Lv. {s['level']}! ({gains_str})")

    def _trigger_defeat(self) -> None:
        """Handles party wipeout."""
        self.phase = CombatPhase.BATTLE_DEFEAT
        self.log("💀 DEFEAT! All party members have fallen in battle...")
