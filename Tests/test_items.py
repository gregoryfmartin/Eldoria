"""Unit tests for the consumable items system and Party inventory management."""
import unittest

from eldoria_py.combat.entities import PartyMember, Party, create_default_party
from eldoria_py.combat.stats import StatId, BattleActionType, TargetScope
from eldoria_py.combat.items import (
    ConsumableItem,
    ItemType,
    ItemEffectType,
    ITEM_CATALOG,
    get_item,
    apply_item_effect,
)


class TestItemsSystem(unittest.TestCase):
    def setUp(self):
        self.party = create_default_party()
        self.hero = self.party.members[0]

    def test_catalog_definitions(self):
        potion = get_item("Potion")
        self.assertIsNotNone(potion)
        self.assertEqual(potion.power, 50)
        self.assertEqual(potion.effect_type, ItemEffectType.RESTORE_HP)

        # Alias lookup
        self.assertEqual(get_item("health_potion"), potion)
        self.assertEqual(get_item("ether"), get_item("Ether"))

    def test_party_inventory_helpers(self):
        party = Party()
        self.assertEqual(party.get_item_count("Potion"), 0)
        self.assertFalse(party.has_item("Potion"))

        party.add_item("Potion", 2)
        self.assertEqual(party.get_item_count("Potion"), 2)
        self.assertTrue(party.has_item("Potion", 2))
        self.assertFalse(party.has_item("Potion", 3))

        party.add_item("Potion", 3)
        self.assertEqual(party.get_item_count("Potion"), 5)

        self.assertTrue(party.remove_item("Potion", 2))
        self.assertEqual(party.get_item_count("Potion"), 3)

        self.assertTrue(party.remove_item("Potion", 3))
        self.assertEqual(party.get_item_count("Potion"), 0)
        self.assertFalse(party.remove_item("Potion", 1))

    def test_apply_potion_heal(self):
        self.party.inventory = []
        self.party.add_item("Potion", 2)

        # Damage hero
        self.hero.current_hp = self.hero.max_hp - 40
        potion = get_item("Potion")

        success, msg = apply_item_effect(potion, self.hero, self.party)
        self.assertTrue(success)
        self.assertEqual(self.hero.current_hp, self.hero.max_hp)
        self.assertEqual(self.party.get_item_count("Potion"), 1)
        self.assertIn("recovered 40 HP", msg)

    def test_potion_rejected_at_full_hp(self):
        self.party.inventory = []
        self.party.add_item("Potion", 1)
        self.hero.current_hp = self.hero.max_hp
        potion = get_item("Potion")

        success, msg = apply_item_effect(potion, self.hero, self.party)
        self.assertFalse(success)
        self.assertEqual(self.party.get_item_count("Potion"), 1)
        self.assertIn("already at full HP", msg)

    def test_ether_restores_mp(self):
        self.party.inventory = []
        self.party.add_item("Ether", 1)
        self.hero.current_mp = 10
        max_mp = self.hero.max_mp
        ether = get_item("Ether")

        success, msg = apply_item_effect(ether, self.hero, self.party)
        self.assertTrue(success)
        self.assertEqual(self.hero.current_mp, min(max_mp, 10 + 40))
        self.assertEqual(self.party.get_item_count("Ether"), 0)

    def test_revive_herb_on_fallen_and_living(self):
        self.party.inventory = []
        self.party.add_item("Revive Herb", 2)
        revive = get_item("Revive Herb")

        # Living ally cannot be revived
        self.hero.current_hp = 50
        success, msg = apply_item_effect(revive, self.hero, self.party)
        self.assertFalse(success)
        self.assertIn("already alive", msg)

        # Fall hero
        self.hero.current_hp = 0
        self.assertFalse(self.hero.is_alive)

        # Standard potion fails on dead hero
        potion = get_item("Potion")
        self.party.add_item("Potion", 1)
        success, msg = apply_item_effect(potion, self.hero, self.party)
        self.assertFalse(success)
        self.assertIn("fallen", msg)

        # Revive succeeds
        success, msg = apply_item_effect(revive, self.hero, self.party)
        self.assertTrue(success)
        self.assertTrue(self.hero.is_alive)
        self.assertEqual(self.hero.current_hp, 100)
        self.assertEqual(self.party.get_item_count("Revive Herb"), 1)

    def test_tent_party_heal(self):
        self.party.inventory = []
        self.party.add_item("Tent", 1)
        tent = get_item("Tent")

        for m in self.party.members:
            m.current_hp = 20
            m.current_mp = 10

        success, msg = apply_item_effect(tent, None, self.party)
        self.assertTrue(success)
        for m in self.party.members:
            self.assertEqual(m.current_hp, m.max_hp)
            self.assertEqual(m.current_mp, m.max_mp)
        self.assertEqual(self.party.get_item_count("Tent"), 0)


if __name__ == "__main__":
    unittest.main()
