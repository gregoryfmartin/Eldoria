"""Eldoria NvN Combat Engine package."""
from eldoria_py.combat.stats import (
    StatId,
    BattleActionType,
    BattleActionResultType,
    EquipmentSlot,
    TargetScope,
    AffinityEffect,
    BattleEntityProperty,
)
from eldoria_py.combat.actions import BattleAction, ActionCategory
from eldoria_py.combat.damage import DamageResult, calculate_damage, get_affinity_effect
from eldoria_py.combat.equipment import BattleEquipment
from eldoria_py.combat.entities import (
    Combatant,
    PartyMember,
    EnemyCombatant,
    Party,
    EnemySquad,
    create_default_party,
    create_bat_squad,
)
from eldoria_py.combat.engine import NvNCombatEngine, CombatPhase, QueuedAction
from eldoria_py.combat.encounters import (
    RegionCode,
    generate_encounter,
    create_plains_encounter,
    create_forest_encounter,
    create_cave_encounter,
)

__all__ = [
    "StatId",
    "BattleActionType",
    "BattleActionResultType",
    "EquipmentSlot",
    "TargetScope",
    "AffinityEffect",
    "BattleEntityProperty",
    "BattleAction",
    "ActionCategory",
    "DamageResult",
    "calculate_damage",
    "get_affinity_effect",
    "BattleEquipment",
    "Combatant",
    "PartyMember",
    "EnemyCombatant",
    "Party",
    "EnemySquad",
    "create_default_party",
    "create_bat_squad",
    "NvNCombatEngine",
    "CombatPhase",
    "QueuedAction",
    "RegionCode",
    "generate_encounter",
    "create_plains_encounter",
    "create_forest_encounter",
    "create_cave_encounter",
]
