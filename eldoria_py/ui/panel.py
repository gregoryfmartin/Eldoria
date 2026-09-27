"""
UIPanel: Container specialized to house child UI elements with circular Tab-focus navigation.
"""

from __future__ import annotations
from typing import Dict, List, Optional
from .base import UIBase
from .container import UIContainer, WindowBorderPart
from .elements.label import UILabel
from .elements.stat_bar import UIStatBar, StatBarType
from ..core.context import Context
from ..core.fsm import SMState
from ..terminal.ansi import ATCoordinates, ATDecoration, ATControlSequences
from ..terminal.color import TrueColor
from ..terminal.box import visible_width
from ..terminal.input import ConsoleKeyInfo, KeyCode


class UIPanel(UIContainer):
    """
    Houses UI elements and manages circular Tab focus cycling across child components.
    """

    def __init__(
        self,
        left_top: Optional[ATCoordinates] = None,
        right_bottom: Optional[ATCoordinates] = None,
        title: str = "",
        ui_element_listing: Optional[Dict[int, UIBase]] = None,
        has_border: bool = True,
    ) -> None:
        super().__init__(left_top, right_bottom, title, has_border=has_border)
        self.active_index: int = 0
        self.ui_element_listing: Dict[int, UIBase] = ui_element_listing if ui_element_listing is not None else {}
        self._initialize_tab_focus_handling()

    def _initialize_tab_focus_handling(self) -> None:
        def on_tab_check(context: Context) -> None:
            # Context references: [0]: UIPanel (Self), [1]: OriginalContext
            if len(context.references) > 1 and isinstance(context.references[1], Context):
                orig_ctx = context.references[1]
                keys_pressed = orig_ctx.get(SMState.ContextKeysPressed)
                if isinstance(keys_pressed, list) and len(keys_pressed) > 0:
                    tab_key: Optional[ConsoleKeyInfo] = None
                    for key in keys_pressed:
                        if key.key == KeyCode.TAB:
                            tab_key = key
                            break
                    if tab_key is not None:
                        self.cycle_focus(orig_ctx)
                        if tab_key in keys_pressed:
                            keys_pressed.remove(tab_key)

        self.subscribe({
            "SMUiElementFocused_OnUpdate": on_tab_check,
            "SMUiElementActive_OnUpdate": on_tab_check,
        })

    def cycle_focus(self, original_context: Optional[Context] = None) -> None:
        """Cycles active focus to the next child element in index order."""
        if not self.ui_element_listing:
            return

        sorted_keys = sorted(self.ui_element_listing.keys())
        try:
            current_pos = sorted_keys.index(self.active_index)
        except ValueError:
            current_pos = -1

        next_pos = (current_pos + 1) % len(sorted_keys)
        self.active_index = sorted_keys[next_pos]

        for key, element in self.ui_element_listing.items():
            elem_ctx = Context([element, original_context])
            if key == self.active_index:
                element.focus(elem_ctx)
            else:
                element.unfocus(elem_ctx)

    def update(self, context: Context) -> None:
        super().update(context)
        if self.is_active():
            for element in self.ui_element_listing.values():
                element.update(Context([element, context]))

    def draw(self) -> None:
        super().draw()
        if self.is_active():
            for element in self.ui_element_listing.values():
                element.draw()

    def activate(self, context: Optional[Context] = None) -> bool:
        res = super().activate(context)
        for element in self.ui_element_listing.values():
            element.activate(Context([element, context]))
        return res

    def deactivate(self, context: Optional[Context] = None) -> bool:
        res = super().deactivate(context)
        for element in self.ui_element_listing.values():
            element.deactivate(Context([element, context]))
        return res

    def set_all_dirty(self) -> None:
        super().set_all_dirty()
        for element in self.ui_element_listing.values():
            element.dirty = True

    def render_lines(self) -> List[str]:
        """
        Renders the panel into a list of formatted lines including borders, title,
        footer, and child elements. Each line has visible width exactly equal to self.width + 1.
        """
        lines: List[str] = []
        inner_w = max(0, self.width - 1)

        # 1. Top Border
        if self.has_border:
            corner_left = (
                self.border_draw_colors[WindowBorderPart.LEFT_TOP].to_ansi_fg()
                + self.current_window_designs[WindowBorderPart.LEFT_TOP]
            )
            corner_right = (
                self.border_draw_colors[WindowBorderPart.RIGHT_TOP].to_ansi_fg()
                + self.current_window_designs[WindowBorderPart.RIGHT_TOP]
            )
            bcolor = self.border_draw_colors[WindowBorderPart.TOP].to_ansi_fg()
            fill_ch = self.current_window_designs[WindowBorderPart.TOP]

            if self.use_title and self.title:
                clean_title = self.title.strip(" ─-")
                if clean_title:
                    title_len = visible_width(clean_title)
                    if title_len + 2 <= inner_w:
                        rem = inner_w - (title_len + 2)
                        pad = " "
                    else:
                        rem = max(0, inner_w - title_len)
                        pad = ""

                    if getattr(self, "title_align", "center") == "left":
                        lp = 1 if pad else 0
                        rp = max(0, rem - lp)
                    elif getattr(self, "title_align", "center") == "right":
                        rp = 1 if pad else 0
                        lp = max(0, rem - rp)
                    else:  # "center"
                        lp = rem // 2
                        rp = rem - lp

                    tcolor = self.title_color.to_ansi_fg() if self.title_color else ""
                    mid_str = f"{bcolor}{fill_ch * lp}{pad}{tcolor}{clean_title}{bcolor}{pad}{fill_ch * rp}"
                else:
                    mid_str = bcolor + (fill_ch * inner_w)
            else:
                mid_str = bcolor + (fill_ch * inner_w)

            top_line = f"{corner_left}{mid_str}{corner_right}{ATControlSequences.SGR_RESET}"
            lines.append(top_line)

        # 2. Content Rows
        left_color = self.border_draw_colors[WindowBorderPart.LEFT].to_ansi_fg()
        left_char = self.current_window_designs[WindowBorderPart.LEFT]
        right_color = self.border_draw_colors[WindowBorderPart.RIGHT].to_ansi_fg()
        right_char = self.current_window_designs[WindowBorderPart.RIGHT]

        for r in range(self.inner_top, self.inner_bottom + 1):
            row_elements = [
                elem for elem in self.ui_element_listing.values()
                if elem.coordinates and elem.coordinates.row == r
            ]
            row_elements.sort(key=lambda e: e.coordinates.column if e.coordinates else 0)

            inner_parts: List[str] = []
            cur_col = self.inner_left

            for elem in row_elements:
                e_col = elem.coordinates.column if elem.coordinates else self.inner_left
                gap = max(0, e_col - cur_col)
                if gap > 0:
                    inner_parts.append(" " * gap)
                    cur_col += gap

                text = elem.text
                fg = elem.fg_color.to_ansi_fg() if elem.fg_color else ""
                bg = elem.bg_color.to_ansi_bg() if elem.bg_color else ""
                dec = elem.decorations.to_ansi() if elem.decorations else ""
                reset = ATControlSequences.SGR_RESET if (fg or bg or dec) else ""
                inner_parts.append(f"{dec}{bg}{fg}{text}{reset}")
                cur_col += visible_width(text)

            trailing = max(0, self.inner_right - cur_col + 1)
            if trailing > 0:
                inner_parts.append(" " * trailing)

            inner_content = "".join(inner_parts)
            if self.has_border:
                row_line = (
                    f"{left_color}{left_char}{ATControlSequences.SGR_RESET}"
                    f"{inner_content}"
                    f"{right_color}{right_char}{ATControlSequences.SGR_RESET}"
                )
            else:
                row_line = inner_content
            lines.append(row_line)

        # 3. Bottom Border
        if self.has_border:
            corner_left = (
                self.border_draw_colors[WindowBorderPart.LEFT_BOTTOM].to_ansi_fg()
                + self.current_window_designs[WindowBorderPart.LEFT_BOTTOM]
            )
            corner_right = (
                self.border_draw_colors[WindowBorderPart.RIGHT_BOTTOM].to_ansi_fg()
                + self.current_window_designs[WindowBorderPart.RIGHT_BOTTOM]
            )
            bcolor = self.border_draw_colors[WindowBorderPart.BOTTOM].to_ansi_fg()
            fill_ch = self.current_window_designs[WindowBorderPart.BOTTOM]

            if self.use_footer and self.footer:
                clean_footer = self.footer.strip(" ─-")
                if clean_footer:
                    footer_len = visible_width(clean_footer)
                    if footer_len + 2 <= inner_w:
                        rem = inner_w - (footer_len + 2)
                        pad = " "
                    else:
                        rem = max(0, inner_w - footer_len)
                        pad = ""

                    lp = rem // 2
                    rp = rem - lp
                    fcolor = self.footer_color.to_ansi_fg() if self.footer_color else ""
                    mid_str = f"{bcolor}{fill_ch * lp}{pad}{fcolor}{clean_footer}{bcolor}{pad}{fill_ch * rp}"
                else:
                    mid_str = bcolor + (fill_ch * inner_w)
            else:
                mid_str = bcolor + (fill_ch * inner_w)

            bottom_line = f"{corner_left}{mid_str}{corner_right}{ATControlSequences.SGR_RESET}"
            lines.append(bottom_line)

        return lines

    def add_label(
        self,
        text: str,
        row: int,
        col: Optional[int] = None,
        align: str = "left",
        fg_color: Optional[TrueColor] = None,
        bg_color: Optional[TrueColor] = None,
        decorations: Optional[ATDecoration] = None,
        index: Optional[int] = None,
    ) -> UILabel:
        """
        Adds a UILabel to the panel, strictly measuring visible length against inner bounds.
        If align == 'center', mathematically computes centered column.
        Raises ValueError if string exceeds container inner bounds (no silent truncation).
        """
        vlen = visible_width(text)
        if vlen > self.inner_width:
            raise ValueError(
                f"Label text '{text}' (visible width {vlen}) exceeds panel inner_width ({self.inner_width})"
            )

        if not (self.inner_top <= row <= self.inner_bottom):
            raise ValueError(
                f"Label row {row} is outside panel vertical inner bounds [{self.inner_top}..{self.inner_bottom}]"
            )

        if align == "center":
            col = self.inner_left + (self.inner_width - vlen) // 2
        elif align == "left":
            col = self.inner_left if col is None else col
        elif align == "right":
            col = self.inner_right - vlen + 1 if col is None else col
        else:
            raise ValueError(f"Unknown align mode '{align}'. Expected 'left', 'center', or 'right'.")

        if col < self.inner_left:
            raise ValueError(
                f"Label column {col} starts outside panel inner_left ({self.inner_left})"
            )
        if col + vlen - 1 > self.inner_right:
            exceeded = (col + vlen - 1) - self.inner_right
            raise ValueError(
                f"Label '{text}' exceeds panel right border by {exceeded} column(s). Allowed inner_right is {self.inner_right}."
            )

        label = UILabel(
            text=text,
            coordinates=ATCoordinates(row, col),
            fg_color=fg_color,
            bg_color=bg_color,
            decorations=decorations,
            parent=self,
        )

        idx = index if index is not None else (max(self.ui_element_listing.keys(), default=-1) + 1)
        self.ui_element_listing[idx] = label

        # If panel is active, activate the newly added label
        if self.is_active():
            label.activate()

        return label

    def add_stat_bar(
        self,
        current_value: int,
        max_value: int,
        row: int,
        col: Optional[int] = None,
        length: int = 8,
        bar_type: Union[StatBarType, str] = StatBarType.HEALTH,
        align: str = "left",
        decorations: Optional[ATDecoration] = None,
        index: Optional[int] = None,
    ) -> UIStatBar:
        """
        Adds a UIStatBar to the panel, strictly measuring visible length (length + 2) against inner bounds.
        """
        vlen = length + 2
        if vlen > self.inner_width:
            raise ValueError(
                f"Stat bar (visible width {vlen}) exceeds panel inner_width ({self.inner_width})"
            )

        if not (self.inner_top <= row <= self.inner_bottom):
            raise ValueError(
                f"Stat bar row {row} is outside panel vertical inner bounds [{self.inner_top}..{self.inner_bottom}]"
            )

        if align == "center":
            col = self.inner_left + (self.inner_width - vlen) // 2
        elif align == "left":
            col = self.inner_left if col is None else col
        elif align == "right":
            col = self.inner_right - vlen + 1 if col is None else col
        else:
            raise ValueError(f"Unknown align mode '{align}'. Expected 'left', 'center', or 'right'.")

        if col < self.inner_left:
            raise ValueError(
                f"Stat bar column {col} starts outside panel inner_left ({self.inner_left})"
            )
        if col + vlen - 1 > self.inner_right:
            exceeded = (col + vlen - 1) - self.inner_right
            raise ValueError(
                f"Stat bar exceeds panel right border by {exceeded} column(s). Allowed inner_right is {self.inner_right}."
            )

        bar = UIStatBar(
            current_value=current_value,
            max_value=max_value,
            length=length,
            bar_type=bar_type,
            coordinates=ATCoordinates(row, col),
            decorations=decorations,
            parent=self,
        )

        idx = index if index is not None else (max(self.ui_element_listing.keys(), default=-1) + 1)
        self.ui_element_listing[idx] = bar

        if self.is_active():
            bar.activate()

        return bar
