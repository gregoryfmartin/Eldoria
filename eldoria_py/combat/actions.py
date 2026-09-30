"""BattleAction definitions and action library."""
from __future__ import annotations
from dataclasses import dataclass, field
from enum import Enum
from typing import Optional
from eldoria_py.combat.stats import BattleActionType, TargetScope


class ActionCategory(str, Enum):
    """Broad UI category for selecting combat actions."""
    ATTACK = "Attack"
    SKILL = "Skill"
    SPELL = "Spell"
    DEFEND = "Defend"
    ITEM = "Item"


@dataclass
class BattleAction:
    """Represents an executable action in combat."""
    name: str
    action_type: BattleActionType
    category: ActionCategory = ActionCategory.ATTACK
    mp_cost: int = 0
    effect_value: int = 10
    accuracy: float = 1.0
    target_scope: TargetScope = TargetScope.SINGLE_ENEMY
    speed_priority: float = 1.0
    description: str = ""

    def copy(self) -> BattleAction:
        """Create a clone of this action."""
        return BattleAction(
            name=self.name,
            action_type=self.action_type,
            category=self.category,
            mp_cost=self.mp_cost,
            effect_value=self.effect_value,
            accuracy=self.accuracy,
            target_scope=self.target_scope,
            speed_priority=self.speed_priority,
            description=self.description,
        )

    def to_dict(self) -> dict:
        return {
            "name": self.name,
            "action_type": self.action_type.value,
            "category": self.category.value,
            "mp_cost": self.mp_cost,
            "effect_value": self.effect_value,
            "accuracy": self.accuracy,
            "target_scope": self.target_scope.value,
            "speed_priority": self.speed_priority,
            "description": self.description,
        }

    @classmethod
    def from_dict(cls, data: dict | str) -> BattleAction:
        if isinstance(data, str):
            if data in ACTIONS:
                return ACTIONS[data].copy()
            raise ValueError(f"Unknown battle action name: {data}")
        return cls(
            name=data["name"],
            action_type=BattleActionType(data["action_type"]),
            category=ActionCategory(data.get("category", ActionCategory.ATTACK.value)),
            mp_cost=data.get("mp_cost", 0),
            effect_value=data.get("effect_value", 10),
            accuracy=data.get("accuracy", 1.0),
            target_scope=TargetScope(data.get("target_scope", TargetScope.SINGLE_ENEMY.value)),
            speed_priority=data.get("speed_priority", 1.0),
            description=data.get("description", ""),
        )


# Canonical library of pre-built actions
ACTIONS: dict[str, BattleAction] = {
    # Basic Attacks
    "Attack": BattleAction(
        name="Attack",
        action_type=BattleActionType.PHYSICAL,
        category=ActionCategory.ATTACK,
        mp_cost=0,
        effect_value=12,
        accuracy=0.95,
        target_scope=TargetScope.SINGLE_ENEMY,
        description="Standard physical strike.",
    ),
    "Defend": BattleAction(
        name="Defend",
        action_type=BattleActionType.PHYSICAL,
        category=ActionCategory.DEFEND,
        mp_cost=0,
        effect_value=0,
        accuracy=999.0,
        target_scope=TargetScope.SELF,
        speed_priority=3.0,
        description="Brace for impact, halving damage taken this round.",
    ),

    # Physical Skills
    "Axe Cleave": BattleAction(
        name="Axe Cleave",
        action_type=BattleActionType.PHYSICAL,
        category=ActionCategory.SKILL,
        mp_cost=9,
        effect_value=18,
        accuracy=0.90,
        target_scope=TargetScope.SINGLE_ENEMY,
        description="Heavy overhead axe strike.",
    ),
    "Flame Punch": BattleAction(
        name="Flame Punch",
        action_type=BattleActionType.ELEMENTAL_FIRE,
        category=ActionCategory.SKILL,
        mp_cost=7,
        effect_value=16,
        accuracy=0.92,
        target_scope=TargetScope.SINGLE_ENEMY,
        description="Fist cloaked in roaring fire.",
    ),
    "Drop Kick": BattleAction(
        name="Drop Kick",
        action_type=BattleActionType.PHYSICAL,
        category=ActionCategory.SKILL,
        mp_cost=12,
        effect_value=22,
        accuracy=0.85,
        target_scope=TargetScope.SINGLE_ENEMY,
        description="High-flying reckless drop kick.",
    ),
    "Double Scratch": BattleAction(
        name="Double Scratch",
        action_type=BattleActionType.PHYSICAL,
        category=ActionCategory.SKILL,
        mp_cost=5,
        effect_value=14,
        accuracy=0.95,
        target_scope=TargetScope.SINGLE_ENEMY,
        description="Swift twin claw attack.",
    ),

    # Magic Spells
    "Fireball": BattleAction(
        name="Fireball",
        action_type=BattleActionType.ELEMENTAL_FIRE,
        category=ActionCategory.SPELL,
        mp_cost=20,
        effect_value=20,
        accuracy=0.98,
        target_scope=TargetScope.ALL_ENEMIES,
        description="Launches an explosive sphere of flame across all enemies.",
    ),
    "Ice Bolt": BattleAction(
        name="Ice Bolt",
        action_type=BattleActionType.ELEMENTAL_ICE,
        category=ActionCategory.SPELL,
        mp_cost=7,
        effect_value=18,
        accuracy=0.98,
        target_scope=TargetScope.SINGLE_ENEMY,
        description="Piercing shard of glacial ice.",
    ),
    "Arctic Blast": BattleAction(
        name="Arctic Blast",
        action_type=BattleActionType.ELEMENTAL_ICE,
        category=ActionCategory.SPELL,
        mp_cost=24,
        effect_value=22,
        accuracy=0.98,
        target_scope=TargetScope.ALL_ENEMIES,
        description="Unleashes a sweeping blizzard on enemy forces.",
    ),
    "Tidal Crush": BattleAction(
        name="Tidal Crush",
        action_type=BattleActionType.ELEMENTAL_WATER,
        category=ActionCategory.SPELL,
        mp_cost=8,
        effect_value=19,
        accuracy=0.98,
        target_scope=TargetScope.SINGLE_ENEMY,
        description="Surges high-pressure water at the target.",
    ),
    "Boulder Bash": BattleAction(
        name="Boulder Bash",
        action_type=BattleActionType.ELEMENTAL_EARTH,
        category=ActionCategory.SPELL,
        mp_cost=9,
        effect_value=20,
        accuracy=0.98,
        target_scope=TargetScope.SINGLE_ENEMY,
        description="Crushes the enemy under an immense boulder.",
    ),
    "Galeflash": BattleAction(
        name="Galeflash",
        action_type=BattleActionType.ELEMENTAL_WIND,
        category=ActionCategory.SPELL,
        mp_cost=7,
        effect_value=17,
        accuracy=0.98,
        target_scope=TargetScope.SINGLE_ENEMY,
        description="Razor winds that slice with incredible speed.",
    ),
    "Radiance": BattleAction(
        name="Radiance",
        action_type=BattleActionType.ELEMENTAL_LIGHT,
        category=ActionCategory.SPELL,
        mp_cost=22,
        effect_value=21,
        accuracy=0.98,
        target_scope=TargetScope.ALL_ENEMIES,
        description="Blinds and burns evil with holy sunlight.",
    ),
    "Dark Surge": BattleAction(
        name="Dark Surge",
        action_type=BattleActionType.ELEMENTAL_DARK,
        category=ActionCategory.SPELL,
        mp_cost=11,
        effect_value=22,
        accuracy=0.98,
        target_scope=TargetScope.SINGLE_ENEMY,
        description="Erupts necrotic energy underneath the target.",
    ),
    "Cataclysm": BattleAction(
        name="Cataclysm",
        action_type=BattleActionType.ELEMENTAL_DARK,
        category=ActionCategory.SPELL,
        mp_cost=36,
        effect_value=32,
        accuracy=0.98,
        target_scope=TargetScope.ALL_ENEMIES,
        description="Unleashes devastating apocalyptic dark matter over all opponents.",
    ),

    # Healing & Support
    "Heal": BattleAction(
        name="Heal",
        action_type=BattleActionType.MAGIC_HEALING,
        category=ActionCategory.SPELL,
        mp_cost=8,
        effect_value=25,
        accuracy=999.0,
        target_scope=TargetScope.SINGLE_ALLY,
        description="Restores health to an ally.",
    ),
    "Group Heal": BattleAction(
        name="Group Heal",
        action_type=BattleActionType.MAGIC_HEALING,
        category=ActionCategory.SPELL,
        mp_cost=22,
        effect_value=18,
        accuracy=999.0,
        target_scope=TargetScope.ALL_ALLIES,
        description="Blesses and heals all allies in the party.",
    ),

    # Enemy Actions
    "Bite": BattleAction(
        name="Bite",
        action_type=BattleActionType.PHYSICAL,
        category=ActionCategory.ATTACK,
        mp_cost=0,
        effect_value=10,
        accuracy=0.90,
        target_scope=TargetScope.SINGLE_ENEMY,
        description="Vicious fang puncture.",
    ),
    "Blood Drain": BattleAction(
        name="Blood Drain",
        action_type=BattleActionType.ELEMENTAL_DARK,
        category=ActionCategory.SKILL,
        mp_cost=5,
        effect_value=13,
        accuracy=0.92,
        target_scope=TargetScope.SINGLE_ENEMY,
        description="Siphons lifeforce from the victim.",
    ),
    "Screech": BattleAction(
        name="Screech",
        action_type=BattleActionType.ELEMENTAL_WIND,
        category=ActionCategory.SKILL,
        mp_cost=8,
        effect_value=9,
        accuracy=0.95,
        target_scope=TargetScope.ALL_ENEMIES,
        description="Piercing sonic shriek disrupting all opponents.",
    ),
}
