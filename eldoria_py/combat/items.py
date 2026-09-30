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
    DAMAGE_PHYSICAL = "DAMAGE_PHYSICAL"
    DAMAGE_MAGICAL = "DAMAGE_MAGICAL"
    STATUS_EFFECT = "STATUS_EFFECT"


@dataclass
class ConsumableItem:
    """Consumable or key item definition with power, effect mechanics, and usage scopes."""
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
    can_discard: bool = True
    consumed_on_use: bool = True

    def __post_init__(self) -> None:
        if self.item_type == ItemType.KEY_ITEM:
            self.can_discard = False
            self.consumed_on_use = False

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
            "can_discard": self.can_discard,
            "consumed_on_use": self.consumed_on_use,
        }

    def to_battle_action(self) -> BattleAction:
        """Converts this consumable into an executable BattleAction for combat."""
        from eldoria_py.combat.actions import BattleAction, ActionCategory
        from eldoria_py.combat.stats import BattleActionType
        if self.effect_type in (ItemEffectType.RESTORE_HP, ItemEffectType.RESTORE_ALL_HP, ItemEffectType.REVIVE):
            action_type = BattleActionType.MAGIC_HEALING
        elif self.effect_type == ItemEffectType.RESTORE_MP:
            action_type = BattleActionType.NONE
        elif self.effect_type == ItemEffectType.DAMAGE_MAGICAL:
            name_lower = self.name.lower()
            if "ice" in name_lower:
                action_type = BattleActionType.ELEMENTAL_ICE
            elif "water" in name_lower:
                action_type = BattleActionType.ELEMENTAL_WATER
            elif "earth" in name_lower:
                action_type = BattleActionType.ELEMENTAL_EARTH
            elif "wind" in name_lower:
                action_type = BattleActionType.ELEMENTAL_WIND
            elif "light" in name_lower:
                action_type = BattleActionType.ELEMENTAL_LIGHT
            elif "dark" in name_lower:
                action_type = BattleActionType.ELEMENTAL_DARK
            else:
                action_type = BattleActionType.ELEMENTAL_FIRE
        elif self.effect_type == ItemEffectType.STATUS_EFFECT:
            if "sleep" in self.name.lower():
                action_type = BattleActionType.MAGIC_SLEEP
            else:
                action_type = BattleActionType.MAGIC_POISON
        else:
            action_type = BattleActionType.PHYSICAL

        return BattleAction(
            name=self.name,
            action_type=action_type,
            category=ActionCategory.ITEM,
            mp_cost=0,
            effect_value=self.power,
            accuracy=1.0,
            target_scope=self.target_scope,
            speed_priority=1.2,
            description=self.description,
        )

    @classmethod
    def from_dict(cls, data: dict) -> ConsumableItem:
        item_type = ItemType(data.get("item_type", ItemType.CONSUMABLE.value))
        default_can_discard = False if item_type == ItemType.KEY_ITEM else True
        default_consumed = False if item_type == ItemType.KEY_ITEM else True
        return cls(
            item_id=data["item_id"],
            name=data["name"],
            item_type=item_type,
            effect_type=ItemEffectType(data.get("effect_type", ItemEffectType.RESTORE_HP.value)),
            power=data.get("power", 50),
            target_scope=TargetScope(data.get("target_scope", TargetScope.SINGLE_ALLY.value)),
            description=data.get("description", ""),
            usable_in_field=data.get("usable_in_field", True),
            usable_in_battle=data.get("usable_in_battle", True),
            price=data.get("price", 25),
            can_discard=data.get("can_discard", default_can_discard),
            consumed_on_use=data.get("consumed_on_use", default_consumed),
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
    # Offensive Combat Items
    "Bomb": ConsumableItem(
        item_id="Bomb",
        name="Bomb",
        item_type=ItemType.CONSUMABLE,
        effect_type=ItemEffectType.DAMAGE_PHYSICAL,
        power=60,
        target_scope=TargetScope.SINGLE_ENEMY,
        description="An alchemical explosive dealing 60 physical damage to one enemy.",
        usable_in_field=False,
        usable_in_battle=True,
        price=50,
    ),
    "Fire Flask": ConsumableItem(
        item_id="Fire Flask",
        name="Fire Flask",
        item_type=ItemType.CONSUMABLE,
        effect_type=ItemEffectType.DAMAGE_MAGICAL,
        power=45,
        target_scope=TargetScope.ALL_ENEMIES,
        description="A volatile flask bursting into flames that damages all enemies.",
        usable_in_field=False,
        usable_in_battle=True,
        price=80,
    ),
    "Sleep Powder": ConsumableItem(
        item_id="Sleep Powder",
        name="Sleep Powder",
        item_type=ItemType.CONSUMABLE,
        effect_type=ItemEffectType.STATUS_EFFECT,
        power=0,
        target_scope=TargetScope.SINGLE_ENEMY,
        description="Enchanted spores that lull an enemy into a deep sleep.",
        usable_in_field=False,
        usable_in_battle=True,
        price=35,
    ),
    "Poison Bottle": ConsumableItem(
        item_id="Poison Bottle",
        name="Poison Bottle",
        item_type=ItemType.CONSUMABLE,
        effect_type=ItemEffectType.STATUS_EFFECT,
        power=35,
        target_scope=TargetScope.SINGLE_ENEMY,
        description="A toxic vial that deals 35 poison damage and inflicts venom on one enemy.",
        usable_in_field=False,
        usable_in_battle=True,
        price=40,
        can_discard=True,
        consumed_on_use=True,
    ),
    # Key & Progression Items (Permanent, non-discardable, not consumed on use)
    "Iron Key": ConsumableItem(
        item_id="Iron Key",
        name="Iron Key",
        item_type=ItemType.KEY_ITEM,
        effect_type=ItemEffectType.BUFF,
        power=0,
        target_scope=TargetScope.NONE,
        description="An ornate iron skeleton key that unlocks iron doors and heavy dungeon chests.",
        usable_in_field=False,
        usable_in_battle=False,
        price=0,
        can_discard=False,
        consumed_on_use=False,
    ),
    "Door Key": ConsumableItem(
        item_id="Door Key",
        name="Door Key",
        item_type=ItemType.KEY_ITEM,
        effect_type=ItemEffectType.BUFF,
        power=0,
        target_scope=TargetScope.NONE,
        description="A sturdy iron key that unlocks standard dungeon doors and barred gates.",
        usable_in_field=False,
        usable_in_battle=False,
        price=0,
        can_discard=False,
        consumed_on_use=False,
    ),
    "Chest Key": ConsumableItem(
        item_id="Chest Key",
        name="Chest Key",
        item_type=ItemType.KEY_ITEM,
        effect_type=ItemEffectType.BUFF,
        power=0,
        target_scope=TargetScope.NONE,
        description="A small brass skeleton key crafted to open locked treasure chests.",
        usable_in_field=False,
        usable_in_battle=False,
        price=0,
        can_discard=False,
        consumed_on_use=False,
    ),
    "Golden Key": ConsumableItem(
        item_id="Golden Key",
        name="Golden Key",
        item_type=ItemType.KEY_ITEM,
        effect_type=ItemEffectType.BUFF,
        power=0,
        target_scope=TargetScope.NONE,
        description="An intricately carved golden key radiant with ancient royal wards.",
        usable_in_field=False,
        usable_in_battle=False,
        price=0,
        can_discard=False,
        consumed_on_use=False,
    ),
    "Ancient Crest": ConsumableItem(
        item_id="Ancient Crest",
        name="Ancient Crest",
        item_type=ItemType.KEY_ITEM,
        effect_type=ItemEffectType.BUFF,
        power=0,
        target_scope=TargetScope.NONE,
        description="An ancient royal insignia required to unseal sanctum portals.",
        usable_in_field=False,
        usable_in_battle=False,
        price=0,
        can_discard=False,
        consumed_on_use=False,
    ),
    "Cavern Key": ConsumableItem(
        item_id="Cavern Key",
        name="Cavern Key",
        item_type=ItemType.KEY_ITEM,
        effect_type=ItemEffectType.BUFF,
        power=0,
        target_scope=TargetScope.NONE,
        description="An amber-tinted key that unlocks sealed subterranean gates.",
        usable_in_field=False,
        usable_in_battle=False,
        price=0,
        can_discard=False,
        consumed_on_use=False,
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
    "bomb": "Bomb",
    "fire_flask": "Fire Flask",
    "fireflask": "Fire Flask",
    "sleep_powder": "Sleep Powder",
    "poison_bottle": "Poison Bottle",
    "poisonbottle": "Poison Bottle",
    "poison": "Poison Bottle",
    "iron_key": "Iron Key",
    "door_key": "Door Key",
    "doorkey": "Door Key",
    "chest_key": "Chest Key",
    "chestkey": "Chest Key",
    "golden_key": "Golden Key",
    "goldenkey": "Golden Key",
    "gold_key": "Golden Key",
    "ancient_crest": "Ancient Crest",
    "cavern_key": "Cavern Key",
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
            if item.consumed_on_use:
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
        if item.consumed_on_use:
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
        if item.consumed_on_use:
            party.remove_item(item.item_id, 1)
        return True, f"{target.name} recovered {delta} HP!"

    elif item.effect_type == ItemEffectType.RESTORE_MP:
        if target.current_mp >= target.max_mp:
            return False, f"{target.name} is already at full MP!"
        old_mp = target.current_mp
        target.current_mp = min(target.max_mp, target.current_mp + item.power)
        delta = target.current_mp - old_mp
        if item.consumed_on_use:
            party.remove_item(item.item_id, 1)
        return True, f"{target.name} restored {delta} MP!"

    elif item.effect_type == ItemEffectType.RESTORE_ALL_HP:
        # Elixir
        if target.current_hp >= target.max_hp and target.current_mp >= target.max_mp:
            return False, f"{target.name} is already at full vitals!"
        target.current_hp = target.max_hp
        target.current_mp = target.max_mp
        if item.consumed_on_use:
            party.remove_item(item.item_id, 1)
        return True, f"{target.name} was fully restored by {item.name}!"

    elif item.effect_type == ItemEffectType.CURE_STATUS:
        if item.consumed_on_use:
            party.remove_item(item.item_id, 1)
        return True, f"{target.name} was cured of all ailments!"

    return False, f"Cannot use {item.name} right now."


def is_key_item(item_id: str) -> bool:
    """Checks if an item is categorized as a key item."""
    item = get_item(item_id)
    return item is not None and item.item_type == ItemType.KEY_ITEM


def can_discard_item(item_id: str) -> bool:
    """Returns True if an item can be discarded (Key items cannot be discarded)."""
    item = get_item(item_id)
    if item is not None:
        return item.can_discard
    # If not in catalog, check if marked as key item in name
    return "key" not in item_id.lower() and "crest" not in item_id.lower()
