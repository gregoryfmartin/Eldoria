"""Combat engine core enumerations and entity property containers."""
from __future__ import annotations
from enum import Enum
from typing import Optional, Dict

from ..terminal.color import TrueColor, ColorLibrary


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


class ElementAffinityInfo:
    """Descriptor for an elemental affinity, including display name, Unicode glyph, and color."""

    def __init__(self, affinity: BattleActionType, name: str, glyph: str, color: TrueColor) -> None:
        self.affinity = affinity
        self.name = name
        self.glyph = glyph
        self.color = color

    def format_badge(self) -> str:
        return f"{self.color.to_ansi_fg()}{self.glyph} {self.name}\033[0m"


ELEMENT_AFFINITIES: Dict[BattleActionType, ElementAffinityInfo] = {
    BattleActionType.ELEMENTAL_FIRE: ElementAffinityInfo(
        affinity=BattleActionType.ELEMENTAL_FIRE,
        name="Fire",
        glyph="♨",
        color=ColorLibrary.AppleRedLight,
    ),
    BattleActionType.ELEMENTAL_WATER: ElementAffinityInfo(
        affinity=BattleActionType.ELEMENTAL_WATER,
        name="Water",
        glyph="≈",
        color=ColorLibrary.AppleBlueLight,
    ),
    BattleActionType.ELEMENTAL_EARTH: ElementAffinityInfo(
        affinity=BattleActionType.ELEMENTAL_EARTH,
        name="Earth",
        glyph="▲",
        color=ColorLibrary.AppleOrangeLight,
    ),
    BattleActionType.ELEMENTAL_WIND: ElementAffinityInfo(
        affinity=BattleActionType.ELEMENTAL_WIND,
        name="Wind",
        glyph="≋",
        color=ColorLibrary.AppleGreenLight,
    ),
    BattleActionType.ELEMENTAL_LIGHT: ElementAffinityInfo(
        affinity=BattleActionType.ELEMENTAL_LIGHT,
        name="Light",
        glyph="✦",
        color=ColorLibrary.AppleYellowLight,
    ),
    BattleActionType.ELEMENTAL_DARK: ElementAffinityInfo(
        affinity=BattleActionType.ELEMENTAL_DARK,
        name="Dark",
        glyph="◆",
        color=ColorLibrary.ApplePurpleLight,
    ),
    BattleActionType.ELEMENTAL_ICE: ElementAffinityInfo(
        affinity=BattleActionType.ELEMENTAL_ICE,
        name="Ice",
        glyph="❄",
        color=ColorLibrary.AppleTealLight,
    ),
    BattleActionType.PHYSICAL: ElementAffinityInfo(
        affinity=BattleActionType.PHYSICAL,
        name="Physical",
        glyph="⚔",
        color=ColorLibrary.White,
    ),
    BattleActionType.NONE: ElementAffinityInfo(
        affinity=BattleActionType.NONE,
        name="None",
        glyph="·",
        color=ColorLibrary.DarkGrey,
    ),
}


def get_element_info(affinity: BattleActionType | str) -> Optional[ElementAffinityInfo]:
    if isinstance(affinity, BattleActionType):
        return ELEMENT_AFFINITIES.get(affinity)
    for aff, info in ELEMENT_AFFINITIES.items():
        if affinity in (aff.value, aff.name, info.name):
            return info
    return None


def get_element_glyph(affinity: BattleActionType | str) -> str:
    info = get_element_info(affinity)
    return info.glyph if info else "✦"


def format_element_badge(affinity: BattleActionType | str) -> str:
    info = get_element_info(affinity)
    if info:
        return info.format_badge()
    if isinstance(affinity, BattleActionType):
        raw_name = affinity.name.replace("ELEMENTAL_", "").capitalize()
    else:
        raw_name = str(affinity).replace("ELEMENTAL_", "").capitalize()
    return f"\033[36m{raw_name}\033[0m"


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

    def to_dict(self) -> dict:
        return {
            "base": self.base,
            "current": self.current,
        }

    @classmethod
    def from_dict(cls, data: dict) -> BattleEntityProperty:
        return cls(
            base=data.get("base", 0),
            current=data.get("current", None),
        )

    def __repr__(self) -> str:
        return f"<Stat total={self.total} (base={self.base} eq={self.equipment_bonus} aug={self.augment_value} turns={self.augment_turns})>"
