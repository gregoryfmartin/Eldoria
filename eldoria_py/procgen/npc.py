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

    def to_dict(self) -> Dict[str, Any]:
        """Serializes NPC to JSON dictionary."""
        d: Dict[str, Any] = {
            "npc_id": self.npc_id,
            "name": self.name,
            "role": self.role.value,
            "glyph": self.glyph,
            "fg_color": [self.fg_color.r, self.fg_color.g, self.fg_color.b],
            "bg_color": [self.bg_color.r, self.bg_color.g, self.bg_color.b],
            "pos": list(self.pos),
            "dialogue": self.dialogue,
        }
        if self.bounties:
            d["bounties"] = self.bounties
        if self.shop_inventory:
            d["shop_inventory"] = self.shop_inventory
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
    return NPC(
        npc_id="npc_king",
        name=name,
        role=NPCRole.KING,
        glyph="K",
        fg_color=TrueColor(0xFF, 0xD7, 0x00),  # Royal Gold
        bg_color=TrueColor(0x9B, 0x2C, 0x2C),  # Crimson Throne Carpet
        pos=pos,
        dialogue="Welcome to my royal hall! Slay the dread monstrosities plaguing our realm for royal rewards.",
        bounties=bounties or [],
    )


def create_service_owner(
    role: NPCRole,
    name: str,
    pos: Tuple[int, int],
    is_endgame: bool = False,
) -> NPC:
    """Creates a reserved town service owner (Innkeeper, Item Shop, Equip Shop, Pub)."""
    if role == NPCRole.INNKEEPER:
        glyph = "I"
        fg = TrueColor(0xFF, 0xEE, 0xAA)  # Warm Ivory
        bg = TrueColor(0x3B, 0x27, 0x1A)  # Dark Timber
        dialogue = "Welcome to the Inn! Rest your weary bones and save your progress."
        inv = []
    elif role == NPCRole.ITEM_SHOPKEEPER:
        glyph = "S"
        fg = TrueColor(0x63, 0xB3, 0xED)  # Sky Cyan
        bg = TrueColor(0x1A, 0x36, 0x5D)  # Midnight Navy
        if is_endgame:
            dialogue = "Welcome to the Grand Empyrean Emporium! We stock rare and forbidden draughts."
            inv = [
                {"item_id": "Elixir", "price": 1200, "qty": 99},
                {"item_id": "Mega Potion", "price": 450, "qty": 99},
                {"item_id": "High Ether", "price": 600, "qty": 99},
                {"item_id": "Revive Herb", "price": 500, "qty": 99},
                {"item_id": "Panacea", "price": 300, "qty": 99},
            ]
        else:
            dialogue = "Supplies and restorative tonics for the road!"
            inv = [
                {"item_id": "Potion", "price": 50, "qty": 99},
                {"item_id": "Ether", "price": 150, "qty": 99},
                {"item_id": "Antidote", "price": 30, "qty": 99},
                {"item_id": "Revive Herb", "price": 250, "qty": 99},
            ]
    elif role == NPCRole.EQUIP_SHOPKEEPER:
        glyph = "E"
        fg = TrueColor(0xED, 0x89, 0x36)  # Forge Amber
        bg = TrueColor(0x3B, 0x27, 0x1A)  # Dark Forge Brown
        if is_endgame:
            dialogue = "Behold legendary arms forged in dragon fire! Top-tier steel for champion hands."
            inv = [
                {"item_id": "Excalibur", "price": 4500, "type": "equipment"},
                {"item_id": "Dragon Shield", "price": 3200, "type": "equipment"},
                {"item_id": "Mythril Plate", "price": 3800, "type": "equipment"},
                {"item_id": "Titan Helm", "price": 2400, "type": "equipment"},
                {"item_id": "Aegis Cloak", "price": 2800, "type": "equipment"},
            ]
        else:
            dialogue = "Fine blades and sturdy armor to turn aside monster claws!"
            inv = [
                {"item_id": "Iron Longsword", "price": 250, "type": "equipment"},
                {"item_id": "Steel Broadsword", "price": 600, "type": "equipment"},
                {"item_id": "Bronze Armor", "price": 350, "type": "equipment"},
                {"item_id": "Iron Buckler", "price": 200, "type": "equipment"},
            ]
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
    )


def create_castle_npc(
    role: NPCRole,
    name: str,
    pos: Tuple[int, int],
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
    )


def create_town_citizen(
    name: str,
    pos: Tuple[int, int],
    seed: int = 0,
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
    )
