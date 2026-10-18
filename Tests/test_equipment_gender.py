"""
Unit and Integration Tests for Equipment Gender Sensitivity.
Tests:
- Model defaults and can_equip_by logic
- Serialization and backward compatibility with legacy save dictionaries
- PartyMember.can_equip() and PartyMember.equip() validation
- Equip Shop UI gender badge and party compatibility display
- Main Menu equipment drawer enforcement and visual badges
"""

import unittest
from unittest.mock import MagicMock

from eldoria_py.combat.stats import StatId, EquipmentSlot
from eldoria_py.combat.equipment import BattleEquipment, EQUIPMENT_CATALOG
from eldoria_py.combat.entities import PartyMember, Party, create_default_party
from eldoria_py.combat.portrait import Gender
from eldoria_py.states.equip_shop import GSEquipShopScreen
from eldoria_py.states.main_menu_screen import GSMainMenuScreen
from eldoria_py.terminal.box import strip_ansi
from eldoria_py.terminal.input import KeyCode, KeyEvent


class TestEquipmentGenderSensitivity(unittest.TestCase):
    def setUp(self):
        self.unisex_item = BattleEquipment(
            name="Iron Cuirass",
            slot=EquipmentSlot.ARMOR,
            stat_bonuses={StatId.DEFENSE: 10},
            target_gender=Gender.UNISEX,
        )
        self.female_item = BattleEquipment(
            name="Valkyrie Mail",
            slot=EquipmentSlot.ARMOR,
            stat_bonuses={StatId.DEFENSE: 18, StatId.SPEED: 4},
            target_gender=Gender.FEMALE,
        )
        self.male_item = BattleEquipment(
            name="Warlord Cuirass",
            slot=EquipmentSlot.ARMOR,
            stat_bonuses={StatId.DEFENSE: 22, StatId.ATTACK: 6},
            target_gender=Gender.MALE,
        )

        self.male_member = PartyMember(
            name="Aide",
            job_class="Warrior",
            gender=Gender.MALE,
        )
        self.female_member = PartyMember(
            name="Lyra",
            job_class="Mage",
            gender=Gender.FEMALE,
        )

    # -------------------------------------------------------------------------
    # 1. Model & Helper Logic
    # -------------------------------------------------------------------------
    def test_default_target_gender_is_unisex(self):
        """Newly instantiated BattleEquipment defaults to Unisex."""
        eq = BattleEquipment(name="Test Robe", slot=EquipmentSlot.ARMOR)
        self.assertEqual(eq.target_gender, Gender.UNISEX)

    def test_can_equip_by(self):
        """Unisex items can be equipped by any gender; gender-locked items only match their gender."""
        self.assertTrue(self.unisex_item.can_equip_by(Gender.MALE))
        self.assertTrue(self.unisex_item.can_equip_by(Gender.FEMALE))
        self.assertTrue(self.unisex_item.can_equip_by(Gender.UNISEX))

        self.assertTrue(self.female_item.can_equip_by(Gender.FEMALE))
        self.assertFalse(self.female_item.can_equip_by(Gender.MALE))

        self.assertTrue(self.male_item.can_equip_by(Gender.MALE))
        self.assertFalse(self.male_item.can_equip_by(Gender.FEMALE))

    # -------------------------------------------------------------------------
    # 2. Serialization & Backward Compatibility
    # -------------------------------------------------------------------------
    def test_serialization_round_trip(self):
        """to_dict and from_dict preserve target_gender."""
        d = self.female_item.to_dict()
        self.assertEqual(d["target_gender"], "Female")

        hydrated = BattleEquipment.from_dict(d)
        self.assertEqual(hydrated.target_gender, Gender.FEMALE)
        self.assertEqual(hydrated.name, "Valkyrie Mail")

    def test_legacy_dict_hydration_defaults_to_unisex(self):
        """Legacy saved item without target_gender cleanly defaults to Unisex."""
        legacy_dict = {
            "name": "Old Tunic",
            "slot": "Armor",
            "stat_bonuses": {"Defense": 5},
            "price": 100,
            "tier": 1,
            "is_relic": False,
        }
        item = BattleEquipment.from_dict(legacy_dict)
        self.assertEqual(item.target_gender, Gender.UNISEX)
        self.assertTrue(item.can_equip_by(Gender.MALE))
        self.assertTrue(item.can_equip_by(Gender.FEMALE))

    # -------------------------------------------------------------------------
    # 3. Party Member can_equip and equip Validation
    # -------------------------------------------------------------------------
    def test_party_member_can_equip(self):
        """PartyMember.can_equip validates according to member gender."""
        # Male member
        self.assertTrue(self.male_member.can_equip(self.unisex_item))
        self.assertTrue(self.male_member.can_equip(self.male_item))
        self.assertFalse(self.male_member.can_equip(self.female_item))
        self.assertTrue(self.male_member.can_equip(None))

        # Female member
        self.assertTrue(self.female_member.can_equip(self.unisex_item))
        self.assertTrue(self.female_member.can_equip(self.female_item))
        self.assertFalse(self.female_member.can_equip(self.male_item))
        self.assertTrue(self.female_member.can_equip(None))

    def test_party_member_equip_enforces_restriction(self):
        """PartyMember.equip raises ValueError when attempting to equip gender-locked gear."""
        # Male equipping male gear succeeds
        old = self.male_member.equip(self.male_item)
        self.assertIsNone(old)
        self.assertEqual(self.male_member.equipment[EquipmentSlot.ARMOR], self.male_item)

        # Male equipping female gear raises ValueError
        with self.assertRaises(ValueError) as ctx:
            self.male_member.equip(self.female_item)
        self.assertIn("cannot equip Valkyrie Mail", str(ctx.exception))
        # Ensure armor slot was not changed
        self.assertEqual(self.male_member.equipment[EquipmentSlot.ARMOR], self.male_item)

        # Female equipping female gear succeeds
        self.female_member.equip(self.female_item)
        self.assertEqual(self.female_member.equipment[EquipmentSlot.ARMOR], self.female_item)

        # Female equipping male gear raises ValueError
        with self.assertRaises(ValueError) as ctx:
            self.female_member.equip(self.male_item)
        self.assertIn("cannot equip Warlord Cuirass", str(ctx.exception))

    # -------------------------------------------------------------------------
    # 4. Equipment Shop UI Feedback
    # -------------------------------------------------------------------------
    def test_equip_shop_renders_gender_badge_and_incompatibility(self):
        """Shop screen displays gender requirement badges and party member compatibility warnings."""
        party = create_default_party()
        # Default party: Aide (Male), Lyra (Female), Dirk (Male), Sara (Female), Vane (Male)
        shop = GSEquipShopScreen()
        shop.party = party
        shop.armorer_npc = MagicMock()
        shop.armorer_npc.shop_inventory = [
            {"name": "Valkyrie Mail", "type": "equipment", "price": 480}
        ]
        shop.mode = "BUY"
        shop.active_cursor = 0

        rendered = shop._render_right_pane()
        rendered_plain = [strip_ansi(l) for l in rendered]
        combined = "\n".join(rendered_plain)

        # 1. Right pane top shows [♀ Female Only] badge
        self.assertIn("[♀ Female Only]", combined)

        # 2. Aide (Male) is flagged incompatible
        self.assertIn("Aide", combined)
        self.assertIn("[Incompat]", combined)
        self.assertIn("[Incompatible: ♀ Only]", combined)

        # 3. Lyra (Female) is compatible (no [Incompatible] badge)
        for line in rendered_plain:
            if "Lyra" in line:
                self.assertNotIn("Incompatible", line)

    # -------------------------------------------------------------------------
    # 5. Main Menu Equipment Drawer Enforcement
    # -------------------------------------------------------------------------
    def test_main_menu_drawer_blocks_incompatible_equip(self):
        """Main menu blocks equipping gender-locked gear and warns player via banner."""
        screen = GSMainMenuScreen()
        screen.party = create_default_party()
        screen.hero_idx = 0  # Aide (Male)
        # Put Valkyrie Mail into party bag
        screen.party.add_item("Valkyrie Mail", 1, item_type="equipment")

        # Open drawer on ARMOR slot
        armor_slot_idx = screen.EQUIP_SLOTS.index(EquipmentSlot.ARMOR)
        screen.equip_slot_cursor = armor_slot_idx

        # Simulate pressing Enter to open drawer
        enter_event = KeyEvent(key=KeyCode.ENTER, char="\r")
        screen._handle_equipment_input(enter_event)

        self.assertTrue(screen.equip_drawer_open)
        # Find Valkyrie Mail in drawer
        v_idx = next(
            i for i, item in enumerate(screen.equip_drawer_items)
            if item is not None and item.name == "Valkyrie Mail"
        )
        screen.equip_drawer_cursor = v_idx

        # Check drawer rendering shows [Female Only] badge
        drawer_lines = screen._render_equipment_submenu()
        drawer_plain = "\n".join(strip_ansi(l) for l in drawer_lines)
        self.assertIn("[Female Only]", drawer_plain)

        # Attempt to equip by pressing Enter
        screen._handle_equipment_input(enter_event)

        # Should remain open, action blocked, banner set, item not equipped
        self.assertTrue(screen.equip_drawer_open)
        self.assertIn("Cannot equip Valkyrie Mail! (Female only)", screen.banner_message)
        self.assertNotEqual(screen.party.members[0].equipment[EquipmentSlot.ARMOR], self.female_item)
        self.assertEqual(screen.party.get_item_count("Valkyrie Mail"), 1)

    # -------------------------------------------------------------------------
    # 6. Name-Based Gender Inference and Catalog Looping
    # -------------------------------------------------------------------------
    def test_infer_equipment_gender_by_name(self):
        """Verifies name-based semantic gender inference across female, male, and unisex keywords."""
        from eldoria_py.combat.equipment import infer_equipment_gender_by_name

        # Female items
        female_cases = [
            "Valkyrie Mail", "Maiden Circlet", "Queen's Tiara",
            "Sorceress Gown", "Princess Dress", "Vixen Boots",
            "Witch's Robe", "Priestess Veil", "Lady's Corset"
        ]
        for name in female_cases:
            self.assertEqual(
                infer_equipment_gender_by_name(name),
                Gender.FEMALE,
                f"Expected {name} to be inferred as Female",
            )

        # Male items
        male_cases = [
            "Warlord Cuirass", "King's Greathelm", "Chieftain Pauldrons",
            "Barbarian Harness", "Lord's Cuirass", "Warlock Robe",
            "Emperor's Plate", "Monk Habit", "Prince's Crown"
        ]
        for name in male_cases:
            self.assertEqual(
                infer_equipment_gender_by_name(name),
                Gender.MALE,
                f"Expected {name} to be inferred as Male",
            )

        # Unisex items (eligible for both males and females)
        unisex_cases = [
            "Iron Longsword", "Oak Staff", "Twin Daggers", "Silver Mace",
            "Heavy Battleaxe", "Steel Broadsword", "Leather Hood", "Iron Greathelm",
            "Mage Circlet", "Brigandine", "Silk Vestment", "Plate Cuirass",
            "Steel Pauldrons", "Mage Mantle", "Iron Gauntlets", "Spellweaver Mitts",
            "Traveler Leggings", "Steel Greaves", "Plated Sabatons", "Winged Sandals",
            "Sapphire Ring", "Ring of Might", "Lucky Coin Talisman", "Amulet of Health",
            "Traveler Cloak", "Cloak of Protection", "Shadow Cape", "Excalibur",
            "Dragon Shield", "Mythril Plate", "Titan Helm", "Aegis Cloak"
        ]
        for name in unisex_cases:
            self.assertEqual(
                infer_equipment_gender_by_name(name),
                Gender.UNISEX,
                f"Expected {name} to be inferred as Unisex",
            )

    def test_assign_genders_to_equipment_catalog_loop(self):
        """assign_genders_to_equipment_catalog loops through all catalog items and assigns genders."""
        from eldoria_py.combat.equipment import assign_genders_to_equipment_catalog, EQUIPMENT_CATALOG

        results = assign_genders_to_equipment_catalog()
        self.assertEqual(len(results), len(EQUIPMENT_CATALOG))

        # Check all items in EQUIPMENT_CATALOG have assigned target_gender matching their name
        for name, eq in EQUIPMENT_CATALOG.items():
            self.assertIn(eq.target_gender, (Gender.FEMALE, Gender.MALE, Gender.UNISEX))
            self.assertEqual(eq.target_gender, results[name])

        # Specific known checks
        self.assertEqual(EQUIPMENT_CATALOG["Valkyrie Mail"].target_gender, Gender.FEMALE)
        self.assertEqual(EQUIPMENT_CATALOG["Warlord Cuirass"].target_gender, Gender.MALE)
        self.assertEqual(EQUIPMENT_CATALOG["Maiden Circlet"].target_gender, Gender.FEMALE)
        self.assertEqual(EQUIPMENT_CATALOG["King's Greathelm"].target_gender, Gender.MALE)
        self.assertEqual(EQUIPMENT_CATALOG["Iron Longsword"].target_gender, Gender.UNISEX)

    # -------------------------------------------------------------------------
    # 7. Party Inventory Equipment Looping and Gender Assignment
    # -------------------------------------------------------------------------
    def test_party_assign_inventory_equipment_genders(self):
        """party.assign_inventory_equipment_genders loops through party inventory and assigns genders to equipment."""
        party = Party()
        # Add diverse items
        party.inventory = [
            {"item_id": "Potion", "qty": 5, "type": "consumable"},
            {"item_id": "Valkyrie Mail", "qty": 1, "type": "equipment"},
            {"item_id": "King's Greathelm", "qty": 1, "type": "equipment"},
            {"item_id": "Iron Longsword", "qty": 2, "type": "equipment"},
            {"item_id": "Hi-Ether", "qty": 3, "type": "consumable"},
        ]

        assignments = party.assign_inventory_equipment_genders()

        # Equipment items assigned
        self.assertEqual(assignments["Valkyrie Mail"], Gender.FEMALE)
        self.assertEqual(assignments["King's Greathelm"], Gender.MALE)
        self.assertEqual(assignments["Iron Longsword"], Gender.UNISEX)

        # Consumables excluded from assignments
        self.assertNotIn("Potion", assignments)
        self.assertNotIn("Hi-Ether", assignments)

        # Inventory entries updated with target_gender
        inv_map = {e["item_id"]: e for e in party.inventory}
        self.assertEqual(inv_map["Valkyrie Mail"].get("target_gender"), "Female")
        self.assertEqual(inv_map["King's Greathelm"].get("target_gender"), "Male")
        self.assertEqual(inv_map["Iron Longsword"].get("target_gender"), "Unisex")
        self.assertNotIn("target_gender", inv_map["Potion"])

    def test_party_add_item_assigns_equipment_gender(self):
        """Adding equipment to party inventory automatically infers and assigns target_gender."""
        party = Party()
        party.add_item("Queen's Tiara", 1, item_type="equipment")
        party.add_item("Barbarian Harness", 1, item_type="equipment")
        party.add_item("Oak Staff", 1, item_type="equipment")

        inv_map = {e["item_id"]: e for e in party.inventory}
        self.assertEqual(inv_map["Queen's Tiara"].get("target_gender"), "Female")
        self.assertEqual(inv_map["Barbarian Harness"].get("target_gender"), "Male")
        self.assertEqual(inv_map["Oak Staff"].get("target_gender"), "Unisex")


if __name__ == "__main__":
    unittest.main()

