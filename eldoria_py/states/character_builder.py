"""
GSCharacterBuilderScreen: 6-substate character creation wizard matching Eldoria's specifications:
1. Name Entry (up to 14 chars with backspace)
2. Gender Selection (Male ♂ / Female ♀ with innate attribute modifiers)
3. 7-Stat Bonus Point Allocation (10-point bonus pool, R to re-roll)
4. Elemental Affinity Selection (Fire, Water, Earth, Wind, Light, Dark, Ice)
5. Profile / Portrait Selection (rendered via UIContainer portrait card)
6. Confirmation Dialog (attribute verification, commits to designated party slot)
Refactored to Eldoria's component UI framework (UIPanel, UIContainer, UIDivider, UILabel).
"""

from __future__ import annotations
import random
import textwrap
from enum import IntEnum
from typing import Dict, List, Optional, Tuple

from ..core.context import Context
from ..core.fsm import SMState
from ..terminal.ansi import ATCoordinates, ATControlSequences, ATDecoration
from ..terminal.color import ColorLibrary, TrueColor
from ..terminal.input import KeyCode
from ..terminal.screen import TerminalScreen
from ..combat.stats import StatId, BattleActionType, ELEMENT_AFFINITIES
from ..combat.actions import BattleAction, ACTIONS
from ..combat.equipment import EQUIPMENT_CATALOG
from ..combat.entities import PartyMember
from ..combat.portrait import (
    Gender,
    CharacterPortrait,
    get_portraits_for_gender,
)
from ..terminal.box import clear_buffer_tail, visible_width
from ..ui.panel import UIPanel
from ..ui.container import UIContainer
from ..ui.elements.label import UILabel
from ..ui.elements.divider import UIDivider


class CharacterBuilderSubstate(IntEnum):
    """Substates of the character creation wizard."""
    NAME_ENTRY = 0
    GENDER_SELECTION = 1
    POINT_ALLOCATION = 2
    AFFINITY_SELECTION = 3
    PROFILE_SELECTION = 4
    CONFIRMATION = 5


class GSCharacterBuilderScreen(SMState):
    """Interactive character creation wizard for configuring party members with UI controls."""

    STAT_KEYS: List[StatId] = [
        StatId.ATTACK,
        StatId.DEFENSE,
        StatId.MAGIC_ATTACK,
        StatId.MAGIC_DEFENSE,
        StatId.SPEED,
        StatId.ACCURACY,
        StatId.LUCK,
    ]

    STAT_LABELS: Dict[StatId, str] = {
        StatId.ATTACK: "ATK (Attack)",
        StatId.DEFENSE: "DEF (Defense)",
        StatId.MAGIC_ATTACK: "MAT (Magic Atk)",
        StatId.MAGIC_DEFENSE: "MDF (Magic Def)",
        StatId.SPEED: "SPD (Speed)",
        StatId.ACCURACY: "ACC (Accuracy)",
        StatId.LUCK: "LCK (Luck)",
    }

    AFFINITIES: List[Tuple[BattleActionType, str, str, TrueColor]] = [
        (info.affinity, info.name, info.glyph, info.color)
        for info in ELEMENT_AFFINITIES.values()
        if info.affinity.name.startswith("ELEMENTAL_")
    ]

    def __init__(self, screen_width: int = 80, screen_height: int = 24) -> None:
        super().__init__("GSCharacterBuilderScreen")
        self.screen_width: int = screen_width
        self.screen_height: int = screen_height

        # Target slot in party (0..4)
        self.target_slot: int = 0

        # Substate tracking
        self.substate: CharacterBuilderSubstate = CharacterBuilderSubstate.NAME_ENTRY
        self.substate_dirty: bool = False

        # Character attributes being configured
        self.char_name: str = "Hero"
        self.gender: Gender = Gender.MALE
        self.affinity_idx: int = 0
        self.profile_idx: int = 0

        # Stat rolls & bonus allocation
        self.base_stats: Dict[StatId, int] = {}
        self.mod_stats: Dict[StatId, int] = {k: 0 for k in self.STAT_KEYS}
        self.points_pool: int = 10
        self.selected_stat_idx: int = 0

        # Output result
        self.created_member: Optional[PartyMember] = None

        # Roll initial stats
        self._roll_base_stats()

        # Build UI Structure
        self._init_ui()

    @property
    def is_compact(self) -> bool:
        return self.screen_width < 70

    def _build_title(self) -> str:
        role_tag = "★ Party Leader" if self.target_slot == 0 else f"Slot {self.target_slot + 1}"
        return f"Character Creation [{role_tag}]"

    def _init_ui(self) -> None:
        panel_bottom = min(self.screen_height - 2, 22)

        # Master Outer Frame Panel (rows 1..22)
        self.main_panel = UIPanel(
            left_top=ATCoordinates(1, 1),
            right_bottom=ATCoordinates(panel_bottom, self.screen_width),
            title=self._build_title(),
            has_border=True,
        )
        self.main_panel.setup_title(self._build_title(), ColorLibrary.AppleCyanLight)
        footer_text = (
            "[Arrows]Nav [Enter]Confirm [Esc]Back"
            if self.is_compact
            else "[↑/↓/←/→]Navigate  [Enter]Next/Confirm  [Esc]Back"
        )
        self.main_panel.setup_footer(footer_text, ColorLibrary.AppleYellowLight)

        # Row 2: Step Progress Breadcrumbs
        bc_text = self._format_breadcrumbs()
        vlen = visible_width(bc_text)
        bc_col = self.main_panel.inner_left + max(0, (self.main_panel.inner_width - vlen) // 2)
        self.breadcrumbs_label = self.main_panel.add_label(
            bc_text,
            row=2,
            col=bc_col,
            fg_color=ColorLibrary.White,
        )

        # Row 3: Horizontal Divider
        self.divider_header = self.main_panel.add_divider(row=3)

        # Content area panels (rows 4..21, borderless)
        content_right = self.screen_width - 1
        content_bottom = min(self.screen_height - 3, 21)

        # 0. Name Entry Panel
        self.name_panel = UIPanel(
            left_top=ATCoordinates(4, 2),
            right_bottom=ATCoordinates(content_bottom, content_right),
            has_border=False,
        )
        self.name_panel.add_label("Enter Character Name (up to 4 characters):", row=5, align="center", fg_color=ColorLibrary.White, decorations=ATDecoration(bold=True))
        self.name_display_label = self.name_panel.add_label(f"Name: {self.char_name}_", row=7, align="center", fg_color=ColorLibrary.AppleGreenLight, decorations=ATDecoration(bold=True))
        name_help1 = (
            "Type name. [Backspace] deletes characters."
            if self.is_compact
            else "Type with keyboard. Press [Backspace] to delete characters."
        )
        name_help2 = (
            "[Enter] Confirm name  |  [Esc] Back to Party"
            if self.is_compact
            else "Press [Enter] to confirm name, [Esc] to return to Party Builder."
        )
        self.name_panel.add_label(name_help1, row=9, align="center", fg_color=ColorLibrary.DarkGrey)
        self.name_panel.add_label(name_help2, row=10, align="center", fg_color=ColorLibrary.DarkGrey)

        # 1. Gender Selection Panel
        self.gender_panel = UIPanel(
            left_top=ATCoordinates(4, 2),
            right_bottom=ATCoordinates(content_bottom, content_right),
            has_border=False,
        )
        self.gender_prompt_label = self.gender_panel.add_label(f"Select Gender for {self.char_name}:", row=5, align="center", fg_color=ColorLibrary.White, decorations=ATDecoration(bold=True))
        self.male_option_label = self.gender_panel.add_label(self._male_option_text(), row=7, align="center")
        self.female_option_label = self.gender_panel.add_label(self._female_option_text(), row=8, align="center")
        gender_help = (
            "[↑/↓] Select Gender  [Enter] Confirm  [Esc] Back"
            if self.is_compact
            else "Use [↑/↓] to select gender. [Enter] Confirm  [Esc] Back"
        )
        self.gender_panel.add_label(gender_help, row=10, align="center", fg_color=ColorLibrary.DarkGrey)

        # 2. Point Allocation Panel
        self.stats_panel = UIPanel(
            left_top=ATCoordinates(4, 2),
            right_bottom=ATCoordinates(content_bottom, content_right),
            has_border=False,
        )
        self.stats_pool_label = self.stats_panel.add_label(self._stats_pool_text(), row=4, col=self.main_panel.inner_left + 1)
        self.stat_row_labels: Dict[StatId, UILabel] = {}
        for idx, key in enumerate(self.STAT_KEYS):
            lbl = self.stats_panel.add_label(self._stat_row_text(key, idx), row=6 + idx, col=self.main_panel.inner_left + 1)
            self.stat_row_labels[key] = lbl
        formula_str = (
            "HP: 160+DEF*8+ATK*2 | MP: 30+MAT*8+MDF*3"
            if self.is_compact
            else "Formulas: HP = 160 + DEF*8 + ATK*2  |  MP = 30 + MAT*8 + MDF*3"
        )
        self.stats_panel.add_label(formula_str, row=14, col=self.main_panel.inner_left + 1, fg_color=ColorLibrary.DarkGrey)

        # 3. Affinity Selection Panel
        self.affinity_panel = UIPanel(
            left_top=ATCoordinates(4, 2),
            right_bottom=ATCoordinates(content_bottom, content_right),
            has_border=False,
        )
        self.affinity_panel.add_label("Choose Elemental Affinity:", row=4, col=self.main_panel.inner_left + 1, fg_color=ColorLibrary.White, decorations=ATDecoration(bold=True))
        self.affinity_row_labels: List[UILabel] = []
        for idx, (aff, name, glyph, col) in enumerate(self.AFFINITIES):
            lbl = self.affinity_panel.add_label(self._affinity_row_text(idx), row=6 + idx, col=self.main_panel.inner_left + 1)
            self.affinity_row_labels.append(lbl)

        # 4. Profile / Portrait Selection Panel
        self.profile_panel = UIPanel(
            left_top=ATCoordinates(4, 2),
            right_bottom=ATCoordinates(content_bottom, content_right),
            has_border=False,
        )
        self.profile_panel.add_label("Choose Character Portrait / Archetype:", row=4, align="center", fg_color=ColorLibrary.White, decorations=ATDecoration(bold=True))

        card_left = 6 if self.is_compact else 11
        cur_portrait = self.current_portrait
        self.portrait_card = UIPanel(
            left_top=ATCoordinates(6, card_left),
            right_bottom=ATCoordinates(8, card_left + 12),
            has_border=True,
        )
        self.portrait_card.border_draw_colors = [cur_portrait.accent_color for _ in range(8)]
        self.portrait_glyph_label = self.portrait_card.add_label(
            f"  {cur_portrait.glyph}  ",
            row=7,
            align="center",
            fg_color=cur_portrait.accent_color,
            decorations=ATDecoration(bold=True),
        )

        btn_left_col = 2 if self.is_compact else card_left - 5
        btn_right_col = 20 if self.is_compact else card_left + 14
        self.btn_left_label = self.profile_panel.add_label("[◄]", row=7, col=btn_left_col, fg_color=ColorLibrary.AppleYellowLight, decorations=ATDecoration(bold=True))
        self.btn_right_label = self.profile_panel.add_label("[►]", row=7, col=btn_right_col, fg_color=ColorLibrary.AppleYellowLight, decorations=ATDecoration(bold=True))

        name_col = 25 if self.is_compact else card_left + 19
        self.profile_name_label = self.profile_panel.add_label(self._profile_name_text(), row=7, col=name_col)

        if self.is_compact:
            desc_lines = textwrap.wrap(cur_portrait.description, width=min(48, self.profile_panel.inner_width))
            d1 = desc_lines[0] if len(desc_lines) > 0 else ""
            d2 = desc_lines[1] if len(desc_lines) > 1 else ""
        else:
            d1 = cur_portrait.description
            d2 = ""

        self.profile_desc_label_1 = self.profile_panel.add_label(d1, row=10, align="center", fg_color=ColorLibrary.DarkGrey)
        self.profile_desc_label_2 = self.profile_panel.add_label(d2, row=11, align="center", fg_color=ColorLibrary.DarkGrey)
        self.profile_desc_label = self.profile_desc_label_1

        nav_help = (
            "[←/→] Browse  [Enter] Select  [Esc] Back"
            if self.is_compact
            else "Use [←/→] to browse archetypes. [Enter] Select  [Esc] Back"
        )
        self.profile_panel.add_label(nav_help, row=13, align="center", fg_color=ColorLibrary.DarkGrey)

        # 5. Confirmation Panel
        self.confirm_panel = UIPanel(
            left_top=ATCoordinates(4, 2),
            right_bottom=ATCoordinates(content_bottom, content_right),
            has_border=False,
        )
        self.confirm_title_label = self.confirm_panel.add_label(self._confirm_title_text(), row=5, align="center", fg_color=ColorLibrary.White, decorations=ATDecoration(bold=True))
        self.confirm_class_label = self.confirm_panel.add_label(self._confirm_class_text(), row=6, align="center")
        self.confirm_vitality_label = self.confirm_panel.add_label(self._confirm_vitality_text(), row=7, align="center")
        self.confirm_attr1_label = self.confirm_panel.add_label(self._confirm_attr1_text(), row=9, align="center", fg_color=ColorLibrary.White)
        self.confirm_attr2_label = self.confirm_panel.add_label(self._confirm_attr2_text(), row=10, align="center", fg_color=ColorLibrary.White)
        confirm_help = (
            "[Enter] Save to Party  |  [Esc] Back to Profile"
            if self.is_compact
            else "[Enter] Save Character & Return to Party  |  [Esc] Back to Profile"
        )
        self.confirm_panel.add_label(
            confirm_help,
            row=12,
            align="center",
            fg_color=ColorLibrary.AppleYellowLight,
            decorations=ATDecoration(bold=True),
        )

        self._substate_panels: Dict[CharacterBuilderSubstate, UIPanel] = {
            CharacterBuilderSubstate.NAME_ENTRY: self.name_panel,
            CharacterBuilderSubstate.GENDER_SELECTION: self.gender_panel,
            CharacterBuilderSubstate.POINT_ALLOCATION: self.stats_panel,
            CharacterBuilderSubstate.AFFINITY_SELECTION: self.affinity_panel,
            CharacterBuilderSubstate.PROFILE_SELECTION: self.profile_panel,
            CharacterBuilderSubstate.CONFIRMATION: self.confirm_panel,
        }

        self.main_panel.activate()
        self.name_panel.activate()

    def _format_breadcrumbs(self) -> str:
        if self.is_compact:
            step_names = ["Name", "Gender", "Stats", "Affinity", "Profile", "Confirm"]
            cur_name = step_names[int(self.substate)]
            return f"Step {int(self.substate) + 1}/6: {cur_name}"
        else:
            steps = ["1. Name", "2. Gender", "3. Stats", "4. Affinity", "5. Profile", "6. Confirm"]
            step_strs = []
            for idx, s in enumerate(steps):
                if idx == int(self.substate):
                    step_strs.append(f"\033[1;33m[{s}]\033[0m")
                elif idx < int(self.substate):
                    step_strs.append(f"\033[32m✔{s}\033[0m")
                else:
                    step_strs.append(f"\033[90m{s}\033[0m")
            return " › ".join(step_strs)

    def _update_breadcrumbs(self) -> None:
        bc_text = self._format_breadcrumbs()
        vlen = visible_width(bc_text)
        bc_col = self.main_panel.inner_left + max(0, (self.main_panel.inner_width - vlen) // 2)
        self.breadcrumbs_label.coordinates = ATCoordinates(2, bc_col)
        self.breadcrumbs_label.set_user_data(bc_text)

    def _switch_substate(self, new_substate: CharacterBuilderSubstate) -> None:
        if self.substate in self._substate_panels:
            self._substate_panels[self.substate].deactivate()
        self.substate = new_substate
        self.substate_dirty = True
        self._update_breadcrumbs()

        if new_substate == CharacterBuilderSubstate.NAME_ENTRY:
            self._update_name_labels()
        elif new_substate == CharacterBuilderSubstate.GENDER_SELECTION:
            self._update_gender_labels()
        elif new_substate == CharacterBuilderSubstate.POINT_ALLOCATION:
            self._update_stats_labels()
        elif new_substate == CharacterBuilderSubstate.AFFINITY_SELECTION:
            self._update_affinity_labels()
        elif new_substate == CharacterBuilderSubstate.PROFILE_SELECTION:
            self._update_profile_labels()
        elif new_substate == CharacterBuilderSubstate.CONFIRMATION:
            self._update_confirm_labels()

        if self.substate in self._substate_panels:
            self._substate_panels[self.substate].activate()
            self._substate_panels[self.substate].set_all_dirty()

    # Label Formatting & Synchronization Helpers
    def _name_display_text(self) -> str:
        return f"Name: \033[1;32m{self.char_name}\033[1;33m_\033[0m"

    def _update_name_labels(self) -> None:
        text = self._name_display_text()
        vlen = visible_width(text)
        col = self.main_panel.inner_left + max(0, (self.main_panel.inner_width - vlen) // 2)
        self.name_display_label.coordinates = ATCoordinates(7, col)
        self.name_display_label.set_user_data(text)

    def _male_option_text(self) -> str:
        if self.is_compact:
            desc = "(+3 ATK, +2 DEF)"
        else:
            desc = "(+3 Attack, +2 Defense)"
        if self.gender == Gender.MALE:
            return f"\033[1;33m❱ \033[1;36m♂ Male\033[0m   \033[90m{desc}\033[0m"
        return f"  \033[90m♂ Male   {desc}\033[0m"

    def _female_option_text(self) -> str:
        if self.is_compact:
            desc = "(+2 MAT, +1 MDF, +2 SPD)"
        else:
            desc = "(+2 Magic Attack, +1 Magic Defense, +2 Speed)"
        if self.gender == Gender.FEMALE:
            return f"\033[1;33m❱ \033[1;35m♀ Female\033[0m \033[90m{desc}\033[0m"
        return f"  \033[90m♀ Female {desc}\033[0m"

    def _update_gender_labels(self) -> None:
        prompt = f"Select Gender for {self.char_name}:"
        vlen = visible_width(prompt)
        col = self.main_panel.inner_left + max(0, (self.main_panel.inner_width - vlen) // 2)
        self.gender_prompt_label.coordinates = ATCoordinates(5, col)
        self.gender_prompt_label.set_user_data(prompt)

        m_text = self._male_option_text()
        col_m = self.main_panel.inner_left + max(0, (self.main_panel.inner_width - visible_width(m_text)) // 2)
        self.male_option_label.coordinates = ATCoordinates(7, col_m)
        self.male_option_label.set_user_data(m_text)

        f_text = self._female_option_text()
        col_f = self.main_panel.inner_left + max(0, (self.main_panel.inner_width - visible_width(f_text)) // 2)
        self.female_option_label.coordinates = ATCoordinates(8, col_f)
        self.female_option_label.set_user_data(f_text)

    def _stats_pool_text(self) -> str:
        pool_color = "\033[1;32m" if self.points_pool > 0 else "\033[1;31m"
        if self.is_compact:
            return f"\033[1;37mPoints Left:\033[0m {pool_color}[ {self.points_pool:02d} ]\033[0m  \033[90m[R] Reroll  [←/→] Adjust\033[0m"
        return f"\033[1;37mBonus Points Left:\033[0m {pool_color}[ {self.points_pool:02d} ]\033[0m   \033[90m[R] Reroll Base Stats   [←/→] Adjust (-/+)\033[0m"

    def _stat_row_text(self, key: StatId, idx: int) -> str:
        base_v = self.base_stats.get(key, 10)
        mod_v = self.mod_stats.get(key, 0)
        tot_v = base_v + mod_v
        prefix = "\033[1;33m❱ \033[0m" if idx == self.selected_stat_idx else "  "
        mod_str = f"\033[32m+{mod_v:<2}\033[0m" if mod_v > 0 else "   "
        max_hp, max_mp = self._derive_hp_mp()

        if self.is_compact:
            short_lbl = key.value[:3].upper()
            extra = f" ➔ \033[36mHP:{max_hp}\033[0m" if key == StatId.DEFENSE else (f" ➔ \033[34mMP:{max_mp}\033[0m" if key == StatId.MAGIC_ATTACK else "")
            return f"{prefix}\033[37m{short_lbl:<3}\033[0m: \033[1;36m{tot_v:>2}\033[0m (Base:{base_v:>2} {mod_str}){extra}"
        else:
            label = self.STAT_LABELS[key]
            extra = f"  \033[36m➔ Live Max HP: {max_hp}\033[0m" if key == StatId.DEFENSE else (f"  \033[34m➔ Live Max MP: {max_mp}\033[0m" if key == StatId.MAGIC_ATTACK else "")
            return f"{prefix}\033[37m{label:<16}\033[0m: \033[1;36m{tot_v:>2}\033[0m  (Base: {base_v:>2} {mod_str}){extra}"

    def _update_stats_labels(self) -> None:
        self.stats_pool_label.set_user_data(self._stats_pool_text())
        for idx, key in enumerate(self.STAT_KEYS):
            if key in self.stat_row_labels:
                self.stat_row_labels[key].set_user_data(self._stat_row_text(key, idx))

    def _affinity_row_text(self, idx: int) -> str:
        aff, name, glyph, col = self.AFFINITIES[idx]
        prefix = "\033[1;33m❱ \033[0m" if idx == self.affinity_idx else "  "
        descriptions_compact = {
            "Fire": "Devastating burst flame damage",
            "Water": "Party restoration & torrents",
            "Earth": "Geological armor & crushing strikes",
            "Wind": "Speed, evasion & critical strikes",
            "Light": "Divine support, cleansing & smite",
            "Dark": "Shadow siphon, drain & decay",
            "Ice": "Glacial stasis & chilling frost",
        }
        descriptions_wide = {
            "Fire": "Ignites foes with burst flame devastation and burn damage",
            "Water": "Flowing torrents and rejuvenating party restoration",
            "Earth": "Immovable geological armor and heavy crushing earth strikes",
            "Wind": "Gale-force speed, evasion, and multi-hit critical strikes",
            "Light": "Radiant divine support, status cleansing, and holy smite",
            "Dark": "Forbidden shadow siphon, draining lifeforce and dark decay",
            "Ice": "Glacial stasis, chilling frost, and armor-piercing icicles",
        }
        desc = (descriptions_compact if self.is_compact else descriptions_wide).get(name, "")
        return f"{prefix}{col.to_ansi_fg()}{glyph} {name:<8}\033[0m  \033[90m{desc}\033[0m"

    def _update_affinity_labels(self) -> None:
        for idx in range(len(self.AFFINITIES)):
            if idx < len(self.affinity_row_labels):
                self.affinity_row_labels[idx].set_user_data(self._affinity_row_text(idx))

    def _profile_name_text(self) -> str:
        catalog = get_portraits_for_gender(self.gender)
        cur = catalog[self.profile_idx % len(catalog)]
        return f"\033[1;37m{cur.name}\033[0m  \033[36m[{self.profile_idx + 1}/{len(catalog)}]\033[0m"

    def _update_profile_labels(self) -> None:
        catalog = get_portraits_for_gender(self.gender)
        cur = catalog[self.profile_idx % len(catalog)]
        self.portrait_card.set_border_color(cur.accent_color)
        self.portrait_glyph_label.fg_color = cur.accent_color
        self.portrait_glyph_label.set_user_data(f"  {cur.glyph}  ")
        self.profile_name_label.set_user_data(self._profile_name_text())

        if self.is_compact:
            desc_lines = textwrap.wrap(cur.description, width=min(48, self.profile_panel.inner_width))
            d1 = desc_lines[0] if len(desc_lines) > 0 else ""
            d2 = desc_lines[1] if len(desc_lines) > 1 else ""
        else:
            d1 = cur.description
            d2 = ""

        c1 = self.profile_panel.inner_left + max(0, (self.profile_panel.inner_width - visible_width(d1)) // 2)
        self.profile_desc_label_1.coordinates = ATCoordinates(10, c1)
        self.profile_desc_label_1.set_user_data(d1)

        c2 = self.profile_panel.inner_left + max(0, (self.profile_panel.inner_width - visible_width(d2)) // 2)
        self.profile_desc_label_2.coordinates = ATCoordinates(11, c2)
        self.profile_desc_label_2.set_user_data(d2)

    def _confirm_title_text(self) -> str:
        return f"Character Summary: \033[1;32m{self.char_name}\033[0m  ({self.gender.value})"

    def _confirm_class_text(self) -> str:
        _, aff_name, aff_glyph, aff_col = self.current_affinity
        portrait = self.current_portrait
        if self.is_compact:
            return f"\033[36m{aff_name} {portrait.name.split()[-1]}\033[0m  {aff_col.to_ansi_fg()}{aff_glyph} {aff_name}\033[0m"
        return f"Class: \033[36m{aff_name} {portrait.name.split()[-1]}\033[0m     Affinity: {aff_col.to_ansi_fg()}{aff_glyph} {aff_name}\033[0m     Archetype: \033[33m{portrait.name}\033[0m"

    def _confirm_vitality_text(self) -> str:
        max_hp, max_mp = self._derive_hp_mp()
        return f"Vitality: \033[1;32mHP: {max_hp}\033[0m        \033[1;34mMP: {max_mp}\033[0m"

    def _confirm_attr1_text(self) -> str:
        s = [f"{k[:3].upper()}:{self.base_stats[k] + self.mod_stats[k]:>2}" for k in self.STAT_KEYS[:4]]
        return "Attributes: " + "   ".join(s)

    def _confirm_attr2_text(self) -> str:
        s = [f"{k[:3].upper()}:{self.base_stats[k] + self.mod_stats[k]:>2}" for k in self.STAT_KEYS[4:]]
        pad = " " * 12
        return pad + "   ".join(s)

    def _update_confirm_labels(self) -> None:
        self.confirm_title_label.set_user_data(self._confirm_title_text())
        self.confirm_class_label.set_user_data(self._confirm_class_text())
        self.confirm_vitality_label.set_user_data(self._confirm_vitality_text())
        self.confirm_attr1_label.set_user_data(self._confirm_attr1_text())
        self.confirm_attr2_label.set_user_data(self._confirm_attr2_text())

    def set_target_slot(
        self, slot_index: int, existing_member: Optional[PartyMember] = None
    ) -> None:
        """Sets the active slot to configure and pre-fills values if editing."""
        self.target_slot = max(0, min(4, slot_index))
        self.created_member = None

        if existing_member is not None:
            self.char_name = existing_member.name
            self.gender = existing_member.gender
            for idx, (aff, _, _, _) in enumerate(self.AFFINITIES):
                if aff == existing_member.affinity:
                    self.affinity_idx = idx
                    break
            else:
                self.affinity_idx = 0
            self.profile_idx = max(0, min(5, existing_member.profile_image_index))
            self.base_stats = {k: existing_member.stats[k].base for k in self.STAT_KEYS}
            self.mod_stats = {k: 0 for k in self.STAT_KEYS}
            self.points_pool = 10
        else:
            default_names = ["Aide", "Lyra", "Garr", "Vesp", "Sera"]
            self.char_name = (
                default_names[self.target_slot]
                if self.target_slot < len(default_names)
                else f"Hro{self.target_slot + 1}"
            )
            self.gender = Gender.MALE if self.target_slot % 2 == 0 else Gender.FEMALE
            self.affinity_idx = self.target_slot % len(self.AFFINITIES)
            self.profile_idx = self.target_slot % 6
            self._roll_base_stats()

        self.main_panel.setup_title(self._build_title(), ColorLibrary.AppleCyanLight)
        self._switch_substate(CharacterBuilderSubstate.NAME_ENTRY)

    def _roll_base_stats(self) -> None:
        """Rolls base stats in [3, 14] and applies innate gender modifiers."""
        self.base_stats = {k: random.randint(3, 14) for k in self.STAT_KEYS}
        # Accuracy is a percentile combat stat with standard 82-88 baseline in Eldoria
        self.base_stats[StatId.ACCURACY] = 82 + random.randint(0, 6)
        if self.gender == Gender.MALE:
            self.base_stats[StatId.ATTACK] += 3
            self.base_stats[StatId.DEFENSE] += 2
        elif self.gender == Gender.FEMALE:
            self.base_stats[StatId.MAGIC_ATTACK] += 2
            self.base_stats[StatId.MAGIC_DEFENSE] += 1
            self.base_stats[StatId.SPEED] += 2

        self.mod_stats = {k: 0 for k in self.STAT_KEYS}
        self.points_pool = 10
        self.selected_stat_idx = 0

    @property
    def current_affinity(self) -> Tuple[BattleActionType, str, str, TrueColor]:
        return self.AFFINITIES[self.affinity_idx % len(self.AFFINITIES)]

    @property
    def current_portrait(self) -> CharacterPortrait:
        catalog = get_portraits_for_gender(self.gender)
        return catalog[self.profile_idx % len(catalog)]

    def _derive_hp_mp(self) -> Tuple[int, int]:
        def_val = self.base_stats.get(StatId.DEFENSE, 10) + self.mod_stats.get(StatId.DEFENSE, 0)
        atk_val = self.base_stats.get(StatId.ATTACK, 10) + self.mod_stats.get(StatId.ATTACK, 0)
        mat_val = self.base_stats.get(StatId.MAGIC_ATTACK, 10) + self.mod_stats.get(StatId.MAGIC_ATTACK, 0)
        mdf_val = self.base_stats.get(StatId.MAGIC_DEFENSE, 10) + self.mod_stats.get(StatId.MAGIC_DEFENSE, 0)

        max_hp = 160 + (def_val * 8) + (atk_val * 2)
        max_mp = 16 + (mat_val * 2) + int(mdf_val * 0.75)
        return max_hp, max_mp

    def _build_combatant(self) -> PartyMember:
        max_hp, max_mp = self._derive_hp_mp()
        aff, aff_name, _, _ = self.current_affinity
        portrait = self.current_portrait

        final_stats: Dict[StatId, int] = {
            StatId.HIT_POINTS: max_hp,
            StatId.MAGIC_POINTS: max_mp,
        }
        for k in self.STAT_KEYS:
            final_stats[k] = self.base_stats[k] + self.mod_stats[k]

        actions: List[BattleAction] = [ACTIONS["Attack"].copy(), ACTIONS["Defend"].copy()]
        if aff == BattleActionType.ELEMENTAL_FIRE:
            actions.append(ACTIONS["FlamePunch"].copy() if "FlamePunch" in ACTIONS else ACTIONS["Flame Punch"].copy())
            actions.append(ACTIONS["Fireball"].copy())
        elif aff == BattleActionType.ELEMENTAL_WATER:
            actions.append(ACTIONS["Tidal Crush"].copy())
            actions.append(ACTIONS["Ice Bolt"].copy())
        elif aff == BattleActionType.ELEMENTAL_EARTH:
            actions.append(ACTIONS["Boulder Bash"].copy())
            actions.append(ACTIONS["Drop Kick"].copy())
        elif aff == BattleActionType.ELEMENTAL_WIND:
            actions.append(ACTIONS["Galeflash"].copy())
            actions.append(ACTIONS["Double Scratch"].copy())
        elif aff == BattleActionType.ELEMENTAL_LIGHT:
            actions.append(ACTIONS["Radiance"].copy())
            actions.append(ACTIONS["Heal"].copy())
        elif aff == BattleActionType.ELEMENTAL_DARK:
            actions.append(ACTIONS["Dark Surge"].copy())
            actions.append(ACTIONS["Double Scratch"].copy())
        elif aff == BattleActionType.ELEMENTAL_ICE:
            actions.append(ACTIONS["Ice Bolt"].copy())
            actions.append(ACTIONS["Arctic Blast"].copy())
        else:
            actions.append(ACTIONS["Axe Cleave"].copy())

        member = PartyMember(
            name=self.char_name.strip() or f"Hero {self.target_slot + 1}",
            job_class=f"{aff_name} {portrait.name.split()[-1]}",
            level=1,
            affinity=aff,
            base_stats=final_stats,
            actions=actions,
            gender=self.gender,
            profile_image_index=self.profile_idx,
        )

        # Equip starter archetype gear matching class profile
        p_name = portrait.name.lower()
        if any(k in p_name for k in ("mage", "scholar", "sorceress")):
            member.equip(EQUIPMENT_CATALOG["Oak Staff"])
            member.equip(EQUIPMENT_CATALOG["Mage Circlet"])
        elif any(k in p_name for k in ("priest", "paladin")):
            member.equip(EQUIPMENT_CATALOG["Silver Mace"])
            member.equip(EQUIPMENT_CATALOG["Silk Vestment"])
        elif any(k in p_name for k in ("infiltrator", "ranger", "assassin", "huntress", "rogue")):
            member.equip(EQUIPMENT_CATALOG["Twin Daggers"])
            member.equip(EQUIPMENT_CATALOG["Leather Hood"])
        else:  # Warrior, Brawler, Spellblade, Valkyrie, etc.
            member.equip(EQUIPMENT_CATALOG["Iron Longsword"])
            member.equip(EQUIPMENT_CATALOG["Brigandine"])

        return member

    def enter(self, context: Context) -> None:
        super().enter(context)
        TerminalScreen.write(ATControlSequences.CursorHide)
        TerminalScreen.clear_screen()
        TerminalScreen.flush()
        self.main_panel.set_all_dirty()
        self.substate_dirty = True
        self._switch_substate(self.substate)

    def exit(self, context: Context) -> None:
        super().exit(context)
        TerminalScreen.clear_screen()
        TerminalScreen.write(ATControlSequences.CursorShow)
        TerminalScreen.flush()

    def update(self, context: Context) -> None:
        super().update(context)
        keys_pressed = context.get(SMState.ContextKeysPressed)
        core = context.get(SMState.ContextEldoriaCore)

        if isinstance(keys_pressed, list) and len(keys_pressed) > 0:
            for key_info in list(keys_pressed):
                self._handle_input(key_info, context, core)
                keys_pressed.remove(key_info)
                break

        if core and hasattr(core, "game_state") and core.game_state.current_state != self.name:
            return

        self._render()

    def _handle_input(self, key_info, context: Context, core) -> None:
        # 1. NAME ENTRY SUBSTATE
        if self.substate == CharacterBuilderSubstate.NAME_ENTRY:
            if key_info.key == KeyCode.ENTER or key_info.char in ("\r", "\n"):
                if len(self.char_name.strip()) == 0:
                    self.char_name = f"Hro{self.target_slot + 1}"
                self._switch_substate(CharacterBuilderSubstate.GENDER_SELECTION)
            elif key_info.key == KeyCode.ESCAPE:
                if core and hasattr(core, "game_state"):
                    core.game_state.trigger("ToPartyBuilder", context)
            elif key_info.key == KeyCode.BACKSPACE or key_info.char == "\x7f":
                if len(self.char_name) > 0:
                    self.char_name = self.char_name[:-1]
                    self._update_name_labels()
            elif key_info.char and key_info.char.isprintable() and len(key_info.char) == 1:
                if len(self.char_name) < 4:
                    self.char_name += key_info.char
                    self._update_name_labels()

        # 2. GENDER SELECTION SUBSTATE
        elif self.substate == CharacterBuilderSubstate.GENDER_SELECTION:
            if key_info.key in (KeyCode.UP, KeyCode.DOWN):
                self.gender = Gender.FEMALE if self.gender == Gender.MALE else Gender.MALE
                self._roll_base_stats()
                self._update_gender_labels()
            elif key_info.char in ("1", "2"):
                target_gender = Gender.MALE if key_info.char == "1" else Gender.FEMALE
                if self.gender != target_gender:
                    self.gender = target_gender
                    self._roll_base_stats()
                    self._update_gender_labels()
            elif key_info.key == KeyCode.ENTER or key_info.char in ("\r", "\n"):
                self._switch_substate(CharacterBuilderSubstate.POINT_ALLOCATION)
            elif key_info.key == KeyCode.ESCAPE:
                self._switch_substate(CharacterBuilderSubstate.NAME_ENTRY)

        # 3. POINT ALLOCATION SUBSTATE
        elif self.substate == CharacterBuilderSubstate.POINT_ALLOCATION:
            if key_info.key == KeyCode.UP:
                self.selected_stat_idx = (self.selected_stat_idx - 1) % len(self.STAT_KEYS)
                self._update_stats_labels()
            elif key_info.key == KeyCode.DOWN:
                self.selected_stat_idx = (self.selected_stat_idx + 1) % len(self.STAT_KEYS)
                self._update_stats_labels()
            elif key_info.key == KeyCode.RIGHT:
                if self.points_pool > 0:
                    cur_key = self.STAT_KEYS[self.selected_stat_idx]
                    self.mod_stats[cur_key] += 1
                    self.points_pool -= 1
                    self._update_stats_labels()
            elif key_info.key == KeyCode.LEFT:
                cur_key = self.STAT_KEYS[self.selected_stat_idx]
                if self.mod_stats[cur_key] > 0:
                    self.mod_stats[cur_key] -= 1
                    self.points_pool += 1
                    self._update_stats_labels()
            elif key_info.char in ("r", "R"):
                self._roll_base_stats()
                self._update_stats_labels()
            elif key_info.key == KeyCode.ENTER or key_info.char in ("\r", "\n"):
                self._switch_substate(CharacterBuilderSubstate.AFFINITY_SELECTION)
            elif key_info.key == KeyCode.ESCAPE:
                self._switch_substate(CharacterBuilderSubstate.GENDER_SELECTION)

        # 4. AFFINITY SELECTION SUBSTATE
        elif self.substate == CharacterBuilderSubstate.AFFINITY_SELECTION:
            if key_info.key == KeyCode.UP:
                self.affinity_idx = (self.affinity_idx - 1) % len(self.AFFINITIES)
                self._update_affinity_labels()
            elif key_info.key == KeyCode.DOWN:
                self.affinity_idx = (self.affinity_idx + 1) % len(self.AFFINITIES)
                self._update_affinity_labels()
            elif key_info.key == KeyCode.ENTER or key_info.char in ("\r", "\n"):
                self._switch_substate(CharacterBuilderSubstate.PROFILE_SELECTION)
            elif key_info.key == KeyCode.ESCAPE:
                self._switch_substate(CharacterBuilderSubstate.POINT_ALLOCATION)

        # 5. PROFILE SELECTION SUBSTATE
        elif self.substate == CharacterBuilderSubstate.PROFILE_SELECTION:
            catalog = get_portraits_for_gender(self.gender)
            if key_info.key == KeyCode.LEFT:
                self.profile_idx = (self.profile_idx - 1) % len(catalog)
                self._update_profile_labels()
            elif key_info.key == KeyCode.RIGHT:
                self.profile_idx = (self.profile_idx + 1) % len(catalog)
                self._update_profile_labels()
            elif key_info.key == KeyCode.ENTER or key_info.char in ("\r", "\n"):
                self._switch_substate(CharacterBuilderSubstate.CONFIRMATION)
            elif key_info.key == KeyCode.ESCAPE:
                self._switch_substate(CharacterBuilderSubstate.AFFINITY_SELECTION)

        # 6. CONFIRMATION SUBSTATE
        elif self.substate == CharacterBuilderSubstate.CONFIRMATION:
            if key_info.key == KeyCode.ENTER or key_info.char in ("\r", "\n"):
                self.created_member = self._build_combatant()
                if core and hasattr(core, "game_state"):
                    party_builder = core.game_state.states.get("GSPartyBuilderScreen")
                    if party_builder and hasattr(party_builder, "set_member_slot"):
                        party_builder.set_member_slot(self.target_slot, self.created_member)
                    core.game_state.trigger("ToPartyBuilder", context)
            elif key_info.key == KeyCode.ESCAPE:
                self._switch_substate(CharacterBuilderSubstate.PROFILE_SELECTION)

    def _clear_content_rect_ansi(self) -> str:
        """Erases interior rows 4..21 between inner left and inner right borders."""
        left = self.main_panel.inner_left
        width = self.main_panel.inner_width
        blank = " " * width
        return "".join(f"\033[{r};{left}H{blank}" for r in range(4, 22))

    def _render(self) -> None:
        """Atomic selective rendering of the Character Builder screen using UI components."""
        TerminalScreen.write(ATControlSequences.DrawOptimizeOn)

        # Draw master window panel (borders, title, breadcrumbs, divider, footer)
        self.main_panel.draw()

        # If substate switched, wipe the content area
        if self.substate_dirty:
            TerminalScreen.write(self._clear_content_rect_ansi())
            self.substate_dirty = False

        # Draw active substate panel
        active_panel = self._substate_panels.get(self.substate)
        if active_panel:
            active_panel.draw()

        # In profile substate, also draw the UIContainer portrait card
        if self.substate == CharacterBuilderSubstate.PROFILE_SELECTION:
            self.portrait_card.draw()

        # Clear tail lines up to 40
        tail_start = self.main_panel.right_bottom.row + 1
        if tail_start <= 40:
            TerminalScreen.write(clear_buffer_tail(tail_start, 40))

        TerminalScreen.write(ATControlSequences.DrawOptimizeOff)
        TerminalScreen.flush()
