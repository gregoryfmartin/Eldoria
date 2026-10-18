"""10-slot RPG equipment system and gear definitions."""
from __future__ import annotations
import re
from dataclasses import dataclass, field
from typing import Optional, Iterable
from eldoria_py.combat.stats import StatId, EquipmentSlot
from eldoria_py.combat.actions import BattleAction, ACTIONS
from eldoria_py.combat.portrait import Gender


# Naming patterns for gender-sensitive equipment
FEMALE_NAME_PATTERNS = [
    r"\bvalkyrie\b",
    r"\bvalkyries\b",
    r"\bvalkyrie's\b",
    r"\bmaiden\b",
    r"\bmaidens\b",
    r"\bmaiden's\b",
    r"\bprincess\b",
    r"\bprincesses\b",
    r"\bprincess's\b",
    r"\bqueen\b",
    r"\bqueens\b",
    r"\bqueen's\b",
    r"\bsorceress\b",
    r"\bsorceresses\b",
    r"\bsorceress's\b",
    r"\bpriestess\b",
    r"\bpriestesses\b",
    r"\bpriestess's\b",
    r"\bwitch\b",
    r"\bwitches\b",
    r"\bwitch's\b",
    r"\bgoddess\b",
    r"\bgoddesses\b",
    r"\bgoddess's\b",
    r"\bvixen\b",
    r"\bvixens\b",
    r"\bvixen's\b",
    r"\blady\b",
    r"\bladies\b",
    r"\blady's\b",
    r"\bdame\b",
    r"\bmatron\b",
    r"\bmatriarch\b",
    r"\bamazon\b",
    r"\bamazonian\b",
    r"\bgown\b",
    r"\bdress\b",
    r"\bcorset\b",
    r"\bskirt\b",
    r"\bblouse\b",
    r"\btiara\b",
]

MALE_NAME_PATTERNS = [
    r"\bwarlord\b",
    r"\bwarlords\b",
    r"\bwarlord's\b",
    r"\bchieftain\b",
    r"\bchieftains\b",
    r"\bchieftain's\b",
    r"\bking\b",
    r"\bkings\b",
    r"\bking's\b",
    r"\bprince\b",
    r"\bprinces\b",
    r"\bprince's\b",
    r"\bemperor\b",
    r"\bemperors\b",
    r"\bemperor's\b",
    r"\blord\b",
    r"\blords\b",
    r"\blord's\b",
    r"\bwarlock\b",
    r"\bwarlocks\b",
    r"\bwarlock's\b",
    r"\bpatriarch\b",
    r"\bpatriarchs\b",
    r"\bpatriarch's\b",
    r"\bbarbarian\b",
    r"\bbarbarians\b",
    r"\bbarbarian's\b",
    r"\bgentleman\b",
    r"\bgentlemen\b",
    r"\bsir\b",
    r"\bduke\b",
    r"\bdukes\b",
    r"\bbaron\b",
    r"\bbarons\b",
    r"\bmonk\b",
    r"\bmonks\b",
]


def infer_equipment_gender_by_name(name: str) -> Gender:
    """
    Evaluates equipment name against semantic gender indicators.
    Returns Gender.FEMALE or Gender.MALE if gender-specific naming patterns
    are matched, otherwise returns Gender.UNISEX for all equipment eligible
    for both males and females.
    """
    lower_name = name.lower()

    for pattern in FEMALE_NAME_PATTERNS:
        if re.search(pattern, lower_name, re.IGNORECASE):
            return Gender.FEMALE

    for pattern in MALE_NAME_PATTERNS:
        if re.search(pattern, lower_name, re.IGNORECASE):
            return Gender.MALE

    return Gender.UNISEX


@dataclass
class BattleEquipment:
    """An equippable item providing static stat augmentations across 10 gear slots."""
    name: str
    slot: EquipmentSlot
    stat_bonuses: dict[StatId, int] = field(default_factory=dict)
    unlocked_action_name: Optional[str] = None
    description: str = ""
    price: int = 100
    tier: int = 1
    is_relic: bool = False
    target_gender: Gender = Gender.UNISEX

    def __post_init__(self) -> None:
        if self.target_gender == Gender.UNISEX:
            inferred = infer_equipment_gender_by_name(self.name)
            if inferred != Gender.UNISEX:
                self.target_gender = inferred

    def get_bonus(self, stat: StatId) -> int:
        """Returns the bonus granted to the given stat, defaulting to 0."""
        return self.stat_bonuses.get(stat, 0)

    def can_equip_by(self, gender: Gender) -> bool:
        """Returns True if the item is Unisex or matches the specified character gender."""
        if self.target_gender == Gender.UNISEX:
            return True
        return self.target_gender == gender

    @property
    def sell_price(self) -> int:
        """Resale price is fixed at 20% of base sale price in all cases."""
        return max(1, int(self.price * 0.20))

    def to_dict(self) -> dict:
        return {
            "name": self.name,
            "slot": self.slot.value,
            "stat_bonuses": {k.value: v for k, v in self.stat_bonuses.items()},
            "unlocked_action_name": self.unlocked_action_name,
            "description": self.description,
            "price": self.price,
            "tier": self.tier,
            "is_relic": self.is_relic,
            "target_gender": self.target_gender.value,
        }

    @classmethod
    def from_dict(cls, data: dict | str) -> BattleEquipment:
        if isinstance(data, str):
            if data in EQUIPMENT_CATALOG:
                item = EQUIPMENT_CATALOG[data]
                return cls(
                    name=item.name,
                    slot=item.slot,
                    stat_bonuses=dict(item.stat_bonuses),
                    unlocked_action_name=item.unlocked_action_name,
                    description=item.description,
                    price=item.price,
                    tier=item.tier,
                    is_relic=item.is_relic,
                    target_gender=item.target_gender,
                )
            raise ValueError(f"Unknown equipment catalog item: {data}")
        raw_gender = data.get("target_gender")
        if raw_gender is not None:
            try:
                target_gender = Gender(raw_gender)
            except (ValueError, KeyError):
                target_gender = infer_equipment_gender_by_name(data["name"])
        else:
            target_gender = infer_equipment_gender_by_name(data["name"])
        return cls(
            name=data["name"],
            slot=EquipmentSlot(data["slot"]),
            stat_bonuses={StatId(k): v for k, v in data.get("stat_bonuses", {}).items()},
            unlocked_action_name=data.get("unlocked_action_name"),
            description=data.get("description", ""),
            price=data.get("price", 100),
            tier=data.get("tier", 1),
            is_relic=data.get("is_relic", False),
            target_gender=target_gender,
        )


def get_equipment(name: str) -> Optional[BattleEquipment]:
    """Retrieves a piece of equipment from the catalog by name, or None."""
    return EQUIPMENT_CATALOG.get(name)


# Standard starting & progression equipment
EQUIPMENT_CATALOG: dict[str, BattleEquipment] = {
    # Weapons
    "Iron Longsword": BattleEquipment(
        name="Iron Longsword",
        slot=EquipmentSlot.WEAPON,
        stat_bonuses={StatId.ATTACK: 18, StatId.ACCURACY: 5},
        unlocked_action_name="Flame Punch",
        description="A sturdy forged steel blade.",
        price=150,
        tier=1,
    ),
    "Oak Staff": BattleEquipment(
        name="Oak Staff",
        slot=EquipmentSlot.WEAPON,
        stat_bonuses={StatId.MAGIC_ATTACK: 22, StatId.MAGIC_POINTS: 30},
        unlocked_action_name="Fireball",
        description="Carved from elder wood, attuned to sorcery.",
        price=140,
        tier=1,
    ),
    "Twin Daggers": BattleEquipment(
        name="Twin Daggers",
        slot=EquipmentSlot.WEAPON,
        stat_bonuses={StatId.ATTACK: 14, StatId.SPEED: 6, StatId.LUCK: 8},
        unlocked_action_name="Double Scratch",
        description="Lightweight rogue blades primed for swift criticals.",
        price=120,
        tier=1,
    ),
    "Silver Mace": BattleEquipment(
        name="Silver Mace",
        slot=EquipmentSlot.WEAPON,
        stat_bonuses={StatId.ATTACK: 12, StatId.MAGIC_ATTACK: 14, StatId.MAGIC_POINTS: 20},
        unlocked_action_name="Radiance",
        description="Holy weapon blessed by the Temple of Light.",
        price=240,
        tier=2,
    ),
    "Heavy Battleaxe": BattleEquipment(
        name="Heavy Battleaxe",
        slot=EquipmentSlot.WEAPON,
        stat_bonuses={StatId.ATTACK: 25, StatId.DEFENSE: -2},
        unlocked_action_name="Axe Cleave",
        description="A brutal two-handed axe of berserker fury.",
        price=350,
        tier=2,
    ),
    "Steel Broadsword": BattleEquipment(
        name="Steel Broadsword",
        slot=EquipmentSlot.WEAPON,
        stat_bonuses={StatId.ATTACK: 32, StatId.ACCURACY: -4},
        unlocked_action_name="Heavy Cleave",
        description="A hefty double-edged broadsword designed for brutal cutting power.",
        price=550,
        tier=3,
    ),

    # Helmets
    "Leather Hood": BattleEquipment(
        name="Leather Hood",
        slot=EquipmentSlot.HELMET,
        stat_bonuses={StatId.DEFENSE: 4, StatId.SPEED: 2},
        description="Soft dark leather hood concealing the wearer.",
        price=90,
        tier=1,
    ),
    "Iron Greathelm": BattleEquipment(
        name="Iron Greathelm",
        slot=EquipmentSlot.HELMET,
        stat_bonuses={StatId.DEFENSE: 8, StatId.MAGIC_DEFENSE: 3},
        description="Full-face visor protecting against concussion.",
        price=250,
        tier=2,
    ),
    "Mage Circlet": BattleEquipment(
        name="Mage Circlet",
        slot=EquipmentSlot.HELMET,
        stat_bonuses={StatId.MAGIC_DEFENSE: 7, StatId.MAGIC_POINTS: 25},
        description="An enchanted silver circlet that focuses mana.",
        price=220,
        tier=2,
    ),
    "Maiden Circlet": BattleEquipment(
        name="Maiden Circlet",
        slot=EquipmentSlot.HELMET,
        stat_bonuses={StatId.MAGIC_DEFENSE: 8, StatId.MAGIC_POINTS: 20},
        description="A delicate silver circlet worn by temple maidens.",
        price=240,
        tier=2,
    ),
    "King's Greathelm": BattleEquipment(
        name="King's Greathelm",
        slot=EquipmentSlot.HELMET,
        stat_bonuses={StatId.DEFENSE: 12, StatId.ATTACK: 4, StatId.HIT_POINTS: 25},
        description="A crowned steel helm forged for sovereign rulers.",
        price=580,
        tier=3,
    ),
    "Queen's Tiara": BattleEquipment(
        name="Queen's Tiara",
        slot=EquipmentSlot.HELMET,
        stat_bonuses={StatId.MAGIC_ATTACK: 10, StatId.MAGIC_DEFENSE: 10, StatId.LUCK: 5},
        description="A regal jewel-encrusted tiara radiating sovereign grace.",
        price=620,
        tier=3,
    ),

    # Armor
    "Brigandine": BattleEquipment(
        name="Brigandine",
        slot=EquipmentSlot.ARMOR,
        stat_bonuses={StatId.DEFENSE: 12, StatId.HIT_POINTS: 30, StatId.SPEED: 3},
        description="Riveted leather and metal plates balancing weight and defense.",
        price=280,
        tier=2,
    ),
    "Silk Vestment": BattleEquipment(
        name="Silk Vestment",
        slot=EquipmentSlot.ARMOR,
        stat_bonuses={StatId.DEFENSE: 6, StatId.MAGIC_DEFENSE: 18, StatId.MAGIC_POINTS: 40},
        description="Weft robes threaded with mystic protection.",
        price=300,
        tier=2,
    ),
    "Plate Cuirass": BattleEquipment(
        name="Plate Cuirass",
        slot=EquipmentSlot.ARMOR,
        stat_bonuses={StatId.DEFENSE: 20, StatId.HIT_POINTS: 60, StatId.SPEED: -2},
        description="Interlocking steel breastplate offering great resilience.",
        price=650,
        tier=3,
    ),
    "Valkyrie Mail": BattleEquipment(
        name="Valkyrie Mail",
        slot=EquipmentSlot.ARMOR,
        stat_bonuses={StatId.DEFENSE: 18, StatId.MAGIC_DEFENSE: 12, StatId.SPEED: 4},
        description="Ceremonial silver plate enchanted for maiden warriors.",
        price=480,
        tier=2,
    ),
    "Warlord Cuirass": BattleEquipment(
        name="Warlord Cuirass",
        slot=EquipmentSlot.ARMOR,
        stat_bonuses={StatId.DEFENSE: 22, StatId.ATTACK: 6, StatId.HIT_POINTS: 35},
        description="Heavy battle plate forged for towering chieftains.",
        price=520,
        tier=2,
    ),
    "Barbarian Harness": BattleEquipment(
        name="Barbarian Harness",
        slot=EquipmentSlot.ARMOR,
        stat_bonuses={StatId.DEFENSE: 14, StatId.ATTACK: 8, StatId.SPEED: 2},
        description="Thick leather harness worn by northern warmongers.",
        price=310,
        tier=2,
    ),
    "Sorceress Gown": BattleEquipment(
        name="Sorceress Gown",
        slot=EquipmentSlot.ARMOR,
        stat_bonuses={StatId.DEFENSE: 8, StatId.MAGIC_DEFENSE: 16, StatId.MAGIC_POINTS: 35},
        description="An elegant gossamer gown woven for enchantresses.",
        price=320,
        tier=2,
    ),
    "Lord's Cuirass": BattleEquipment(
        name="Lord's Cuirass",
        slot=EquipmentSlot.ARMOR,
        stat_bonuses={StatId.DEFENSE: 24, StatId.ATTACK: 5, StatId.HIT_POINTS: 40},
        description="Noble parade plate worn by martial lords.",
        price=680,
        tier=3,
    ),
    "Princess Dress": BattleEquipment(
        name="Princess Dress",
        slot=EquipmentSlot.ARMOR,
        stat_bonuses={StatId.DEFENSE: 15, StatId.MAGIC_DEFENSE: 20, StatId.LUCK: 8},
        description="Finely tailored royal vesture imbued with protective wards.",
        price=700,
        tier=3,
    ),
    "Warlock Robe": BattleEquipment(
        name="Warlock Robe",
        slot=EquipmentSlot.ARMOR,
        stat_bonuses={StatId.DEFENSE: 7, StatId.MAGIC_ATTACK: 16, StatId.MAGIC_POINTS: 30},
        description="Dark woolen robe embroidered with demonic sigils.",
        price=290,
        tier=2,
    ),

    # Pauldrons
    "Steel Pauldrons": BattleEquipment(
        name="Steel Pauldrons",
        slot=EquipmentSlot.PAULDRON,
        stat_bonuses={StatId.DEFENSE: 6, StatId.ATTACK: 2},
        description="Heavy shoulder guards.",
        price=200,
        tier=2,
    ),
    "Mage Mantle": BattleEquipment(
        name="Mage Mantle",
        slot=EquipmentSlot.PAULDRON,
        stat_bonuses={StatId.MAGIC_DEFENSE: 6, StatId.MAGIC_ATTACK: 3},
        description="Shoulder cloak embroidered with wards.",
        price=180,
        tier=2,
    ),
    "Chieftain Pauldrons": BattleEquipment(
        name="Chieftain Pauldrons",
        slot=EquipmentSlot.PAULDRON,
        stat_bonuses={StatId.DEFENSE: 8, StatId.ATTACK: 4},
        description="Spiked iron pauldrons signifying clan leadership.",
        price=230,
        tier=2,
    ),

    # Gauntlets
    "Iron Gauntlets": BattleEquipment(
        name="Iron Gauntlets",
        slot=EquipmentSlot.GAUNTLETS,
        stat_bonuses={StatId.DEFENSE: 5, StatId.ATTACK: 3, StatId.ACCURACY: 4},
        description="Reinforced gloves that protect knuckles and wrists.",
        price=210,
        tier=2,
    ),
    "Spellweaver Mitts": BattleEquipment(
        name="Spellweaver Mitts",
        slot=EquipmentSlot.GAUNTLETS,
        stat_bonuses={StatId.MAGIC_ATTACK: 5, StatId.ACCURACY: 8},
        description="Fine glove empowering runic casting.",
        price=200,
        tier=2,
    ),

    # Greaves
    "Traveler Leggings": BattleEquipment(
        name="Traveler Leggings",
        slot=EquipmentSlot.GREAVES,
        stat_bonuses={StatId.DEFENSE: 3, StatId.SPEED: 4},
        description="Flexible hide pants crafted for rapid motion.",
        price=100,
        tier=1,
    ),
    "Steel Greaves": BattleEquipment(
        name="Steel Greaves",
        slot=EquipmentSlot.GREAVES,
        stat_bonuses={StatId.DEFENSE: 7, StatId.HIT_POINTS: 20},
        description="Armored leg guards.",
        price=280,
        tier=2,
    ),

    # Boots
    "Plated Sabatons": BattleEquipment(
        name="Plated Sabatons",
        slot=EquipmentSlot.BOOTS,
        stat_bonuses={StatId.DEFENSE: 5, StatId.SPEED: -1},
        description="Solid steel boots.",
        price=220,
        tier=2,
    ),
    "Winged Sandals": BattleEquipment(
        name="Winged Sandals",
        slot=EquipmentSlot.BOOTS,
        stat_bonuses={StatId.SPEED: 10, StatId.LUCK: 4},
        description="Enchanted footwear granting agile footing.",
        price=600,
        tier=3,
    ),
    "Vixen Boots": BattleEquipment(
        name="Vixen Boots",
        slot=EquipmentSlot.BOOTS,
        stat_bonuses={StatId.SPEED: 7, StatId.LUCK: 6},
        description="Sleek velvet boots favoured by cunning rogue maidens.",
        price=260,
        tier=2,
    ),

    # Jewelry A
    "Sapphire Ring": BattleEquipment(
        name="Sapphire Ring",
        slot=EquipmentSlot.JEWELRY_A,
        stat_bonuses={StatId.MAGIC_ATTACK: 8, StatId.MAGIC_POINTS: 30},
        description="Channeling deep oceanic arcane flow.",
        price=700,
        tier=3,
    ),
    "Ring of Might": BattleEquipment(
        name="Ring of Might",
        slot=EquipmentSlot.JEWELRY_A,
        stat_bonuses={StatId.ATTACK: 8, StatId.HIT_POINTS: 25},
        description="A heavy ruby ring pulsing with physical vigor.",
        price=800,
        tier=3,
    ),

    # Jewelry B
    "Lucky Coin Talisman": BattleEquipment(
        name="Lucky Coin Talisman",
        slot=EquipmentSlot.JEWELRY_B,
        stat_bonuses={StatId.LUCK: 14, StatId.ACCURACY: 6},
        description="Old gold medallion favored by gamblers and thieves.",
        price=750,
        tier=3,
    ),
    "Amulet of Health": BattleEquipment(
        name="Amulet of Health",
        slot=EquipmentSlot.JEWELRY_B,
        stat_bonuses={StatId.HIT_POINTS: 75, StatId.DEFENSE: 3},
        description="Pendant imbued with vitality blessing.",
        price=900,
        tier=3,
    ),

    # Cape
    "Traveler Cloak": BattleEquipment(
        name="Traveler Cloak",
        slot=EquipmentSlot.CAPE,
        stat_bonuses={StatId.MAGIC_DEFENSE: 6, StatId.SPEED: 2},
        description="A durable traveling cloak that fends off cold winds and minor hexes.",
        price=80,
        tier=1,
    ),
    "Cloak of Protection": BattleEquipment(
        name="Cloak of Protection",
        slot=EquipmentSlot.CAPE,
        stat_bonuses={StatId.DEFENSE: 4, StatId.MAGIC_DEFENSE: 8, StatId.SPEED: 2},
        description="A flowing woolen cape repelling elemental gusts.",
        price=260,
        tier=2,
    ),
    "Shadow Cape": BattleEquipment(
        name="Shadow Cape",
        slot=EquipmentSlot.CAPE,
        stat_bonuses={StatId.SPEED: 6, StatId.LUCK: 6, StatId.MAGIC_DEFENSE: 4},
        description="Woven of dusky fibers blending into obscurity.",
        price=650,
        tier=3,
    ),

    # High-End / Endgame Relics (Not stocked at normal town armorers)
    "Excalibur": BattleEquipment(
        name="Excalibur",
        slot=EquipmentSlot.WEAPON,
        stat_bonuses={StatId.ATTACK: 55, StatId.ACCURACY: 10, StatId.LUCK: 10},
        unlocked_action_name="Radiance",
        description="Legendary holy blade of kings.",
        price=4500,
        tier=5,
        is_relic=True,
    ),
    "Dragon Shield": BattleEquipment(
        name="Dragon Shield",
        slot=EquipmentSlot.PAULDRON,
        stat_bonuses={StatId.DEFENSE: 25, StatId.MAGIC_DEFENSE: 15, StatId.HIT_POINTS: 50},
        description="Scales of an ancient wyrm forged into an impenetrable shield.",
        price=3200,
        tier=5,
        is_relic=True,
    ),
    "Mythril Plate": BattleEquipment(
        name="Mythril Plate",
        slot=EquipmentSlot.ARMOR,
        stat_bonuses={StatId.DEFENSE: 40, StatId.MAGIC_DEFENSE: 20, StatId.HIT_POINTS: 120},
        description="Impossibly light yet impervious mythril armor.",
        price=3800,
        tier=5,
        is_relic=True,
    ),
    "Titan Helm": BattleEquipment(
        name="Titan Helm",
        slot=EquipmentSlot.HELMET,
        stat_bonuses={StatId.DEFENSE: 20, StatId.MAGIC_DEFENSE: 10, StatId.HIT_POINTS: 50},
        description="Helm forged for colossal giants of antiquity.",
        price=2400,
        tier=5,
        is_relic=True,
    ),
    "Aegis Cloak": BattleEquipment(
        name="Aegis Cloak",
        slot=EquipmentSlot.CAPE,
        stat_bonuses={StatId.DEFENSE: 15, StatId.MAGIC_DEFENSE: 25, StatId.SPEED: 8},
        description="Cloak enchanted by the gods to repel all curses.",
        price=2800,
        tier=5,
        is_relic=True,
    ),
}


def assign_genders_to_equipment_catalog(
    catalog: Optional[dict[str, BattleEquipment]] = None,
) -> dict[str, Gender]:
    """
    Loops through all equipment catalog items and assigns appropriate genders based on their names.
    Unisex is used for equipment eligible for both males and females.
    Returns a mapping of item name to assigned Gender.
    """
    target = EQUIPMENT_CATALOG if catalog is None else catalog
    results: dict[str, Gender] = {}
    for name, eq in target.items():
        inferred = infer_equipment_gender_by_name(name)
        eq.target_gender = inferred
        results[name] = inferred
    return results


# Execute gender assignment across all equipment items in the catalog
assign_genders_to_equipment_catalog()

