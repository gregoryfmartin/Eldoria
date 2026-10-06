"""
Eldoria Bestiary Catalog:
- Complete taxonomic roster of regular enemies and 16 bosses (including Level 75 final boss Malakor).
- Strict Invariants:
  1. Enemy names must be single words with len(name) <= 10.
  2. Simpler/weaker enemies have weak-sounding names; higher-threat enemies have imposing names.
  3. Distinction between normal enemies and bosses (is_boss flag).
  4. Boss squads are strictly solo (1 combatant).
  5. Enemies never drop key items; spoils are tier-gated.
  6. Enemies only cast spells matching their assigned elemental affinity.
  7. Low-probability defensive postures with damage mitigation and crit negation.
"""

from __future__ import annotations
from dataclasses import dataclass, field
from typing import Dict, List, Optional
from eldoria_py.combat.stats import BattleActionType


@dataclass
class LootDrop:
    """Represents a potential loot drop from an enemy."""
    item_id: str
    chance: float  # 0.0 to 1.0 (1.0 = guaranteed)
    min_qty: int = 1
    max_qty: int = 1


@dataclass
class BestiaryTemplate:
    """Defines a canonical enemy blueprint in Eldoria."""
    name: str
    family: str
    is_boss: bool = False
    affinity: BattleActionType = BattleActionType.PHYSICAL
    role: str = "balanced"  # "tank", "dps", "speed", "magic", "balanced", "boss"
    biomes: List[str] = field(default_factory=list)
    min_region: int = 1
    max_region: int = 9
    threat_rank: str = "D"  # "D", "C", "B", "A", "S"
    actions: List[str] = field(default_factory=lambda: ["Attack"])
    drop_table: List[LootDrop] = field(default_factory=list)
    defend_chance: float = 0.06
    defend_multiplier: float = 0.50
    negate_crits_when_defending: bool = False
    base_hp_override: Optional[int] = None
    default_level: Optional[int] = None

    def __post_init__(self) -> None:
        # Enforce name constraints: 1 word and len <= 10
        if " " in self.name or len(self.name) > 10:
            raise ValueError(f"Enemy name '{self.name}' violates length (<=10) or single-word constraint.")


# =============================================================================
# 16 REGIONAL BOSSES (All 1 word, <= 10 chars, solo encounters, guaranteed drops)
# =============================================================================
BOSS_CATALOG: Dict[str, BestiaryTemplate] = {
    # Region 1: Level 4 Bosses
    "Rattus": BestiaryTemplate(
        name="Rattus",
        family="Beast / Burrow Chieftain",
        is_boss=True,
        affinity=BattleActionType.PHYSICAL,
        role="speed",
        biomes=["Plains", "Cave"],
        min_region=1,
        max_region=1,
        threat_rank="S",
        actions=["Attack", "Bite", "Double Scratch", "Defend"],
        drop_table=[LootDrop("Potion", 1.0), LootDrop("Twin Daggers", 1.0)],
        default_level=4,
    ),
    "Grumble": BestiaryTemplate(
        name="Grumble",
        family="Plant / Ancient Stump",
        is_boss=True,
        affinity=BattleActionType.ELEMENTAL_EARTH,
        role="tank",
        biomes=["Forest", "Cave"],
        min_region=1,
        max_region=1,
        threat_rank="S",
        actions=["Attack", "Boulder Bash", "Defend"],
        drop_table=[LootDrop("Antidote", 1.0), LootDrop("Oak Staff", 1.0)],
        default_level=4,
    ),

    # Region 2: Level 10 Bosses
    "Brigand": BestiaryTemplate(
        name="Brigand",
        family="Humanoid / Highway Captain",
        is_boss=True,
        affinity=BattleActionType.PHYSICAL,
        role="speed",
        biomes=["Plains", "Cave"],
        min_region=2,
        max_region=2,
        threat_rank="S",
        actions=["Attack", "Drop Kick", "Double Scratch", "Defend"],
        drop_table=[LootDrop("Hi-Potion", 1.0), LootDrop("Leather Hood", 1.0)],
        default_level=10,
    ),
    "Fangclaw": BestiaryTemplate(
        name="Fangclaw",
        family="Beast / Alpha Dire",
        is_boss=True,
        affinity=BattleActionType.ELEMENTAL_WIND,
        role="dps",
        biomes=["Forest", "Cave"],
        min_region=2,
        max_region=2,
        threat_rank="S",
        actions=["Attack", "Bite", "Screech", "Galeflash", "Defend"],
        drop_table=[LootDrop("Sleep Powder", 1.0), LootDrop("Traveler Leggings", 1.0)],
        default_level=10,
    ),

    # Region 3: Level 18 Bosses
    "Broodfang": BestiaryTemplate(
        name="Broodfang",
        family="Arachnid / Matriarch",
        is_boss=True,
        affinity=BattleActionType.ELEMENTAL_DARK,
        role="magic",
        biomes=["Cave", "Subterranean"],
        min_region=3,
        max_region=3,
        threat_rank="S",
        actions=["Attack", "Bite", "Dark Surge", "Blood Drain", "Defend"],
        drop_table=[LootDrop("Poison Bottle", 1.0), LootDrop("Iron Greathelm", 1.0)],
        default_level=18,
    ),
    "Craghorn": BestiaryTemplate(
        name="Craghorn",
        family="Beast / Mountain Ram",
        is_boss=True,
        affinity=BattleActionType.ELEMENTAL_EARTH,
        role="tank",
        biomes=["Mountain", "Cave"],
        min_region=3,
        max_region=3,
        threat_rank="S",
        actions=["Attack", "Boulder Bash", "Defend"],
        drop_table=[LootDrop("Bomb", 1.0), LootDrop("Traveler Cloak", 1.0)],
        default_level=18,
    ),

    # Region 4: Level 28 Bosses
    "Tideclaw": BestiaryTemplate(
        name="Tideclaw",
        family="Aquatic / Trench Horror",
        is_boss=True,
        affinity=BattleActionType.ELEMENTAL_WATER,
        role="dps",
        biomes=["Coast", "Cave"],
        min_region=4,
        max_region=4,
        threat_rank="S",
        actions=["Attack", "Tidal Crush", "Double Scratch", "Defend"],
        drop_table=[LootDrop("Hi-Potion", 1.0), LootDrop("Silver Mace", 1.0)],
        default_level=28,
    ),
    "Ironhide": BestiaryTemplate(
        name="Ironhide",
        family="Beast / Armored Behemoth",
        is_boss=True,
        affinity=BattleActionType.PHYSICAL,
        role="tank",
        biomes=["Plains", "Cave"],
        min_region=4,
        max_region=4,
        threat_rank="S",
        actions=["Attack", "Axe Cleave", "Drop Kick", "Defend"],
        drop_table=[LootDrop("Ether", 1.0), LootDrop("Plate Cuirass", 1.0)],
        default_level=28,
    ),

    # Region 5: Level 40 Bosses
    "Venomtail": BestiaryTemplate(
        name="Venomtail",
        family="Chimera / Manticore",
        is_boss=True,
        affinity=BattleActionType.ELEMENTAL_DARK,
        role="dps",
        biomes=["Forest", "Cave"],
        min_region=5,
        max_region=5,
        threat_rank="S",
        actions=["Attack", "Dark Surge", "Blood Drain", "Double Scratch", "Defend"],
        drop_table=[LootDrop("Poison Bottle", 1.0), LootDrop("Brigandine", 1.0)],
        default_level=40,
    ),
    "Gargoyle": BestiaryTemplate(
        name="Gargoyle",
        family="Construct / Stone Guardian",
        is_boss=True,
        affinity=BattleActionType.ELEMENTAL_EARTH,
        role="tank",
        biomes=["Mountain", "Cave"],
        min_region=5,
        max_region=5,
        threat_rank="S",
        actions=["Attack", "Boulder Bash", "Drop Kick", "Defend"],
        drop_table=[LootDrop("Hi-Ether", 1.0), LootDrop("Steel Pauldrons", 1.0)],
        default_level=40,
    ),

    # Region 6: Level 54 Bosses
    "Frostfang": BestiaryTemplate(
        name="Frostfang",
        family="Draconic / Glacial Apex",
        is_boss=True,
        affinity=BattleActionType.ELEMENTAL_ICE,
        role="magic",
        biomes=["Snow", "Cave"],
        min_region=6,
        max_region=6,
        threat_rank="S",
        actions=["Attack", "Ice Bolt", "Arctic Blast", "Defend"],
        drop_table=[LootDrop("Fire Flask", 1.0), LootDrop("Mage Circlet", 1.0)],
        default_level=54,
    ),
    "Magmadon": BestiaryTemplate(
        name="Magmadon",
        family="Elemental / Caldera Titan",
        is_boss=True,
        affinity=BattleActionType.ELEMENTAL_FIRE,
        role="tank",
        biomes=["Cave", "Subterranean"],
        min_region=6,
        max_region=6,
        threat_rank="S",
        actions=["Attack", "Flame Punch", "Fireball", "Defend"],
        drop_table=[LootDrop("Fire Flask", 1.0), LootDrop("Iron Gauntlets", 1.0)],
        default_level=54,
    ),

    # Region 7: Level 68 Bosses
    "Stormlord": BestiaryTemplate(
        name="Stormlord",
        family="Elemental / Sky Sovereign",
        is_boss=True,
        affinity=BattleActionType.ELEMENTAL_WIND,
        role="speed",
        biomes=["Mountain", "Cave"],
        min_region=7,
        max_region=7,
        threat_rank="S",
        actions=["Attack", "Galeflash", "Screech", "Defend"],
        drop_table=[LootDrop("Revive Herb", 1.0), LootDrop("Mage Mantle", 1.0)],
        default_level=68,
    ),
    "Deathclaw": BestiaryTemplate(
        name="Deathclaw",
        family="Fiend / Nether Stalker",
        is_boss=True,
        affinity=BattleActionType.ELEMENTAL_DARK,
        role="dps",
        biomes=["Cave", "Subterranean"],
        min_region=7,
        max_region=7,
        threat_rank="S",
        actions=["Attack", "Dark Surge", "Blood Drain", "Double Scratch", "Defend"],
        drop_table=[LootDrop("Hi-Ether", 1.0), LootDrop("Steel Broadsword", 1.0)],
        default_level=68,
    ),

    # Region 8: Level 72 Boss
    "Archdemon": BestiaryTemplate(
        name="Archdemon",
        family="Demon / Abyss Warlord",
        is_boss=True,
        affinity=BattleActionType.ELEMENTAL_DARK,
        role="boss",
        biomes=["Cave", "Citadel", "Subterranean"],
        min_region=8,
        max_region=8,
        threat_rank="S",
        actions=["Attack", "Dark Surge", "Cataclysm", "Blood Drain", "Defend"],
        drop_table=[LootDrop("Tent", 1.0), LootDrop("Silk Vestment", 1.0)],
        defend_chance=0.10,
        default_level=72,
    ),

    # Region 9: FINAL BOSS OF ELDORIA (Level 75, High-Stat Profile, AOE Dark, 20% Defend, 75% Cut, Crit Immunity)
    "Malakor": BestiaryTemplate(
        name="Malakor",
        family="Overlord / Lord of Oblivion",
        is_boss=True,
        affinity=BattleActionType.ELEMENTAL_DARK,
        role="boss",
        biomes=["Citadel", "Cave", "Subterranean"],
        min_region=9,
        max_region=9,
        threat_rank="S",
        actions=["Attack", "Dark Surge", "Cataclysm", "Blood Drain", "Axe Cleave", "Defend"],
        drop_table=[LootDrop("Elixir", 1.0), LootDrop("Shadow Cape", 1.0)],
        defend_chance=0.20,
        defend_multiplier=0.25,  # 75% damage mitigation
        negate_crits_when_defending=True,  # Completely immune to crits while in defensive posture
        base_hp_override=8800,  # Massive final boss health pool
        default_level=75,
    ),
}


# =============================================================================
# REGULAR ENEMIES ROSTER (All 1 word, <= 10 chars, weak-to-imposing progression)
# =============================================================================
BESTIARY: Dict[str, BestiaryTemplate] = {
    # -------------------------------------------------------------------------
    # PLAINS, COAST & ROAD
    # -------------------------------------------------------------------------
    # Tier 1 (Lv 1-4)
    "Rat": BestiaryTemplate(
        name="Rat", family="Beast", affinity=BattleActionType.PHYSICAL, role="speed",
        biomes=["Plains", "Road"], min_region=1, max_region=2, threat_rank="D",
        actions=["Attack", "Bite"],
        drop_table=[LootDrop("Potion", 0.25), LootDrop("Twin Daggers", 0.03)],
    ),
    "Scout": BestiaryTemplate(
        name="Scout", family="Humanoid", affinity=BattleActionType.PHYSICAL, role="speed",
        biomes=["Plains", "Road"], min_region=1, max_region=3, threat_rank="D",
        actions=["Attack", "Drop Kick"],
        drop_table=[LootDrop("Potion", 0.25)],
    ),
    "Archer": BestiaryTemplate(
        name="Archer", family="Humanoid", affinity=BattleActionType.PHYSICAL, role="dps",
        biomes=["Plains", "Road"], min_region=1, max_region=3, threat_rank="D",
        actions=["Attack", "Drop Kick"],
        drop_table=[LootDrop("Potion", 0.25)],
    ),
    "Brawler": BestiaryTemplate(
        name="Brawler", family="Humanoid", affinity=BattleActionType.ELEMENTAL_EARTH, role="tank",
        biomes=["Plains", "Road"], min_region=1, max_region=3, threat_rank="D",
        actions=["Attack", "Boulder Bash", "Defend"],
        drop_table=[LootDrop("Potion", 0.25)],
    ),
    "Slug": BestiaryTemplate(
        name="Slug", family="Mollusk", affinity=BattleActionType.ELEMENTAL_WATER, role="tank",
        biomes=["Plains", "Coast"], min_region=1, max_region=2, threat_rank="D",
        actions=["Attack", "Tidal Crush", "Defend"],
        drop_table=[LootDrop("Antidote", 0.20)],
    ),
    "Sparrow": BestiaryTemplate(
        name="Sparrow", family="Avian", affinity=BattleActionType.ELEMENTAL_WIND, role="speed",
        biomes=["Plains", "Road"], min_region=1, max_region=2, threat_rank="D",
        actions=["Attack", "Screech"],
        drop_table=[LootDrop("Sleep Powder", 0.15)],
    ),
    # Tier 2 (Lv 5-10)
    "Toad": BestiaryTemplate(
        name="Toad", family="Amphibian", affinity=BattleActionType.ELEMENTAL_WATER, role="tank",
        biomes=["Plains", "Coast"], min_region=2, max_region=3, threat_rank="D",
        actions=["Attack", "Tidal Crush", "Defend"],
        drop_table=[LootDrop("Potion", 0.30), LootDrop("Antidote", 0.20)],
    ),
    "Bandit": BestiaryTemplate(
        name="Bandit", family="Humanoid", affinity=BattleActionType.PHYSICAL, role="dps",
        biomes=["Plains", "Road"], min_region=1, max_region=3, threat_rank="D",
        actions=["Attack", "Drop Kick", "Double Scratch"],
        drop_table=[LootDrop("Potion", 0.30), LootDrop("Iron Longsword", 0.05)],
    ),
    "Prowler": BestiaryTemplate(
        name="Prowler", family="Humanoid", affinity=BattleActionType.PHYSICAL, role="speed",
        biomes=["Plains", "Road"], min_region=2, max_region=4, threat_rank="C",
        actions=["Attack", "Drop Kick", "Double Scratch"],
        drop_table=[LootDrop("Hi-Potion", 0.20), LootDrop("Twin Daggers", 0.05)],
    ),
    # Tier 3 (Lv 11-18)
    "Kobold": BestiaryTemplate(
        name="Kobold", family="Humanoid", affinity=BattleActionType.ELEMENTAL_EARTH, role="dps",
        biomes=["Plains", "Road"], min_region=3, max_region=4, threat_rank="D",
        actions=["Attack", "Boulder Bash", "Defend"],
        drop_table=[LootDrop("Hi-Potion", 0.20), LootDrop("Leather Hood", 0.04)],
    ),
    "Stalker": BestiaryTemplate(
        name="Stalker", family="Beast", affinity=BattleActionType.PHYSICAL, role="speed",
        biomes=["Plains", "Coast"], min_region=3, max_region=5, threat_rank="C",
        actions=["Attack", "Bite", "Double Scratch"],
        drop_table=[LootDrop("Hi-Potion", 0.20), LootDrop("Bomb", 0.10)],
    ),
    # Tier 4 (Lv 19-28)
    "Centaur": BestiaryTemplate(
        name="Centaur", family="Monstrosity", affinity=BattleActionType.PHYSICAL, role="tank",
        biomes=["Plains"], min_region=4, max_region=5, threat_rank="B",
        actions=["Attack", "Axe Cleave", "Drop Kick", "Defend"],
        drop_table=[LootDrop("Hi-Potion", 0.25), LootDrop("Plate Cuirass", 0.04)],
    ),
    "Siren": BestiaryTemplate(
        name="Siren", family="Aquatic", affinity=BattleActionType.ELEMENTAL_WATER, role="magic",
        biomes=["Coast"], min_region=4, max_region=6, threat_rank="C",
        actions=["Attack", "Tidal Crush", "Defend"],
        drop_table=[LootDrop("Ether", 0.25), LootDrop("Silver Mace", 0.04)],
    ),
    "Corsair": BestiaryTemplate(
        name="Corsair", family="Humanoid", affinity=BattleActionType.PHYSICAL, role="dps",
        biomes=["Coast", "Road"], min_region=4, max_region=6, threat_rank="C",
        actions=["Attack", "Drop Kick", "Axe Cleave"],
        drop_table=[LootDrop("Hi-Potion", 0.25), LootDrop("Brigandine", 0.04)],
    ),
    # Tier 5 (Lv 29-40)
    "Gryphon": BestiaryTemplate(
        name="Gryphon", family="Avian", affinity=BattleActionType.ELEMENTAL_WIND, role="speed",
        biomes=["Plains"], min_region=5, max_region=7, threat_rank="B",
        actions=["Attack", "Galeflash", "Screech"],
        drop_table=[LootDrop("Hi-Ether", 0.20), LootDrop("Winged Sandals", 0.03)],
    ),
    "Chimera": BestiaryTemplate(
        name="Chimera", family="Monstrosity", affinity=BattleActionType.ELEMENTAL_FIRE, role="dps",
        biomes=["Plains"], min_region=5, max_region=7, threat_rank="B",
        actions=["Attack", "Flame Punch", "Fireball", "Bite"],
        drop_table=[LootDrop("Fire Flask", 0.20), LootDrop("Steel Pauldrons", 0.04)],
    ),
    # Tier 6 (Lv 41-55)
    "Hydra": BestiaryTemplate(
        name="Hydra", family="Draconic", affinity=BattleActionType.ELEMENTAL_WATER, role="tank",
        biomes=["Coast", "Plains"], min_region=6, max_region=8, threat_rank="A",
        actions=["Attack", "Tidal Crush", "Bite", "Defend"],
        drop_table=[LootDrop("Hi-Ether", 0.25), LootDrop("Plate Cuirass", 0.04)],
    ),
    "Myrmidon": BestiaryTemplate(
        name="Myrmidon", family="Humanoid", affinity=BattleActionType.PHYSICAL, role="dps",
        biomes=["Plains", "Road"], min_region=6, max_region=8, threat_rank="B",
        actions=["Attack", "Axe Cleave", "Drop Kick", "Defend"],
        drop_table=[LootDrop("Revive Herb", 0.15), LootDrop("Steel Broadsword", 0.04)],
    ),
    # Tier 7 (Lv 56-70)
    "Gorgon": BestiaryTemplate(
        name="Gorgon", family="Monstrosity", affinity=BattleActionType.ELEMENTAL_DARK, role="magic",
        biomes=["Coast", "Plains"], min_region=7, max_region=9, threat_rank="A",
        actions=["Attack", "Dark Surge", "Defend"],
        drop_table=[LootDrop("Hi-Ether", 0.25), LootDrop("Silk Vestment", 0.04)],
    ),
    "Warlord": BestiaryTemplate(
        name="Warlord", family="Humanoid", affinity=BattleActionType.PHYSICAL, role="tank",
        biomes=["Plains", "Road"], min_region=7, max_region=9, threat_rank="A",
        actions=["Attack", "Axe Cleave", "Drop Kick", "Defend"],
        drop_table=[LootDrop("Revive Herb", 0.20), LootDrop("Ring of Might", 0.03)],
    ),
    # Tier 8-9 (Lv 71-95)
    "Colossus": BestiaryTemplate(
        name="Colossus", family="Giant", affinity=BattleActionType.ELEMENTAL_EARTH, role="tank",
        biomes=["Plains"], min_region=8, max_region=9, threat_rank="A",
        actions=["Attack", "Boulder Bash", "Defend"],
        drop_table=[LootDrop("Elixir", 0.05), LootDrop("Amulet of Health", 0.04)],
    ),
    "Leviathan": BestiaryTemplate(
        name="Leviathan", family="Aquatic", affinity=BattleActionType.ELEMENTAL_WATER, role="boss",
        biomes=["Coast"], min_region=8, max_region=9, threat_rank="A",
        actions=["Attack", "Tidal Crush", "Bite", "Defend"],
        drop_table=[LootDrop("Elixir", 0.08), LootDrop("Sapphire Ring", 0.04)],
    ),

    # -------------------------------------------------------------------------
    # FOREST
    # -------------------------------------------------------------------------
    # Tier 1 (Lv 1-4)
    "Sprout": BestiaryTemplate(
        name="Sprout", family="Plant", affinity=BattleActionType.ELEMENTAL_EARTH, role="balanced",
        biomes=["Forest"], min_region=1, max_region=2, threat_rank="D",
        actions=["Attack", "Boulder Bash"],
        drop_table=[LootDrop("Potion", 0.25), LootDrop("Oak Staff", 0.04)],
    ),
    "Hornet": BestiaryTemplate(
        name="Hornet", family="Insect", affinity=BattleActionType.ELEMENTAL_WIND, role="speed",
        biomes=["Forest"], min_region=1, max_region=2, threat_rank="D",
        actions=["Attack", "Double Scratch"],
        drop_table=[LootDrop("Antidote", 0.20)],
    ),
    "Badger": BestiaryTemplate(
        name="Badger", family="Beast", affinity=BattleActionType.PHYSICAL, role="tank",
        biomes=["Forest"], min_region=1, max_region=3, threat_rank="D",
        actions=["Attack", "Bite", "Defend"],
        drop_table=[LootDrop("Potion", 0.25)],
    ),
    # Tier 2 (Lv 5-10)
    "Goblin": BestiaryTemplate(
        name="Goblin", family="Humanoid", affinity=BattleActionType.PHYSICAL, role="dps",
        biomes=["Forest"], min_region=2, max_region=3, threat_rank="D",
        actions=["Attack", "Double Scratch", "Drop Kick"],
        drop_table=[LootDrop("Potion", 0.30), LootDrop("Twin Daggers", 0.05)],
    ),
    "Wolf": BestiaryTemplate(
        name="Wolf", family="Beast", affinity=BattleActionType.PHYSICAL, role="speed",
        biomes=["Forest", "Plains"], min_region=1, max_region=4, threat_rank="D",
        actions=["Attack", "Bite", "Double Scratch"],
        drop_table=[LootDrop("Potion", 0.30), LootDrop("Traveler Leggings", 0.04)],
    ),
    # Tier 3 (Lv 11-18)
    "Spitter": BestiaryTemplate(
        name="Spitter", family="Plant", affinity=BattleActionType.ELEMENTAL_EARTH, role="magic",
        biomes=["Forest"], min_region=3, max_region=5, threat_rank="D",
        actions=["Attack", "Boulder Bash", "Defend"],
        drop_table=[LootDrop("Poison Bottle", 0.20), LootDrop("Antidote", 0.20)],
    ),
    "Viper": BestiaryTemplate(
        name="Viper", family="Reptile", affinity=BattleActionType.PHYSICAL, role="speed",
        biomes=["Forest"], min_region=3, max_region=5, threat_rank="D",
        actions=["Attack", "Bite", "Double Scratch"],
        drop_table=[LootDrop("Poison Bottle", 0.25)],
    ),
    # Tier 4 (Lv 19-28)
    "Dryad": BestiaryTemplate(
        name="Dryad", family="Fey", affinity=BattleActionType.ELEMENTAL_EARTH, role="magic",
        biomes=["Forest"], min_region=4, max_region=6, threat_rank="C",
        actions=["Attack", "Boulder Bash", "Heal", "Defend"],
        drop_table=[LootDrop("Ether", 0.25), LootDrop("Oak Staff", 0.04)],
    ),
    "Lurker": BestiaryTemplate(
        name="Lurker", family="Humanoid", affinity=BattleActionType.ELEMENTAL_DARK, role="speed",
        biomes=["Forest"], min_region=4, max_region=6, threat_rank="C",
        actions=["Attack", "Blood Drain", "Double Scratch"],
        drop_table=[LootDrop("Hi-Potion", 0.25), LootDrop("Traveler Cloak", 0.04)],
    ),
    "Troll": BestiaryTemplate(
        name="Troll", family="Giant", affinity=BattleActionType.PHYSICAL, role="tank",
        biomes=["Forest"], min_region=4, max_region=6, threat_rank="B",
        actions=["Attack", "Axe Cleave", "Drop Kick", "Defend"],
        drop_table=[LootDrop("Hi-Potion", 0.30), LootDrop("Heavy Battleaxe", 0.04)],
    ),
    # Tier 5 (Lv 29-40)
    "Treant": BestiaryTemplate(
        name="Treant", family="Plant", affinity=BattleActionType.ELEMENTAL_EARTH, role="tank",
        biomes=["Forest"], min_region=5, max_region=7, threat_rank="B",
        actions=["Attack", "Boulder Bash", "Defend"],
        drop_table=[LootDrop("Hi-Ether", 0.20), LootDrop("Brigandine", 0.04)],
    ),
    "Basilisk": BestiaryTemplate(
        name="Basilisk", family="Reptile", affinity=BattleActionType.ELEMENTAL_DARK, role="dps",
        biomes=["Forest"], min_region=5, max_region=7, threat_rank="B",
        actions=["Attack", "Dark Surge", "Bite"],
        drop_table=[LootDrop("Poison Bottle", 0.25), LootDrop("Lucky Coin Talisman", 0.03)],
    ),
    # Tier 6 (Lv 41-55)
    "Manticore": BestiaryTemplate(
        name="Manticore", family="Monstrosity", affinity=BattleActionType.ELEMENTAL_DARK, role="dps",
        biomes=["Forest"], min_region=6, max_region=8, threat_rank="A",
        actions=["Attack", "Dark Surge", "Blood Drain", "Bite"],
        drop_table=[LootDrop("Hi-Ether", 0.25), LootDrop("Steel Pauldrons", 0.04)],
    ),
    "Shade": BestiaryTemplate(
        name="Shade", family="Undead", affinity=BattleActionType.ELEMENTAL_DARK, role="magic",
        biomes=["Forest"], min_region=6, max_region=8, threat_rank="B",
        actions=["Attack", "Dark Surge", "Blood Drain"],
        drop_table=[LootDrop("Hi-Ether", 0.25), LootDrop("Mage Mantle", 0.04)],
    ),
    # Tier 7 (Lv 56-70)
    "Banshee": BestiaryTemplate(
        name="Banshee", family="Undead", affinity=BattleActionType.ELEMENTAL_DARK, role="speed",
        biomes=["Forest"], min_region=7, max_region=9, threat_rank="A",
        actions=["Attack", "Screech", "Dark Surge"],
        drop_table=[LootDrop("Revive Herb", 0.20), LootDrop("Shadow Cape", 0.03)],
    ),
    "Wendigo": BestiaryTemplate(
        name="Wendigo", family="Monstrosity", affinity=BattleActionType.ELEMENTAL_ICE, role="dps",
        biomes=["Forest"], min_region=7, max_region=9, threat_rank="A",
        actions=["Attack", "Ice Bolt", "Double Scratch"],
        drop_table=[LootDrop("Revive Herb", 0.20), LootDrop("Steel Broadsword", 0.04)],
    ),
    # Tier 8-9 (Lv 71-95)
    "Nightmare": BestiaryTemplate(
        name="Nightmare", family="Fiend", affinity=BattleActionType.ELEMENTAL_FIRE, role="speed",
        biomes=["Forest"], min_region=8, max_region=9, threat_rank="A",
        actions=["Attack", "Flame Punch", "Fireball"],
        drop_table=[LootDrop("Elixir", 0.05), LootDrop("Winged Sandals", 0.03)],
    ),
    "Behemoth": BestiaryTemplate(
        name="Behemoth", family="Beast", affinity=BattleActionType.PHYSICAL, role="tank",
        biomes=["Forest"], min_region=8, max_region=9, threat_rank="A",
        actions=["Attack", "Axe Cleave", "Drop Kick", "Defend"],
        drop_table=[LootDrop("Elixir", 0.08), LootDrop("Ring of Might", 0.04)],
    ),

    # -------------------------------------------------------------------------
    # CAVE & SUBTERRANEAN
    # -------------------------------------------------------------------------
    # Tier 1 (Lv 1-4)
    "Bat": BestiaryTemplate(
        name="Bat", family="Beast", affinity=BattleActionType.PHYSICAL, role="speed",
        biomes=["Cave", "Subterranean"], min_region=1, max_region=5, threat_rank="D",
        actions=["Attack", "Bite", "Double Scratch"],
        drop_table=[LootDrop("Potion", 0.25)],
    ),
    "Spider": BestiaryTemplate(
        name="Spider", family="Arachnid", affinity=BattleActionType.PHYSICAL, role="dps",
        biomes=["Cave", "Subterranean"], min_region=1, max_region=2, threat_rank="D",
        actions=["Attack", "Bite"],
        drop_table=[LootDrop("Poison Bottle", 0.20)],
    ),
    "Beetle": BestiaryTemplate(
        name="Beetle", family="Insect", affinity=BattleActionType.PHYSICAL, role="tank",
        biomes=["Cave", "Subterranean"], min_region=1, max_region=3, threat_rank="D",
        actions=["Attack", "Defend"],
        drop_table=[LootDrop("Potion", 0.25)],
    ),
    # Tier 2 (Lv 5-10)
    "Slime": BestiaryTemplate(
        name="Slime", family="Ooze", affinity=BattleActionType.ELEMENTAL_WATER, role="tank",
        biomes=["Cave", "Subterranean"], min_region=2, max_region=3, threat_rank="D",
        actions=["Attack", "Tidal Crush", "Defend"],
        drop_table=[LootDrop("Potion", 0.30), LootDrop("Antidote", 0.20)],
    ),
    "Crawler": BestiaryTemplate(
        name="Crawler", family="Arachnid", affinity=BattleActionType.PHYSICAL, role="speed",
        biomes=["Cave", "Subterranean"], min_region=2, max_region=4, threat_rank="D",
        actions=["Attack", "Bite", "Double Scratch"],
        drop_table=[LootDrop("Hi-Potion", 0.20)],
    ),
    "Golem": BestiaryTemplate(
        name="Golem", family="Construct", affinity=BattleActionType.ELEMENTAL_EARTH, role="tank",
        biomes=["Cave", "Subterranean", "Mountain"], min_region=2, max_region=5, threat_rank="C",
        actions=["Attack", "Boulder Bash", "Defend"],
        drop_table=[LootDrop("Bomb", 0.20), LootDrop("Iron Greathelm", 0.05)],
    ),
    # Tier 3 (Lv 11-18)
    "Skulker": BestiaryTemplate(
        name="Skulker", family="Humanoid", affinity=BattleActionType.ELEMENTAL_DARK, role="speed",
        biomes=["Cave", "Subterranean"], min_region=3, max_region=5, threat_rank="C",
        actions=["Attack", "Blood Drain", "Double Scratch"],
        drop_table=[LootDrop("Hi-Potion", 0.20), LootDrop("Leather Hood", 0.04)],
    ),
    "Scorpion": BestiaryTemplate(
        name="Scorpion", family="Insect", affinity=BattleActionType.PHYSICAL, role="tank",
        biomes=["Cave", "Subterranean"], min_region=3, max_region=5, threat_rank="C",
        actions=["Attack", "Bite", "Defend"],
        drop_table=[LootDrop("Poison Bottle", 0.25), LootDrop("Bomb", 0.10)],
    ),
    # Tier 4 (Lv 19-28)
    "Specter": BestiaryTemplate(
        name="Specter", family="Undead", affinity=BattleActionType.ELEMENTAL_DARK, role="magic",
        biomes=["Cave", "Subterranean"], min_region=4, max_region=6, threat_rank="C",
        actions=["Attack", "Dark Surge", "Blood Drain"],
        drop_table=[LootDrop("Ether", 0.25), LootDrop("Mage Circlet", 0.04)],
    ),
    "Ghoul": BestiaryTemplate(
        name="Ghoul", family="Undead", affinity=BattleActionType.PHYSICAL, role="dps",
        biomes=["Cave", "Subterranean"], min_region=4, max_region=6, threat_rank="C",
        actions=["Attack", "Bite", "Drop Kick"],
        drop_table=[LootDrop("Hi-Potion", 0.25), LootDrop("Iron Gauntlets", 0.04)],
    ),
    # Tier 5 (Lv 29-40)
    "Shadow": BestiaryTemplate(
        name="Shadow", family="Fiend", affinity=BattleActionType.ELEMENTAL_DARK, role="speed",
        biomes=["Cave", "Subterranean"], min_region=5, max_region=7, threat_rank="B",
        actions=["Attack", "Dark Surge", "Double Scratch"],
        drop_table=[LootDrop("Hi-Ether", 0.20), LootDrop("Shadow Cape", 0.03)],
    ),
    "Minotaur": BestiaryTemplate(
        name="Minotaur", family="Monstrosity", affinity=BattleActionType.PHYSICAL, role="tank",
        biomes=["Cave", "Subterranean"], min_region=5, max_region=7, threat_rank="B",
        actions=["Attack", "Axe Cleave", "Drop Kick", "Defend"],
        drop_table=[LootDrop("Hi-Potion", 0.30), LootDrop("Heavy Battleaxe", 0.04)],
    ),
    # Tier 6 (Lv 41-55)
    "Wraith": BestiaryTemplate(
        name="Wraith", family="Undead", affinity=BattleActionType.ELEMENTAL_DARK, role="magic",
        biomes=["Cave", "Subterranean"], min_region=6, max_region=8, threat_rank="A",
        actions=["Attack", "Dark Surge", "Blood Drain", "Defend"],
        drop_table=[LootDrop("Hi-Ether", 0.25), LootDrop("Silk Vestment", 0.04)],
    ),
    "Lich": BestiaryTemplate(
        name="Lich", family="Undead", affinity=BattleActionType.ELEMENTAL_DARK, role="magic",
        biomes=["Cave", "Subterranean"], min_region=6, max_region=8, threat_rank="A",
        actions=["Attack", "Dark Surge", "Defend"],
        drop_table=[LootDrop("Hi-Ether", 0.30), LootDrop("Mage Mantle", 0.04)],
    ),
    # Tier 7 (Lv 56-70)
    "Dreadmaw": BestiaryTemplate(
        name="Dreadmaw", family="Beast", affinity=BattleActionType.PHYSICAL, role="dps",
        biomes=["Cave", "Subterranean"], min_region=7, max_region=9, threat_rank="A",
        actions=["Attack", "Bite", "Axe Cleave"],
        drop_table=[LootDrop("Revive Herb", 0.20), LootDrop("Steel Broadsword", 0.04)],
    ),
    "Cryptlord": BestiaryTemplate(
        name="Cryptlord", family="Undead", affinity=BattleActionType.ELEMENTAL_DARK, role="tank",
        biomes=["Cave", "Subterranean"], min_region=7, max_region=9, threat_rank="A",
        actions=["Attack", "Dark Surge", "Axe Cleave", "Defend"],
        drop_table=[LootDrop("Revive Herb", 0.20), LootDrop("Plate Cuirass", 0.04)],
    ),
    # Tier 8-9 (Lv 71-95)
    "Hellhound": BestiaryTemplate(
        name="Hellhound", family="Fiend", affinity=BattleActionType.ELEMENTAL_FIRE, role="speed",
        biomes=["Cave", "Subterranean"], min_region=8, max_region=9, threat_rank="A",
        actions=["Attack", "Flame Punch", "Fireball", "Bite"],
        drop_table=[LootDrop("Elixir", 0.05), LootDrop("Ring of Might", 0.03)],
    ),
    "Archlich": BestiaryTemplate(
        name="Archlich", family="Undead", affinity=BattleActionType.ELEMENTAL_DARK, role="boss",
        biomes=["Cave", "Subterranean"], min_region=8, max_region=9, threat_rank="A",
        actions=["Attack", "Dark Surge", "Cataclysm", "Defend"],
        drop_table=[LootDrop("Elixir", 0.08), LootDrop("Shadow Cape", 0.04)],
    ),

    # -------------------------------------------------------------------------
    # MOUNTAIN & SNOW
    # -------------------------------------------------------------------------
    # Tier 1 (Lv 1-4)
    "Goat": BestiaryTemplate(
        name="Goat", family="Beast", affinity=BattleActionType.PHYSICAL, role="tank",
        biomes=["Mountain"], min_region=1, max_region=2, threat_rank="D",
        actions=["Attack", "Drop Kick", "Defend"],
        drop_table=[LootDrop("Potion", 0.25)],
    ),
    "Hawk": BestiaryTemplate(
        name="Hawk", family="Avian", affinity=BattleActionType.ELEMENTAL_WIND, role="speed",
        biomes=["Mountain"], min_region=1, max_region=2, threat_rank="D",
        actions=["Attack", "Screech"],
        drop_table=[LootDrop("Potion", 0.25)],
    ),
    "Snowhare": BestiaryTemplate(
        name="Snowhare", family="Beast", affinity=BattleActionType.ELEMENTAL_ICE, role="speed",
        biomes=["Snow"], min_region=1, max_region=3, threat_rank="D",
        actions=["Attack", "Double Scratch"],
        drop_table=[LootDrop("Potion", 0.25)],
    ),
    # Tier 2 (Lv 5-10)
    "Pebble": BestiaryTemplate(
        name="Pebble", family="Construct", affinity=BattleActionType.ELEMENTAL_EARTH, role="tank",
        biomes=["Mountain"], min_region=2, max_region=3, threat_rank="D",
        actions=["Attack", "Boulder Bash", "Defend"],
        drop_table=[LootDrop("Bomb", 0.15)],
    ),
    "Cragling": BestiaryTemplate(
        name="Cragling", family="Construct", affinity=BattleActionType.ELEMENTAL_EARTH, role="tank",
        biomes=["Mountain"], min_region=2, max_region=4, threat_rank="D",
        actions=["Attack", "Boulder Bash", "Defend"],
        drop_table=[LootDrop("Bomb", 0.20), LootDrop("Iron Greathelm", 0.04)],
    ),
    # Tier 3 (Lv 11-18)
    "Harpy": BestiaryTemplate(
        name="Harpy", family="Avian", affinity=BattleActionType.ELEMENTAL_WIND, role="speed",
        biomes=["Mountain"], min_region=3, max_region=5, threat_rank="C",
        actions=["Attack", "Galeflash", "Screech"],
        drop_table=[LootDrop("Hi-Potion", 0.20), LootDrop("Traveler Cloak", 0.04)],
    ),
    "Frostwolf": BestiaryTemplate(
        name="Frostwolf", family="Beast", affinity=BattleActionType.ELEMENTAL_ICE, role="speed",
        biomes=["Snow"], min_region=3, max_region=5, threat_rank="C",
        actions=["Attack", "Ice Bolt", "Bite"],
        drop_table=[LootDrop("Hi-Potion", 0.20), LootDrop("Traveler Leggings", 0.04)],
    ),
    # Tier 4 (Lv 19-28)
    "Yeti": BestiaryTemplate(
        name="Yeti", family="Beast", affinity=BattleActionType.ELEMENTAL_ICE, role="tank",
        biomes=["Snow", "Mountain"], min_region=4, max_region=6, threat_rank="B",
        actions=["Attack", "Ice Bolt", "Drop Kick", "Defend"],
        drop_table=[LootDrop("Hi-Potion", 0.25), LootDrop("Heavy Battleaxe", 0.04)],
    ),
    # Tier 5 (Lv 29-40)
    "Wyvern": BestiaryTemplate(
        name="Wyvern", family="Draconic", affinity=BattleActionType.ELEMENTAL_WIND, role="speed",
        biomes=["Mountain"], min_region=5, max_region=7, threat_rank="B",
        actions=["Attack", "Galeflash", "Bite", "Double Scratch"],
        drop_table=[LootDrop("Hi-Ether", 0.20), LootDrop("Winged Sandals", 0.03)],
    ),
    "Frostbeast": BestiaryTemplate(
        name="Frostbeast", family="Monstrosity", affinity=BattleActionType.ELEMENTAL_ICE, role="tank",
        biomes=["Snow"], min_region=5, max_region=7, threat_rank="B",
        actions=["Attack", "Ice Bolt", "Arctic Blast", "Defend"],
        drop_table=[LootDrop("Fire Flask", 0.20), LootDrop("Plate Cuirass", 0.04)],
    ),
    # Tier 6 (Lv 41-55)
    "Valkyrie": BestiaryTemplate(
        name="Valkyrie", family="Humanoid", affinity=BattleActionType.ELEMENTAL_LIGHT, role="balanced",
        biomes=["Mountain", "Snow"], min_region=6, max_region=8, threat_rank="A",
        actions=["Attack", "Radiance", "Heal", "Defend"],
        drop_table=[LootDrop("Revive Herb", 0.20), LootDrop("Silver Mace", 0.04)],
    ),
    # Tier 7 (Lv 56-70)
    "Stormbird": BestiaryTemplate(
        name="Stormbird", family="Avian", affinity=BattleActionType.ELEMENTAL_WIND, role="speed",
        biomes=["Mountain"], min_region=7, max_region=9, threat_rank="A",
        actions=["Attack", "Galeflash", "Screech"],
        drop_table=[LootDrop("Revive Herb", 0.20), LootDrop("Mage Mantle", 0.04)],
    ),
    "Titan": BestiaryTemplate(
        name="Titan", family="Giant", affinity=BattleActionType.ELEMENTAL_EARTH, role="tank",
        biomes=["Mountain"], min_region=7, max_region=9, threat_rank="A",
        actions=["Attack", "Boulder Bash", "Drop Kick", "Defend"],
        drop_table=[LootDrop("Revive Herb", 0.20), LootDrop("Ring of Might", 0.04)],
    ),
    # Tier 8-9 (Lv 71-95)
    "Frostwyrm": BestiaryTemplate(
        name="Frostwyrm", family="Draconic", affinity=BattleActionType.ELEMENTAL_ICE, role="boss",
        biomes=["Snow", "Mountain"], min_region=8, max_region=9, threat_rank="A",
        actions=["Attack", "Ice Bolt", "Arctic Blast", "Bite", "Defend"],
        drop_table=[LootDrop("Elixir", 0.05), LootDrop("Sapphire Ring", 0.03)],
    ),
    "Juggernaut": BestiaryTemplate(
        name="Juggernaut", family="Construct", affinity=BattleActionType.PHYSICAL, role="tank",
        biomes=["Mountain"], min_region=8, max_region=9, threat_rank="A",
        actions=["Attack", "Axe Cleave", "Drop Kick", "Defend"],
        drop_table=[LootDrop("Elixir", 0.08), LootDrop("Amulet of Health", 0.04)],
    ),

    # -------------------------------------------------------------------------
    # BADLANDS
    # -------------------------------------------------------------------------
    # Tier 1 (Lv 1-4)
    "Rattler": BestiaryTemplate(
        name="Rattler", family="Reptile", affinity=BattleActionType.PHYSICAL, role="speed",
        biomes=["Badlands"], min_region=1, max_region=2, threat_rank="D",
        actions=["Attack", "Bite"],
        drop_table=[LootDrop("Antidote", 0.25), LootDrop("Poison Bottle", 0.10)],
    ),
    "Vulture": BestiaryTemplate(
        name="Vulture", family="Avian", affinity=BattleActionType.ELEMENTAL_WIND, role="speed",
        biomes=["Badlands"], min_region=1, max_region=3, threat_rank="D",
        actions=["Attack", "Screech"],
        drop_table=[LootDrop("Potion", 0.25)],
    ),
    # Tier 2 (Lv 5-10)
    "Jackal": BestiaryTemplate(
        name="Jackal", family="Beast", affinity=BattleActionType.PHYSICAL, role="dps",
        biomes=["Badlands"], min_region=2, max_region=4, threat_rank="D",
        actions=["Attack", "Bite", "Drop Kick"],
        drop_table=[LootDrop("Potion", 0.30)],
    ),
    "Cactoid": BestiaryTemplate(
        name="Cactoid", family="Plant", affinity=BattleActionType.ELEMENTAL_EARTH, role="tank",
        biomes=["Badlands"], min_region=2, max_region=4, threat_rank="D",
        actions=["Attack", "Boulder Bash", "Defend"],
        drop_table=[LootDrop("Potion", 0.30), LootDrop("Bomb", 0.10)],
    ),
    # Tier 3 (Lv 11-18)
    "Hyena": BestiaryTemplate(
        name="Hyena", family="Beast", affinity=BattleActionType.PHYSICAL, role="dps",
        biomes=["Badlands"], min_region=3, max_region=5, threat_rank="C",
        actions=["Attack", "Bite", "Double Scratch"],
        drop_table=[LootDrop("Hi-Potion", 0.20)],
    ),
    "Gila": BestiaryTemplate(
        name="Gila", family="Reptile", affinity=BattleActionType.ELEMENTAL_EARTH, role="tank",
        biomes=["Badlands"], min_region=3, max_region=5, threat_rank="C",
        actions=["Attack", "Boulder Bash", "Bite", "Defend"],
        drop_table=[LootDrop("Hi-Potion", 0.20), LootDrop("Poison Bottle", 0.20)],
    ),
    # Tier 4 (Lv 19-28)
    "Sandwurm": BestiaryTemplate(
        name="Sandwurm", family="Monstrosity", affinity=BattleActionType.ELEMENTAL_EARTH, role="tank",
        biomes=["Badlands"], min_region=4, max_region=6, threat_rank="B",
        actions=["Attack", "Boulder Bash", "Axe Cleave", "Defend"],
        drop_table=[LootDrop("Hi-Potion", 0.25), LootDrop("Plate Cuirass", 0.04)],
    ),
    "Scorcher": BestiaryTemplate(
        name="Scorcher", family="Humanoid", affinity=BattleActionType.ELEMENTAL_FIRE, role="dps",
        biomes=["Badlands"], min_region=4, max_region=6, threat_rank="C",
        actions=["Attack", "Flame Punch", "Fireball"],
        drop_table=[LootDrop("Fire Flask", 0.25), LootDrop("Iron Gauntlets", 0.04)],
    ),
    # Tier 5 (Lv 29-40)
    "Dunehound": BestiaryTemplate(
        name="Dunehound", family="Fiend", affinity=BattleActionType.ELEMENTAL_FIRE, role="speed",
        biomes=["Badlands"], min_region=5, max_region=7, threat_rank="B",
        actions=["Attack", "Flame Punch", "Bite"],
        drop_table=[LootDrop("Fire Flask", 0.20), LootDrop("Winged Sandals", 0.03)],
    ),
    # Tier 6 (Lv 41-55)
    "Dustwraith": BestiaryTemplate(
        name="Dustwraith", family="Undead", affinity=BattleActionType.ELEMENTAL_DARK, role="magic",
        biomes=["Badlands"], min_region=6, max_region=8, threat_rank="A",
        actions=["Attack", "Dark Surge", "Defend"],
        drop_table=[LootDrop("Hi-Ether", 0.25), LootDrop("Mage Mantle", 0.04)],
    ),
    # Tier 7-9 (Lv 56-95)
    "Anubis": BestiaryTemplate(
        name="Anubis", family="Construct", affinity=BattleActionType.ELEMENTAL_DARK, role="tank",
        biomes=["Badlands"], min_region=7, max_region=9, threat_rank="A",
        actions=["Attack", "Dark Surge", "Axe Cleave", "Defend"],
        drop_table=[LootDrop("Revive Herb", 0.20), LootDrop("Shadow Cape", 0.03)],
    ),
    "Ifrit": BestiaryTemplate(
        name="Ifrit", family="Elemental", affinity=BattleActionType.ELEMENTAL_FIRE, role="magic",
        biomes=["Badlands"], min_region=8, max_region=9, threat_rank="A",
        actions=["Attack", "Flame Punch", "Fireball", "Defend"],
        drop_table=[LootDrop("Elixir", 0.08), LootDrop("Ring of Might", 0.04)],
    ),

    # -------------------------------------------------------------------------
    # TUNDRA
    # -------------------------------------------------------------------------
    # Tier 1 (Lv 1-4)
    "Fox": BestiaryTemplate(
        name="Fox", family="Beast", affinity=BattleActionType.ELEMENTAL_ICE, role="speed",
        biomes=["Tundra"], min_region=1, max_region=2, threat_rank="D",
        actions=["Attack", "Double Scratch"],
        drop_table=[LootDrop("Potion", 0.25)],
    ),
    "Penguin": BestiaryTemplate(
        name="Penguin", family="Avian", affinity=BattleActionType.ELEMENTAL_ICE, role="balanced",
        biomes=["Tundra"], min_region=1, max_region=3, threat_rank="D",
        actions=["Attack", "Ice Bolt"],
        drop_table=[LootDrop("Potion", 0.25)],
    ),
    # Tier 2 (Lv 5-10)
    "Weasel": BestiaryTemplate(
        name="Weasel", family="Beast", affinity=BattleActionType.PHYSICAL, role="speed",
        biomes=["Tundra"], min_region=2, max_region=4, threat_rank="D",
        actions=["Attack", "Bite", "Double Scratch"],
        drop_table=[LootDrop("Potion", 0.30)],
    ),
    "Drifter": BestiaryTemplate(
        name="Drifter", family="Elemental", affinity=BattleActionType.ELEMENTAL_ICE, role="magic",
        biomes=["Tundra"], min_region=2, max_region=4, threat_rank="D",
        actions=["Attack", "Ice Bolt", "Defend"],
        drop_table=[LootDrop("Ether", 0.25)],
    ),
    # Tier 3 (Lv 11-18)
    "Caribou": BestiaryTemplate(
        name="Caribou", family="Beast", affinity=BattleActionType.PHYSICAL, role="tank",
        biomes=["Tundra"], min_region=3, max_region=5, threat_rank="C",
        actions=["Attack", "Drop Kick", "Defend"],
        drop_table=[LootDrop("Hi-Potion", 0.20), LootDrop("Traveler Leggings", 0.04)],
    ),
    # Tier 4 (Lv 19-28)
    "Walrus": BestiaryTemplate(
        name="Walrus", family="Beast", affinity=BattleActionType.ELEMENTAL_ICE, role="tank",
        biomes=["Tundra"], min_region=4, max_region=6, threat_rank="B",
        actions=["Attack", "Ice Bolt", "Drop Kick", "Defend"],
        drop_table=[LootDrop("Hi-Potion", 0.25), LootDrop("Heavy Battleaxe", 0.04)],
    ),
    "Wolverine": BestiaryTemplate(
        name="Wolverine", family="Beast", affinity=BattleActionType.PHYSICAL, role="dps",
        biomes=["Tundra"], min_region=4, max_region=6, threat_rank="C",
        actions=["Attack", "Bite", "Double Scratch", "Axe Cleave"],
        drop_table=[LootDrop("Hi-Potion", 0.25)],
    ),
    # Tier 5 (Lv 29-40)
    "Mammoth": BestiaryTemplate(
        name="Mammoth", family="Beast", affinity=BattleActionType.ELEMENTAL_ICE, role="tank",
        biomes=["Tundra"], min_region=5, max_region=7, threat_rank="B",
        actions=["Attack", "Ice Bolt", "Drop Kick", "Defend"],
        drop_table=[LootDrop("Hi-Ether", 0.20), LootDrop("Steel Pauldrons", 0.04)],
    ),
    "Blizzard": BestiaryTemplate(
        name="Blizzard", family="Elemental", affinity=BattleActionType.ELEMENTAL_ICE, role="magic",
        biomes=["Tundra"], min_region=5, max_region=7, threat_rank="B",
        actions=["Attack", "Ice Bolt", "Arctic Blast"],
        drop_table=[LootDrop("Hi-Ether", 0.25), LootDrop("Mage Circlet", 0.04)],
    ),
    # Tier 6 (Lv 41-55)
    "Frostwight": BestiaryTemplate(
        name="Frostwight", family="Undead", affinity=BattleActionType.ELEMENTAL_ICE, role="magic",
        biomes=["Tundra"], min_region=6, max_region=8, threat_rank="A",
        actions=["Attack", "Ice Bolt", "Arctic Blast", "Defend"],
        drop_table=[LootDrop("Hi-Ether", 0.25), LootDrop("Silk Vestment", 0.04)],
    ),
    "Glacier": BestiaryTemplate(
        name="Glacier", family="Construct", affinity=BattleActionType.ELEMENTAL_ICE, role="tank",
        biomes=["Tundra"], min_region=6, max_region=8, threat_rank="A",
        actions=["Attack", "Ice Bolt", "Drop Kick", "Defend"],
        drop_table=[LootDrop("Hi-Potion", 0.30), LootDrop("Plate Cuirass", 0.04)],
    ),
    # Tier 7-9 (Lv 56-95)
    "Jotun": BestiaryTemplate(
        name="Jotun", family="Giant", affinity=BattleActionType.ELEMENTAL_ICE, role="tank",
        biomes=["Tundra"], min_region=7, max_region=9, threat_rank="A",
        actions=["Attack", "Ice Bolt", "Axe Cleave", "Defend"],
        drop_table=[LootDrop("Revive Herb", 0.20), LootDrop("Ring of Might", 0.03)],
    ),

    # -------------------------------------------------------------------------
    # SWAMP
    # -------------------------------------------------------------------------
    # Tier 1 (Lv 1-4)
    "Leech": BestiaryTemplate(
        name="Leech", family="Vermicular", affinity=BattleActionType.ELEMENTAL_DARK, role="dps",
        biomes=["Swamp"], min_region=1, max_region=2, threat_rank="D",
        actions=["Attack", "Blood Drain"],
        drop_table=[LootDrop("Potion", 0.25)],
    ),
    "Mosquito": BestiaryTemplate(
        name="Mosquito", family="Insect", affinity=BattleActionType.ELEMENTAL_WIND, role="speed",
        biomes=["Swamp"], min_region=1, max_region=3, threat_rank="D",
        actions=["Attack", "Double Scratch", "Blood Drain"],
        drop_table=[LootDrop("Antidote", 0.25)],
    ),
    # Tier 2 (Lv 5-10)
    "Newt": BestiaryTemplate(
        name="Newt", family="Amphibian", affinity=BattleActionType.ELEMENTAL_WATER, role="balanced",
        biomes=["Swamp"], min_region=2, max_region=4, threat_rank="D",
        actions=["Attack", "Tidal Crush"],
        drop_table=[LootDrop("Potion", 0.30)],
    ),
    "Frog": BestiaryTemplate(
        name="Frog", family="Amphibian", affinity=BattleActionType.ELEMENTAL_WATER, role="tank",
        biomes=["Swamp"], min_region=2, max_region=4, threat_rank="D",
        actions=["Attack", "Tidal Crush", "Defend"],
        drop_table=[LootDrop("Potion", 0.30), LootDrop("Antidote", 0.20)],
    ),
    # Tier 3 (Lv 11-18)
    "Gator": BestiaryTemplate(
        name="Gator", family="Reptile", affinity=BattleActionType.ELEMENTAL_WATER, role="tank",
        biomes=["Swamp"], min_region=3, max_region=5, threat_rank="C",
        actions=["Attack", "Bite", "Tidal Crush", "Defend"],
        drop_table=[LootDrop("Hi-Potion", 0.25), LootDrop("Traveler Cloak", 0.04)],
    ),
    "Muck": BestiaryTemplate(
        name="Muck", family="Slime", affinity=BattleActionType.ELEMENTAL_EARTH, role="tank",
        biomes=["Swamp"], min_region=3, max_region=5, threat_rank="C",
        actions=["Attack", "Boulder Bash", "Defend"],
        drop_table=[LootDrop("Poison Bottle", 0.25), LootDrop("Antidote", 0.25)],
    ),
    # Tier 4 (Lv 19-28)
    "Bogwitch": BestiaryTemplate(
        name="Bogwitch", family="Humanoid", affinity=BattleActionType.ELEMENTAL_DARK, role="magic",
        biomes=["Swamp"], min_region=4, max_region=6, threat_rank="C",
        actions=["Attack", "Dark Surge", "Blood Drain", "Defend"],
        drop_table=[LootDrop("Ether", 0.25), LootDrop("Oak Staff", 0.04)],
    ),
    "Mudgolem": BestiaryTemplate(
        name="Mudgolem", family="Construct", affinity=BattleActionType.ELEMENTAL_EARTH, role="tank",
        biomes=["Swamp"], min_region=4, max_region=6, threat_rank="B",
        actions=["Attack", "Boulder Bash", "Drop Kick", "Defend"],
        drop_table=[LootDrop("Hi-Potion", 0.25), LootDrop("Plate Cuirass", 0.04)],
    ),
    # Tier 5 (Lv 29-40)
    "Boa": BestiaryTemplate(
        name="Boa", family="Reptile", affinity=BattleActionType.PHYSICAL, role="dps",
        biomes=["Swamp"], min_region=5, max_region=7, threat_rank="B",
        actions=["Attack", "Bite", "Double Scratch"],
        drop_table=[LootDrop("Hi-Potion", 0.25), LootDrop("Brigandine", 0.04)],
    ),
    "Willows": BestiaryTemplate(
        name="Willows", family="Plant", affinity=BattleActionType.ELEMENTAL_EARTH, role="magic",
        biomes=["Swamp"], min_region=5, max_region=7, threat_rank="B",
        actions=["Attack", "Boulder Bash", "Defend"],
        drop_table=[LootDrop("Hi-Ether", 0.20), LootDrop("Mage Mantle", 0.04)],
    ),
    # Tier 6 (Lv 41-55)
    "Mirebeast": BestiaryTemplate(
        name="Mirebeast", family="Monstrosity", affinity=BattleActionType.ELEMENTAL_DARK, role="tank",
        biomes=["Swamp"], min_region=6, max_region=8, threat_rank="A",
        actions=["Attack", "Dark Surge", "Axe Cleave", "Defend"],
        drop_table=[LootDrop("Hi-Potion", 0.25), LootDrop("Steel Pauldrons", 0.04)],
    ),
    "Hydraling": BestiaryTemplate(
        name="Hydraling", family="Draconic", affinity=BattleActionType.ELEMENTAL_WATER, role="dps",
        biomes=["Swamp"], min_region=6, max_region=8, threat_rank="A",
        actions=["Attack", "Tidal Crush", "Bite"],
        drop_table=[LootDrop("Hi-Ether", 0.25), LootDrop("Steel Broadsword", 0.04)],
    ),
    # Tier 7-9 (Lv 56-95)
    "Boglord": BestiaryTemplate(
        name="Boglord", family="Undead", affinity=BattleActionType.ELEMENTAL_DARK, role="magic",
        biomes=["Swamp"], min_region=7, max_region=9, threat_rank="A",
        actions=["Attack", "Dark Surge", "Cataclysm", "Defend"],
        drop_table=[LootDrop("Revive Herb", 0.20), LootDrop("Shadow Cape", 0.03)],
    ),
    "Foulfang": BestiaryTemplate(
        name="Foulfang", family="Draconic", affinity=BattleActionType.ELEMENTAL_DARK, role="dps",
        biomes=["Swamp"], min_region=8, max_region=9, threat_rank="A",
        actions=["Attack", "Dark Surge", "Blood Drain", "Bite"],
        drop_table=[LootDrop("Elixir", 0.08), LootDrop("Sapphire Ring", 0.04)],
    ),
}


def get_template(name: str) -> Optional[BestiaryTemplate]:
    """Retrieves a bestiary template by exact name from BOSS_CATALOG or BESTIARY."""
    if name in BOSS_CATALOG:
        return BOSS_CATALOG[name]
    return BESTIARY.get(name)


def get_boss_by_region(region_code: int) -> Optional[BestiaryTemplate]:
    """Retrieves the primary boss assigned to a given region code (1 to 9)."""
    reg = max(1, min(9, region_code))
    # Direct mapping of canonical boss per region
    primary_boss_names = {
        1: "Rattus",
        2: "Brigand",
        3: "Broodfang",
        4: "Ironhide",
        5: "Gargoyle",
        6: "Magmadon",
        7: "Deathclaw",
        8: "Archdemon",
        9: "Malakor",
    }
    boss_name = primary_boss_names.get(reg, "Malakor")
    return BOSS_CATALOG.get(boss_name)
