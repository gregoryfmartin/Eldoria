"""10-slot RPG equipment system and gear definitions."""
from __future__ import annotations
from dataclasses import dataclass, field
from typing import Optional
from eldoria_py.combat.stats import StatId, EquipmentSlot
from eldoria_py.combat.actions import BattleAction, ACTIONS


@dataclass
class BattleEquipment:
    """An equippable item providing static stat augmentations across 10 gear slots."""
    name: str
    slot: EquipmentSlot
    stat_bonuses: dict[StatId, int] = field(default_factory=dict)
    unlocked_action_name: Optional[str] = None
    description: str = ""

    def get_bonus(self, stat: StatId) -> int:
        """Returns the bonus granted to the given stat, defaulting to 0."""
        return self.stat_bonuses.get(stat, 0)


# Standard starting & progression equipment
EQUIPMENT_CATALOG: dict[str, BattleEquipment] = {
    # Weapons
    "Iron Longsword": BattleEquipment(
        name="Iron Longsword",
        slot=EquipmentSlot.WEAPON,
        stat_bonuses={StatId.ATTACK: 18, StatId.ACCURACY: 5},
        unlocked_action_name="Flame Punch",
        description="A sturdy forged steel blade.",
    ),
    "Oak Staff": BattleEquipment(
        name="Oak Staff",
        slot=EquipmentSlot.WEAPON,
        stat_bonuses={StatId.MAGIC_ATTACK: 22, StatId.MAGIC_POINTS: 30},
        unlocked_action_name="Fireball",
        description="Carved from elder wood, attuned to sorcery.",
    ),
    "Twin Daggers": BattleEquipment(
        name="Twin Daggers",
        slot=EquipmentSlot.WEAPON,
        stat_bonuses={StatId.ATTACK: 14, StatId.SPEED: 6, StatId.LUCK: 8},
        unlocked_action_name="Double Scratch",
        description="Lightweight rogue blades primed for swift criticals.",
    ),
    "Silver Mace": BattleEquipment(
        name="Silver Mace",
        slot=EquipmentSlot.WEAPON,
        stat_bonuses={StatId.ATTACK: 12, StatId.MAGIC_ATTACK: 14, StatId.MAGIC_POINTS: 20},
        unlocked_action_name="Radiance",
        description="Holy weapon blessed by the Temple of Light.",
    ),
    "Heavy Battleaxe": BattleEquipment(
        name="Heavy Battleaxe",
        slot=EquipmentSlot.WEAPON,
        stat_bonuses={StatId.ATTACK: 25, StatId.DEFENSE: -2},
        unlocked_action_name="Axe Cleave",
        description="A brutal two-handed axe of berserker fury.",
    ),

    # Helmets
    "Iron Greathelm": BattleEquipment(
        name="Iron Greathelm",
        slot=EquipmentSlot.HELMET,
        stat_bonuses={StatId.DEFENSE: 8, StatId.MAGIC_DEFENSE: 3},
        description="Full-face visor protecting against concussion.",
    ),
    "Mage Circlet": BattleEquipment(
        name="Mage Circlet",
        slot=EquipmentSlot.HELMET,
        stat_bonuses={StatId.MAGIC_DEFENSE: 7, StatId.MAGIC_POINTS: 25},
        description="An enchanted silver circlet that focuses mana.",
    ),
    "Leather Hood": BattleEquipment(
        name="Leather Hood",
        slot=EquipmentSlot.HELMET,
        stat_bonuses={StatId.DEFENSE: 4, StatId.SPEED: 2},
        description="Soft dark leather hood concealing the wearer.",
    ),

    # Armor
    "Plate Cuirass": BattleEquipment(
        name="Plate Cuirass",
        slot=EquipmentSlot.ARMOR,
        stat_bonuses={StatId.DEFENSE: 20, StatId.HIT_POINTS: 60, StatId.SPEED: -2},
        description="Interlocking steel breastplate offering great resilience.",
    ),
    "Silk Vestment": BattleEquipment(
        name="Silk Vestment",
        slot=EquipmentSlot.ARMOR,
        stat_bonuses={StatId.DEFENSE: 6, StatId.MAGIC_DEFENSE: 18, StatId.MAGIC_POINTS: 40},
        description="Weft robes threaded with mystic protection.",
    ),
    "Brigandine": BattleEquipment(
        name="Brigandine",
        slot=EquipmentSlot.ARMOR,
        stat_bonuses={StatId.DEFENSE: 12, StatId.HIT_POINTS: 30, StatId.SPEED: 3},
        description="Riveted leather and metal plates balancing weight and defense.",
    ),

    # Pauldrons
    "Steel Pauldrons": BattleEquipment(
        name="Steel Pauldrons",
        slot=EquipmentSlot.PAULDRON,
        stat_bonuses={StatId.DEFENSE: 6, StatId.ATTACK: 2},
        description="Heavy shoulder guards.",
    ),
    "Mage Mantle": BattleEquipment(
        name="Mage Mantle",
        slot=EquipmentSlot.PAULDRON,
        stat_bonuses={StatId.MAGIC_DEFENSE: 6, StatId.MAGIC_ATTACK: 3},
        description="Shoulder cloak embroidered with wards.",
    ),

    # Gauntlets
    "Iron Gauntlets": BattleEquipment(
        name="Iron Gauntlets",
        slot=EquipmentSlot.GAUNTLETS,
        stat_bonuses={StatId.DEFENSE: 5, StatId.ATTACK: 3, StatId.ACCURACY: 4},
        description="Reinforced gloves that protect knuckles and wrists.",
    ),
    "Spellweaver Mitts": BattleEquipment(
        name="Spellweaver Mitts",
        slot=EquipmentSlot.GAUNTLETS,
        stat_bonuses={StatId.MAGIC_ATTACK: 5, StatId.ACCURACY: 8},
        description="Fine glove empowering runic casting.",
    ),

    # Greaves
    "Steel Greaves": BattleEquipment(
        name="Steel Greaves",
        slot=EquipmentSlot.GREAVES,
        stat_bonuses={StatId.DEFENSE: 7, StatId.HIT_POINTS: 20},
        description="Armored leg guards.",
    ),
    "Traveler Leggings": BattleEquipment(
        name="Traveler Leggings",
        slot=EquipmentSlot.GREAVES,
        stat_bonuses={StatId.DEFENSE: 3, StatId.SPEED: 4},
        description="Flexible hide pants crafted for rapid motion.",
    ),

    # Boots
    "Plated Sabatons": BattleEquipment(
        name="Plated Sabatons",
        slot=EquipmentSlot.BOOTS,
        stat_bonuses={StatId.DEFENSE: 5, StatId.SPEED: -1},
        description="Solid steel boots.",
    ),
    "Winged Sandals": BattleEquipment(
        name="Winged Sandals",
        slot=EquipmentSlot.BOOTS,
        stat_bonuses={StatId.SPEED: 10, StatId.LUCK: 4},
        description="Enchanted footwear granting agile footing.",
    ),

    # Jewelry A
    "Ring of Might": BattleEquipment(
        name="Ring of Might",
        slot=EquipmentSlot.JEWELRY_A,
        stat_bonuses={StatId.ATTACK: 8, StatId.HIT_POINTS: 25},
        description="A heavy ruby ring pulsing with physical vigor.",
    ),
    "Sapphire Ring": BattleEquipment(
        name="Sapphire Ring",
        slot=EquipmentSlot.JEWELRY_A,
        stat_bonuses={StatId.MAGIC_ATTACK: 8, StatId.MAGIC_POINTS: 30},
        description="Channeling deep oceanic arcane flow.",
    ),

    # Jewelry B
    "Amulet of Health": BattleEquipment(
        name="Amulet of Health",
        slot=EquipmentSlot.JEWELRY_B,
        stat_bonuses={StatId.HIT_POINTS: 75, StatId.DEFENSE: 3},
        description="Pendant imbued with vitality blessing.",
    ),
    "Lucky Coin Talisman": BattleEquipment(
        name="Lucky Coin Talisman",
        slot=EquipmentSlot.JEWELRY_B,
        stat_bonuses={StatId.LUCK: 14, StatId.ACCURACY: 6},
        description="Old gold medallion favored by gamblers and thieves.",
    ),

    # Cape
    "Cloak of Protection": BattleEquipment(
        name="Cloak of Protection",
        slot=EquipmentSlot.CAPE,
        stat_bonuses={StatId.DEFENSE: 4, StatId.MAGIC_DEFENSE: 8, StatId.SPEED: 2},
        description="A flowing woolen cape repelling elemental gusts.",
    ),
    "Shadow Cape": BattleEquipment(
        name="Shadow Cape",
        slot=EquipmentSlot.CAPE,
        stat_bonuses={StatId.SPEED: 6, StatId.LUCK: 6, StatId.MAGIC_DEFENSE: 4},
        description="Woven of dusky fibers blending into obscurity.",
    ),
}
