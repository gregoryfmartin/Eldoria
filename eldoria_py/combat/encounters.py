"""Regional and Biome-driven enemy encounter tables, dynamic stat scaling, and squad generation."""
from __future__ import annotations
import random
from enum import IntEnum
from typing import Optional, Union, Tuple
from eldoria_py.combat.stats import StatId, BattleActionType
from eldoria_py.combat.actions import BattleAction, ActionCategory, ACTIONS
from eldoria_py.combat.entities import EnemyCombatant, EnemySquad
from eldoria_py.procgen.map_generator import BiomeType
from eldoria_py.combat.bestiary import (
    BOSS_CATALOG,
    BESTIARY,
    BestiaryTemplate,
    get_template,
    get_boss_by_region,
)


class RegionCode(IntEnum):
    """Regional danger tiers from 0 (Safe) to 9 (Endgame Citadel)."""
    SAFE = 0
    TIER_1 = 1
    TIER_2 = 2
    TIER_3 = 3
    TIER_4 = 4
    TIER_5 = 5
    TIER_6 = 6
    TIER_7 = 7
    TIER_8 = 8
    TIER_9 = 9

    # Backward compatibility aliases
    OVERWORLD_PLAINS = 1
    OVERWORLD_FOREST = 2
    SUBTERRANEAN_CAVE = 3


# Level ranges mapped to Region Codes (1 to 9)
REGION_LEVEL_RANGES: dict[int, Tuple[int, int]] = {
    1: (1, 4),
    2: (5, 10),
    3: (11, 18),
    4: (19, 28),
    5: (29, 40),
    6: (41, 55),
    7: (56, 70),
    8: (71, 85),
    9: (86, 95),
}

# Threat rank scaling multipliers
THREAT_MULTIPLIERS: dict[str, float] = {
    "D": 1.0,     # Standard minion / skirmisher
    "C": 1.35,    # Veteran / prowler
    "B": 1.8,     # Elite / squad captain
    "A": 2.4,     # Champion / apex predator
    "S": 3.5,     # Boss / dungeon overlord
}


# -----------------------------------------------------------------------------
# Spoils Calculation
# -----------------------------------------------------------------------------
def calculate_enemy_xp_reward(level: int, threat_rank: str = "D") -> int:
    """Calculates individual enemy XP reward using:
    BaseXP(L) = round(18.0 * (L ** 1.15)) * ThreatMultiplier
    Guarantees no single enemy can power-level a character to 99.
    """
    mult = THREAT_MULTIPLIERS.get(threat_rank, 1.0)
    base = 18.0 * (max(1, int(level)) ** 1.15)
    return max(5, int(round(base * mult)))


def calculate_enemy_gold_reward(level: int, threat_rank: str = "D") -> int:
    """Calculates individual enemy Gold reward using:
    BaseGold(L) = round(12.0 * (L ** 1.05)) * ThreatMultiplier
    """
    mult = THREAT_MULTIPLIERS.get(threat_rank, 1.0)
    base = 12.0 * (max(1, int(level)) ** 1.05)
    return max(3, int(round(base * mult)))


# -----------------------------------------------------------------------------
# Parameterized Scaled Enemy Builder
# -----------------------------------------------------------------------------
def build_scaled_enemy(
    name: str,
    family: str,
    level: int = 1,
    threat_rank: str = "D",
    affinity: BattleActionType = BattleActionType.PHYSICAL,
    role: str = "balanced",  # "tank", "dps", "magic", "speed", "balanced", "boss"
    actions: Optional[list[BattleAction]] = None,
    is_boss: bool = False,
    defend_chance: float = 0.06,
    defend_multiplier: float = 0.50,
    negate_crits_when_defending: bool = False,
    drop_table: Optional[list[Any]] = None,
    base_hp_override: Optional[int] = None,
) -> EnemyCombatant:
    """Builds an enemy combatant with dynamically scaled stats adhering to hard caps (9999 HP, 999 MP, 99 stats)."""
    lvl = max(1, min(95, int(level)))
    rank_mult = THREAT_MULTIPLIERS.get(threat_rank, 1.0)

    if role == "boss":
        hp_growth, atk_growth, def_growth, spd_growth = 50.0, 0.80, 0.65, 0.50
        base_hp, base_atk, base_def = 180, 22, 16
    elif role == "tank":
        hp_growth, atk_growth, def_growth, spd_growth = 35.0, 0.55, 0.70, 0.30
        base_hp, base_atk, base_def = 45, 15, 14
    elif role == "dps":
        hp_growth, atk_growth, def_growth, spd_growth = 28.0, 0.75, 0.45, 0.45
        base_hp, base_atk, base_def = 35, 18, 10
    elif role == "speed":
        hp_growth, atk_growth, def_growth, spd_growth = 22.0, 0.60, 0.35, 0.80
        base_hp, base_atk, base_def = 25, 16, 9
    elif role == "magic":
        hp_growth, atk_growth, def_growth, spd_growth = 20.0, 0.30, 0.35, 0.40
        base_hp, base_atk, base_def = 24, 10, 8
    else:  # balanced
        hp_growth, atk_growth, def_growth, spd_growth = 26.0, 0.55, 0.50, 0.45
        base_hp, base_atk, base_def = 30, 15, 11

    if base_hp_override is not None:
        raw_hp = base_hp_override
    else:
        raw_hp = int(round((base_hp + (lvl - 1) * hp_growth) * (0.8 + 0.2 * rank_mult)))
    raw_mp = int(round((40 + (lvl - 1) * 4.5) * (0.8 + 0.2 * rank_mult)))

    stats = {
        StatId.HIT_POINTS: min(9999, max(15, raw_hp)),
        StatId.MAGIC_POINTS: min(999, max(10, raw_mp)),
        StatId.ATTACK: min(99, max(5, int(round(base_atk + (lvl - 1) * atk_growth)))),
        StatId.DEFENSE: min(99, max(5, int(round(base_def + (lvl - 1) * def_growth)))),
        StatId.MAGIC_ATTACK: min(99, max(5, int(round(10 + (lvl - 1) * 0.45)))),
        StatId.MAGIC_DEFENSE: min(99, max(5, int(round(10 + (lvl - 1) * 0.45)))),
        StatId.SPEED: min(99, max(5, int(round(12 + (lvl - 1) * spd_growth)))),
        StatId.LUCK: min(99, max(5, int(round(10 + (lvl - 1) * 0.30)))),
        StatId.ACCURACY: min(99, max(50, int(round(82 + (lvl - 1) * 0.10)))),
    }

    if actions is None:
        actions = [ACTIONS["Attack"].copy()]

    xp_reward = calculate_enemy_xp_reward(lvl, threat_rank)
    gold_reward = calculate_enemy_gold_reward(lvl, threat_rank)

    return EnemyCombatant(
        name=name,
        family=family,
        level=lvl,
        threat_rank=threat_rank,
        affinity=affinity,
        stats=stats,
        actions=actions,
        xp_reward=xp_reward,
        gold_reward=gold_reward,
        is_boss=is_boss,
        defend_chance=defend_chance,
        defend_damage_multiplier=defend_multiplier,
        negate_crits_when_defending=negate_crits_when_defending,
        drop_table=drop_table,
    )


# -----------------------------------------------------------------------------
# Bestiary Template Builders
# -----------------------------------------------------------------------------
def build_from_template(template: BestiaryTemplate, level: Optional[int] = None) -> EnemyCombatant:
    """Builds an EnemyCombatant directly from a BestiaryTemplate."""
    lvl = level if level is not None else (template.default_level if template.default_level is not None else 1)
    actions = [ACTIONS[a_name].copy() for a_name in template.actions if a_name in ACTIONS]
    if not actions:
        actions = [ACTIONS["Attack"].copy()]

    return build_scaled_enemy(
        name=template.name,
        family=template.family,
        level=lvl,
        threat_rank=template.threat_rank,
        affinity=template.affinity,
        role=template.role,
        actions=actions,
        is_boss=template.is_boss,
        defend_chance=template.defend_chance,
        defend_multiplier=template.defend_multiplier,
        negate_crits_when_defending=template.negate_crits_when_defending,
        drop_table=list(template.drop_table),
        base_hp_override=template.base_hp_override,
    )


def build_boss_enemy(boss_name: str, level: Optional[int] = None) -> EnemyCombatant:
    """Builds a boss EnemyCombatant by boss name from BOSS_CATALOG."""
    if boss_name in BOSS_CATALOG:
        return build_from_template(BOSS_CATALOG[boss_name], level=level)
    return build_from_template(BOSS_CATALOG["Malakor"], level=level)


def create_boss_encounter(boss_name: str, level: Optional[int] = None) -> EnemySquad:
    """Creates a solo boss encounter. Invariant: Boss encounters will NEVER have more than the boss enemy in the troop."""
    boss = build_boss_enemy(boss_name, level=level)
    return EnemySquad([boss])


# -----------------------------------------------------------------------------
# Specific Archetype Builders (Backward Compatible)
# -----------------------------------------------------------------------------
def build_bandit_archer(name: str = "Archer", level: int = 2) -> EnemyCombatant:
    return build_scaled_enemy(
        name=name,
        family="Humanoid / Rogue",
        level=level,
        threat_rank="D",
        affinity=BattleActionType.PHYSICAL,
        role="speed",
        actions=[ACTIONS["Attack"].copy(), ACTIONS["Drop Kick"].copy()],
    )


def build_bandit_brawler(name: str = "Brawler", level: int = 2) -> EnemyCombatant:
    return build_scaled_enemy(
        name=name,
        family="Humanoid / Warrior",
        level=level,
        threat_rank="D",
        affinity=BattleActionType.ELEMENTAL_EARTH,
        role="dps",
        actions=[ACTIONS["Attack"].copy(), ACTIONS["Drop Kick"].copy(), ACTIONS["Defend"].copy()],
    )


def build_bandit_chieftain(name: str = "Chief", level: int = 4) -> EnemyCombatant:
    return build_scaled_enemy(
        name=name,
        family="Humanoid / Boss",
        level=level,
        threat_rank="B",
        affinity=BattleActionType.ELEMENTAL_FIRE,
        role="tank",
        actions=[ACTIONS["Axe Cleave"].copy(), ACTIONS["Flame Punch"].copy(), ACTIONS["Attack"].copy()],
    )


def build_wild_wolf(name: str = "Wolf", level: int = 2) -> EnemyCombatant:
    return build_scaled_enemy(
        name=name,
        family="Beast / Canine",
        level=level,
        threat_rank="D",
        affinity=BattleActionType.PHYSICAL,
        role="speed",
        actions=[ACTIONS["Bite"].copy(), ACTIONS["Double Scratch"].copy()],
    )


def build_dire_wolf(name: str = "Direwolf", level: int = 4) -> EnemyCombatant:
    return build_scaled_enemy(
        name=name,
        family="Beast / Apex",
        level=level,
        threat_rank="C",
        affinity=BattleActionType.ELEMENTAL_WIND,
        role="dps",
        actions=[ACTIONS["Bite"].copy(), ACTIONS["Screech"].copy(), ACTIONS["Double Scratch"].copy()],
    )


def build_rock_golem(name: str = "Golem", level: int = 3) -> EnemyCombatant:
    return build_scaled_enemy(
        name=name,
        family="Construct / Earth",
        level=level,
        threat_rank="C",
        affinity=BattleActionType.ELEMENTAL_EARTH,
        role="tank",
        actions=[ACTIONS["Boulder Bash"].copy(), ACTIONS["Attack"].copy(), ACTIONS["Defend"].copy()],
    )


def build_cave_bat(name: str = "Bat", level: int = 2, is_elite: bool = False, is_boss: bool = False) -> EnemyCombatant:
    rank = "S" if is_boss else ("B" if is_elite else "D")
    return build_scaled_enemy(
        name=name,
        family="Beast / Flying",
        level=level,
        threat_rank=rank,
        affinity=BattleActionType.ELEMENTAL_ICE,
        role="speed",
        actions=[ACTIONS["Bite"].copy(), ACTIONS["Blood Drain"].copy(), ACTIONS["Screech"].copy()],
    )


# -----------------------------------------------------------------------------
# Regional & Biome Squad Generators (Bestiary Driven)
# -----------------------------------------------------------------------------
def _pick_biome_templates(biome_name: str, region_code: int) -> list[BestiaryTemplate]:
    reg = max(1, min(9, region_code))
    matching = [
        t for t in BESTIARY.values()
        if (not t.is_boss) and any(biome_name.lower() in b.lower() for b in t.biomes) and t.min_region <= reg <= t.max_region
    ]
    if not matching:
        matching = [t for t in BESTIARY.values() if not t.is_boss and t.min_region <= reg <= t.max_region]
    if not matching:
        matching = [t for t in BESTIARY.values() if not t.is_boss]
    return matching


def create_plains_encounter(rng: Optional[random.Random] = None, region_code: int = 1) -> EnemySquad:
    """Plains, Coast, and Roads: Bandits, scouts, and road encounters scaled to region tier (3 to 5 enemies)."""
    r = rng if rng is not None else random
    reg = max(1, min(9, region_code))
    lvl_min, lvl_max = REGION_LEVEL_RANGES[reg]
    squad = EnemySquad()

    templates = _pick_biome_templates("Plains", reg)
    count = r.randint(3, 5)
    for _ in range(count):
        tmpl = r.choice(templates)
        lvl = r.randint(lvl_min, lvl_max)
        squad.add_enemy(build_from_template(tmpl, level=lvl))

    # Invariant: Ensure at least one representative regional archetype in lower regions
    core_plains = [t for t in templates if any(k in t.name for k in ("Brawler", "Archer", "Scout", "Wolf", "Bat", "Bandit"))]
    if core_plains and not any(any(k in m.name for k in ("Brawler", "Archer", "Scout", "Wolf", "Bat", "Highwayman", "Bandit")) for m in squad.enemies):
        tmpl = r.choice(core_plains)
        lvl = r.randint(lvl_min, lvl_max)
        squad.enemies[0] = build_from_template(tmpl, level=lvl)

    return squad


def create_forest_encounter(rng: Optional[random.Random] = None, region_code: int = 2) -> EnemySquad:
    """Forest & Woods: Woodland beasts, predators, and plant fiends scaled to region tier (4 to 7 enemies)."""
    r = rng if rng is not None else random
    reg = max(1, min(9, region_code))
    lvl_min, lvl_max = REGION_LEVEL_RANGES[reg]
    squad = EnemySquad()

    templates = _pick_biome_templates("Forest", reg)
    count = r.randint(4, 7)
    for _ in range(count):
        tmpl = r.choice(templates)
        lvl = r.randint(lvl_min, lvl_max)
        squad.add_enemy(build_from_template(tmpl, level=lvl))

    return squad


def create_cave_encounter(rng: Optional[random.Random] = None, region_code: int = 3) -> EnemySquad:
    """Cave & Dungeon Sub-Maps: Subterranean horrors, undead, and vermin scaled to floor depth (6 to 10 enemies)."""
    r = rng if rng is not None else random
    reg = max(1, min(9, region_code))
    lvl_min, lvl_max = REGION_LEVEL_RANGES[reg]
    squad = EnemySquad()

    templates = _pick_biome_templates("Cave", reg)
    count = r.randint(6, 10)
    for _ in range(count):
        tmpl = r.choice(templates)
        lvl = r.randint(lvl_min, lvl_max)
        squad.add_enemy(build_from_template(tmpl, level=lvl))

    # Invariant: Ensure at least one Bat or Golem in early subterranean caverns
    core_cave = [t for t in templates if "Bat" in t.name or "Golem" in t.name]
    if core_cave and not any("Bat" in m.name or "Golem" in m.name for m in squad.enemies):
        tmpl = r.choice(core_cave)
        lvl = r.randint(lvl_min, lvl_max)
        squad.enemies[0] = build_from_template(tmpl, level=lvl)

    return squad


def create_mountain_encounter(rng: Optional[random.Random] = None, region_code: int = 5) -> EnemySquad:
    """Mountain & Snow Peaks: Golems, avians, giants, and glacial beasts (3 to 6 enemies)."""
    r = rng if rng is not None else random
    reg = max(1, min(9, region_code))
    lvl_min, lvl_max = REGION_LEVEL_RANGES[reg]
    squad = EnemySquad()

    templates = _pick_biome_templates("Mountain", reg)
    count = r.randint(3, 6)
    for _ in range(count):
        tmpl = r.choice(templates)
        lvl = r.randint(lvl_min, lvl_max)
        squad.add_enemy(build_from_template(tmpl, level=lvl))

    return squad


# -----------------------------------------------------------------------------
# Universal Dispatcher
# -----------------------------------------------------------------------------
def generate_encounter(
    arg1: Union[BiomeType, int, str],
    arg2: Optional[Union[int, random.Random]] = None,
    rng: Optional[random.Random] = None,
) -> Optional[EnemySquad]:
    """Factory creating an EnemySquad based on Biome and Region Code (1 to 9).
    Supports signatures:
      generate_encounter(biome: BiomeType, region_code: int = 1, rng = None)
      generate_encounter(region_code: int, rng = None)   # backward compatibility
    """
    r = rng
    if isinstance(arg1, (int, RegionCode)):
        # Legacy signature: generate_encounter(region_code, rng)
        region_code = int(arg1)
        if isinstance(arg2, random.Random):
            r = arg2

        if region_code == RegionCode.SAFE:
            return None
        elif region_code == RegionCode.OVERWORLD_FOREST:
            biome_str = "Forest"
        elif region_code == RegionCode.SUBTERRANEAN_CAVE:
            biome_str = "Cave"
        else:
            biome_str = "Plains"
    else:
        # Modern signature: generate_encounter(biome, region_code, rng)
        biome_str = str(arg1.value if hasattr(arg1, "value") else arg1)
        if isinstance(arg2, (int, RegionCode)):
            region_code = int(arg2)
        else:
            region_code = 1
            if isinstance(arg2, random.Random):
                r = arg2

    if region_code == RegionCode.SAFE:
        return None

    region_code = max(1, min(9, region_code))
    r = r if r is not None else random

    b_lower = biome_str.lower()
    if "forest" in b_lower:
        return create_forest_encounter(rng=r, region_code=region_code)
    elif "cave" in b_lower or "subterranean" in b_lower or "dungeon" in b_lower:
        return create_cave_encounter(rng=r, region_code=region_code)
    elif "mountain" in b_lower or "snow" in b_lower:
        return create_mountain_encounter(rng=r, region_code=region_code)
    else:
        # Default to Plains / Coast / Road
        return create_plains_encounter(rng=r, region_code=region_code)
