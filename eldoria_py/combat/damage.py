"""Combat mathematics and damage calculation engine.

Fixes the legacy BaCalc bugs:
- Eliminates Math.Abs inverted defense scaling (higher defense no longer increases damage taken).
- Corrects negative affinity healing (resistances correctly reduce damage, absorptions heal).
- Provides non-negative damage floors, critical strikes, and multi-target AoE scaling.
"""
from __future__ import annotations
import math
import random
from dataclasses import dataclass
from typing import Optional, Any
from eldoria_py.combat.stats import (
    StatId,
    BattleActionType,
    BattleActionResultType,
    AffinityEffect,
    TargetScope,
)

# Canonical 8x8 Elemental Matchup Lookup Table
# Rows: Attacking Action Type -> Cols: Target Affinity -> AffinityEffect
AFFINITY_MATRIX: dict[tuple[BattleActionType, BattleActionType], AffinityEffect] = {
    # Physical vs Elements
    (BattleActionType.PHYSICAL, BattleActionType.PHYSICAL): AffinityEffect.NORMAL,
    (BattleActionType.PHYSICAL, BattleActionType.ELEMENTAL_FIRE): AffinityEffect.NORMAL,
    (BattleActionType.PHYSICAL, BattleActionType.ELEMENTAL_WATER): AffinityEffect.NORMAL,
    (BattleActionType.PHYSICAL, BattleActionType.ELEMENTAL_EARTH): AffinityEffect.NORMAL,
    (BattleActionType.PHYSICAL, BattleActionType.ELEMENTAL_WIND): AffinityEffect.NORMAL,
    (BattleActionType.PHYSICAL, BattleActionType.ELEMENTAL_LIGHT): AffinityEffect.NORMAL,
    (BattleActionType.PHYSICAL, BattleActionType.ELEMENTAL_DARK): AffinityEffect.NORMAL,
    (BattleActionType.PHYSICAL, BattleActionType.ELEMENTAL_ICE): AffinityEffect.NORMAL,

    # Fire Attacks
    (BattleActionType.ELEMENTAL_FIRE, BattleActionType.ELEMENTAL_FIRE): AffinityEffect.RESIST,
    (BattleActionType.ELEMENTAL_FIRE, BattleActionType.ELEMENTAL_WATER): AffinityEffect.RESIST,
    (BattleActionType.ELEMENTAL_FIRE, BattleActionType.ELEMENTAL_EARTH): AffinityEffect.RESIST,
    (BattleActionType.ELEMENTAL_FIRE, BattleActionType.ELEMENTAL_WIND): AffinityEffect.NORMAL,
    (BattleActionType.ELEMENTAL_FIRE, BattleActionType.ELEMENTAL_LIGHT): AffinityEffect.NORMAL,
    (BattleActionType.ELEMENTAL_FIRE, BattleActionType.ELEMENTAL_DARK): AffinityEffect.NORMAL,
    (BattleActionType.ELEMENTAL_FIRE, BattleActionType.ELEMENTAL_ICE): AffinityEffect.WEAK,

    # Water Attacks
    (BattleActionType.ELEMENTAL_WATER, BattleActionType.ELEMENTAL_FIRE): AffinityEffect.WEAK,
    (BattleActionType.ELEMENTAL_WATER, BattleActionType.ELEMENTAL_WATER): AffinityEffect.RESIST,
    (BattleActionType.ELEMENTAL_WATER, BattleActionType.ELEMENTAL_EARTH): AffinityEffect.NORMAL,
    (BattleActionType.ELEMENTAL_WATER, BattleActionType.ELEMENTAL_WIND): AffinityEffect.RESIST,
    (BattleActionType.ELEMENTAL_WATER, BattleActionType.ELEMENTAL_LIGHT): AffinityEffect.NORMAL,
    (BattleActionType.ELEMENTAL_WATER, BattleActionType.ELEMENTAL_DARK): AffinityEffect.NORMAL,
    (BattleActionType.ELEMENTAL_WATER, BattleActionType.ELEMENTAL_ICE): AffinityEffect.RESIST,

    # Earth Attacks
    (BattleActionType.ELEMENTAL_EARTH, BattleActionType.ELEMENTAL_FIRE): AffinityEffect.RESIST,
    (BattleActionType.ELEMENTAL_EARTH, BattleActionType.ELEMENTAL_WATER): AffinityEffect.NORMAL,
    (BattleActionType.ELEMENTAL_EARTH, BattleActionType.ELEMENTAL_EARTH): AffinityEffect.RESIST,
    (BattleActionType.ELEMENTAL_EARTH, BattleActionType.ELEMENTAL_WIND): AffinityEffect.RESIST,
    (BattleActionType.ELEMENTAL_EARTH, BattleActionType.ELEMENTAL_LIGHT): AffinityEffect.NORMAL,
    (BattleActionType.ELEMENTAL_EARTH, BattleActionType.ELEMENTAL_DARK): AffinityEffect.NORMAL,
    (BattleActionType.ELEMENTAL_EARTH, BattleActionType.ELEMENTAL_ICE): AffinityEffect.WEAK,

    # Wind Attacks
    (BattleActionType.ELEMENTAL_WIND, BattleActionType.ELEMENTAL_FIRE): AffinityEffect.NORMAL,
    (BattleActionType.ELEMENTAL_WIND, BattleActionType.ELEMENTAL_WATER): AffinityEffect.NORMAL,
    (BattleActionType.ELEMENTAL_WIND, BattleActionType.ELEMENTAL_EARTH): AffinityEffect.WEAK,
    (BattleActionType.ELEMENTAL_WIND, BattleActionType.ELEMENTAL_WIND): AffinityEffect.RESIST,
    (BattleActionType.ELEMENTAL_WIND, BattleActionType.ELEMENTAL_LIGHT): AffinityEffect.NORMAL,
    (BattleActionType.ELEMENTAL_WIND, BattleActionType.ELEMENTAL_DARK): AffinityEffect.NORMAL,
    (BattleActionType.ELEMENTAL_WIND, BattleActionType.ELEMENTAL_ICE): AffinityEffect.RESIST,

    # Light Attacks
    (BattleActionType.ELEMENTAL_LIGHT, BattleActionType.ELEMENTAL_FIRE): AffinityEffect.NORMAL,
    (BattleActionType.ELEMENTAL_LIGHT, BattleActionType.ELEMENTAL_WATER): AffinityEffect.NORMAL,
    (BattleActionType.ELEMENTAL_LIGHT, BattleActionType.ELEMENTAL_EARTH): AffinityEffect.NORMAL,
    (BattleActionType.ELEMENTAL_LIGHT, BattleActionType.ELEMENTAL_WIND): AffinityEffect.NORMAL,
    (BattleActionType.ELEMENTAL_LIGHT, BattleActionType.ELEMENTAL_LIGHT): AffinityEffect.RESIST,
    (BattleActionType.ELEMENTAL_LIGHT, BattleActionType.ELEMENTAL_DARK): AffinityEffect.WEAK,
    (BattleActionType.ELEMENTAL_LIGHT, BattleActionType.ELEMENTAL_ICE): AffinityEffect.NORMAL,

    # Dark Attacks
    (BattleActionType.ELEMENTAL_DARK, BattleActionType.ELEMENTAL_FIRE): AffinityEffect.NORMAL,
    (BattleActionType.ELEMENTAL_DARK, BattleActionType.ELEMENTAL_WATER): AffinityEffect.NORMAL,
    (BattleActionType.ELEMENTAL_DARK, BattleActionType.ELEMENTAL_EARTH): AffinityEffect.NORMAL,
    (BattleActionType.ELEMENTAL_DARK, BattleActionType.ELEMENTAL_WIND): AffinityEffect.NORMAL,
    (BattleActionType.ELEMENTAL_DARK, BattleActionType.ELEMENTAL_LIGHT): AffinityEffect.WEAK,
    (BattleActionType.ELEMENTAL_DARK, BattleActionType.ELEMENTAL_DARK): AffinityEffect.RESIST,
    (BattleActionType.ELEMENTAL_DARK, BattleActionType.ELEMENTAL_ICE): AffinityEffect.NORMAL,

    # Ice Attacks
    (BattleActionType.ELEMENTAL_ICE, BattleActionType.ELEMENTAL_FIRE): AffinityEffect.RESIST,
    (BattleActionType.ELEMENTAL_ICE, BattleActionType.ELEMENTAL_WATER): AffinityEffect.WEAK,
    (BattleActionType.ELEMENTAL_ICE, BattleActionType.ELEMENTAL_EARTH): AffinityEffect.WEAK,
    (BattleActionType.ELEMENTAL_ICE, BattleActionType.ELEMENTAL_WIND): AffinityEffect.NORMAL,
    (BattleActionType.ELEMENTAL_ICE, BattleActionType.ELEMENTAL_LIGHT): AffinityEffect.NORMAL,
    (BattleActionType.ELEMENTAL_ICE, BattleActionType.ELEMENTAL_DARK): AffinityEffect.NORMAL,
    (BattleActionType.ELEMENTAL_ICE, BattleActionType.ELEMENTAL_ICE): AffinityEffect.RESIST,
}


def get_affinity_effect(
    action_type: BattleActionType,
    target_affinity: BattleActionType,
    explicit_absorbs: Optional[set[BattleActionType]] = None,
    explicit_immunes: Optional[set[BattleActionType]] = None,
) -> AffinityEffect:
    """Determine elemental affinity matchup outcome."""
    if explicit_absorbs and action_type in explicit_absorbs:
        return AffinityEffect.ABSORB
    if explicit_immunes and action_type in explicit_immunes:
        return AffinityEffect.IMMUNE
    if target_affinity == BattleActionType.NONE or action_type == BattleActionType.NONE:
        return AffinityEffect.NORMAL
    return AFFINITY_MATRIX.get((action_type, target_affinity), AffinityEffect.NORMAL)


@dataclass
class DamageResult:
    """Detailed outcome of executing a combat action."""
    result_type: BattleActionResultType
    hit: bool
    is_critical: bool
    affinity_effect: AffinityEffect
    raw_damage: int
    final_damage: int
    is_healing: bool
    message: str


def calculate_hit(
    attacker_acc: int,
    target_spd: int,
    target_lck: int,
    skill_acc: float = 1.0,
    rng: Optional[random.Random] = None,
) -> bool:
    """Hit & evasion check clamped between 5% and 98%."""
    if skill_acc >= 9.0:  # Guaranteed hit flag (e.g. 999.0)
        return True
    r = rng if rng is not None else random
    evasion_factor = (target_spd * 0.4 + target_lck * 0.2) / max(1.0, (100.0 + attacker_acc))
    hit_chance = skill_acc * (1.0 - evasion_factor)
    clamped_chance = max(0.05, min(0.98, hit_chance))
    return r.random() < clamped_chance


def calculate_crit(
    attacker_lck: int,
    target_lck: int,
    rng: Optional[random.Random] = None,
) -> bool:
    """Critical hit check clamped between 2% and 50%."""
    r = rng if rng is not None else random
    crit_chance = (attacker_lck * 1.5 - target_lck * 0.5) / 100.0
    clamped_chance = max(0.02, min(0.50, crit_chance))
    return r.random() < clamped_chance


def calculate_damage(
    attacker_stats: dict[StatId, int],
    target_stats: dict[StatId, int],
    action_type: BattleActionType,
    power: int,
    accuracy: float,
    target_affinity: BattleActionType = BattleActionType.NONE,
    target_count: int = 1,
    explicit_absorbs: Optional[set[BattleActionType]] = None,
    explicit_immunes: Optional[set[BattleActionType]] = None,
    rng: Optional[random.Random] = None,
    force_hit: Optional[bool] = None,
    force_crit: Optional[bool] = None,
    variance: Optional[float] = None,
) -> DamageResult:
    """Executes the shored combat formula and produces a DamageResult."""
    r = rng if rng is not None else random

    # 1. Healing Action
    if action_type == BattleActionType.MAGIC_HEALING:
        matk = attacker_stats.get(StatId.MAGIC_ATTACK, 10)
        heal_base = int((power * matk) / 8.0 + 10)
        var = variance if variance is not None else r.uniform(0.92, 1.08)
        heal_amt = max(1, int(round(heal_base * var)))
        return DamageResult(
            result_type=BattleActionResultType.SUCCESS,
            hit=True,
            is_critical=False,
            affinity_effect=AffinityEffect.NORMAL,
            raw_damage=heal_amt,
            final_damage=-heal_amt,  # Negative represents HP gain
            is_healing=True,
            message=f"Restored {heal_amt} HP!",
        )

    # 2. Hit / Evasion Check
    hit = force_hit if force_hit is not None else calculate_hit(
        attacker_acc=attacker_stats.get(StatId.ACCURACY, 50),
        target_spd=target_stats.get(StatId.SPEED, 10),
        target_lck=target_stats.get(StatId.LUCK, 10),
        skill_acc=accuracy,
        rng=r,
    )

    if not hit:
        return DamageResult(
            result_type=BattleActionResultType.FAILED_MISSED,
            hit=False,
            is_critical=False,
            affinity_effect=AffinityEffect.NORMAL,
            raw_damage=0,
            final_damage=0,
            is_healing=False,
            message="Attack missed!",
        )

    # 3. Critical Hit Check
    is_crit = force_crit if force_crit is not None else calculate_crit(
        attacker_lck=attacker_stats.get(StatId.LUCK, 10),
        target_lck=target_stats.get(StatId.LUCK, 10),
        rng=r,
    )

    # 4. Affinity Check
    affinity = get_affinity_effect(
        action_type=action_type,
        target_affinity=target_affinity,
        explicit_absorbs=explicit_absorbs,
        explicit_immunes=explicit_immunes,
    )

    if affinity == AffinityEffect.IMMUNE:
        return DamageResult(
            result_type=BattleActionResultType.IMMUNE,
            hit=True,
            is_critical=False,
            affinity_effect=AffinityEffect.IMMUNE,
            raw_damage=0,
            final_damage=0,
            is_healing=False,
            message="[No Effect] Target is immune!",
        )

    # 5. Base Damage Math (Non-negative guarantee)
    is_magic = action_type in (
        BattleActionType.ELEMENTAL_FIRE,
        BattleActionType.ELEMENTAL_WATER,
        BattleActionType.ELEMENTAL_EARTH,
        BattleActionType.ELEMENTAL_WIND,
        BattleActionType.ELEMENTAL_LIGHT,
        BattleActionType.ELEMENTAL_DARK,
        BattleActionType.ELEMENTAL_ICE,
        BattleActionType.MAGIC_POISON,
        BattleActionType.MAGIC_CONFUSE,
        BattleActionType.MAGIC_SLEEP,
        BattleActionType.MAGIC_AGING,
    )

    if is_magic:
        atk_val = attacker_stats.get(StatId.MAGIC_ATTACK, 10)
        def_val = target_stats.get(StatId.MAGIC_DEFENSE, 10)
        effective_def = def_val * 0.7 if is_crit else float(def_val)
        # Elemental spells possess an inherent base floor (power * 0.8) so spending MP deals substantial damage
        base_dmg = max(1.0, (power * 0.8) + ((power * atk_val) / 10.0) - (effective_def / 3.0))
    else:
        atk_val = attacker_stats.get(StatId.ATTACK, 10)
        def_val = target_stats.get(StatId.DEFENSE, 10)
        effective_def = def_val * 0.7 if is_crit else float(def_val)
        base_dmg = max(1.0, ((power * atk_val) / 12.0) - (effective_def / 4.0))

    # Variance (0.92 to 1.08)
    var = variance if variance is not None else r.uniform(0.92, 1.08)
    crit_mult = 1.5 if is_crit else 1.0

    # Multi-target AoE Scaling (5v10 Squad balance)
    if target_count >= 5:
        aoe_mult = 0.65
    elif target_count >= 2:
        aoe_mult = 0.80
    else:
        aoe_mult = 1.0

    # Affinity Multiplier
    if affinity == AffinityEffect.WEAK:
        aff_mult = 1.75
    elif affinity == AffinityEffect.RESIST:
        aff_mult = 0.50
    elif affinity == AffinityEffect.ABSORB:
        aff_mult = 1.0  # Will be inverted into heal below
    else:
        aff_mult = 1.0

    calc_val = base_dmg * var * crit_mult * aoe_mult * aff_mult
    raw_dmg = max(1, int(round(calc_val)))

    if affinity == AffinityEffect.ABSORB:
        return DamageResult(
            result_type=BattleActionResultType.ABSORBED,
            hit=True,
            is_critical=is_crit,
            affinity_effect=AffinityEffect.ABSORB,
            raw_damage=raw_dmg,
            final_damage=-raw_dmg,  # Heals the target
            is_healing=True,
            message=f"[Absorbed] Heals for {raw_dmg} HP!",
        )

    # Determine Result Type Tag
    if is_crit and affinity == AffinityEffect.WEAK:
        res_type = BattleActionResultType.SUCCESS_CRIT_AND_AFFINITY
        msg = f"[★ CRIT & WEAKNESS] Dealt {raw_dmg} damage!"
    elif is_crit:
        res_type = BattleActionResultType.SUCCESS_CRITICAL
        msg = f"[★ CRITICAL HIT] Dealt {raw_dmg} damage!"
    elif affinity == AffinityEffect.WEAK:
        res_type = BattleActionResultType.SUCCESS_AFFINITY_BONUS
        msg = f"[★ CRITICAL WEAKNESS] Dealt {raw_dmg} damage!"
    elif affinity == AffinityEffect.RESIST:
        res_type = BattleActionResultType.SUCCESS
        msg = f"[Resisted] Dealt {raw_dmg} damage."
    else:
        res_type = BattleActionResultType.SUCCESS
        msg = f"Dealt {raw_dmg} damage."

    return DamageResult(
        result_type=res_type,
        hit=True,
        is_critical=is_crit,
        affinity_effect=affinity,
        raw_damage=raw_dmg,
        final_damage=raw_dmg,
        is_healing=False,
        message=msg,
    )
