"""
Factory and procedural generator for Storyline and Side Questlines in Eldoria.
Scales Storyline boss objectives to world macro dimensions and provisions
curated side quests for town and castle NPCs.
"""
from __future__ import annotations
from typing import List, Tuple
from .step import QuestStep, QuestStepType
from .quest import LinearQuest, NonlinearQuest
from .questline import StorylineQuestline, SideQuestline, QuestRewards
from ..procgen.world_macro import BOSS_CAVE_MAPPING


def build_storyline_questline(macro_size: str = "medium") -> StorylineQuestline:
    """
    Builds the canonical Storyline Questline scaled to the chosen world size.
    The questline consists of an ordered LinearQuest containing QuestSteps to defeat
    each territorial boss from least powerful to most powerful.
    """
    size_key = macro_size.lower().strip()
    if "4" in size_key or "classic" in size_key:
        # Classic / Prologue: 4 bosses
        boss_names = ["Rattus", "Grumble", "Brigand", "Broodfang"]
    elif "quick" in size_key or "small" in size_key or "6" in size_key:
        # Quick Campaign: 11 bosses up to Region 6
        boss_names = [
            b[0] for b in BOSS_CAVE_MAPPING if b[1] <= 6 and b[0] != "Magmadon"
        ]
    else:
        # Standard & Odyssey: All 16 bosses culminating in Malakor
        boss_names = [b[0] for b in BOSS_CAVE_MAPPING]

    # Build sequential QuestSteps in linear order
    steps: List[QuestStep] = []
    for idx, boss_name in enumerate(boss_names):
        # Look up region and cave if available
        cave_info = next((b for b in BOSS_CAVE_MAPPING if b[0] == boss_name), None)
        region_num = cave_info[1] if cave_info else (idx + 1)
        cave_name = cave_info[2] if cave_info else f"Dungeon {idx + 1}"

        is_final = (idx == len(boss_names) - 1)
        if is_final:
            desc = f"Defeat the Lord of Shadow, {boss_name}, in {cave_name}"
        else:
            desc = f"Vanquish {boss_name} lurking in {cave_name} (Region {region_num})"

        step = QuestStep(
            step_id=f"step_boss_{boss_name.lower()}",
            description=desc,
            step_type=QuestStepType.DEFEAT_ENEMY,
            target_name=boss_name,
            target_count=1,
            is_completed=False,
            is_active=(idx == 0),  # First step starts active
        )
        steps.append(step)

    boss_quest = LinearQuest(
        quest_id="quest_scourge_of_eldoria",
        title="Scourge of the Realm",
        description="Defeat each territorial boss in sequence to dismantle the dark curse.",
        steps=steps,
    )

    storyline = StorylineQuestline(
        questline_id="storyline_main",
        title="The Fall of Malakor",
        description="Liberate the realm of Eldoria by vanquishing the territorial bosses.",
        quests=[boss_quest],
    )
    return storyline


# -------------------------------------------------------------------------
# Curated Side Quest Templates
# -------------------------------------------------------------------------
SIDE_QUEST_TEMPLATES = [
    {
        "template_id": "sq_herbal_remedy",
        "title": "Apothecary's Request",
        "offer_dialogue": "Greetings, traveler! A persistent fever has gripped our villagers, and our herbal stores are empty. Could you gather 2 Potions to help us brew a remedy?",
        "in_progress_dialogue": "Have you gathered those 2 Potions yet? Our apothecary desperately needs them!",
        "turn_in_dialogue": "Praise the Heavens! You've brought the medicine! Please take this gold and these herbs for your trouble!",
        "post_complete_dialogue": "Thanks to you, our sick villagers have made a full recovery. May fortune favor your path!",
        "step_type": QuestStepType.OBTAIN_ITEM,
        "target_name": "Potion",
        "target_count": 2,
        "step_desc": "Gather 2 Potions for the town apothecary",
        "rewards": {"gold": 60, "xp": 40, "items": [("Hi-Potion", 1)]},
    },
    {
        "template_id": "sq_cave_crawler_cull",
        "title": "Pest Control",
        "offer_dialogue": "Hail! Giant bats have made nesting grounds near our roads and are harassing traders. Would you be willing to slay 3 Bats to clear the highway?",
        "in_progress_dialogue": "Have you thinned out those bats yet? The roads remain hazardous until you do.",
        "turn_in_dialogue": "Superb work! Our trade caravans can safely travel once more. Here is your promised bounty!",
        "post_complete_dialogue": "The merchant caravans have resumed their routes. We owe you a great debt.",
        "step_type": QuestStepType.DEFEAT_ENEMY,
        "target_name": "Bat",
        "target_count": 3,
        "step_desc": "Defeat 3 Bats along the trade routes",
        "rewards": {"gold": 80, "xp": 60, "items": [("Bomb", 2)]},
    },
    {
        "template_id": "sq_goblin_trouble",
        "title": "Goblin Skirmishers",
        "offer_dialogue": "Watch your step, friend! Goblins have been ambushing travelers along the forest outskirts. Slay 2 Goblins to push them back into the deep woods?",
        "in_progress_dialogue": "Have you driven off those goblins yet? Stay vigilant out there!",
        "turn_in_dialogue": "You vanquished them! The perimeter is secure again. Take this reward with our deepest gratitude!",
        "post_complete_dialogue": "The woods are peaceful again thanks to your blade. Travel safely!",
        "step_type": QuestStepType.DEFEAT_ENEMY,
        "target_name": "Goblin",
        "target_count": 2,
        "step_desc": "Defeat 2 Goblins in the wild",
        "rewards": {"gold": 100, "xp": 75, "items": [("Antidote", 2), ("Ether", 1)]},
    },
    {
        "template_id": "sq_combat_mastery",
        "title": "Trial of Strength",
        "offer_dialogue": "You bear the stance of a seasoned warrior, but how sharp is your steel? Deal at least 150 points of damage in battle to prove your martial prowess!",
        "in_progress_dialogue": "Have you struck with that 150 damage yet? Show me what you're truly capable of!",
        "turn_in_dialogue": "Magnificent display of force! You possess remarkable valor. Here is a relic fit for a true champion!",
        "post_complete_dialogue": "Your prowess in combat is unquestioned. I shall speak highly of your strength!",
        "step_type": QuestStepType.DEFEAT_ENEMY,
        "step_type_override": QuestStepType.DEAL_DAMAGE,
        "target_count": 150,
        "step_desc": "Deal 150 cumulative damage in battle",
        "rewards": {"gold": 120, "xp": 100, "items": [("Iron Sword", 1)]},
    },
]


def create_side_quest_for_npc(
    npc_id: str,
    npc_name: str,
    location_name: str = "Oakhaven",
    template_idx: int = 0,
) -> Tuple[SideQuestline, dict]:
    """
    Creates a SideQuestline tailored to a specific NPC and returns
    (SideQuestline, dialogue_dict).
    """
    idx = template_idx % len(SIDE_QUEST_TEMPLATES)
    tpl = SIDE_QUEST_TEMPLATES[idx]

    step_type = tpl.get("step_type_override", tpl.get("step_type", QuestStepType.DEFEAT_ENEMY))
    target_name = tpl.get("target_name", "")
    target_count = tpl.get("target_count", 1)

    step = QuestStep(
        step_id=f"step_{npc_id}_{tpl['template_id']}",
        description=tpl["step_desc"],
        step_type=step_type,
        target_name=target_name,
        target_count=target_count,
        is_completed=False,
        is_active=True,
    )

    quest = LinearQuest(
        quest_id=f"quest_{npc_id}_{tpl['template_id']}",
        title=tpl["title"],
        description=tpl["step_desc"],
        steps=[step],
    )

    rew_dict = tpl["rewards"]
    rewards = QuestRewards(
        gold=rew_dict.get("gold", 0),
        xp=rew_dict.get("xp", 0),
        items=rew_dict.get("items", []),
    )

    side_questline = SideQuestline(
        questline_id=f"sq_{npc_id}_{tpl['template_id']}",
        title=tpl["title"],
        description=tpl["step_desc"],
        originator_npc_id=npc_id,
        originator_name=npc_name,
        originator_location=location_name,
        rewards=rewards,
        quests=[quest],
    )

    dialogues = {
        "offer": tpl["offer_dialogue"],
        "in_progress": tpl["in_progress_dialogue"],
        "turn_in": tpl["turn_in_dialogue"],
        "completed": tpl["post_complete_dialogue"],
    }

    return side_questline, dialogues
