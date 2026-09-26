"""Regional enemy encounter tables and squad generation for Eldoria."""
from __future__ import annotations
import random
from enum import IntEnum
from typing import Optional
from eldoria_py.combat.stats import StatId, BattleActionType
from eldoria_py.combat.actions import BattleAction, ActionCategory, ACTIONS
from eldoria_py.combat.entities import EnemyCombatant, EnemySquad


class RegionCode(IntEnum):
    """Geographical and thematic encounter zones."""
    SAFE = 0                 # Towns, Castles, Safe POIs (0% encounters)
    OVERWORLD_PLAINS = 1     # Plains, Coastlines, Roads (Bandits, Stray Bats, Scouts)
    OVERWORLD_FOREST = 2     # Dense Forests, Woods (Wolves, Spiders, Raiding Parties)
    SUBTERRANEAN_CAVE = 3    # Deep Caverns, Dungeons (Bat Swarms, Rock Golems, Troglodytes)


# -----------------------------------------------------------------------------
# Enemy Archetype Builders
# -----------------------------------------------------------------------------
def build_bandit_archer(name: str = "Bandit Archer", level: int = 2) -> EnemyCombatant:
    return EnemyCombatant(
        name=name,
        family="Humanoid / Rogue",
        level=level,
        threat_rank="D",
        affinity=BattleActionType.PHYSICAL,
        stats={
            StatId.HIT_POINTS: 160 + level * 20,
            StatId.MAGIC_POINTS: 40,
            StatId.ATTACK: 16 + level * 2,
            StatId.DEFENSE: 10 + level,
            StatId.MAGIC_ATTACK: 8,
            StatId.MAGIC_DEFENSE: 10,
            StatId.SPEED: 18 + level,
            StatId.LUCK: 16,
            StatId.ACCURACY: 92,
        },
        actions=[ACTIONS["Attack"].copy(), ACTIONS["Drop Kick"].copy()],
        xp_reward=22 + level * 5,
        gold_reward=18 + level * 4,
    )


def build_bandit_brawler(name: str = "Bandit Brawler", level: int = 2) -> EnemyCombatant:
    return EnemyCombatant(
        name=name,
        family="Humanoid / Warrior",
        level=level,
        threat_rank="D",
        affinity=BattleActionType.ELEMENTAL_EARTH,
        stats={
            StatId.HIT_POINTS: 210 + level * 25,
            StatId.MAGIC_POINTS: 30,
            StatId.ATTACK: 18 + level * 2,
            StatId.DEFENSE: 14 + level,
            StatId.MAGIC_ATTACK: 6,
            StatId.MAGIC_DEFENSE: 8,
            StatId.SPEED: 12,
            StatId.LUCK: 12,
            StatId.ACCURACY: 84,
        },
        actions=[ACTIONS["Attack"].copy(), ACTIONS["Drop Kick"].copy(), ACTIONS["Defend"].copy()],
        xp_reward=24 + level * 5,
        gold_reward=16 + level * 4,
    )


def build_bandit_chieftain(name: str = "Bandit Chief", level: int = 4) -> EnemyCombatant:
    return EnemyCombatant(
        name=name,
        family="Humanoid / Boss",
        level=level,
        threat_rank="B",
        affinity=BattleActionType.ELEMENTAL_FIRE,
        stats={
            StatId.HIT_POINTS: 450,
            StatId.MAGIC_POINTS: 80,
            StatId.ATTACK: 28,
            StatId.DEFENSE: 20,
            StatId.MAGIC_ATTACK: 14,
            StatId.MAGIC_DEFENSE: 16,
            StatId.SPEED: 17,
            StatId.LUCK: 18,
            StatId.ACCURACY: 88,
        },
        actions=[ACTIONS["Axe Cleave"].copy(), ACTIONS["Flame Punch"].copy(), ACTIONS["Attack"].copy()],
        xp_reward=75,
        gold_reward=60,
    )


def build_wild_wolf(name: str = "Wild Wolf", level: int = 2) -> EnemyCombatant:
    return EnemyCombatant(
        name=name,
        family="Beast / Canine",
        level=level,
        threat_rank="D",
        affinity=BattleActionType.PHYSICAL,
        stats={
            StatId.HIT_POINTS: 170 + level * 15,
            StatId.MAGIC_POINTS: 30,
            StatId.ATTACK: 17 + level * 2,
            StatId.DEFENSE: 10 + level,
            StatId.MAGIC_ATTACK: 8,
            StatId.MAGIC_DEFENSE: 10,
            StatId.SPEED: 22 + level,
            StatId.LUCK: 16,
            StatId.ACCURACY: 90,
        },
        actions=[ACTIONS["Bite"].copy(), ACTIONS["Double Scratch"].copy()],
        xp_reward=20 + level * 4,
        gold_reward=12 + level * 3,
    )


def build_dire_wolf(name: str = "Dire Wolf Alpha", level: int = 4) -> EnemyCombatant:
    return EnemyCombatant(
        name=name,
        family="Beast / Apex",
        level=level,
        threat_rank="C",
        affinity=BattleActionType.ELEMENTAL_WIND,
        stats={
            StatId.HIT_POINTS: 360,
            StatId.MAGIC_POINTS: 60,
            StatId.ATTACK: 26,
            StatId.DEFENSE: 16,
            StatId.MAGIC_ATTACK: 14,
            StatId.MAGIC_DEFENSE: 14,
            StatId.SPEED: 26,
            StatId.LUCK: 20,
            StatId.ACCURACY: 92,
        },
        actions=[ACTIONS["Bite"].copy(), ACTIONS["Screech"].copy(), ACTIONS["Double Scratch"].copy()],
        xp_reward=55,
        gold_reward=35,
    )


def build_rock_golem(name: str = "Rock Golem", level: int = 3) -> EnemyCombatant:
    return EnemyCombatant(
        name=name,
        family="Construct / Earth",
        level=level,
        threat_rank="C",
        affinity=BattleActionType.ELEMENTAL_EARTH,
        stats={
            StatId.HIT_POINTS: 380,
            StatId.MAGIC_POINTS: 50,
            StatId.ATTACK: 24,
            StatId.DEFENSE: 30,
            StatId.MAGIC_ATTACK: 16,
            StatId.MAGIC_DEFENSE: 12,
            StatId.SPEED: 8,
            StatId.LUCK: 8,
            StatId.ACCURACY: 80,
        },
        actions=[ACTIONS["Boulder Bash"].copy(), ACTIONS["Attack"].copy(), ACTIONS["Defend"].copy()],
        xp_reward=60,
        gold_reward=45,
    )


def build_cave_bat(name: str, level: int = 2, is_elite: bool = False, is_boss: bool = False) -> EnemyCombatant:
    hp = 420 if is_boss else (280 if is_elite else 150 + level * 10)
    atk = 26 if is_boss else (20 if is_elite else 13 + level)
    spd = 24 if is_boss else (21 if is_elite else 18)
    rank = "B" if is_boss else ("C" if is_elite else "D")

    return EnemyCombatant(
        name=name,
        family="Beast / Flying",
        level=level,
        threat_rank=rank,
        affinity=BattleActionType.ELEMENTAL_ICE,
        stats={
            StatId.HIT_POINTS: hp,
            StatId.MAGIC_POINTS: 50,
            StatId.ATTACK: atk,
            StatId.DEFENSE: 14 if is_boss else 9,
            StatId.MAGIC_ATTACK: 16 if is_boss else 10,
            StatId.MAGIC_DEFENSE: 14 if is_boss else 10,
            StatId.SPEED: spd,
            StatId.LUCK: 14,
            StatId.ACCURACY: 88,
        },
        actions=[ACTIONS["Bite"].copy(), ACTIONS["Blood Drain"].copy(), ACTIONS["Screech"].copy()],
        xp_reward=65 if is_boss else (38 if is_elite else 18),
        gold_reward=45 if is_boss else (22 if is_elite else 12),
    )


# -----------------------------------------------------------------------------
# Regional Squad Generators
# -----------------------------------------------------------------------------
def create_plains_encounter(rng: Optional[random.Random] = None) -> EnemySquad:
    """Plains, Coast, and Roads: Bandit skirmishers, scouts, or stray bats (3 to 5 enemies)."""
    r = rng if rng is not None else random
    squad = EnemySquad()

    encounter_type = r.choice(["bandits", "scouts", "mixed_bats"])
    if encounter_type == "bandits":
        squad.add_enemy(build_bandit_brawler("Brawler A", level=2))
        squad.add_enemy(build_bandit_brawler("Brawler B", level=2))
        squad.add_enemy(build_bandit_archer("Archer A", level=2))
        if r.random() < 0.6:
            squad.add_enemy(build_bandit_archer("Archer B", level=2))
    elif encounter_type == "scouts":
        squad.add_enemy(build_bandit_archer("Scout A", level=2))
        squad.add_enemy(build_bandit_archer("Scout B", level=2))
        squad.add_enemy(build_wild_wolf("Wolf Hound", level=2))
    else:
        squad.add_enemy(build_cave_bat("Stray Bat A", level=1))
        squad.add_enemy(build_cave_bat("Stray Bat B", level=1))
        squad.add_enemy(build_cave_bat("Stray Bat C", level=1))
        squad.add_enemy(build_bandit_brawler("Highwayman", level=2))

    return squad


def create_forest_encounter(rng: Optional[random.Random] = None) -> EnemySquad:
    """Forest & Woods: Wolf packs, raiding parties, or forest prowlers (4 to 7 enemies)."""
    r = rng if rng is not None else random
    squad = EnemySquad()

    encounter_type = r.choice(["wolfpack", "raiders"])
    if encounter_type == "wolfpack":
        squad.add_enemy(build_wild_wolf("Forest Wolf A", level=2))
        squad.add_enemy(build_wild_wolf("Forest Wolf B", level=2))
        squad.add_enemy(build_wild_wolf("Forest Wolf C", level=2))
        squad.add_enemy(build_wild_wolf("Forest Wolf D", level=2))
        squad.add_enemy(build_dire_wolf("Dire Alpha", level=4))
    else:
        squad.add_enemy(build_bandit_brawler("Raider A", level=3))
        squad.add_enemy(build_bandit_brawler("Raider B", level=3))
        squad.add_enemy(build_bandit_archer("Marksman A", level=3))
        squad.add_enemy(build_bandit_archer("Marksman B", level=3))
        squad.add_enemy(build_bandit_chieftain("Bandit Chief", level=4))
        if r.random() < 0.5:
            squad.add_enemy(build_wild_wolf("Attack Dog", level=2))

    return squad


def create_cave_encounter(rng: Optional[random.Random] = None) -> EnemySquad:
    """Cave Sub-Map: Large bat swarms, rock golems, or cavern terrors (6 to 10 enemies)."""
    r = rng if rng is not None else random
    squad = EnemySquad()

    encounter_type = r.choice(["swarm", "golem_chamber"])
    if encounter_type == "swarm":
        # 6 to 8 Bat minions + 1 Nightwing + 1 Bloodswoop
        bat_count = r.randint(6, 8)
        names = ["Bat A", "Bat B", "Bat C", "Bat D", "Bat E", "Bat F", "Bat G", "Bat H"]
        for i in range(bat_count):
            squad.add_enemy(build_cave_bat(names[i], level=2))
        squad.add_enemy(build_cave_bat("Nightwing", level=3, is_elite=True))
        squad.add_enemy(build_cave_bat("Bloodswoop", level=4, is_boss=True))
    else:
        # Golem guardian with bat escorts
        squad.add_enemy(build_rock_golem("Stone Golem", level=4))
        squad.add_enemy(build_rock_golem("Iron Golem", level=4))
        squad.add_enemy(build_cave_bat("Cave Bat A", level=2))
        squad.add_enemy(build_cave_bat("Cave Bat B", level=2))
        squad.add_enemy(build_cave_bat("Cave Bat C", level=2))
        squad.add_enemy(build_cave_bat("Dreadwing", level=3, is_elite=True))

    return squad


def generate_encounter(region_code: int, rng: Optional[random.Random] = None) -> Optional[EnemySquad]:
    """
    Factory creating an appropriate EnemySquad for the specified region code:
    - 0: Safe (returns None)
    - 1: Overworld Plains, Coast, Roads (3-5 enemies)
    - 2: Overworld Forest (4-7 enemies)
    - 3: Subterranean Caverns / Caves (6-10 enemies)
    """
    if region_code == RegionCode.SAFE:
        return None
    elif region_code == RegionCode.OVERWORLD_FOREST:
        return create_forest_encounter(rng)
    elif region_code == RegionCode.SUBTERRANEAN_CAVE:
        return create_cave_encounter(rng)
    else:
        # Default to Plains / Region 1
        return create_plains_encounter(rng)
