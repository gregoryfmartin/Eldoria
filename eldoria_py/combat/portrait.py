"""
Character Portrait Catalog and Image Protocol Hooks (Sixel / KGP / ANSI).
"""
from __future__ import annotations
from dataclasses import dataclass
from enum import Enum
from typing import List, Optional
from ..terminal.color import TrueColor, ColorLibrary


class Gender(str, Enum):
    """Character gender representation."""
    MALE = "Male"
    FEMALE = "Female"
    UNISEX = "Unisex"


@dataclass
class CharacterPortrait:
    """
    Metadata container for a character portrait.
    Supports future Sixel and Kitty Graphics Protocol (KGP) image streams
    via `sixel_data` and `kgp_asset_path`, while providing clean ANSI/glyph
    fallbacks for standard terminal rendering.
    """
    id: int
    name: str
    gender: Gender
    glyph: str
    accent_color: TrueColor
    description: str = ""
    sixel_data: Optional[bytes] = None
    kgp_asset_path: Optional[str] = None


PORTRAIT_CATALOG_MALE: List[CharacterPortrait] = [
    CharacterPortrait(
        id=0,
        name="Vanguard Warrior",
        gender=Gender.MALE,
        glyph="⚔",
        accent_color=ColorLibrary.AppleRedLight,
        description="A battle-hardened frontline fighter clad in iron plate.",
    ),
    CharacterPortrait(
        id=1,
        name="Sun Paladin",
        gender=Gender.MALE,
        glyph="🛡",
        accent_color=ColorLibrary.AppleYellowLight,
        description="A holy knight wielding divine shields and radiant steel.",
    ),
    CharacterPortrait(
        id=2,
        name="Arcane Scholar",
        gender=Gender.MALE,
        glyph="🔮",
        accent_color=ColorLibrary.AppleIndigoLight,
        description="A studious mystic versed in devastating elemental incantations.",
    ),
    CharacterPortrait(
        id=3,
        name="Shadow Infiltrator",
        gender=Gender.MALE,
        glyph="🗡",
        accent_color=ColorLibrary.ApplePurpleLight,
        description="A nimble scout who strikes from concealed darkness.",
    ),
    CharacterPortrait(
        id=4,
        name="Wilds Ranger",
        gender=Gender.MALE,
        glyph="🏹",
        accent_color=ColorLibrary.AppleGreenLight,
        description="A master marksman with peerless bowmanship and keen eyes.",
    ),
    CharacterPortrait(
        id=5,
        name="Earth Brawler",
        gender=Gender.MALE,
        glyph="🪓",
        accent_color=ColorLibrary.AppleOrangeLight,
        description="A powerhouse pugilist channeling seismic tremors.",
    ),
]

PORTRAIT_CATALOG_FEMALE: List[CharacterPortrait] = [
    CharacterPortrait(
        id=0,
        name="Flame Spellblade",
        gender=Gender.FEMALE,
        glyph="⚔",
        accent_color=ColorLibrary.AppleRedLight,
        description="A swift duelist imbuing twin rapiers with fiery fury.",
    ),
    CharacterPortrait(
        id=1,
        name="Light Priestess",
        gender=Gender.FEMALE,
        glyph="⚕",
        accent_color=ColorLibrary.AppleMintLight,
        description="A compassionate cleric wielding blessed restoration prayers.",
    ),
    CharacterPortrait(
        id=2,
        name="Frost Sorceress",
        gender=Gender.FEMALE,
        glyph="❄",
        accent_color=ColorLibrary.AppleTealLight,
        description="A regal conjurer commanding blizzards and glacial spears.",
    ),
    CharacterPortrait(
        id=3,
        name="Night Assassin",
        gender=Gender.FEMALE,
        glyph="🗡",
        accent_color=ColorLibrary.ApplePinkLight,
        description="A lethal shadowblade versed in poisons and silent strikes.",
    ),
    CharacterPortrait(
        id=4,
        name="Wind Huntress",
        gender=Gender.FEMALE,
        glyph="🏹",
        accent_color=ColorLibrary.AppleGreenLight,
        description="A sharp tracker attuned to the whispers of ancient groves.",
    ),
    CharacterPortrait(
        id=5,
        name="Thunder Valkyrie",
        gender=Gender.FEMALE,
        glyph="⚡",
        accent_color=ColorLibrary.AppleYellowLight,
        description="An armored winged defender descending with storming lances.",
    ),
]


def get_portraits_for_gender(gender: Gender) -> List[CharacterPortrait]:
    """Returns the portrait catalog matching the specified gender."""
    if gender == Gender.FEMALE:
        return PORTRAIT_CATALOG_FEMALE
    return PORTRAIT_CATALOG_MALE
