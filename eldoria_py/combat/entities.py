"""Combatant entities, party structure, enemy squads, and factory presets."""
from __future__ import annotations
import random
from typing import Optional
from eldoria_py.combat.stats import (
    StatId,
    BattleActionType,
    EquipmentSlot,
    TargetScope,
    BattleEntityProperty,
)
from eldoria_py.combat.actions import BattleAction, ACTIONS
from eldoria_py.combat.equipment import BattleEquipment, EQUIPMENT_CATALOG
from eldoria_py.combat.portrait import Gender


class Combatant:
    """Base class for any entity participating in combat."""

    def __init__(
        self,
        name: str,
        affinity: BattleActionType = BattleActionType.NONE,
        stats: Optional[dict[StatId, int]] = None,
        actions: Optional[list[BattleAction]] = None,
    ):
        self.name: str = name
        self.affinity: BattleActionType = affinity
        self.explicit_absorbs: set[BattleActionType] = set()
        self.explicit_immunes: set[BattleActionType] = set()
        self.is_defending: bool = False

        # Initialize stats
        self.stats: dict[StatId, BattleEntityProperty] = {}
        defaults: dict[StatId, int] = {
            StatId.HIT_POINTS: 100,
            StatId.MAGIC_POINTS: 50,
            StatId.ATTACK: 15,
            StatId.DEFENSE: 10,
            StatId.MAGIC_ATTACK: 10,
            StatId.MAGIC_DEFENSE: 10,
            StatId.SPEED: 10,
            StatId.LUCK: 10,
            StatId.ACCURACY: 80,
        }
        if stats:
            defaults.update(stats)

        for stat_id, val in defaults.items():
            self.stats[stat_id] = BattleEntityProperty(base=val)

        # Actions
        self.actions: list[BattleAction] = actions if actions is not None else [ACTIONS["Attack"].copy()]

    @property
    def is_alive(self) -> bool:
        return self.hp > 0

    @property
    def hp(self) -> int:
        return self.stats[StatId.HIT_POINTS].current

    @hp.setter
    def hp(self, val: int) -> None:
        self.stats[StatId.HIT_POINTS].current = val

    @property
    def max_hp(self) -> int:
        return self.stats[StatId.HIT_POINTS].total

    @property
    def mp(self) -> int:
        return self.stats[StatId.MAGIC_POINTS].current

    @mp.setter
    def mp(self, val: int) -> None:
        self.stats[StatId.MAGIC_POINTS].current = val

    @property
    def max_mp(self) -> int:
        return self.stats[StatId.MAGIC_POINTS].total

    @property
    def current_hp(self) -> int:
        return self.hp

    @current_hp.setter
    def current_hp(self, val: int) -> None:
        self.hp = val

    @property
    def current_mp(self) -> int:
        return self.mp

    @current_mp.setter
    def current_mp(self, val: int) -> None:
        self.mp = val

    def get_stat(self, stat_id: StatId) -> int:
        prop = self.stats.get(stat_id)
        return prop.total if prop else 0

    def get_all_stat_totals(self) -> dict[StatId, int]:
        return {s: self.get_stat(s) for s in StatId}

    def take_damage(self, amount: int) -> int:
        """Apply damage reduction if defending, decrement HP, return actual delta."""
        if not self.is_alive or amount <= 0:
            return 0
        final_amt = int(max(1, amount // 2)) if self.is_defending else amount
        return abs(self.stats[StatId.HIT_POINTS].modify_current(-final_amt))

    def heal(self, amount: int) -> int:
        """Restores HP bounded by max_hp, returning actual healed amount."""
        if not self.is_alive or amount <= 0:
            return 0
        return self.stats[StatId.HIT_POINTS].modify_current(amount)

    def spend_mp(self, cost: int) -> bool:
        """Attempts to spend MP; returns True on success, False if insufficient."""
        if cost <= 0:
            return True
        if self.mp >= cost:
            self.stats[StatId.MAGIC_POINTS].modify_current(-cost)
            return True
        return False

    def update_turn(self) -> None:
        """Turn-end tick for defending state and augment durations."""
        self.is_defending = False
        for prop in self.stats.values():
            prop.update()


class PartyMember(Combatant):
    """Player-controlled character equipped with 10 gear slots and distinct class skills."""

    def __init__(
        self,
        name: str,
        job_class: str,
        level: int = 1,
        affinity: BattleActionType = BattleActionType.PHYSICAL,
        base_stats: Optional[dict[StatId, int]] = None,
        actions: Optional[list[BattleAction]] = None,
        gender: Gender = Gender.MALE,
        profile_image_index: int = 0,
    ):
        super().__init__(name=name, affinity=affinity, stats=base_stats, actions=actions)
        self.job_class: str = job_class
        self.level: int = level
        self.gender: Gender = gender
        self.profile_image_index: int = profile_image_index
        self.equipment: dict[EquipmentSlot, Optional[BattleEquipment]] = {slot: None for slot in EquipmentSlot}
        self.base_actions: list[BattleAction] = list(self.actions)

    def equip(self, item: BattleEquipment) -> Optional[BattleEquipment]:
        """Equip an item into its designated slot and recalculate stat bonuses."""
        old = self.equipment[item.slot]
        self.equipment[item.slot] = item
        self.recalculate_equipment()
        return old

    def unequip(self, slot: EquipmentSlot) -> Optional[BattleEquipment]:
        """Unequip item from slot and recalculate."""
        old = self.equipment[slot]
        self.equipment[slot] = None
        self.recalculate_equipment()
        return old

    def recalculate_equipment(self) -> None:
        """Recalculates stat bonuses from all 10 slots and updates unlocked skills."""
        # Reset bonuses
        for prop in self.stats.values():
            prop.equipment_bonus = 0

        # Sum bonuses from all equipped items
        unlocked_skills: list[BattleAction] = []
        for eq in self.equipment.values():
            if eq is None:
                continue
            for stat_id, bonus in eq.stat_bonuses.items():
                if stat_id in self.stats:
                    self.stats[stat_id].equipment_bonus += bonus
            if eq.unlocked_action_name and eq.unlocked_action_name in ACTIONS:
                unlocked_skills.append(ACTIONS[eq.unlocked_action_name].copy())

        # Combine base actions and unlocked skills (avoiding duplicates)
        combined = list(self.base_actions)
        names = {a.name for a in combined}
        for act in unlocked_skills:
            if act.name not in names:
                combined.append(act)
                names.add(act.name)
        self.actions = combined

    def to_dict(self) -> dict:
        return {
            "name": self.name,
            "job_class": self.job_class,
            "level": self.level,
            "gender": self.gender.value,
            "profile_image_index": self.profile_image_index,
            "affinity": self.affinity.value,
            "stats": {stat_id.value: prop.to_dict() for stat_id, prop in self.stats.items()},
            "equipment": {
                slot.value: (eq.to_dict() if eq else None)
                for slot, eq in self.equipment.items()
            },
            "base_actions": [a.to_dict() for a in self.base_actions],
        }

    @classmethod
    def from_dict(cls, data: dict) -> PartyMember:
        gender_val = data.get("gender", "Male")
        try:
            gender = Gender(gender_val)
        except ValueError:
            gender = Gender.MALE

        affinity_val = data.get("affinity", "Physical")
        try:
            affinity = BattleActionType(affinity_val)
        except ValueError:
            affinity = BattleActionType.PHYSICAL

        raw_stats = data.get("stats", {})
        base_stats = {}
        current_stats = {}
        for s_key, s_data in raw_stats.items():
            try:
                sid = StatId(s_key)
            except ValueError:
                continue
            if isinstance(s_data, dict):
                base_stats[sid] = s_data.get("base", 0)
                current_stats[sid] = s_data.get("current")
            elif isinstance(s_data, int):
                base_stats[sid] = s_data

        raw_actions = data.get("base_actions", data.get("actions", []))
        actions = []
        for a_data in raw_actions:
            if isinstance(a_data, str) and a_data in ACTIONS:
                actions.append(ACTIONS[a_data].copy())
            elif isinstance(a_data, dict):
                actions.append(BattleAction.from_dict(a_data))

        member = cls(
            name=data.get("name", "Unknown"),
            job_class=data.get("job_class", "Adventurer"),
            level=data.get("level", 1),
            affinity=affinity,
            base_stats=base_stats,
            actions=actions,
            gender=gender,
            profile_image_index=data.get("profile_image_index", 0),
        )

        # Restore current HP/MP if provided
        for sid, cur_val in current_stats.items():
            if cur_val is not None and sid in member.stats:
                member.stats[sid].current = cur_val

        # Restore equipment
        raw_eq = data.get("equipment", {})
        for slot_key, eq_data in raw_eq.items():
            if eq_data is None:
                continue
            try:
                eq_item = BattleEquipment.from_dict(eq_data)
                member.equip(eq_item)
            except Exception:
                pass

        return member


class EnemyCombatant(Combatant):
    """Enemy squad member with tactical AI behavior, family tag, and loot tables."""

    def __init__(
        self,
        name: str,
        family: str = "Beast",
        level: int = 1,
        threat_rank: str = "D",
        affinity: BattleActionType = BattleActionType.NONE,
        stats: Optional[dict[StatId, int]] = None,
        actions: Optional[list[BattleAction]] = None,
        action_marble_bag: Optional[list[BattleAction]] = None,
        xp_reward: int = 25,
        gold_reward: int = 15,
    ):
        super().__init__(name=name, affinity=affinity, stats=stats, actions=actions)
        self.family: str = family
        self.level: int = level
        self.threat_rank: str = threat_rank
        self.action_marble_bag: list[BattleAction] = (
            action_marble_bag if action_marble_bag is not None else list(self.actions)
        )
        self.xp_reward: int = xp_reward
        self.gold_reward: int = gold_reward

    def choose_action(
        self,
        party_targets: list[Combatant],
        ally_targets: list[Combatant],
        rng: Optional[random.Random] = None,
    ) -> tuple[BattleAction, Combatant]:
        """AI intent decision: select action from marble bag and appropriate target."""
        r = rng if rng is not None else random
        action = r.choice(self.action_marble_bag)

        if action.target_scope in (TargetScope.SINGLE_ALLY, TargetScope.ALL_ALLIES):
            # Target alive ally with lowest HP ratio
            alive_allies = [a for a in ally_targets if a.is_alive]
            if not alive_allies:
                chosen_target = self
            else:
                chosen_target = min(alive_allies, key=lambda a: a.hp / max(1, a.max_hp))
        elif action.target_scope == TargetScope.SELF:
            chosen_target = self
        else:
            # Target living party member (prefer lowest HP or random)
            alive_enemies = [p for p in party_targets if p.is_alive]
            if not alive_enemies:
                chosen_target = self
            else:
                # 60% chance to target lowest HP, 40% random
                if r.random() < 0.60:
                    chosen_target = min(alive_enemies, key=lambda p: p.hp / max(1, p.max_hp))
                else:
                    chosen_target = r.choice(alive_enemies)

        return action, chosen_target


class Party:
    """Manages the player party of 1 to 5 members with shared gold, inventory, and campaign playtime."""

    def __init__(
        self,
        members: Optional[list[PartyMember]] = None,
        gold: int = 0,
        inventory: Optional[list[dict]] = None,
        quest_items: Optional[list[str]] = None,
        playtime_seconds: int = 0,
    ):
        self.members: list[PartyMember] = members if members is not None else []
        self.gold: int = gold
        self.inventory: list[dict] = inventory if inventory is not None else []
        self.quest_items: list[str] = quest_items if quest_items is not None else []
        self.playtime_seconds: int = playtime_seconds
        self._playtime_accumulator: float = 0.0

    def add_playtime(self, delta_time: float) -> None:
        """Accumulates delta_time into playtime_seconds with sub-second precision and safety clamping."""
        if delta_time <= 0:
            return
        dt = min(delta_time, 1.0)
        self._playtime_accumulator += dt
        if self._playtime_accumulator >= 1.0:
            add_secs = int(self._playtime_accumulator)
            self.playtime_seconds += add_secs
            self._playtime_accumulator -= add_secs

    @property
    def formatted_playtime(self) -> str:
        """Returns elapsed playtime formatted as HH:MM:SS."""
        h = self.playtime_seconds // 3600
        m = (self.playtime_seconds % 3600) // 60
        s = self.playtime_seconds % 60
        return f"{h:02d}:{m:02d}:{s:02d}"

    def to_dict(self) -> dict:
        return {
            "members": [m.to_dict() for m in self.members],
            "gold": self.gold,
            "inventory": list(self.inventory),
            "quest_items": list(self.quest_items),
            "playtime_seconds": self.playtime_seconds,
        }

    @classmethod
    def from_dict(cls, data: dict) -> Party:
        members = [PartyMember.from_dict(m) for m in data.get("members", [])]
        return cls(
            members=members,
            gold=data.get("gold", 0),
            inventory=data.get("inventory", []),
            quest_items=data.get("quest_items", []),
            playtime_seconds=data.get("playtime_seconds", 0),
        )

    def add_member(self, member: PartyMember) -> bool:
        if len(self.members) >= 5:
            return False
        self.members.append(member)
        return True

    @property
    def alive_members(self) -> list[PartyMember]:
        return [m for m in self.members if m.is_alive]

    @property
    def is_wiped(self) -> bool:
        return len(self.alive_members) == 0

    def get_member(self, index: int) -> Optional[PartyMember]:
        if 0 <= index < len(self.members):
            return self.members[index]
        return None

    def update_turn(self) -> None:
        for m in self.members:
            m.update_turn()

    def add_item(self, item_id: str, qty: int = 1, item_type: str = "consumable") -> None:
        """Adds quantity of an item to inventory, grouping if existing."""
        if qty <= 0:
            return
        for entry in self.inventory:
            if entry.get("item_id") == item_id or entry.get("name") == item_id:
                entry["qty"] = entry.get("qty", 1) + qty
                return
        self.inventory.append({"item_id": item_id, "qty": qty, "type": item_type})

    def remove_item(self, item_id: str, qty: int = 1) -> bool:
        """Removes quantity of an item from inventory. Returns True if successful."""
        if qty <= 0:
            return True
        for i, entry in enumerate(self.inventory):
            if entry.get("item_id") == item_id or entry.get("name") == item_id:
                cur_qty = entry.get("qty", 1)
                if cur_qty > qty:
                    entry["qty"] = cur_qty - qty
                    return True
                elif cur_qty == qty:
                    self.inventory.pop(i)
                    return True
                else:
                    return False
        return False

    def get_item_count(self, item_id: str) -> int:
        """Returns the total count of an item in inventory."""
        for entry in self.inventory:
            if entry.get("item_id") == item_id or entry.get("name") == item_id:
                return entry.get("qty", 0)
        return 0

    def has_item(self, item_id: str, qty: int = 1) -> bool:
        """Returns True if the party has at least qty of an item."""
        return self.get_item_count(item_id) >= qty


class EnemySquad:
    """Manages an enemy squad of 1 to 10 combatants."""

    def __init__(self, enemies: Optional[list[EnemyCombatant]] = None):
        self.enemies: list[EnemyCombatant] = enemies if enemies is not None else []

    def add_enemy(self, enemy: EnemyCombatant) -> bool:
        if len(self.enemies) >= 10:
            return False
        self.enemies.append(enemy)
        return True

    @property
    def alive_enemies(self) -> list[EnemyCombatant]:
        return [e for e in self.enemies if e.is_alive]

    @property
    def is_wiped(self) -> bool:
        return len(self.alive_enemies) == 0

    def get_enemy(self, index: int) -> Optional[EnemyCombatant]:
        if 0 <= index < len(self.enemies):
            return self.enemies[index]
        return None

    def total_xp(self) -> int:
        return sum(e.xp_reward for e in self.enemies)

    def total_gold(self) -> int:
        return sum(e.gold_reward for e in self.enemies)

    def update_turn(self) -> None:
        for e in self.enemies:
            e.update_turn()


# Presets & Factory Helpers
def create_default_party() -> Party:
    """Creates the standard 5-member player party with balanced equipment and skillsets."""
    party = Party()

    # 1. Aide - Knight (Tank / Physical Single Target)
    steve = PartyMember(
        name="Aide",
        job_class="Knight",
        level=3,
        affinity=BattleActionType.PHYSICAL,
        base_stats={
            StatId.HIT_POINTS: 420,
            StatId.MAGIC_POINTS: 80,
            StatId.ATTACK: 28,
            StatId.DEFENSE: 26,
            StatId.MAGIC_ATTACK: 12,
            StatId.MAGIC_DEFENSE: 18,
            StatId.SPEED: 14,
            StatId.LUCK: 12,
            StatId.ACCURACY: 85,
        },
        actions=[ACTIONS["Attack"].copy(), ACTIONS["Defend"].copy()],
    )
    steve.equip(EQUIPMENT_CATALOG["Iron Longsword"])
    steve.equip(EQUIPMENT_CATALOG["Iron Greathelm"])
    steve.equip(EQUIPMENT_CATALOG["Plate Cuirass"])
    steve.equip(EQUIPMENT_CATALOG["Steel Pauldrons"])
    steve.equip(EQUIPMENT_CATALOG["Iron Gauntlets"])
    steve.equip(EQUIPMENT_CATALOG["Steel Greaves"])
    steve.equip(EQUIPMENT_CATALOG["Plated Sabatons"])
    steve.equip(EQUIPMENT_CATALOG["Ring of Might"])
    steve.equip(EQUIPMENT_CATALOG["Amulet of Health"])
    steve.equip(EQUIPMENT_CATALOG["Cloak of Protection"])
    party.add_member(steve)

    # 2. Lyra - Mage (Arcane / AoE Elemental)
    lyra = PartyMember(
        name="Lyra",
        job_class="Mage",
        level=3,
        affinity=BattleActionType.ELEMENTAL_FIRE,
        base_stats={
            StatId.HIT_POINTS: 260,
            StatId.MAGIC_POINTS: 220,
            StatId.ATTACK: 12,
            StatId.DEFENSE: 14,
            StatId.MAGIC_ATTACK: 35,
            StatId.MAGIC_DEFENSE: 28,
            StatId.SPEED: 16,
            StatId.LUCK: 15,
            StatId.ACCURACY: 90,
        },
        actions=[
            ACTIONS["Attack"].copy(),
            ACTIONS["Fireball"].copy(),
            ACTIONS["Ice Bolt"].copy(),
            ACTIONS["Arctic Blast"].copy(),
            ACTIONS["Defend"].copy(),
        ],
    )
    lyra.equip(EQUIPMENT_CATALOG["Oak Staff"])
    lyra.equip(EQUIPMENT_CATALOG["Mage Circlet"])
    lyra.equip(EQUIPMENT_CATALOG["Silk Vestment"])
    lyra.equip(EQUIPMENT_CATALOG["Mage Mantle"])
    lyra.equip(EQUIPMENT_CATALOG["Spellweaver Mitts"])
    lyra.equip(EQUIPMENT_CATALOG["Traveler Leggings"])
    lyra.equip(EQUIPMENT_CATALOG["Winged Sandals"])
    lyra.equip(EQUIPMENT_CATALOG["Sapphire Ring"])
    lyra.equip(EQUIPMENT_CATALOG["Lucky Coin Talisman"])
    lyra.equip(EQUIPMENT_CATALOG["Cloak of Protection"])
    party.add_member(lyra)

    # 3. Dirk - Rogue (High Speed / Crit / Physical Skills)
    derek = PartyMember(
        name="Dirk",
        job_class="Rogue",
        level=3,
        affinity=BattleActionType.ELEMENTAL_WIND,
        base_stats={
            StatId.HIT_POINTS: 310,
            StatId.MAGIC_POINTS: 110,
            StatId.ATTACK: 25,
            StatId.DEFENSE: 18,
            StatId.MAGIC_ATTACK: 14,
            StatId.MAGIC_DEFENSE: 16,
            StatId.SPEED: 25,
            StatId.LUCK: 28,
            StatId.ACCURACY: 92,
        },
        actions=[ACTIONS["Attack"].copy(), ACTIONS["Drop Kick"].copy(), ACTIONS["Defend"].copy()],
    )
    derek.equip(EQUIPMENT_CATALOG["Twin Daggers"])
    derek.equip(EQUIPMENT_CATALOG["Leather Hood"])
    derek.equip(EQUIPMENT_CATALOG["Brigandine"])
    derek.equip(EQUIPMENT_CATALOG["Traveler Leggings"])
    derek.equip(EQUIPMENT_CATALOG["Winged Sandals"])
    derek.equip(EQUIPMENT_CATALOG["Lucky Coin Talisman"])
    derek.equip(EQUIPMENT_CATALOG["Shadow Cape"])
    party.add_member(derek)

    # 4. Sara - Cleric (Healer / Holy Radiance)
    sarah = PartyMember(
        name="Sara",
        job_class="Cleric",
        level=3,
        affinity=BattleActionType.ELEMENTAL_LIGHT,
        base_stats={
            StatId.HIT_POINTS: 330,
            StatId.MAGIC_POINTS: 190,
            StatId.ATTACK: 18,
            StatId.DEFENSE: 20,
            StatId.MAGIC_ATTACK: 26,
            StatId.MAGIC_DEFENSE: 26,
            StatId.SPEED: 15,
            StatId.LUCK: 18,
            StatId.ACCURACY: 88,
        },
        actions=[
            ACTIONS["Attack"].copy(),
            ACTIONS["Heal"].copy(),
            ACTIONS["Group Heal"].copy(),
            ACTIONS["Defend"].copy(),
        ],
    )
    sarah.equip(EQUIPMENT_CATALOG["Silver Mace"])
    sarah.equip(EQUIPMENT_CATALOG["Mage Circlet"])
    sarah.equip(EQUIPMENT_CATALOG["Silk Vestment"])
    sarah.equip(EQUIPMENT_CATALOG["Mage Mantle"])
    sarah.equip(EQUIPMENT_CATALOG["Traveler Leggings"])
    sarah.equip(EQUIPMENT_CATALOG["Amulet of Health"])
    sarah.equip(EQUIPMENT_CATALOG["Cloak of Protection"])
    party.add_member(sarah)

    # 5. Vane - Berserker (Heavy Frontline Damage)
    vance = PartyMember(
        name="Vane",
        job_class="Berserker",
        level=3,
        affinity=BattleActionType.ELEMENTAL_EARTH,
        base_stats={
            StatId.HIT_POINTS: 490,
            StatId.MAGIC_POINTS: 70,
            StatId.ATTACK: 34,
            StatId.DEFENSE: 22,
            StatId.MAGIC_ATTACK: 8,
            StatId.MAGIC_DEFENSE: 14,
            StatId.SPEED: 18,
            StatId.LUCK: 14,
            StatId.ACCURACY: 82,
        },
        actions=[ACTIONS["Attack"].copy(), ACTIONS["Defend"].copy()],
    )
    vance.equip(EQUIPMENT_CATALOG["Heavy Battleaxe"])
    vance.equip(EQUIPMENT_CATALOG["Iron Greathelm"])
    vance.equip(EQUIPMENT_CATALOG["Brigandine"])
    vance.equip(EQUIPMENT_CATALOG["Steel Pauldrons"])
    vance.equip(EQUIPMENT_CATALOG["Iron Gauntlets"])
    vance.equip(EQUIPMENT_CATALOG["Steel Greaves"])
    vance.equip(EQUIPMENT_CATALOG["Plated Sabatons"])
    vance.equip(EQUIPMENT_CATALOG["Ring of Might"])
    vance.equip(EQUIPMENT_CATALOG["Amulet of Health"])
    party.add_member(vance)

    # Re-fill HP/MP to full with all equipment applied
    for m in party.members:
        m.hp = m.max_hp
        m.mp = m.max_mp

    # Default starter pouch
    party.gold = 350
    party.add_item("Potion", 3)
    party.add_item("Ether", 1)
    party.add_item("Revive Herb", 1)
    party.add_item("Steel Broadsword", 1, item_type="equipment")
    party.add_item("Traveler Cloak", 1, item_type="equipment")

    return party


def create_bat_squad(size: int = 6) -> EnemySquad:
    """Creates a swarm of bats (up to 10) featuring Ice affinity and screech tactics."""
    squad = EnemySquad()
    actual_size = max(1, min(10, size))

    bat_names = ["Bat A", "Bat B", "Bat C", "Bat D", "Bat E", "Bat F", "Nightwing", "Bloodswoop", "Dreadwing", "Vampire Lord"]
    for i in range(actual_size):
        name = bat_names[i]
        is_boss = (i >= 8)
        is_elite = (i >= 6)

        hp = 380 if is_boss else (260 if is_elite else 140)
        atk = 24 if is_boss else (18 if is_elite else 12)
        spd = 22 if is_boss else (20 if is_elite else 17)
        xp = 60 if is_boss else (35 if is_elite else 18)
        gold = 40 if is_boss else (20 if is_elite else 10)
        rank = "B" if is_boss else ("C" if is_elite else "D")

        bat = EnemyCombatant(
            name=name,
            family="Beast / Flying",
            level=3 if is_boss else 2,
            threat_rank=rank,
            affinity=BattleActionType.ELEMENTAL_ICE,
            stats={
                StatId.HIT_POINTS: hp,
                StatId.MAGIC_POINTS: 50,
                StatId.ATTACK: atk,
                StatId.DEFENSE: 12 if is_boss else 8,
                StatId.MAGIC_ATTACK: 14 if is_boss else 10,
                StatId.MAGIC_DEFENSE: 14 if is_boss else 10,
                StatId.SPEED: spd,
                StatId.LUCK: 12,
                StatId.ACCURACY: 86,
            },
            actions=[ACTIONS["Bite"].copy(), ACTIONS["Blood Drain"].copy(), ACTIONS["Screech"].copy()],
            xp_reward=xp,
            gold_reward=gold,
        )
        bat.hp = bat.max_hp
        bat.mp = bat.max_mp
        squad.add_enemy(bat)

    return squad
