"""
NPC data model, roles, name pools, and factory generators for Eldoria towns and castles.
"""
from __future__ import annotations
from enum import Enum
import random
from typing import Any, Dict, List, Optional, Tuple

from ..terminal.color import TrueColor


class NPCRole(str, Enum):
    """Categorical classification of NPCs."""
    # Town Reserved Service Owners
    INNKEEPER = "Innkeeper"
    ITEM_SHOPKEEPER = "ItemShopkeeper"
    EQUIP_SHOPKEEPER = "EquipmentShopkeeper"
    PUB_BARTENDER = "PubBartender"

    # Castle Royal Personnel
    KING = "King"
    KNIGHT = "Knight"
    ROYAL_GUARD = "RoyalGuard"
    SERVANT = "Servant"
    COURT_ADVISOR = "CourtAdvisor"
    SQUIRE = "Squire"

    # Town Citizens & Folk
    CITIZEN = "Citizen"
    TRAVELER = "Traveler"
    VILLAGER = "Villager"
    MERCHANT = "Merchant"


class DialogCategory(str, Enum):
    """Classification of NPC interaction dialogue modality."""
    STANDARD = "Standard"
    CHOICE = "Choice"


# -------------------------------------------------------------------------
# Name Pools
# -------------------------------------------------------------------------
MONARCH_NAMES = [
    "King Aldous",
    "King Valen",
    "King Roderick",
    "King Theron",
    "King Cedric",
]

KNIGHT_NAMES = [
    "Sir Gareth",
    "Dame Teresa",
    "Sir Percival",
    "Sir Donald",
    "Sir Matthew",
    "Captain Roland",
    "Sir Geoffrey",
    "Dame Eleanor",
    "Sir Justin",
    "Sir Kenneth",
    "Knight Bradley",
    "Guard Lucas",
    "Sentry Vance",
    "Sentinel Cole",
    "Guard Tristan",
]

SERVANT_NAMES = [
    "Elspeth",
    "Marta",
    "Cedric",
    "Tobias",
    "Greta",
    "Corin",
    "Annette",
    "Harlan",
    "Nesta",
    "Daphne",
]

ADVISOR_NAMES = [
    "Chancellor Moros",
    "Archmage Eldred",
    "Sage Corvus",
    "Advisor Julia",
    "Grand Maester Lucian",
]

INNKEEPER_NAMES = [
    "Innkeeper Barnaby",
    "Innkeeper Helena",
    "Innkeeper Thaddeus",
    "Innkeeper Mary",
    "Host Rowan",
]

ITEM_SHOP_NAMES = [
    "Merchant Silas",
    "Apothecary Clara",
    "Alchemist Vance",
    "Trader Owen",
    "Herbalist Wendy",
]

EQUIP_SHOP_NAMES = [
    "Blacksmith Torvald",
    "Armorer Greta",
    "Weaponsmith Brand",
    "Forge-Master Varek",
    "Smith Derrick",
]

PUB_BARTENDER_NAMES = [
    "Barkeep Garek",
    "Tavernkeep Maeve",
    "Bartender Ollie",
    "Publican Jethro",
    "Barkeep Finn",
]

CITIZEN_NAMES = [
    "Farmer Giles",
    "Old Pete",
    "Miller Bram",
    "Weaver Lisa",
    "Baker Timothy",
    "Fisher Hal",
    "Woodcutter Ralph",
    "Acolyte Paul",
    "Herbalist Fiona",
    "Mason Drake",
    "Scout Karen",
    "Cobbler Finn",
    "Minstrel Robin",
    "Shepherd Colin",
    "Tanner Hugo",
    "Gardener Nora",
    "Tailor Sam",
    "Cooper Sean",
    "Potter Daisy",
    "Watchman Dirk",
    "Peddler Tom",
    "Miner Jack",
    "Scholar Iris",
    "Sailor Bruce",
    "Carpenter Luke",
]


class NPC:
    """Represents an interactive or decorative NPC placed on a sub-map."""

    def __init__(
        self,
        npc_id: str,
        name: str,
        role: NPCRole,
        glyph: str,
        fg_color: TrueColor,
        bg_color: TrueColor,
        pos: Tuple[int, int] = (0, 0),
        dialogue: str = "Greetings, traveler.",
        bounties: Optional[List[str]] = None,
        shop_inventory: Optional[List[Dict[str, Any]]] = None,
        category: DialogCategory = DialogCategory.STANDARD,
        choice_options: Optional[List[str]] = None,
        inn_fee: int = 20,
        side_quest_template_idx: Optional[int] = None,
        region: int = 1,
    ) -> None:
        self.npc_id = npc_id
        self.name = name
        self.role = role
        self.glyph = glyph
        self.fg_color = fg_color
        self.bg_color = bg_color
        self.pos = pos
        self.dialogue = dialogue
        self.bounties = list(bounties) if bounties else []
        self.shop_inventory = list(shop_inventory) if shop_inventory else []
        self.category = category
        if choice_options is not None:
            self.choice_options = list(choice_options)
        elif category == DialogCategory.CHOICE:
            self.choice_options = ["Yes", "No"]
        else:
            self.choice_options = []
        self.inn_fee = inn_fee
        self.side_quest_template_idx: Optional[int] = side_quest_template_idx
        self.region: int = region

    def to_dict(self) -> Dict[str, Any]:
        """Serializes NPC to JSON dictionary."""
        d: Dict[str, Any] = {
            "npc_id": self.npc_id,
            "name": self.name,
            "role": self.role.value,
            "category": self.category.value,
            "glyph": self.glyph,
            "fg_color": [self.fg_color.r, self.fg_color.g, self.fg_color.b],
            "bg_color": [self.bg_color.r, self.bg_color.g, self.bg_color.b],
            "pos": list(self.pos),
            "dialogue": self.dialogue,
        }
        if self.choice_options:
            d["choice_options"] = self.choice_options
        if self.inn_fee != 20:
            d["inn_fee"] = self.inn_fee
        if self.bounties:
            d["bounties"] = self.bounties
        if self.shop_inventory:
            d["shop_inventory"] = self.shop_inventory
        if self.side_quest_template_idx is not None:
            d["side_quest_template_idx"] = self.side_quest_template_idx
        if self.region != 1:
            d["region"] = self.region
        return d

    @classmethod
    def from_dict(cls, data: Dict[str, Any]) -> NPC:
        """Hydrates NPC from JSON dictionary."""
        fg = TrueColor(*data["fg_color"]) if "fg_color" in data else TrueColor(255, 255, 255)
        bg = TrueColor(*data["bg_color"]) if "bg_color" in data else TrueColor(0, 0, 0)
        try:
            role = NPCRole(data.get("role", NPCRole.CITIZEN.value))
        except ValueError:
            role = NPCRole.CITIZEN

        cat_str = data.get("category", DialogCategory.STANDARD.value)
        try:
            category = DialogCategory(cat_str)
        except ValueError:
            category = DialogCategory.STANDARD

        choice_opts = data.get("choice_options")
        inn_fee = data.get("inn_fee", 20)
        sq_idx = data.get("side_quest_template_idx")
        region = data.get("region", 1)

        return cls(
            npc_id=data.get("npc_id", "npc_unknown"),
            name=data.get("name", "Unknown"),
            role=role,
            glyph=data.get("glyph", "c"),
            fg_color=fg,
            bg_color=bg,
            pos=tuple(data.get("pos", [0, 0])),
            dialogue=data.get("dialogue", "Greetings."),
            bounties=data.get("bounties", []),
            shop_inventory=data.get("shop_inventory", []),
            category=category,
            choice_options=choice_opts,
            inn_fee=inn_fee,
            side_quest_template_idx=sq_idx,
            region=region,
        )


# -------------------------------------------------------------------------
# Factory Generators
# -------------------------------------------------------------------------

def create_king(
    name: str = "King Aldous",
    pos: Tuple[int, int] = (27, 4),
    bounties: Optional[List[str]] = None,
) -> NPC:
    """Creates a royal King NPC with boss bounty rewards."""
    if bounties:
        bounty_str = ", ".join(bounties)
        dialogue = (
            f"Welcome to my royal hall! Slay the dread monstrosities plaguing our realm for royal rewards: "
            f"{bounty_str}. Bring me their crests to claim your rightful glory!"
        )
    else:
        dialogue = (
            "Welcome to my royal hall! Slay the dread monstrosities plaguing our realm: "
            "Dreadfang, Bone Golem, and the Ancient Wyrm. Bring me their crests for royal rewards!"
        )
    return NPC(
        npc_id="npc_king",
        name=name,
        role=NPCRole.KING,
        glyph="K",
        fg_color=TrueColor(0xFF, 0xD7, 0x00),  # Royal Gold
        bg_color=TrueColor(0x9B, 0x2C, 0x2C),  # Crimson Throne Carpet
        pos=pos,
        dialogue=dialogue,
        bounties=bounties or ["Dreadfang", "Bone Golem", "Ancient Wyrm"],
        category=DialogCategory.STANDARD,
    )


REGION_INN_FEES: Dict[int, int] = {
    1: 20,   # Starter buffer (Region 1)
    2: 40,   # Outskirts (Region 2)
    3: 70,   # Midlands (Region 3)
    4: 110,  # Frontier (Region 4)
    5: 160,  # Wilds (Region 5)
    6: 220,  # Highlands (Region 6)
    7: 300,  # Hazard Wastes (Region 7)
    8: 400,  # Shadow Lands (Region 8)
    9: 500,  # Periphery Citadel (Region 9)
}


def calculate_inn_fee(region_code: int) -> int:
    """Calculates the overnight stay fee in gold based on the region tier (1 to 9)."""
    reg = max(1, min(9, int(region_code)))
    return REGION_INN_FEES.get(reg, 20)


def generate_armorer_inventory(region_tier: int = 1, seed: Optional[int] = None) -> List[Dict[str, Any]]:
    """
    Generates a shop inventory of equipment scaled to the specified region (1 to 9).
    Only equipment is stocked; endgame relics are strictly excluded.
    Lower regions stock Tier 1 items with a smattering of Tier 2 items.
    Higher regions stock Tier 2 and Tier 3 items.
    """
    from ..combat.equipment import EQUIPMENT_CATALOG
    reg = max(1, min(9, int(region_tier)))
    rng = random.Random(seed) if seed is not None else random

    t1_items = [name for name, eq in EQUIPMENT_CATALOG.items() if eq.tier == 1 and not eq.is_relic]
    t2_items = [name for name, eq in EQUIPMENT_CATALOG.items() if eq.tier == 2 and not eq.is_relic]
    t3_items = [name for name, eq in EQUIPMENT_CATALOG.items() if eq.tier == 3 and not eq.is_relic]

    selected_names: List[str] = []

    if reg == 1:
        # All Tier 1 equipment
        selected_names.extend(t1_items)
        # Smattering of 3 Tier 2 items (cost prohibitive early goals)
        starter_smattering = ["Iron Greathelm", "Steel Pauldrons", "Plated Sabatons"]
        if seed is not None:
            chosen_t2 = rng.sample(t2_items, min(3, len(t2_items)))
        else:
            chosen_t2 = [n for n in starter_smattering if n in t2_items]
        selected_names.extend(chosen_t2)
    elif reg in (2, 3):
        # All Tier 1 and all Tier 2
        selected_names.extend(t1_items)
        selected_names.extend(t2_items)
        # Smattering of 2 Tier 3 items
        if seed is not None:
            chosen_t3 = rng.sample(t3_items, min(2, len(t3_items)))
        else:
            chosen_t3 = [n for n in ["Steel Broadsword", "Plate Cuirass"] if n in t3_items]
        selected_names.extend(chosen_t3)
    elif reg in (4, 5, 6):
        # All Tier 2 and all Tier 3
        selected_names.extend(t2_items)
        selected_names.extend(t3_items)
    else:  # reg in (7, 8, 9)
        # Complete commercial catalog (Tier 2 and Tier 3, no relics)
        selected_names.extend(t2_items)
        selected_names.extend(t3_items)

    # Sort items consistently: by slot order then price
    slot_order = [
        "Weapon", "Helmet", "Armor", "Pauldron", "Gauntlets",
        "Greaves", "Boots", "JewelryA", "JewelryB", "Cape"
    ]
    def item_sort_key(name: str):
        eq = EQUIPMENT_CATALOG[name]
        slot_idx = slot_order.index(eq.slot.value) if eq.slot.value in slot_order else 99
        return (slot_idx, eq.price, name)

    unique_names = list(dict.fromkeys(selected_names))
    unique_names.sort(key=item_sort_key)

    inventory: List[Dict[str, Any]] = []
    for name in unique_names:
        eq = EQUIPMENT_CATALOG[name]
        inventory.append({
            "item_id": name,
            "name": name,
            "price": eq.price,
            "sell_price": eq.sell_price,
            "type": "equipment",
            "target_gender": eq.target_gender.value,
            "qty": 99,
        })
    return inventory


def generate_item_shop_inventory(region_tier: int = 1, seed: Optional[int] = None) -> List[Dict[str, Any]]:
    """
    Generates a shop inventory of consumable/remedy items scaled to the specified region (1 to 9).
    Only non-equipment items can be stocked; key items are strictly excluded.
    Lower regions stock Tier 1 items with a smattering of mid-tier items.
    Higher regions stock mid-tier and high-tier items.
    Sell prices are fixed at 20% of base price in all cases.
    """
    from ..combat.items import ITEM_CATALOG, ItemType, ItemEffectType
    reg = max(1, min(9, int(region_tier)))
    rng = random.Random(seed) if seed is not None else random

    # Filter out equipment and key items
    valid_items = {
        name: item for name, item in ITEM_CATALOG.items()
        if item.item_type not in (ItemType.EQUIPMENT, ItemType.KEY_ITEM)
    }

    remedy_items = {
        name: item for name, item in valid_items.items()
        if item.effect_type != ItemEffectType.TEACH_ACTION
    }
    study_items = {
        name: item for name, item in valid_items.items()
        if item.effect_type == ItemEffectType.TEACH_ACTION
    }

    t1_items = [name for name, item in remedy_items.items() if item.tier == 1]
    t2_items = [name for name, item in remedy_items.items() if item.tier == 2]
    t3_items = [name for name, item in remedy_items.items() if item.tier == 3]
    t4_items = [name for name, item in remedy_items.items() if item.tier >= 4]

    selected_names: List[str] = []

    if reg == 1:
        # All Tier 1 staples
        selected_names.extend(t1_items)
        # Smattering of 2 Tier 2 items (cost prohibitive early goals)
        starter_smattering = ["Hi-Potion", "Ether"]
        if seed is not None:
            chosen_t2 = rng.sample(t2_items, min(2, len(t2_items)))
        else:
            chosen_t2 = [n for n in starter_smattering if n in t2_items]
        selected_names.extend(chosen_t2)
        # Early-tier high-cost study manuals (5,000G each)
        for st in ("ST: Axe Cleave", "T: Ice Bolt"):
            if st in study_items:
                selected_names.append(st)
    elif reg in (2, 3):
        # All Tier 1 and all Tier 2
        selected_names.extend(t1_items)
        selected_names.extend(t2_items)
        # Smattering of 2 Tier 3 items
        if seed is not None:
            chosen_t3 = rng.sample(t3_items, min(2, len(t3_items)))
        else:
            chosen_t3 = [n for n in ["Hi-Ether", "Revive Herb"] if n in t3_items]
        selected_names.extend(chosen_t3)
        # Tier 1-2 study manuals & tomes
        for st in (
            "ST: Axe Cleave",
            "ST: Flame Punch",
            "ST: Double Scratch",
            "T: Ice Bolt",
            "T: Fireball",
            "T: Heal",
        ):
            if st in study_items:
                selected_names.append(st)
    elif reg in (4, 5, 6):
        # All Tier 1, 2, and 3 items
        selected_names.extend(t1_items)
        selected_names.extend(t2_items)
        selected_names.extend(t3_items)
        # Smattering of 1 Tier 4 item (Elixir)
        if t4_items:
            selected_names.append("Elixir" if "Elixir" in t4_items else t4_items[0])
        # Intermediate to advanced study manuals & tomes
        for st in (
            "ST: Axe Cleave",
            "ST: Flame Punch",
            "ST: Drop Kick",
            "ST: Double Scratch",
            "ST: Shield Bash",
            "T: Ice Bolt",
            "T: Fireball",
            "T: Tidal Crush",
            "T: Boulder Bash",
            "T: Galeflash",
            "T: Radiance",
            "T: Dark Surge",
            "T: Heal",
        ):
            if st in study_items:
                selected_names.append(st)
    else:  # reg in (7, 8, 9)
        # Full apothecary stock of all commercial tiers
        selected_names.extend(t1_items)
        selected_names.extend(t2_items)
        selected_names.extend(t3_items)
        selected_names.extend(t4_items)
        # Full master-tier study manuals & tomes
        selected_names.extend(list(study_items.keys()))

    # Compass Conch is a staple utility available across all shops
    if "Compass Conch" in valid_items and "Compass Conch" not in selected_names:
        selected_names.append("Compass Conch")

    unique_names = list(dict.fromkeys(selected_names))
    # Sort by tier, price, name
    unique_names.sort(key=lambda n: (valid_items[n].tier, valid_items[n].price, n))

    inventory: List[Dict[str, Any]] = []
    for name in unique_names:
        item = valid_items[name]
        inventory.append({
            "item_id": item.item_id,
            "name": item.name,
            "price": item.price,
            "sell_price": item.sell_price,
            "type": "consumable",
            "tier": item.tier,
            "qty": 99,
        })
    return inventory


def create_service_owner(
    role: NPCRole,
    name: str,
    pos: Tuple[int, int],
    is_endgame: bool = False,
    inn_fee: int = 20,
    region: int = 1,
) -> NPC:
    """Creates a reserved town service owner (Innkeeper, Item Shop, Equip Shop, Pub)."""
    category = DialogCategory.STANDARD
    choice_options = []
    if role == NPCRole.INNKEEPER:
        glyph = "I"
        fg = TrueColor(0xFF, 0xEE, 0xAA)  # Warm Ivory
        bg = TrueColor(0x3B, 0x27, 0x1A)  # Dark Timber
        category = DialogCategory.CHOICE
        dialogue = f"Welcome! It costs {inn_fee} gold to stay for the night. Do you want a room?"
        choice_options = ["Yes", "No"]
        inv = []
    elif role == NPCRole.ITEM_SHOPKEEPER:
        glyph = "S"
        fg = TrueColor(0x63, 0xB3, 0xED)  # Sky Cyan
        bg = TrueColor(0x1A, 0x36, 0x5D)  # Midnight Navy
        category = DialogCategory.CHOICE
        dialogue = "Welcome! Would you like to buy something today?"
        choice_options = ["Yes", "No"]
        if is_endgame:
            inv = generate_item_shop_inventory(region_tier=9)
        else:
            inv = generate_item_shop_inventory(region_tier=region)
    elif role == NPCRole.EQUIP_SHOPKEEPER:
        glyph = "E"
        fg = TrueColor(0xED, 0x89, 0x36)  # Forge Amber
        bg = TrueColor(0x3B, 0x27, 0x1A)  # Dark Forge Brown
        category = DialogCategory.CHOICE
        dialogue = "Welcome to my forge! Care to examine my wares?"
        choice_options = ["Yes", "No"]
        if is_endgame:
            inv = [
                {"item_id": "Excalibur", "name": "Excalibur", "price": 4500, "sell_price": 900, "type": "equipment", "qty": 99},
                {"item_id": "Dragon Shield", "name": "Dragon Shield", "price": 3200, "sell_price": 640, "type": "equipment", "qty": 99},
                {"item_id": "Mythril Plate", "name": "Mythril Plate", "price": 3800, "sell_price": 760, "type": "equipment", "qty": 99},
                {"item_id": "Titan Helm", "name": "Titan Helm", "price": 2400, "sell_price": 480, "type": "equipment", "qty": 99},
                {"item_id": "Aegis Cloak", "name": "Aegis Cloak", "price": 2800, "sell_price": 560, "type": "equipment", "qty": 99},
            ]
        else:
            inv = generate_armorer_inventory(region_tier=region)
    elif role == NPCRole.PUB_BARTENDER:
        glyph = "P"
        fg = TrueColor(0xF6, 0xE0, 0x5E)  # Ale Gold
        bg = TrueColor(0x2D, 0x37, 0x48)  # Slate
        dialogue = "Pull up a stool! Hear any good rumors about the ancient ruins out in the wilds?"
        inv = []
    else:
        glyph = "c"
        fg = TrueColor(255, 255, 255)
        bg = TrueColor(0, 0, 0)
        dialogue = "Greetings."
        inv = []

    return NPC(
        npc_id=f"owner_{role.value.lower()}_{pos[0]}_{pos[1]}",
        name=name,
        role=role,
        glyph=glyph,
        fg_color=fg,
        bg_color=bg,
        pos=pos,
        dialogue=dialogue,
        shop_inventory=inv,
        category=category,
        choice_options=choice_options,
        inn_fee=inn_fee,
        region=region,
    )


def create_castle_npc(
    role: NPCRole,
    name: str,
    pos: Tuple[int, int],
    side_quest_template_idx: Optional[int] = None,
) -> NPC:
    """Creates a castle guard, knight, servant, or advisor."""
    if role in (NPCRole.KNIGHT, NPCRole.ROYAL_GUARD):
        glyph = "G"
        fg = TrueColor(0xE2, 0xE8, 0xF0)  # Silver Steel
        bg = TrueColor(0x1A, 0x20, 0x2C)  # Dark Armor
        dialogue = "The castle stands vigilant against the beasts of the outer regions."
    elif role == NPCRole.COURT_ADVISOR:
        glyph = "A"
        fg = TrueColor(0x9F, 0x7A, 0xEA)  # Mystic Purple
        bg = TrueColor(0x2D, 0x37, 0x48)  # Robe Slate
        dialogue = "The stars whisper of rising turmoil across the distant provinces."
    elif role == NPCRole.SQUIRE:
        glyph = "q"
        fg = TrueColor(0x68, 0xD3, 0x91)  # Soft Green
        bg = TrueColor(0x2D, 0x37, 0x48)
        dialogue = "I am polishing the knight commander's armor for the next patrol!"
    else:  # SERVANT
        glyph = "s"
        fg = TrueColor(0xFC, 0x81, 0x81)  # Rose Linen
        bg = TrueColor(0x2D, 0x37, 0x48)
        dialogue = "Pardon me, I must ensure the royal banqueting hall is impeccably prepared."

    return NPC(
        npc_id=f"castle_npc_{pos[0]}_{pos[1]}",
        name=name,
        role=role,
        glyph=glyph,
        fg_color=fg,
        bg_color=bg,
        pos=pos,
        dialogue=dialogue,
        side_quest_template_idx=side_quest_template_idx,
    )


def create_town_citizen(
    name: str,
    pos: Tuple[int, int],
    seed: int = 0,
    side_quest_template_idx: Optional[int] = None,
) -> NPC:
    """Creates a random town citizen, villager, or traveler with colorful styling and casual banter."""
    rng = random.Random(seed + pos[0] * 31 + pos[1] * 17)

    dialogue_choices = [
        "The harvests have been plentiful this season, thank the heavens!",
        "They say deep within the caves lurk beasts that guard ancient treasures.",
        "Keep your blade sharp and your wits sharper if you venture past the hills.",
        "I heard travelers speaking of strange lights dancing in the western woods.",
        "Nothing beats fresh bread and a warm hearth after a long journey.",
        "Be wary of bandits along the high roads—travel in numbers!",
        "The King's scouts passed through here just yesterday scouting the passes.",
        "If you need provisions, the local shops have the finest gear around.",
    ]
    color_palette = [
        (TrueColor(0x68, 0xD3, 0x91), "v"),  # Soft Green villager
        (TrueColor(0x4F, 0xD1, 0xC5), "c"),  # Teal citizen
        (TrueColor(0xF6, 0xAD, 0x55), "t"),  # Amber traveler
        (TrueColor(0xB7, 0x94, 0xF4), "p"),  # Lavender peasant
        (TrueColor(0xFC, 0x81, 0x81), "c"),  # Coral citizen
    ]

    fg, glyph = rng.choice(color_palette)
    dialogue = rng.choice(dialogue_choices)

    return NPC(
        npc_id=f"citizen_{pos[0]}_{pos[1]}",
        name=name,
        role=NPCRole.CITIZEN,
        glyph=glyph,
        fg_color=fg,
        bg_color=TrueColor(0x1A, 0x20, 0x2C),
        pos=pos,
        dialogue=dialogue,
        side_quest_template_idx=side_quest_template_idx,
    )
