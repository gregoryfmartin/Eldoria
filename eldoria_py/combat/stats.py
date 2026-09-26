"""Combat engine core enumerations and entity property containers."""
from __future__ import annotations
from enum import Enum
from typing import Optional


class StatId(str, Enum):
    """Core RPG combat statistics."""
    HIT_POINTS = "HitPoints"
    MAGIC_POINTS = "MagicPoints"
    ATTACK = "Attack"
    DEFENSE = "Defense"
    MAGIC_ATTACK = "MagicAttack"
    MAGIC_DEFENSE = "MagicDefense"
    SPEED = "Speed"
    LUCK = "Luck"
    ACCURACY = "Accuracy"


class BattleActionType(str, Enum):
    """Elemental affinities, damage classifications, and status types."""
    PHYSICAL = "Physical"
    ELEMENTAL_FIRE = "ElementalFire"
    ELEMENTAL_WATER = "ElementalWater"
    ELEMENTAL_EARTH = "ElementalEarth"
    ELEMENTAL_WIND = "ElementalWind"
    ELEMENTAL_LIGHT = "ElementalLight"
    ELEMENTAL_DARK = "ElementalDark"
    ELEMENTAL_ICE = "ElementalIce"
    MAGIC_POISON = "MagicPoison"
    MAGIC_CONFUSE = "MagicConfuse"
    MAGIC_SLEEP = "MagicSleep"
    MAGIC_AGING = "MagicAging"
    MAGIC_HEALING = "MagicHealing"
    MAGIC_STAT_AUGMENT = "MagicStatAugment"
    NONE = "None"


class BattleActionResultType(str, Enum):
    """Outcome classification of a battle action."""
    SUCCESS = "Success"
    SUCCESS_CRITICAL = "SuccessWithCritical"
    SUCCESS_AFFINITY_BONUS = "SuccessWithAffinityBonus"
    SUCCESS_CRIT_AND_AFFINITY = "SuccessWithCritAndAffinityBonus"
    FAILED_MISSED = "FailedAttackMissed"
    FAILED_NOT_ENOUGH_MP = "FailedNotEnoughMp"
    IMMUNE = "FailedImmune"
    ABSORBED = "Absorbed"


class EquipmentSlot(str, Enum):
    """The 10 equipment slots available to party members."""
    WEAPON = "Weapon"
    HELMET = "Helmet"
    ARMOR = "Armor"
    PAULDRON = "Pauldron"
    GAUNTLETS = "Gauntlets"
    GREAVES = "Greaves"
    BOOTS = "Boots"
    JEWELRY_A = "JewelryA"
    JEWELRY_B = "JewelryB"
    CAPE = "Cape"


class TargetScope(str, Enum):
    """Targeting scope for battle actions."""
    SINGLE_ENEMY = "SingleEnemy"
    ALL_ENEMIES = "AllEnemies"
    CLEAVE_ENEMIES = "CleaveEnemies"
    SINGLE_ALLY = "SingleAlly"
    ALL_ALLIES = "AllAllies"
    SELF = "Self"


class AffinityEffect(str, Enum):
    """Multipliers and effects resulting from elemental affinity matchups."""
    WEAK = "Weak"       # 1.75x damage
    NORMAL = "Normal"   # 1.0x damage
    RESIST = "Resist"   # 0.5x damage
    IMMUNE = "Immune"   # 0.0x damage
    ABSORB = "Absorb"   # Converts damage into healing


class BattleEntityProperty:
    """Manages a single numeric stat with equipment scaling and turn-based augments."""

    def __init__(self, base: int = 0, current: Optional[int] = None):
        self.base: int = max(0, int(base))
        self.equipment_bonus: int = 0
        self.augment_value: int = 0
        self.augment_turns: int = 0
        self._current: int = self.total if current is None else max(0, int(current))

    @property
    def total(self) -> int:
        """Total effective stat value factoring in base, equipment, and active augments."""
        return max(0, self.base + self.equipment_bonus + self.augment_value)

    @property
    def current(self) -> int:
        """Current stat value (e.g. current HP or current MP), bounded by [0, total]."""
        return max(0, min(self._current, self.total))

    @current.setter
    def current(self, value: int) -> None:
        self._current = max(0, min(int(value), self.total))

    def modify_current(self, delta: int) -> int:
        """Modify current value by delta, clamping between 0 and total. Returns actual change."""
        old = self.current
        self.current = self.current + delta
        return self.current - old

    def apply_augment(self, value: int, duration_turns: int) -> None:
        """Apply a temporary stat modifier (buff/debuff) for N turns."""
        self.augment_value = value
        self.augment_turns = max(1, duration_turns)

    def clear_augment(self) -> None:
        """Clear active stat augment."""
        self.augment_value = 0
        self.augment_turns = 0

    def update(self) -> None:
        """Turn maintenance tick for active augments."""
        if self.augment_turns > 0:
            self.augment_turns -= 1
            if self.augment_turns == 0:
                self.augment_value = 0

    def __repr__(self) -> str:
        return f"<Stat total={self.total} (base={self.base} eq={self.equipment_bonus} aug={self.augment_value} turns={self.augment_turns})>"
