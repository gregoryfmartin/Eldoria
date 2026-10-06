"""
Unit and Integration Tests for Eldoria's Questing Subsystem:
- QuestStep primitives (Gold, Items, Enemies, Damage, Baselines)
- LinearQuest vs NonlinearQuest gating behavior
- StorylineQuestline vs SideQuestline (Spoils, Win Condition)
- QuestManager governor, event dispatching, and tracked artifact resolution
- Storyline boss scaling by map size (Classic 4, Quick 11, Standard 16)
- NPC Side Quest lifecycle (Offer -> Accept -> In Progress -> Turn-in -> Completed)
- Party & SaveManager serialization and state persistence
- Main Menu Quests accordion UI, tree expansion, tracking, and hierarchical escape
"""
import unittest
from unittest.mock import patch, MagicMock

from eldoria_py.core.context import Context
from eldoria_py.terminal.input import KeyEvent, KeyCode
from eldoria_py.combat.entities import PartyMember, Party, EnemyCombatant, EnemySquad, create_default_party
from eldoria_py.combat.stats import StatId, BattleActionType
from eldoria_py.terminal.color import TrueColor
from eldoria_py.procgen.npc import NPC, NPCRole, DialogCategory
from eldoria_py.ui.npc_dialog import DialogState
from eldoria_py.quests.step import QuestStep, QuestStepType
from eldoria_py.quests.quest import Quest, LinearQuest, NonlinearQuest
from eldoria_py.quests.questline import QuestRewards, Questline, StorylineQuestline, SideQuestline
from eldoria_py.quests.manager import QuestManager
from eldoria_py.quests.generator import (
    build_storyline_questline,
    create_side_quest_for_npc,
    SIDE_QUEST_TEMPLATES,
)
from eldoria_py.states.main_menu_screen import GSMainMenuScreen
from eldoria_py.states.test_noise_map import GSNoiseMapTestScreen
from eldoria_py.core.save_manager import SaveManager
from eldoria_py.terminal.box import visible_width


class TestQuestingSubsystem(unittest.TestCase):
    def setUp(self):
        self.party = create_default_party()
        self.party.inventory.clear()

    # -------------------------------------------------------------------------
    # 1. QuestStep Primitives
    # -------------------------------------------------------------------------
    def test_quest_step_obtain_and_spend_gold(self):
        """Verifies gold delta tracking for OBTAIN_GOLD and SPEND_GOLD."""
        step_earn = QuestStep(
            step_id="step_earn_100",
            description="Earn 100 gold",
            step_type=QuestStepType.OBTAIN_GOLD,
            target_count=100,
            is_active=True,
        )
        step_spend = QuestStep(
            step_id="step_spend_50",
            description="Spend 50 gold",
            step_type=QuestStepType.SPEND_GOLD,
            target_count=50,
            is_active=True,
        )

        # Gain 40 gold
        step_earn.evaluate_event("GOLD_CHANGED", {"delta": 40, "is_gain": True})
        self.assertEqual(step_earn.current_progress, 40)
        self.assertFalse(step_earn.is_completed)

        # Spending gold should not progress OBTAIN_GOLD
        step_earn.evaluate_event("GOLD_CHANGED", {"delta": 30, "is_gain": False})
        self.assertEqual(step_earn.current_progress, 40)

        # Spending progresses SPEND_GOLD
        step_spend.evaluate_event("GOLD_CHANGED", {"delta": 30, "is_gain": False})
        self.assertEqual(step_spend.current_progress, 30)
        self.assertFalse(step_spend.is_completed)

        # Complete both
        step_earn.evaluate_event("GOLD_CHANGED", {"delta": 70, "is_gain": True})
        self.assertTrue(step_earn.is_completed)
        self.assertEqual(step_earn.formatted_progress, "✔ Completed")

        step_spend.evaluate_event("GOLD_CHANGED", {"delta": 25, "is_gain": False})
        self.assertTrue(step_spend.is_completed)

    def test_quest_step_inventory_items(self):
        """Verifies OBTAIN_ITEM and OBTAIN_ITEMS check inventory quotas."""
        self.party.inventory.clear()
        step_item = QuestStep(
            step_id="step_potion",
            description="Collect 3 Potions",
            step_type=QuestStepType.OBTAIN_ITEM,
            target_name="Potion",
            target_count=3,
            is_active=True,
        )
        step_items = QuestStep(
            step_id="step_multi",
            description="Collect 2 Herbs and 1 Ether",
            step_type=QuestStepType.OBTAIN_ITEMS,
            target_dict={"Antidote": 2, "Ether": 1},
            is_active=True,
        )

        # Add 2 Potions
        self.party.add_item("Potion", 2)
        step_item.check_inventory(self.party)
        self.assertEqual(step_item.current_progress, 2)
        self.assertFalse(step_item.is_completed)

        # Add 1 more Potion
        self.party.add_item("Potion", 1)
        step_item.check_inventory(self.party)
        self.assertTrue(step_item.is_completed)

        # Test multi-item
        self.party.add_item("Antidote", 2)
        step_items.check_inventory(self.party)
        self.assertFalse(step_items.is_completed)
        self.party.add_item("Ether", 1)
        step_items.check_inventory(self.party)
        self.assertTrue(step_items.is_completed)

    def test_quest_step_enemies_and_damage(self):
        """Verifies DEFEAT_ENEMY, DEFEAT_ENEMIES, and DEAL_DAMAGE events."""
        step_kill = QuestStep(
            step_id="step_kill_bat",
            description="Defeat 2 Bats",
            step_type=QuestStepType.DEFEAT_ENEMY,
            target_name="Bat",
            target_count=2,
            is_active=True,
        )
        step_dmg = QuestStep(
            step_id="step_dmg",
            description="Deal 200 damage",
            step_type=QuestStepType.DEAL_DAMAGE,
            target_count=200,
            is_active=True,
        )

        step_kill.evaluate_event("ENEMY_DEFEATED", {"enemy_name": "Goblin", "count": 1})
        self.assertEqual(step_kill.current_progress, 0)
        step_kill.evaluate_event("ENEMY_DEFEATED", {"enemy_name": "Bat", "count": 1})
        self.assertEqual(step_kill.current_progress, 1)
        self.assertFalse(step_kill.is_completed)
        step_kill.evaluate_event("ENEMY_DEFEATED", {"enemy_name": "Bat", "count": 1})
        self.assertTrue(step_kill.is_completed)

        step_dmg.evaluate_event("DAMAGE_DEALT", {"damage": 120})
        self.assertEqual(step_dmg.current_progress, 120)
        self.assertFalse(step_dmg.is_completed)
        step_dmg.evaluate_event("DAMAGE_DEALT", {"damage": 90})
        self.assertTrue(step_dmg.is_completed)

    # -------------------------------------------------------------------------
    # 2. Linear vs Nonlinear Quest Gating
    # -------------------------------------------------------------------------
    def test_linear_quest_sequential_gating(self):
        """Verifies LinearQuest gates lower-order steps until higher-order steps complete."""
        s1 = QuestStep("s1", "Step 1", QuestStepType.DEFEAT_ENEMY, target_name="Wolf", target_count=1)
        s2 = QuestStep("s2", "Step 2", QuestStepType.DEFEAT_ENEMY, target_name="Bear", target_count=1)
        s3 = QuestStep("s3", "Step 3", QuestStepType.DEFEAT_ENEMY, target_name="Dragon", target_count=1)

        quest = LinearQuest("q_hunt", "Big Game Hunt", steps=[s1, s2, s3])

        # Step 1 should be active; steps 2 and 3 inactive
        self.assertTrue(s1.is_active)
        self.assertFalse(s2.is_active)
        self.assertFalse(s3.is_active)

        # Killing Bear or Dragon before Wolf should have zero effect
        quest.notify("ENEMY_DEFEATED", {"enemy_name": "Bear", "count": 1})
        self.assertFalse(s2.is_completed)
        self.assertEqual(s2.current_progress, 0)

        # Slaying Wolf completes Step 1 and immediately activates Step 2
        quest.notify("ENEMY_DEFEATED", {"enemy_name": "Wolf", "count": 1})
        self.assertTrue(s1.is_completed)
        self.assertTrue(s2.is_active)
        self.assertFalse(s3.is_active)
        self.assertFalse(quest.is_completed)

        # Slaying Bear completes Step 2 and activates Step 3
        quest.notify("ENEMY_DEFEATED", {"enemy_name": "Bear", "count": 1})
        self.assertTrue(s2.is_completed)
        self.assertTrue(s3.is_active)

        # Slaying Dragon completes Step 3 and the Quest
        quest.notify("ENEMY_DEFEATED", {"enemy_name": "Dragon", "count": 1})
        self.assertTrue(s3.is_completed)
        self.assertTrue(quest.is_completed)

    def test_nonlinear_quest_parallel_gating(self):
        """Verifies NonlinearQuest permits steps to be satisfied in any order."""
        s1 = QuestStep("s1", "Find Ruby", QuestStepType.OBTAIN_ITEM, target_name="Ruby", target_count=1)
        s2 = QuestStep("s2", "Find Sapphire", QuestStepType.OBTAIN_ITEM, target_name="Sapphire", target_count=1)

        quest = NonlinearQuest("q_gems", "Gem Collector", steps=[s1, s2])
        self.assertTrue(s1.is_active)
        self.assertTrue(s2.is_active)

        # Satisfy Step 2 first
        self.party.add_item("Sapphire", 1)
        quest.notify("INVENTORY_CHANGED", {}, party=self.party)
        self.assertTrue(s2.is_completed)
        self.assertFalse(s1.is_completed)
        self.assertFalse(quest.is_completed)

        # Satisfy Step 1 second
        self.party.add_item("Ruby", 1)
        quest.notify("INVENTORY_CHANGED", {}, party=self.party)
        self.assertTrue(s1.is_completed)
        self.assertTrue(quest.is_completed)

    # -------------------------------------------------------------------------
    # 3. Storyline vs Side Questlines & Spoils
    # -------------------------------------------------------------------------
    def test_side_questline_rewards_claim(self):
        """Verifies SideQuestline awards spoils upon completion and cannot double-claim."""
        s = QuestStep("s_gold", "Earn 50 Gold", QuestStepType.OBTAIN_GOLD, target_count=50)
        q = LinearQuest("q_sub", "Subquest", steps=[s])
        rewards = QuestRewards(gold=150, xp=100, items=[("Hi-Potion", 2)])
        sq = SideQuestline(
            questline_id="sq_test",
            title="Mercenary Contract",
            rewards=rewards,
            quests=[q],
        )

        initial_gold = self.party.gold
        # Cannot claim uncompleted quest
        self.assertFalse(sq.is_completed)
        sq.claim_rewards(self.party)
        self.assertEqual(self.party.gold, initial_gold)

        # Complete quest
        sq.notify("GOLD_CHANGED", {"delta": 60, "is_gain": True}, party=self.party)
        self.assertTrue(sq.is_completed)

        # Claim rewards
        summary = sq.claim_rewards(self.party)
        self.assertEqual(summary["gold_awarded"], 150)
        self.assertEqual(self.party.gold, initial_gold + 150)
        self.assertEqual(self.party.get_item_count("Hi-Potion"), 2)
        self.assertTrue(sq.is_reward_claimed)

        # Subsequent claims have no effect
        second_claim = sq.claim_rewards(self.party)
        self.assertEqual(second_claim, {})
        self.assertEqual(self.party.gold, initial_gold + 150)

    # -------------------------------------------------------------------------
    # 4. QuestManager Governor & Event Dispatching
    # -------------------------------------------------------------------------
    def test_quest_manager_governor_and_tracked_artifact(self):
        """Verifies QuestManager registration, tracked artifact resolution, and event dispatch."""
        storyline = build_storyline_questline("classic")
        qm = QuestManager(storyline=storyline)

        # Default tracked artifact should resolve to Storyline -> Quest 1 -> Step 1 (Rattus)
        ql, q, s = qm.get_tracked_artifact()
        self.assertEqual(ql.questline_id, "storyline_main")
        self.assertEqual(s.target_name, "Rattus")

        # Register a Side Quest
        sq, _ = create_side_quest_for_npc(
            npc_id="npc_alchemist",
            npc_name="Alchemist Jerry",
            location_name="Oakhaven",
            template_idx=0,  # Potion quest
        )
        self.assertTrue(qm.register_side_questline(sq, party=self.party))
        # Cannot re-register duplicate
        self.assertFalse(qm.register_side_questline(sq, party=self.party))

        # Switch tracked artifact to Side Questline
        qm.set_tracked_artifact(sq.questline_id)
        ql2, q2, s2 = qm.get_tracked_artifact()
        self.assertEqual(ql2.questline_id, sq.questline_id)
        self.assertEqual(s2.target_name, "Potion")

        # Event dispatching
        self.party.add_item("Potion", 2)
        qm.notify_inventory_changed(party=self.party)
        self.assertTrue(s2.is_completed)
        self.assertTrue(sq.is_completed)

    # -------------------------------------------------------------------------
    # 5. Storyline Boss Scaling by Map Size
    # -------------------------------------------------------------------------
    def test_storyline_scaling_and_game_completion(self):
        """Verifies boss count scales to macro size and final boss completes the campaign."""
        # Classic: 4 bosses
        story_classic = build_storyline_questline("classic")
        self.assertEqual(len(story_classic.quests[0].steps), 4)
        self.assertEqual(story_classic.quests[0].steps[-1].target_name, "Broodfang")

        # Quick: 11 bosses
        story_quick = build_storyline_questline("quick")
        self.assertEqual(len(story_quick.quests[0].steps), 11)

        # Standard: 16 bosses culminating in Malakor
        story_standard = build_storyline_questline("standard")
        self.assertEqual(len(story_standard.quests[0].steps), 16)
        self.assertEqual(story_standard.quests[0].steps[-1].target_name, "Malakor")

        qm = QuestManager(storyline=story_classic)
        self.assertFalse(qm.is_game_completed)

        # Defeat all 4 bosses in sequence
        for boss in ["Rattus", "Grumble", "Brigand", "Broodfang"]:
            qm.notify_enemy_defeated(boss)

        self.assertTrue(story_classic.is_completed)
        self.assertTrue(qm.is_game_completed)

    # -------------------------------------------------------------------------
    # 6. NPC Side Quest Lifecycle
    # -------------------------------------------------------------------------
    def test_npc_side_quest_interaction_flow(self):
        """Verifies NPC dialog changes across the entire lifecycle: Offer -> In Progress -> Turn In -> Completed."""
        screen = GSNoiseMapTestScreen(map_width=54, map_height=24)
        screen.party = self.party
        qm = QuestManager(storyline=build_storyline_questline("classic"))
        self.party.quest_manager = qm

        # Create eligible citizen with quest template 0 (2 Potions)
        citizen = NPC(
            npc_id="citizen_apothecary",
            name="Apothecary Jerry",
            role=NPCRole.CITIZEN,
            glyph="c",
            fg_color=TrueColor(255, 255, 255),
            bg_color=TrueColor(0, 0, 0),
            side_quest_template_idx=0,
        )

        # 1. First interaction: Offer Quest (CHOICE)
        self.assertEqual(qm.get_npc_quest_status(citizen.npc_id), "NOT_REGISTERED")
        screen._start_npc_dialog(citizen)
        self.assertEqual(citizen.category, DialogCategory.CHOICE)
        self.assertIn("Could you gather 2 Potions", citizen.dialogue)
        self.assertEqual(len(screen.npc_dialog.choices), 2)

        # Advance through pages to reach choices without over-advancing
        guard = 0
        while screen.npc_dialog.state not in (
            DialogState.CHOICE_WAITING,
            DialogState.CLOSED,
            DialogState.FINISHED,
        ):
            guard += 1
            if guard > 50:
                self.fail("Infinite loop advancing dialog pages")
            if screen.npc_dialog.state == DialogState.TELETYPING:
                screen.npc_dialog.flush_page()
            elif screen.npc_dialog.state == DialogState.PAGE_WAITING:
                screen.npc_dialog.advance_or_act()
            else:
                break

        # Accept quest (Option 0: Yes)
        screen.npc_dialog.choice_cursor = 0
        screen.npc_dialog.advance_or_act()
        self.assertEqual(qm.get_npc_quest_status(citizen.npc_id), "IN_PROGRESS")
        self.assertIn("Quest Accepted", screen.last_status_msg)

        # 2. Second interaction: Still in progress (STANDARD)
        screen._start_npc_dialog(citizen)
        self.assertEqual(citizen.category, DialogCategory.STANDARD)
        self.assertIn("Have you gathered those 2 Potions yet?", citizen.dialogue)

        # 3. Fulfill condition: Add 2 Potions
        self.party.add_item("Potion", 2)
        self.assertEqual(qm.get_npc_quest_status(citizen.npc_id), "READY_TO_TURN_IN")

        # Third interaction: Turn in and receive spoils
        initial_gold = self.party.gold
        screen._start_npc_dialog(citizen)
        self.assertIn("Praise the Heavens", citizen.dialogue)
        self.assertIn("Quest Completed", screen.last_status_msg)
        self.assertEqual(qm.get_npc_quest_status(citizen.npc_id), "COMPLETED")
        self.assertGreater(self.party.gold, initial_gold)

        # 4. Subsequent interaction: Already completed, post-complete flavor
        screen._start_npc_dialog(citizen)
        self.assertEqual(citizen.category, DialogCategory.STANDARD)
        self.assertIn("made a full recovery", citizen.dialogue)

    def test_ineligible_npc_cannot_give_side_quest(self):
        """Verifies King, Innkeeper, and Shopkeepers cannot offer side quests."""
        screen = GSNoiseMapTestScreen(map_width=54, map_height=24)
        screen.party = self.party
        qm = QuestManager(storyline=build_storyline_questline("classic"))
        self.party.quest_manager = qm

        king = NPC(
            npc_id="king_1",
            name="King Aldous",
            role=NPCRole.KING,
            glyph="K",
            fg_color=TrueColor(255, 255, 255),
            bg_color=TrueColor(0, 0, 0),
            side_quest_template_idx=0,  # Even if template assigned, role must be respected
        )
        screen._start_npc_dialog(king)
        self.assertEqual(qm.get_npc_quest_status(king.npc_id), "NOT_REGISTERED")
        self.assertFalse(any(sq.originator_npc_id == king.npc_id for sq in qm.side_questlines))

    # -------------------------------------------------------------------------
    # 7. Serialization and Persistence
    # -------------------------------------------------------------------------
    def test_party_quest_manager_serialization_round_trip(self):
        """Verifies full round trip dictionary serialization of QuestManager within Party."""
        qm = QuestManager(storyline=build_storyline_questline("classic"))
        sq, _ = create_side_quest_for_npc("npc_1", "Jerry", template_idx=1)
        qm.register_side_questline(sq, party=self.party)
        self.party.quest_manager = qm

        party_dict = self.party.to_dict()
        self.assertIn("quest_manager", party_dict)

        restored_party = Party.from_dict(party_dict)
        self.assertIsNotNone(restored_party.quest_manager)
        self.assertEqual(restored_party.quest_manager.storyline.title, "The Fall of Malakor")
        self.assertEqual(len(restored_party.quest_manager.side_questlines), 1)
        self.assertEqual(restored_party.quest_manager.side_questlines[0].title, "Pest Control")

    # -------------------------------------------------------------------------
    # 8. Main Menu Accordion UI
    # -------------------------------------------------------------------------
    def test_main_menu_quest_accordion_navigation_and_rendering(self):
        """Verifies Main Menu accordion tree flattening, expand/collapse, tracking, and rendering."""
        menu = GSMainMenuScreen(party=self.party)
        qm = QuestManager(storyline=build_storyline_questline("classic"))
        sq, _ = create_side_quest_for_npc("npc_1", "Jerry", template_idx=0)
        qm.register_side_questline(sq, party=self.party)
        self.party.quest_manager = qm

        # Verify category inclusion
        self.assertIn("Quests", menu.CATEGORIES)
        menu.category_idx = menu.CATEGORIES.index("Quests")

        # Enter submenu
        menu._enter_submenu()
        self.assertEqual(menu.focus_mode, "SUBMENU")

        # Flat tree should have Storyline expanded by default
        tree = menu._build_flat_quest_tree()
        self.assertGreater(len(tree), 0)
        self.assertEqual(tree[0]["type"], "QUESTLINE")
        self.assertTrue(tree[0]["is_storyline"])

        # Test tracking toggle key (T)
        menu.quest_cursor = 0
        menu._handle_quests_input(KeyEvent(key=KeyCode.NONE, char="T"))
        self.assertIn("Tracking", menu.banner_message)

        # Test hierarchical escape
        step_indices = [i for i, n in enumerate(tree) if n["type"] == "STEP"]
        self.assertTrue(len(step_indices) > 0)
        menu.quest_cursor = step_indices[0]
        escaped = menu._handle_quests_escape()
        self.assertTrue(escaped)

        # Render submenu output
        lines = menu._render_quests_submenu()
        rendered_text = "".join(lines)
        self.assertIn("Quest Journal", rendered_text)
        self.assertIn("STORY", rendered_text)
        self.assertIn("The Fall of Malakor", rendered_text)

    def test_quest_submenu_refinements_and_dual_pane_layout(self):
        """
        Verifies visual refinements to Quest Submenu:
        - 34 total rows returned, each strictly 55 columns wide
        - Header directions removed from Quest Journal line
        - Active row line highlighting with slate-blue background and '❱' chevron
        - No parenthetical progress numbers '(0/16)' after quest names
        - Tracked quests show subtle star glyph instead of loud [📌 TRACKED]
        - Bottom half divided horizontally (row 16 divider with '┬') and vertically (col 27 '│')
        - Left bottom pane has paginated Lore & Summary
        - Right bottom pane has Current Status colored yellow
        - Quest titles adhere to <= 4 words constraint
        """
        menu = GSMainMenuScreen(party=self.party)
        qm = QuestManager(storyline=build_storyline_questline("classic"))
        sq, _ = create_side_quest_for_npc("npc_1", "Jerry", template_idx=0)
        qm.register_side_questline(sq, party=self.party)
        self.party.quest_manager = qm

        menu.category_idx = menu.CATEGORIES.index("Quests")
        menu._enter_submenu()

        # 1. Row count & Column width budget
        lines = menu._render_quests_submenu()
        self.assertEqual(len(lines), 34, f"Quests submenu should return exactly 34 rows, got {len(lines)}")
        for idx, l in enumerate(lines):
            self.assertEqual(visible_width(l), 55, f"Row {idx} visible width {visible_width(l)} != 55: {repr(l)}")

        # 2. Header: directions removed
        header_line = lines[0]
        self.assertIn("Quest Journal", header_line)
        self.assertNotIn("[Enter]", header_line)
        self.assertNotIn("[T]Track", header_line)
        self.assertNotIn("[Esc]", header_line)

        # 3. Active line highlighting & chevron '❱'
        active_line = lines[1]  # quest_cursor = 0
        self.assertIn("❱", active_line)
        self.assertIn("\033[48;2;25;55;85m", active_line)
        self.assertNotIn("►", active_line)

        # 4. Subtle star glyph for tracked quest (no [📌 TRACKED])
        full_text = "".join(lines)
        self.assertNotIn("[📌 TRACKED]", full_text)
        self.assertNotIn("[TRACKED]", full_text)

        # Pin side quest as tracked
        qm.set_tracked_artifact(questline_id=sq.questline_id)
        tracked_lines = menu._render_quests_submenu()
        tracked_text = "".join(tracked_lines)
        self.assertIn("★", tracked_text)
        self.assertNotIn("[📌 TRACKED]", tracked_text)

        # 5. No parenthetical numbers on Quest lines
        self.assertNotIn("(0/4)", full_text)
        self.assertNotIn("(0/16)", full_text)
        self.assertNotIn("(0/1)", full_text)

        # 6. Horizontal & vertical dividers
        div_row = lines[16]
        self.assertIn("┬", div_row)
        self.assertEqual(visible_width(div_row), 55)

        # 7. Bottom panes: Lore & Status
        bot_row_header = lines[17]
        self.assertIn("Lore & Summary", bot_row_header)
        self.assertIn("Current Status", bot_row_header)
        self.assertIn("│", bot_row_header)

        # Verify yellow coloring in status pane
        status_line = lines[19]
        self.assertIn("\033[33m", status_line)

        # 8. Lore pagination controls
        self.assertEqual(menu.quest_lore_page, 0)
        menu._handle_quests_input(KeyEvent(key=KeyCode.RIGHT))
        # Moving cursor resets page
        menu._handle_quests_input(KeyEvent(key=KeyCode.DOWN))
        self.assertEqual(menu.quest_lore_page, 0)

        # 9. Quest Title <= 4 words constraint
        for q in qm.storyline.quests:
            self.assertLessEqual(len(q.title.split()), 4, f"Story quest title exceeds 4 words: '{q.title}'")
        for side_ql in qm.side_questlines:
            for q in side_ql.quests:
                self.assertLessEqual(len(q.title.split()), 4, f"Side quest title exceeds 4 words: '{q.title}'")

    def test_story_quest_step_titles_and_display(self):
        """
        Verifies that Story Quest Steps have concise titles ('Defeat {Boss}'),
        their long descriptions remain preserved for the Directive panel,
        and backward compatibility fallback handles old saves.
        """
        qm = QuestManager(storyline=build_storyline_questline("classic"))
        self.party.quest_manager = qm

        # 1. Verify all story steps have short titles
        for step in qm.storyline.quests[0].steps:
            self.assertTrue(step.title.startswith("Defeat "))
            self.assertLessEqual(len(step.title.split()), 4)
            # Full narrative directive preserved in description
            self.assertTrue(len(step.description) > len(step.title))

        # 2. Verify flat quest tree displays concise title
        menu = GSMainMenuScreen(party=self.party)
        menu.category_idx = menu.CATEGORIES.index("Quests")
        menu._enter_submenu()

        # Expand Story Questline and Boss Quest
        menu.quest_expanded_nodes.add("storyline_main")
        menu.quest_expanded_nodes.add("quest_scourge_of_eldoria")

        flat_nodes = menu._build_flat_quest_tree()
        step_nodes = [n for n in flat_nodes if n["type"] == "STEP"]
        self.assertGreater(len(step_nodes), 0)
        first_step_node = step_nodes[0]
        self.assertEqual(first_step_node["title"], "Defeat Rattus")

        # 3. Position cursor on first step and verify rendering
        menu.quest_cursor = flat_nodes.index(first_step_node)
        lines = menu._render_quests_submenu()
        rendered_text = "\n".join(lines)

        # Tree displays "Defeat Rattus" without numeric suffix like [0/1]
        self.assertIn("Defeat Rattus", rendered_text)
        top_tree_text = "\n".join(lines[1:16])
        self.assertNotIn("[0/1]", top_tree_text)
        self.assertNotIn("[0/", top_tree_text)

        # Verify no digits in story step titles
        for s in qm.storyline.quests[0].steps:
            self.assertFalse(any(c.isdigit() for c in s.title), f"Digits found in step title: {s.title}")

        # Verify no digits in side quest step titles
        from eldoria_py.quests.generator import SIDE_QUEST_TEMPLATES
        for tpl in SIDE_QUEST_TEMPLATES:
            step_t = tpl.get("step_title", "")
            self.assertFalse(any(c.isdigit() for c in step_t), f"Digits found in side quest step_title: {step_t}")

        # Directive pane displays the full description
        self.assertIn("Directive:", rendered_text)
        self.assertIn("Vanquish Rattus", rendered_text)
        # Lore pane displays Rattus lore
        self.assertIn("Rattus", rendered_text)

        # 4. Completed step displays [✔] without numbers
        first_step_node["obj"].is_completed = True
        comp_lines = menu._render_quests_submenu()
        comp_tree_text = "\n".join(comp_lines[1:16])
        self.assertIn("[✔]", comp_tree_text)
        self.assertNotIn("[0/1]", comp_tree_text)

        # 5. Backwards compatibility: deserialize old step without title
        old_data = {
            "step_id": "step_boss_grumble",
            "description": "Vanquish Grumble in Sunken Grotto",
            "step_type": "DEFEAT_ENEMY",
            "target_name": "Grumble",
            "target_count": 1,
        }
        hydrated = QuestStep.from_dict(old_data)
        self.assertEqual(hydrated.title, "Defeat Grumble")

    def test_completed_quest_cannot_be_tracked(self):
        """
        Verifies that completed quests, questlines, and steps cannot be marked as tracked,
        both in QuestManager and via user input in GSMainMenuScreen.
        """
        qm = QuestManager(storyline=build_storyline_questline("classic"))
        sq, _ = create_side_quest_for_npc("npc_1", "Jerry", template_idx=0)
        qm.register_side_questline(sq, party=self.party)
        self.party.quest_manager = qm

        story_q1 = qm.storyline.quests[0]
        # Mark all steps of story_q1 complete
        for s in story_q1.steps:
            s.is_completed = True
        story_q1.check_completion()
        self.assertTrue(story_q1.is_completed)

        # 1. QuestManager.set_tracked_artifact rejects completed quest
        res = qm.set_tracked_artifact(qm.storyline.questline_id, quest_id=story_q1.quest_id)
        self.assertFalse(res)
        self.assertNotEqual(qm.tracked_quest_id, story_q1.quest_id)

        # QuestManager.set_tracked_artifact rejects completed step
        res_step = qm.set_tracked_artifact(
            qm.storyline.questline_id,
            quest_id=story_q1.quest_id,
            step_id=story_q1.steps[0].step_id,
        )
        self.assertFalse(res_step)

        # QuestManager.get_tracked_artifact automatically falls back away from completed quest
        ql, q, s = qm.get_tracked_artifact()
        self.assertNotEqual(q.quest_id if q else None, story_q1.quest_id)

        # Complete the side questline
        for s in sq.quests[0].steps:
            s.is_completed = True
        sq.quests[0].check_completion()
        sq.check_completion()
        self.assertTrue(sq.is_completed)

        # QuestManager.set_tracked_artifact rejects completed side questline
        res_ql = qm.set_tracked_artifact(sq.questline_id)
        self.assertFalse(res_ql)
        self.assertNotEqual(qm.tracked_questline_id, sq.questline_id)

        # 2. Main Menu UI: Trying to track completed quest
        menu = GSMainMenuScreen(party=self.party)
        menu.category_idx = menu.CATEGORIES.index("Quests")
        menu._enter_submenu()

        # Expand storyline so story_q1 is visible
        menu.quest_expanded_nodes.add(qm.storyline.questline_id)
        flat_tree = menu._build_flat_quest_tree()
        q1_indices = [i for i, n in enumerate(flat_tree) if n["id"] == story_q1.quest_id]
        self.assertTrue(len(q1_indices) > 0)
        q1_idx = q1_indices[0]
        self.assertTrue(flat_tree[q1_idx]["is_completed"])
        self.assertFalse(flat_tree[q1_idx]["is_tracked"])

        # Position cursor on completed quest and press 'T'
        menu.quest_cursor = q1_idx
        menu._handle_quests_input(KeyEvent(key=KeyCode.NONE, char="T"))
        self.assertIn("Cannot track a completed quest", menu.banner_message)

        # Press space on completed quest
        menu.banner_message = ""
        menu._handle_quests_input(KeyEvent(key=KeyCode.NONE, char=" "))
        self.assertIn("Cannot track a completed quest", menu.banner_message)

        # Verify quest is still not tracked in tree
        updated_tree = menu._build_flat_quest_tree()
        self.assertFalse(updated_tree[q1_idx]["is_tracked"])

        # Render submenu and verify star is not on the completed quest, and Pinned is No
        lines = menu._render_quests_submenu()
        rendered = "\n".join(lines)
        self.assertIn("Pinned:  No", rendered)
        self.assertNotIn("Pinned:  Yes ★", rendered)

        # 3. Trying to track completed step via Enter
        menu.quest_expanded_nodes.add(story_q1.quest_id)
        flat_tree_with_steps = menu._build_flat_quest_tree()
        step_indices = [i for i, n in enumerate(flat_tree_with_steps) if n["type"] == "STEP" and n["is_completed"]]
        self.assertTrue(len(step_indices) > 0)
        menu.quest_cursor = step_indices[0]
        menu._handle_quests_input(KeyEvent(key=KeyCode.ENTER))
        self.assertIn("Cannot track", menu.banner_message)
        tree_after_enter = menu._build_flat_quest_tree()
        self.assertFalse(tree_after_enter[step_indices[0]]["is_tracked"])

        # 4. Trying to track completed questline via 'T'
        sq_indices = [i for i, n in enumerate(flat_tree_with_steps) if n["id"] == sq.questline_id]
        self.assertTrue(len(sq_indices) > 0)
        menu.quest_cursor = sq_indices[0]
        menu._handle_quests_input(KeyEvent(key=KeyCode.NONE, char="T"))
        self.assertIn("Cannot track a completed questline", menu.banner_message)
        tree_after_ql_track = menu._build_flat_quest_tree()
        self.assertFalse(tree_after_ql_track[sq_indices[0]]["is_tracked"])


if __name__ == "__main__":
    unittest.main()

