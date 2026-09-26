"""
UIPartySlotItem & UIPartySlotList: Granular party member slot components and coordinator.
"""

from __future__ import annotations
from typing import List, Optional, TYPE_CHECKING
from ..base import UIBase
from .label import UILabel
from ...combat.entities import PartyMember
from ...combat.portrait import Gender
from ...combat.stats import StatId
from ...terminal.ansi import ATCoordinates
from ...terminal.box import visible_width

if TYPE_CHECKING:
    from ..container import UIContainer


class UIPartySlotItem(UIBase):
    """
    Granular UI component representing an individual party slot (leader or companion).
    Houses 2 UILabel rows (basic identity & HP/MP on row 1, affinity & stats on row 2).
    Dynamically formats for both wide (>=80 cols) and compact (54 cols) containers.
    """

    def __init__(
        self,
        slot_idx: int,
        start_row: int,
        parent: UIContainer,
        member: Optional[PartyMember] = None,
        selected: bool = False,
        locked: bool = False,
    ) -> None:
        super().__init__()
        self.slot_idx: int = slot_idx
        self.start_row: int = start_row
        self.parent: UIContainer = parent
        self.member: Optional[PartyMember] = member
        self.selected: bool = selected
        self.locked: bool = locked

        col = self.parent.inner_left + 1

        self.line1_label = UILabel(
            text=self._format_line1(),
            coordinates=ATCoordinates(self.start_row, col),
            parent=self.parent,
        )
        self.line2_label = UILabel(
            text=self._format_line2(),
            coordinates=ATCoordinates(self.start_row + 1, col),
            parent=self.parent,
        )

    @property
    def is_compact(self) -> bool:
        return self.parent.inner_width < 70

    def _role_label(self) -> str:
        if self.locked:
            return f"\033[90m[Slot {self.slot_idx + 1} ]\033[0m"
        if self.slot_idx == 0:
            return "\033[1;33m[★ Leader]\033[0m" if self.selected else "\033[33m[★ Leader]\033[0m"
        return f"\033[1;37m[Slot {self.slot_idx + 1} ]\033[0m" if self.selected else f"\033[37m[Slot {self.slot_idx + 1} ]\033[0m"

    def _format_line1(self) -> str:
        if self.locked:
            role = self._role_label()
            return f"  {role} \033[90m··· Locked ···\033[0m"

        chev = "\033[1;33m❱\033[0m " if self.selected else "  "
        role = self._role_label()

        if self.member is None:
            return f"{chev}{role} \033[90m··· Empty Slot ···\033[0m"

        m = self.member
        g_icon = "♂" if m.gender == Gender.MALE else "♀"

        if self.is_compact:
            hp_str = f"HP:{m.hp:>3}/{m.max_hp:<3}"
            m_name = m.name[:9]
            j_class = m.job_class[:10]
            return (
                f"{chev}{role} \033[1;32m{m_name:<9}\033[0m {g_icon} "
                f"\033[36m{j_class:<10}\033[0m \033[32m{hp_str}\033[0m"
            )
        else:
            hp_str = f"HP: {m.hp:>3}/{m.max_hp:<3}"
            mp_str = f"MP: {m.mp:>3}/{m.max_mp:<3}"
            return (
                f"{chev}{role} \033[1;32m{m.name:<13}\033[0m {g_icon}  "
                f"\033[36m{m.job_class:<18}\033[0m \033[32m{hp_str}\033[0m   \033[34m{mp_str}\033[0m"
            )

    def _format_line2(self) -> str:
        if self.locked:
            if self.slot_idx == 1:
                prev_name = "Leader" if self.is_compact else "Party Leader"
            else:
                prev_name = f"Slot {self.slot_idx}"

            if self.is_compact:
                return f"   \033[90mLocked (Configure {prev_name} first)\033[0m"
            else:
                return f"       \033[90mLocked ── Configure {prev_name} to unlock\033[0m"

        if self.member is None:
            if self.is_compact:
                return "   \033[90m[Enter] Create   [R] Auto-fill\033[0m"
            else:
                return "       \033[90mPress [Enter] to create character or [R] to auto-fill templates\033[0m"

        m = self.member
        aff_name = m.affinity.value.replace("Elemental", "")
        atk = m.stats[StatId.ATTACK].total
        def_val = m.stats[StatId.DEFENSE].total
        mat = m.stats[StatId.MAGIC_ATTACK].total
        mdf = m.stats[StatId.MAGIC_DEFENSE].total
        spd = m.stats[StatId.SPEED].total

        if self.is_compact:
            aff_short = aff_name[:5]
            return (
                f"   \033[33m{aff_short:<5}\033[0m \033[90mA:\033[0m{atk:<2} "
                f"\033[90mD:\033[0m{def_val:<2} \033[90mMA:\033[0m{mat:<2} "
                f"\033[90mMD:\033[0m{mdf:<2} \033[90mS:\033[0m{spd:<2} \033[90m[Enter]\033[0m"
            )
        else:
            return (
                f"       \033[33m{aff_name:<8}\033[0m \033[90mATK:\033[0m{atk:<2} "
                f"\033[90mDEF:\033[0m{def_val:<2} \033[90mMAT:\033[0m{mat:<2} "
                f"\033[90mMDF:\033[0m{mdf:<2} \033[90mSPD:\033[0m{spd:<2}   \033[90m[Enter] Edit\033[0m"
            )

    def _update_labels(self) -> None:
        self.line1_label.set_user_data(self._format_line1())
        self.line2_label.set_user_data(self._format_line2())

    def set_selected(self, selected: bool) -> None:
        if self.selected != selected:
            self.selected = selected
            self._update_labels()

    def set_locked(self, locked: bool) -> None:
        if self.locked != locked:
            self.locked = locked
            self._update_labels()

    def set_member(self, member: Optional[PartyMember]) -> None:
        self.member = member
        self._update_labels()

    def set_all_dirty(self) -> None:
        self.line1_label.dirty = True
        self.line2_label.dirty = True

    def activate(self, context=None) -> bool:
        res = super().activate(context)
        self.line1_label.activate(context)
        self.line2_label.activate(context)
        return res

    def deactivate(self, context=None) -> bool:
        res = super().deactivate(context)
        self.line1_label.deactivate(context)
        self.line2_label.deactivate(context)
        return res

    def draw(self) -> None:
        self.line1_label.draw()
        self.line2_label.draw()


class UIPartySlotList(UIBase):
    """
    Compound coordinator managing 5 UIPartySlotItem instances.
    Handles sequential progression slot locking, circular cursor navigation within unlocked slots,
    selective dirty-rect marking, and member data dispatch.
    """

    def __init__(
        self,
        parent: UIContainer,
        start_row: int = 4,
        slot_spacing: int = 3,
        num_slots: int = 5,
    ) -> None:
        super().__init__()
        self.parent: UIContainer = parent
        self.start_row: int = start_row
        self.slot_spacing: int = slot_spacing
        self.selected_index: int = 0
        self.max_unlocked_idx: int = 0
        self.slots: List[UIPartySlotItem] = []

        for i in range(num_slots):
            slot = UIPartySlotItem(
                slot_idx=i,
                start_row=self.start_row + (i * self.slot_spacing),
                parent=self.parent,
                selected=(i == 0),
                locked=(i > self.max_unlocked_idx),
            )
            self.slots.append(slot)

    def set_max_unlocked_index(self, max_idx: int) -> None:
        if not self.slots:
            return
        clamped_idx = max(0, min(len(self.slots) - 1, max_idx))
        self.max_unlocked_idx = clamped_idx
        for i, slot in enumerate(self.slots):
            slot.set_locked(i > self.max_unlocked_idx)

        if self.selected_index > self.max_unlocked_idx:
            self.slots[self.selected_index].set_selected(False)
            self.selected_index = self.max_unlocked_idx
            self.slots[self.selected_index].set_selected(True)

    def select_next(self) -> None:
        if not self.slots:
            return
        allowed_count = self.max_unlocked_idx + 1
        if allowed_count <= 1:
            return
        old_idx = self.selected_index
        new_idx = (self.selected_index + 1) % allowed_count
        if old_idx != new_idx:
            self.slots[old_idx].set_selected(False)
            self.slots[new_idx].set_selected(True)
            self.selected_index = new_idx

    def select_prev(self) -> None:
        if not self.slots:
            return
        allowed_count = self.max_unlocked_idx + 1
        if allowed_count <= 1:
            return
        old_idx = self.selected_index
        new_idx = (self.selected_index - 1) % allowed_count
        if old_idx != new_idx:
            self.slots[old_idx].set_selected(False)
            self.slots[new_idx].set_selected(True)
            self.selected_index = new_idx

    def select_index(self, idx: int) -> bool:
        if 0 <= idx <= self.max_unlocked_idx:
            if idx != self.selected_index:
                self.slots[self.selected_index].set_selected(False)
                self.selected_index = idx
                self.slots[self.selected_index].set_selected(True)
            return True
        return False

    def set_slot_member(self, idx: int, member: Optional[PartyMember]) -> None:
        if 0 <= idx < len(self.slots):
            self.slots[idx].set_member(member)

    def get_slot_member(self, idx: int) -> Optional[PartyMember]:
        if 0 <= idx < len(self.slots):
            return self.slots[idx].member
        return None

    def set_all_dirty(self) -> None:
        for slot in self.slots:
            slot.set_all_dirty()

    def activate(self, context=None) -> bool:
        res = super().activate(context)
        for slot in self.slots:
            slot.activate(context)
        return res

    def deactivate(self, context=None) -> bool:
        res = super().deactivate(context)
        for slot in self.slots:
            slot.deactivate(context)
        return res

    def draw(self) -> None:
        for slot in self.slots:
            slot.draw()
