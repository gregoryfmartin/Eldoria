"""
Unit tests for domain entity serialization (Phase 1).
Verifies bijective round-trip serialization for BattleEntityProperty, BattleAction,
BattleEquipment, PartyMember, and Party.
"""

import unittest
from eldoria_py.combat.stats import StatId, BattleActionType, EquipmentSlot
from eldoria_py.combat.actions import BattleAction, ACTIONS
from eldoria_py.combat.equipment import BattleEquipment, EQUIPMENT_CATALOG
from eldoria_py.combat.portrait import Gender
from eldoria_py.combat.entities import PartyMember, Party, create_default_party


class TestDomainSerialization(unittest.TestCase):

    def test_battle_action_round_trip(self):
        act = ACTIONS["Boulder Bash"].copy()
        data = act.to_dict()
        self.assertEqual(data["name"], "Boulder Bash")
        self.assertEqual(data["action_type"], BattleActionType.ELEMENTAL_EARTH.value)

        restored = BattleAction.from_dict(data)
        self.assertEqual(restored.name, act.name)
        self.assertEqual(restored.action_type, act.action_type)
        self.assertEqual(restored.mp_cost, act.mp_cost)
        self.assertEqual(restored.effect_value, act.effect_value)

        # Also verify from string name
        from_name = BattleAction.from_dict("Boulder Bash")
        self.assertEqual(from_name.name, "Boulder Bash")

    def test_battle_equipment_round_trip(self):
        eq = EQUIPMENT_CATALOG["Iron Longsword"]
        data = eq.to_dict()
        self.assertEqual(data["name"], "Iron Longsword")
        self.assertEqual(data["slot"], EquipmentSlot.WEAPON.value)

        restored = BattleEquipment.from_dict(data)
        self.assertEqual(restored.name, eq.name)
        self.assertEqual(restored.slot, eq.slot)
        self.assertEqual(restored.stat_bonuses, eq.stat_bonuses)
        self.assertEqual(restored.unlocked_action_name, eq.unlocked_action_name)

        # Also verify from catalog name
        from_name = BattleEquipment.from_dict("Iron Longsword")
        self.assertEqual(from_name.name, "Iron Longsword")

    def test_party_member_round_trip(self):
        member = PartyMember(
            name="Seraphina",
            job_class="Priestess",
            level=5,
            affinity=BattleActionType.ELEMENTAL_LIGHT,
            base_stats={
                StatId.HIT_POINTS: 250,
                StatId.MAGIC_POINTS: 180,
                StatId.ATTACK: 12,
                StatId.DEFENSE: 14,
                StatId.MAGIC_ATTACK: 20,
                StatId.MAGIC_DEFENSE: 22,
                StatId.SPEED: 15,
                StatId.LUCK: 18,
                StatId.ACCURACY: 92,
            },
            gender=Gender.FEMALE,
            profile_image_index=2,
            actions=[ACTIONS["Attack"].copy(), ACTIONS["Radiance"].copy()],
        )
        # Equip helmet and armor
        member.equip(EQUIPMENT_CATALOG["Mage Circlet"])
        member.equip(EQUIPMENT_CATALOG["Silk Vestment"])

        # Take some damage
        member.hp = 180
        member.mp = 120

        data = member.to_dict()
        self.assertEqual(data["name"], "Seraphina")
        self.assertEqual(data["gender"], "Female")
        self.assertEqual(data["affinity"], "ElementalLight")
        self.assertEqual(data["stats"]["HitPoints"]["current"], 180)
        self.assertEqual(data["stats"]["MagicPoints"]["current"], 120)

        restored = PartyMember.from_dict(data)
        self.assertEqual(restored.name, "Seraphina")
        self.assertEqual(restored.job_class, "Priestess")
        self.assertEqual(restored.level, 5)
        self.assertEqual(restored.gender, Gender.FEMALE)
        self.assertEqual(restored.profile_image_index, 2)
        self.assertEqual(restored.affinity, BattleActionType.ELEMENTAL_LIGHT)

        # Check restored stats and current HP/MP
        self.assertEqual(restored.hp, 180)
        self.assertEqual(restored.mp, 120)
        self.assertEqual(restored.stats[StatId.HIT_POINTS].base, 250)

        # Check equipment was re-equipped and bonuses applied
        self.assertIsNotNone(restored.equipment[EquipmentSlot.HELMET])
        self.assertEqual(restored.equipment[EquipmentSlot.HELMET].name, "Mage Circlet")
        self.assertIsNotNone(restored.equipment[EquipmentSlot.ARMOR])
        self.assertEqual(restored.equipment[EquipmentSlot.ARMOR].name, "Silk Vestment")
        self.assertGreater(restored.get_stat(StatId.MAGIC_DEFENSE), 22)

    def test_party_round_trip(self):
        party = create_default_party()
        party.gold = 1250
        party.inventory = [
            {"item_id": "health_potion", "qty": 3},
            {"item_id": "ether", "qty": 1},
        ]
        party.quest_items = ["oakhaven_seal", "ancient_key"]

        data = party.to_dict()
        self.assertEqual(len(data["members"]), 5)
        self.assertEqual(data["gold"], 1250)
        self.assertEqual(len(data["inventory"]), 2)
        self.assertEqual(len(data["quest_items"]), 2)

        restored = Party.from_dict(data)
        self.assertEqual(len(restored.members), 5)
        self.assertEqual(restored.gold, 1250)
        self.assertEqual(restored.inventory, party.inventory)
        self.assertEqual(restored.quest_items, ["oakhaven_seal", "ancient_key"])

        # Check members
        self.assertEqual(restored.members[0].name, "Aide")
        self.assertEqual(restored.members[1].name, "Lyra")
        self.assertEqual(restored.members[2].name, "Dirk")
        self.assertEqual(restored.members[3].name, "Sara")
        self.assertEqual(restored.members[4].name, "Vane")


if __name__ == "__main__":
    unittest.main()
