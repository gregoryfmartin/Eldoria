"""Consumable items catalog, item types, and out-of-combat/field use mechanics."""
from __future__ import annotations
from dataclasses import dataclass, field
from enum import Enum
from typing import Optional, TYPE_CHECKING

from eldoria_py.combat.stats import TargetScope

if TYPE_CHECKING:
    from eldoria_py.combat.entities import PartyMember, Party


class ItemType(str, Enum):
    CONSUMABLE = "CONSUMABLE"
    EQUIPMENT = "EQUIPMENT"
    KEY_ITEM = "KEY_ITEM"


class ItemEffectType(str, Enum):
    RESTORE_HP = "RESTORE_HP"
    RESTORE_MP = "RESTORE_MP"
    RESTORE_ALL_HP = "RESTORE_ALL_HP"
    RESTORE_ALL_MP = "RESTORE_ALL_MP"
    REVIVE = "REVIVE"
    CURE_STATUS = "CURE_STATUS"
    BUFF = "BUFF"


@dataclass
class ConsumableItem:
    """Consumable item definition with power, effect mechanics, and usage scopes."""
    item_id: str
    name: str
    item_type: ItemType = ItemType.CONSUMABLE
    effect_type: ItemEffectType = ItemEffectType.RESTORE_HP
    power: int = 50
    target_scope: TargetScope = TargetScope.SINGLE_ALLY
    description: str = ""
    usable_in_field: bool = True
    usable_in_battle: bool = True
    price: int = 25

    def to_dict(self) -> dict:
        return {
            "item_id": self.item_id,
            "name": self.name,
            "item_type": self.item_type.value,
            "effect_type": self.effect_type.value,
            "power": self.power,
            "target_scope": self.target_scope.value,
            "description": self.description,
            "usable_in_field": self.usable_in_field,
            "usable_in_battle": self.usable_in_battle,
            "price": self.price,
        }

    @classmethod
    def from_dict(cls, data: dict) -> ConsumableItem:
        return cls(
            item_id=data["item_id"],
            name=data["name"],
            item_type=ItemType(data.get("item_type", ItemType.CONSUMABLE.value)),
            effect_type=ItemEffectType(data.get("effect_type", ItemEffectType.RESTORE_HP.value)),
            power=data.get("power", 50),
            target_scope=TargetScope(data.get("target_scope", TargetScope.SINGLE_ALLY.value)),
            description=data.get("description", ""),
            usable_in_field=data.get("usable_in_field", True),
            usable_in_battle=data.get("usable_in_battle", True),
            price=data.get("price", 25),
        )


ITEM_CATALOG: dict[str, ConsumableItem] = {
    "Potion": ConsumableItem(
        item_id="Potion",
        name="Potion",
        item_type=ItemType.CONSUMABLE,
        effect_type=ItemEffectType.RESTORE_HP,
        power=50,
        target_scope=TargetScope.SINGLE_ALLY,
        description="A soothing herbal brew that restores 50 HP to one ally.",
        usable_in_field=True,
        usable_in_battle=True,
        price=20,
    ),
    "Hi-Potion": ConsumableItem(
        item_id="Hi-Potion",
        name="Hi-Potion",
        item_type=ItemType.CONSUMABLE,
        effect_type=ItemEffectType.RESTORE_HP,
        power=150,
        target_scope=TargetScope.SINGLE_ALLY,
        description="A concentrated draught that restores 150 HP to one ally.",
        usable_in_field=True,
        usable_in_battle=True,
        price=60,
    ),
    "Ether": ConsumableItem(
        item_id="Ether",
        name="Ether",
        item_type=ItemType.CONSUMABLE,
        effect_type=ItemEffectType.RESTORE_MP,
        power=40,
        target_scope=TargetScope.SINGLE_ALLY,
        description="A crystalline tonic that restores 40 MP to one ally.",
        usable_in_field=True,
        usable_in_battle=True,
        price=45,
    ),
    "Hi-Ether": ConsumableItem(
        item_id="Hi-Ether",
        name="Hi-Ether",
        item_type=ItemType.CONSUMABLE,
        effect_type=ItemEffectType.RESTORE_MP,
        power=100,
        target_scope=TargetScope.SINGLE_ALLY,
        description="Pure distilled mana that restores 100 MP to one ally.",
        usable_in_field=True,
        usable_in_battle=True,
        price=120,
    ),
    "Elixir": ConsumableItem(
        item_id="Elixir",
        name="Elixir",
        item_type=ItemType.CONSUMABLE,
        effect_type=ItemEffectType.RESTORE_ALL_HP,
        power=9999,
        target_scope=TargetScope.SINGLE_ALLY,
        description="Legendary miraculous elixir that completely restores HP and MP.",
        usable_in_field=True,
        usable_in_battle=True,
        price=500,
    ),
    "Revive Herb": ConsumableItem(
        item_id="Revive Herb",
        name="Revive Herb",
        item_type=ItemType.CONSUMABLE,
        effect_type=ItemEffectType.REVIVE,
        power=100,
        target_scope=TargetScope.SINGLE_ALLY,
        description="A fragrant golden sprig that revives a fallen ally with 100 HP.",
        usable_in_field=True,
        usable_in_battle=True,
        price=100,
    ),
    "Antidote": ConsumableItem(
        item_id="Antidote",
        name="Antidote",
        item_type=ItemType.CONSUMABLE,
        effect_type=ItemEffectType.CURE_STATUS,
        power=0,
        target_scope=TargetScope.SINGLE_ALLY,
        description="Neutralizes poisons and toxins from one ally.",
        usable_in_field=True,
        usable_in_battle=True,
        price=15,
    ),
    "Tent": ConsumableItem(
        item_id="Tent",
        name="Tent",
        item_type=ItemType.CONSUMABLE,
        effect_type=ItemEffectType.RESTORE_ALL_HP,
        power=9999,
        target_scope=TargetScope.ALL_ALLIES,
        description="A sturdy field shelter that fully restores HP and MP for the whole party.",
        usable_in_field=True,
        usable_in_battle=False,
        price=250,
    ),
}

# Compatibility aliases
ITEM_ALIASES: dict[str, str] = {
    "health_potion": "Potion",
    "potion": "Potion",
    "hi_potion": "Hi-Potion",
    "ether": "Ether",
    "hi_ether": "Hi-Ether",
    "elixir": "Elixir",
    "revive_herb": "Revive Herb",
    "antidote": "Antidote",
    "tent": "Tent",
}


def get_item(item_id: str) -> Optional[ConsumableItem]:
    """Retrieves a consumable item from catalog with alias support."""
    if item_id in ITEM_CATALOG:
        return ITEM_CATALOG[item_id]
    alias = ITEM_ALIASES.get(item_id.lower())
    if alias and alias in ITEM_CATALOG:
        return ITEM_CATALOG[alias]
    return None


def apply_item_effect(
    item: ConsumableItem,
    target: Optional[PartyMember],
    party: Party,
) -> tuple[bool, str]:
    """
    Applies a consumable item's effect to a target member or whole party.
    Returns (success: bool, feedback_message: str).
    """
    if not item.usable_in_field:
        return False, f"{item.name} cannot be used outside of battle!"

    if item.target_scope == TargetScope.ALL_ALLIES:
        # Applies to whole party
        if item.effect_type in (ItemEffectType.RESTORE_ALL_HP, ItemEffectType.RESTORE_HP):
            all_full = all(m.current_hp >= m.max_hp for m in party.members if m.is_alive)
            if all_full:
                return False, "Party is already at full health!"
            for m in party.members:
                if m.is_alive:
                    m.current_hp = min(m.max_hp, m.current_hp + item.power)
                    m.current_mp = min(m.max_mp, m.current_mp + item.power)
            party.remove_item(item.item_id, 1)
            return True, f"Used {item.name}! Party HP and MP restored."
        return False, "Unsupported party effect."

    # Single-target consumable
    if target is None:
        return False, "No target selected!"

    if item.effect_type == ItemEffectType.REVIVE:
        if target.is_alive:
            return False, f"{target.name} is already alive!"
        target.current_hp = min(target.max_hp, item.power)
        party.remove_item(item.item_id, 1)
        return True, f"{target.name} was revived with {target.current_hp} HP!"

    # Other items require target to be alive
    if not target.is_alive:
        return False, f"{target.name} has fallen and cannot receive items!"

    if item.effect_type == ItemEffectType.RESTORE_HP:
        if target.current_hp >= target.max_hp:
            return False, f"{target.name} is already at full HP!"
        old_hp = target.current_hp
        target.current_hp = min(target.max_hp, target.current_hp + item.power)
        delta = target.current_hp - old_hp
        party.remove_item(item.item_id, 1)
        return True, f"{target.name} recovered {delta} HP!"

    elif item.effect_type == ItemEffectType.RESTORE_MP:
        if target.current_mp >= target.max_mp:
            return False, f"{target.name} is already at full MP!"
        old_mp = target.current_mp
        target.current_mp = min(target.max_mp, target.current_mp + item.power)
        delta = target.current_mp - old_mp
        party.remove_item(item.item_id, 1)
        return True, f"{target.name} restored {delta} MP!"

    elif item.effect_type == ItemEffectType.RESTORE_ALL_HP:
        # Elixir
        if target.current_hp >= target.max_hp and target.current_mp >= target.max_mp:
            return False, f"{target.name} is already at full vitals!"
        target.current_hp = target.max_hp
        target.current_mp = target.max_mp
        party.remove_item(item.item_id, 1)
        return True, f"{target.name} was fully restored by {item.name}!"

    elif item.effect_type == ItemEffectType.CURE_STATUS:
        party.remove_item(item.item_id, 1)
        return True, f"{target.name} was cured of all ailments!"

    return False, f"Cannot use {item.name} right now."
