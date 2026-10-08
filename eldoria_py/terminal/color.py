"""
24-bit TrueColor support, color channel clamping, and color palette library.
"""

from __future__ import annotations
import colorsys
import random
import re
from typing import Union


class ColorChannel:
    """Clamped integer representing a single 8-bit color channel (0-255)."""

    __slots__ = ("_value",)

    def __init__(self, value: int = 0) -> None:
        self.value = value

    @property
    def value(self) -> int:
        return self._value

    @value.setter
    def value(self, val: int) -> None:
        self._value = max(0, min(255, int(val)))

    def __int__(self) -> int:
        return self._value

    def __repr__(self) -> str:
        return f"ColorChannel({self._value})"

    def __eq__(self, other: object) -> bool:
        if isinstance(other, ColorChannel):
            return self._value == other._value
        if isinstance(other, int):
            return self._value == other
        return False


class TrueColor:
    """Represents a 24-bit RGB color with direct ANSI escape code formatting."""

    __slots__ = ("_red", "_green", "_blue")

    def __init__(
        self,
        red: Union[int, ColorChannel] = 0,
        green: Union[int, ColorChannel] = 0,
        blue: Union[int, ColorChannel] = 0,
        hex_val: int | None = None,
    ) -> None:
        if hex_val is not None:
            self._red = ColorChannel((hex_val >> 16) & 0xFF)
            self._green = ColorChannel((hex_val >> 8) & 0xFF)
            self._blue = ColorChannel(hex_val & 0xFF)
        else:
            self._red = red if isinstance(red, ColorChannel) else ColorChannel(red)
            self._green = green if isinstance(green, ColorChannel) else ColorChannel(green)
            self._blue = blue if isinstance(blue, ColorChannel) else ColorChannel(blue)

    @classmethod
    def from_hex(cls, hex_val: int) -> TrueColor:
        return cls(hex_val=hex_val)

    @classmethod
    def random(cls) -> TrueColor:
        return cls(
            random.randint(0, 255),
            random.randint(0, 255),
            random.randint(0, 255),
        )

    @property
    def red(self) -> ColorChannel:
        return self._red

    @property
    def green(self) -> ColorChannel:
        return self._green

    @property
    def blue(self) -> ColorChannel:
        return self._blue

    @property
    def r(self) -> int:
        return self._red.value

    @property
    def g(self) -> int:
        return self._green.value

    @property
    def b(self) -> int:
        return self._blue.value

    def to_fg_ansi(self) -> str:
        """Returns the ANSI SGR sequence for 24-bit foreground color."""
        return f"\033[38;2;{self.r};{self.g};{self.b}m"

    def to_bg_ansi(self) -> str:
        """Returns the ANSI SGR sequence for 24-bit background color."""
        return f"\033[48;2;{self.r};{self.g};{self.b}m"

    to_ansi_fg = to_fg_ansi
    to_ansi_bg = to_bg_ansi


    def __repr__(self) -> str:
        return f"TrueColor(r={self.r}, g={self.g}, b={self.b})"

    def __eq__(self, other: object) -> bool:
        if isinstance(other, TrueColor):
            return self.r == other.r and self.g == other.g and self.b == other.b
        return False


class ColorLibrary:
    """Predefined 24-bit TrueColor palette library matching Eldoria specifications."""

    # Standard / Web Colors
    IndianRed = TrueColor(hex_val=0xCD5C5C)
    Crimson = TrueColor(hex_val=0xDC143C)
    LightCoral = TrueColor(hex_val=0xF08080)
    Red = TrueColor(hex_val=0xFF0000)
    Salmon = TrueColor(hex_val=0xFA8072)
    FireBrick = TrueColor(hex_val=0xB22222)
    DarkSalmon = TrueColor(hex_val=0xE9967A)
    DarkRed = TrueColor(hex_val=0x8B0000)
    Pink = TrueColor(hex_val=0xFFC0CB)
    MediumVioletRed = TrueColor(hex_val=0xC71585)
    LightPink = TrueColor(hex_val=0xFFB6C1)
    PaleVioletRed = TrueColor(hex_val=0xDB7093)
    HotPink = TrueColor(hex_val=0xFF69B4)
    DeepPink = TrueColor(hex_val=0xFF1493)
    LightSalmon = TrueColor(hex_val=0xFFA07A)
    DarkOrange = TrueColor(hex_val=0xFF8C00)
    Coral = TrueColor(hex_val=0xFF7F50)
    Orange = TrueColor(hex_val=0xFFA500)
    Tomato = TrueColor(hex_val=0xFF6347)
    Gold = TrueColor(hex_val=0xFFD700)
    OrangeRed = TrueColor(hex_val=0xFF4500)
    Yellow = TrueColor(hex_val=0xFFFF00)
    LightYellow = TrueColor(hex_val=0xFFFFE0)
    PapayaWhip = TrueColor(hex_val=0xFFEFD5)
    LemonChiffon = TrueColor(hex_val=0xFFFACD)
    Moccasin = TrueColor(hex_val=0xFFE4B5)
    LightGoldenrodYellow = TrueColor(hex_val=0xFAFAD2)
    PeachPuff = TrueColor(hex_val=0xFFDAB9)
    PaleGoldenrod = TrueColor(hex_val=0xEEE8AA)
    Khaki = TrueColor(hex_val=0xF0E68C)
    DarkKhaki = TrueColor(hex_val=0xBDB76B)
    Lavender = TrueColor(hex_val=0xE6E6FA)
    MediumOrchid = TrueColor(hex_val=0xBA55D3)
    Thistle = TrueColor(hex_val=0xD8BFD8)
    Plum = TrueColor(hex_val=0xDDA0DD)
    DarkViolet = TrueColor(hex_val=0x9400D3)
    Violet = TrueColor(hex_val=0xEE82EE)
    BlueViolet = TrueColor(hex_val=0x8A2BE2)
    Orchid = TrueColor(hex_val=0xDA70D6)
    MediumPurple = TrueColor(hex_val=0x9370DB)
    Magenta = TrueColor(hex_val=0xFF00FF)
    Fuchsia = TrueColor(hex_val=0xFF00FF)
    SlateBlue = TrueColor(hex_val=0x6A5ACD)
    MediumSlateBlue = TrueColor(hex_val=0x7B68EE)
    DarkSlateBlue = TrueColor(hex_val=0x483D8B)
    Purple = TrueColor(hex_val=0x800080)
    Indigo = TrueColor(hex_val=0x4B0082)
    GreenYellow = TrueColor(hex_val=0xADFF2F)
    SeaGreen = TrueColor(hex_val=0x2E8B57)
    Chartreuse = TrueColor(hex_val=0x7FFF00)
    ForestGreen = TrueColor(hex_val=0x228B22)
    LawnGreen = TrueColor(hex_val=0x7CFC00)
    Green = TrueColor(hex_val=0x008000)
    Lime = TrueColor(hex_val=0x00FF00)
    DarkGreen = TrueColor(hex_val=0x006400)
    LimeGreen = TrueColor(hex_val=0x32CD32)
    YellowGreen = TrueColor(hex_val=0x9ACD32)
    PaleGreen = TrueColor(hex_val=0x98FB98)
    OliveDrab = TrueColor(hex_val=0x6B8E23)
    LightGreen = TrueColor(hex_val=0x90EE90)
    Olive = TrueColor(hex_val=0x808000)
    MediumSpringGreen = TrueColor(hex_val=0x00FA9A)
    DarkOliveGreen = TrueColor(hex_val=0x556B2F)
    SpringGreen = TrueColor(hex_val=0x00FF7F)
    MediumAquamarine = TrueColor(hex_val=0x66CDAA)
    MediumSeaGreen = TrueColor(hex_val=0x3CB371)
    DarkSeaGreen = TrueColor(hex_val=0x8FBC8F)
    LightSeaGreen = TrueColor(hex_val=0x20B2AA)
    DarkCyan = TrueColor(hex_val=0x008B8B)
    Teal = TrueColor(hex_val=0x008080)
    Aqua = TrueColor(hex_val=0x00FFFF)
    Cyan = TrueColor(hex_val=0x00FFFF)
    SkyBlue = TrueColor(hex_val=0x87CEEB)
    LightCyan = TrueColor(hex_val=0xE0FFFF)
    LightSkyBlue = TrueColor(hex_val=0x87CEFA)
    PaleTurquoise = TrueColor(hex_val=0xAFEEEE)
    DeepSkyBlue = TrueColor(hex_val=0x00BFFF)
    Aquamarine = TrueColor(hex_val=0x7FFFD4)
    DodgerBlue = TrueColor(hex_val=0x1E90FF)
    Turquoise = TrueColor(hex_val=0x40E0D0)
    CornflowerBlue = TrueColor(hex_val=0x6495ED)
    MediumTurquoise = TrueColor(hex_val=0x48D1CC)
    RoyalBlue = TrueColor(hex_val=0x4169E1)
    DarkTurquoise = TrueColor(hex_val=0x00CED1)
    Blue = TrueColor(hex_val=0x0000FF)
    CadetBlue = TrueColor(hex_val=0x5F9EA0)
    MediumBlue = TrueColor(hex_val=0x0000CD)
    SteelBlue = TrueColor(hex_val=0x4682B4)
    DarkBlue = TrueColor(hex_val=0x00008B)
    LightSteelBlue = TrueColor(hex_val=0xB0C4DE)
    Navy = TrueColor(hex_val=0x000080)
    PowderBlue = TrueColor(hex_val=0xB0E0E6)
    MidnightBlue = TrueColor(hex_val=0x191970)
    LightBlue = TrueColor(hex_val=0xADD8E6)
    Cornsilk = TrueColor(hex_val=0xFFF8DC)
    RosyBrown = TrueColor(hex_val=0xBC8F8F)
    BlanchedAlmond = TrueColor(hex_val=0xFFEBCD)
    SandyBrown = TrueColor(hex_val=0xF4A460)
    Bisque = TrueColor(hex_val=0xFFE4C4)
    Goldenrod = TrueColor(hex_val=0xDAA520)
    NavajoWhite = TrueColor(hex_val=0xFFDEAD)
    DarkGoldenrod = TrueColor(hex_val=0xB8860B)
    Wheat = TrueColor(hex_val=0xF5DEB3)
    Peru = TrueColor(hex_val=0xCD853F)
    BurlyWood = TrueColor(hex_val=0xDEB887)
    Chocolate = TrueColor(hex_val=0xD2691E)
    Tan = TrueColor(hex_val=0xD2B48C)
    SaddleBrown = TrueColor(hex_val=0x8B4513)
    Sienna = TrueColor(hex_val=0xA0522D)
    Maroon = TrueColor(hex_val=0x800000)
    Brown = TrueColor(hex_val=0xA52A2A)
    White = TrueColor(hex_val=0xFFFFFF)
    Gainsboro = TrueColor(hex_val=0xDCDCDC)
    Snow = TrueColor(hex_val=0xFFFAFA)
    LightGrey = TrueColor(hex_val=0xD3D3D3)
    Honeydew = TrueColor(hex_val=0xF0FFF0)
    Silver = TrueColor(hex_val=0xC0C0C0)
    MintCream = TrueColor(hex_val=0xF5FFFA)
    DarkGrey = TrueColor(hex_val=0xA9A9A9)
    Azure = TrueColor(hex_val=0xF0FFFF)
    Grey = TrueColor(hex_val=0x808080)
    AliceBlue = TrueColor(hex_val=0xF0F8FF)
    DimGrey = TrueColor(hex_val=0x696969)
    GhostWhite = TrueColor(hex_val=0xF8F8FF)
    LightSlateGrey = TrueColor(hex_val=0x778899)
    WhiteSmoke = TrueColor(hex_val=0xF5F5F5)
    SlateGrey = TrueColor(hex_val=0x708090)
    Seashell = TrueColor(hex_val=0xFFF5EE)
    DarkSlateGrey = TrueColor(hex_val=0x2F4F4F)
    Beige = TrueColor(hex_val=0xF5F5DC)
    Black = TrueColor(hex_val=0x000000)
    OldLace = TrueColor(hex_val=0xFDF5E6)
    FloralWhite = TrueColor(hex_val=0xFFFAF0)
    Ivory = TrueColor(hex_val=0xFFFFF0)
    AntiqueWhite = TrueColor(hex_val=0xFAEBD7)
    Linen = TrueColor(hex_val=0xFAF0E6)
    LavenderBlush = TrueColor(hex_val=0xFFF0F5)
    MistyRose = TrueColor(hex_val=0xFFE4E1)

    # Apple HIG Colors
    AppleRedLight = TrueColor(hex_val=0xFF383C)
    AppleRedDark = TrueColor(hex_val=0xFF4245)
    AppleOrangeLight = TrueColor(hex_val=0xFF8D28)
    AppleOrangeDark = TrueColor(hex_val=0xFF9230)
    AppleYellowLight = TrueColor(hex_val=0xFFCC00)
    AppleYellowDark = TrueColor(hex_val=0xFFD600)
    AppleGreenLight = TrueColor(hex_val=0x34C759)
    AppleGreenDark = TrueColor(hex_val=0x30D158)
    AppleMintLight = TrueColor(hex_val=0x00C8B3)
    AppleMintDark = TrueColor(hex_val=0x00DAC3)
    AppleTealLight = TrueColor(hex_val=0x00C3D0)
    AppleTealDark = TrueColor(hex_val=0x00D2E0)
    AppleCyanLight = TrueColor(hex_val=0x00C0E8)
    AppleCyanDark = TrueColor(hex_val=0x3CD3FE)
    AppleBlueLight = TrueColor(hex_val=0x0088FF)
    AppleBlueDark = TrueColor(hex_val=0x0091FF)
    AppleIndigoLight = TrueColor(hex_val=0x6155F5)
    AppleIndigoDark = TrueColor(hex_val=0x6D7CFF)
    ApplePurpleLight = TrueColor(hex_val=0xCB30E0)
    ApplePurpleDark = TrueColor(hex_val=0xDB34F2)
    ApplePinkLight = TrueColor(hex_val=0xFF2D55)
    ApplePinkDark = TrueColor(hex_val=0xFF375F)
    AppleBrownLight = TrueColor(hex_val=0xAC7F5E)
    AppleBrownDark = TrueColor(hex_val=0xB78A66)

    # Gemstone & Pigment Colors
    EmeraldGreen = TrueColor(hex_val=0x50C878)
    RubyRed = TrueColor(hex_val=0xE0115F)
    AlizarinCrimson = TrueColor(hex_val=0xE32636)
    Alizarin = AlizarinCrimson
    AmberGold = TrueColor(hex_val=0xE5A93C)

    # Game UI Design Tokens
    WindowBorderActiveColor = Ivory
    WindowBorderInactiveColor = DarkSlateGrey
    TextActiveColor = GhostWhite
    TextInactiveColor = DarkSlateGrey
    TextColor = GhostWhite
    TextDefault = White
    UICheckboxHasFocus = AppleMintLight
    UICheckboxChecked = AppleGreenLight
    UICheckboxInactiveColor = DarkSlateGrey
    UICheckboxActive = GhostWhite
    UIChevronActive = GhostWhite
    UIChevronInactive = DarkSlateGrey
    UIChevronHasFocus = AppleMintLight
    ListItemCurrentHighlight = AppleYellowLight

    # Aliases
    WINDOW_BORDER_ACTIVE_COLOR = WindowBorderActiveColor
    WINDOW_BORDER_INACTIVE_COLOR = WindowBorderInactiveColor
    TEXT_ACTIVE_COLOR = TextActiveColor
    TEXT_INACTIVE_COLOR = TextInactiveColor
    TEXT_COLOR = TextColor
    TEXT_DEFAULT = TextDefault
    UI_CHECKBOX_HAS_FOCUS = UICheckboxHasFocus
    UI_CHECKBOX_CHECKED = UICheckboxChecked
    UI_CHECKBOX_INACTIVE_COLOR = UICheckboxInactiveColor
    UI_CHECKBOX_ACTIVE = UICheckboxActive
    UI_CHEVRON_ACTIVE = UIChevronActive
    UI_CHEVRON_INACTIVE = UIChevronInactive
    UI_CHEVRON_HAS_FOCUS = UIChevronHasFocus
    LIST_ITEM_CURRENT_HIGHLIGHT = ListItemCurrentHighlight
    EMERALD_GREEN = EmeraldGreen
    RUBY_RED = RubyRed
    ALIZARIN = AlizarinCrimson
    ALIZARIN_CRIMSON = AlizarinCrimson


def rainbow_color(hue: float) -> TrueColor:
    """Returns a TrueColor corresponding to the given hue (0.0 to 1.0) with full saturation and value."""
    r, g, b = colorsys.hsv_to_rgb(hue % 1.0, 1.0, 1.0)
    return TrueColor(int(r * 255), int(g * 255), int(b * 255))


def format_chromatic_wave(
    text: str,
    phase: float = 0.0,
    char_step: float = 0.035,
    bold: bool = False,
) -> str:
    """Renders text with a horizontal 24-bit TrueColor chromatic wave gradient."""
    bold_code = "\033[1m" if bold else ""
    out = []
    for i, ch in enumerate(text):
        if ch == " ":
            out.append(" ")
            continue
        c = rainbow_color(phase + i * char_step)
        out.append(f"{bold_code}{c.to_fg_ansi()}{ch}\033[0m")
    return "".join(out)


def interpolate_color(c1: TrueColor, c2: TrueColor, t: float) -> TrueColor:
    """Linearly interpolates between two TrueColors by factor t (clamped to 0.0..1.0)."""
    t = max(0.0, min(1.0, t))
    r = int(round(c1.r + (c2.r - c1.r) * t))
    g = int(round(c1.g + (c2.g - c1.g) * t))
    b = int(round(c1.b + (c2.b - c1.b) * t))
    return TrueColor(r, g, b)


def interpolate_alizarin_to_emerald(t: float) -> TrueColor:
    """
    Interpolates from Alizarin Crimson (#E32636) through Amber Gold (#E5A93C)
    to Emerald Green (#50C878) across t in [0.0, 1.0].
    """
    t = max(0.0, min(1.0, t))
    c_start = ColorLibrary.AlizarinCrimson
    c_mid = ColorLibrary.AmberGold
    c_end = ColorLibrary.EmeraldGreen

    if t <= 0.5:
        sub_t = t / 0.5
        return interpolate_color(c_start, c_mid, sub_t)
    else:
        sub_t = (t - 0.5) / 0.5
        return interpolate_color(c_mid, c_end, sub_t)


def scale_color(color: TrueColor, factor: float) -> TrueColor:
    """Scales a TrueColor RGB by a factor in [0.0, 1.0]."""
    factor = max(0.0, min(1.0, factor))
    return TrueColor(
        int(round(color.r * factor)),
        int(round(color.g * factor)),
        int(round(color.b * factor)),
    )


ANSI_16_COLORS_FG = {
    # Standard foreground colors (30-37)
    30: (0, 0, 0),        # Black
    31: (205, 49, 49),    # Red
    32: (13, 188, 121),   # Green
    33: (229, 229, 16),   # Yellow
    34: (36, 114, 200),   # Blue
    35: (188, 63, 188),   # Magenta
    36: (17, 168, 205),   # Cyan
    37: (229, 229, 229),  # White
    # High-intensity foreground colors (90-97)
    90: (102, 102, 102),  # Bright Black / Dark Gray
    91: (241, 76, 76),    # Bright Red
    92: (35, 209, 139),   # Bright Green
    93: (245, 245, 67),   # Bright Yellow
    94: (59, 142, 234),   # Bright Blue
    95: (214, 112, 214),  # Bright Magenta
    96: (41, 184, 219),   # Bright Cyan
    97: (255, 255, 255),  # Bright White
}

ANSI_16_COLORS_BG = {
    # Standard background colors (40-47)
    40: (0, 0, 0),        # Black
    41: (205, 49, 49),    # Red
    42: (13, 188, 121),   # Green
    43: (229, 229, 16),   # Yellow
    44: (36, 114, 200),   # Blue
    45: (188, 63, 188),   # Magenta
    46: (17, 168, 205),   # Cyan
    47: (229, 229, 229),  # White
    # High-intensity background colors (100-107)
    100: (102, 102, 102), # Bright Black / Dark Gray
    101: (241, 76, 76),   # Bright Red
    102: (35, 209, 139),  # Bright Green
    103: (245, 245, 67),  # Bright Yellow
    104: (59, 142, 234),  # Bright Blue
    105: (214, 112, 214), # Bright Magenta
    106: (41, 184, 219),  # Bright Cyan
    107: (255, 255, 255), # Bright White
}

_XTERM_256_PALETTE: list[tuple[int, int, int]] = []
for _c in range(16):
    _fg_code = 30 + _c if _c < 8 else 90 + (_c - 8)
    _XTERM_256_PALETTE.append(ANSI_16_COLORS_FG[_fg_code])
for _r_step in [0, 95, 135, 175, 215, 255]:
    for _g_step in [0, 95, 135, 175, 215, 255]:
        for _b_step in [0, 95, 135, 175, 215, 255]:
            _XTERM_256_PALETTE.append((_r_step, _g_step, _b_step))
for _gray_step in range(24):
    _g_val = 8 + _gray_step * 10
    _XTERM_256_PALETTE.append((_g_val, _g_val, _g_val))

_SGR_RE = re.compile(r"\033\[([0-9;]*)m")
_ANSI_24BIT_COLOR_RE = re.compile(r"\033\[(38|48);2;(\d+);(\d+);(\d+)m")


def dim_ansi(
    ansi_str: str,
    factor: float,
    *,
    buffer_wide: bool = False,
    default_fg: TrueColor | None = None,
) -> str:
    """
    Scales all ANSI color sequences (24-bit TrueColor, 256-color, and 16-color)
    in the string by factor in [0.0, 1.0]. Used for smooth terminal fade transitions.

    When buffer_wide=True, also enforces dimmed default foreground on unstyled text
    at the start of the buffer and following SGR resets (\\033[0m / \\033[m), ensuring
    complete frame-wide dimming to pitch black (factor 0.0) without leaving bright
    borders, dividers, or unstyled text remnants.
    """
    if not ansi_str:
        return ansi_str

    factor = max(0.0, min(1.0, float(factor)))
    if factor >= 0.999:
        return ansi_str

    if default_fg is None:
        default_fg = TrueColor(204, 204, 204)

    dim_def_r = int(default_fg.r * factor)
    dim_def_g = int(default_fg.g * factor)
    dim_def_b = int(default_fg.b * factor)
    dim_def_fg_seq = f"\033[38;2;{dim_def_r};{dim_def_g};{dim_def_b}m"

    def repl_sgr(m: re.Match[str]) -> str:
        param_str = m.group(1)
        if not param_str:
            if buffer_wide:
                return f"\033[0m{dim_def_fg_seq}"
            return "\033[m"

        tokens = [int(p) if p else 0 for p in param_str.split(";")]
        new_tokens: list[str] = []
        i = 0
        n = len(tokens)
        has_reset = False
        has_fg = False

        while i < n:
            code = tokens[i]
            if code == 0:
                has_reset = True
                has_fg = False
                new_tokens.append("0")
                i += 1
            elif code == 38:
                if i + 4 < n and tokens[i + 1] == 2:
                    r = int(tokens[i + 2] * factor)
                    g = int(tokens[i + 3] * factor)
                    b = int(tokens[i + 4] * factor)
                    new_tokens.extend(["38", "2", str(r), str(g), str(b)])
                    has_fg = True
                    i += 5
                elif i + 2 < n and tokens[i + 1] == 5:
                    idx = max(0, min(255, tokens[i + 2]))
                    orig_r, orig_g, orig_b = _XTERM_256_PALETTE[idx]
                    r = int(orig_r * factor)
                    g = int(orig_g * factor)
                    b = int(orig_b * factor)
                    new_tokens.extend(["38", "2", str(r), str(g), str(b)])
                    has_fg = True
                    i += 3
                else:
                    new_tokens.append(str(code))
                    i += 1
            elif code == 48:
                if i + 4 < n and tokens[i + 1] == 2:
                    r = int(tokens[i + 2] * factor)
                    g = int(tokens[i + 3] * factor)
                    b = int(tokens[i + 4] * factor)
                    new_tokens.extend(["48", "2", str(r), str(g), str(b)])
                    i += 5
                elif i + 2 < n and tokens[i + 1] == 5:
                    idx = max(0, min(255, tokens[i + 2]))
                    orig_r, orig_g, orig_b = _XTERM_256_PALETTE[idx]
                    r = int(orig_r * factor)
                    g = int(orig_g * factor)
                    b = int(orig_b * factor)
                    new_tokens.extend(["48", "2", str(r), str(g), str(b)])
                    i += 3
                else:
                    new_tokens.append(str(code))
                    i += 1
            elif code in ANSI_16_COLORS_FG:
                orig_r, orig_g, orig_b = ANSI_16_COLORS_FG[code]
                r = int(orig_r * factor)
                g = int(orig_g * factor)
                b = int(orig_b * factor)
                new_tokens.extend(["38", "2", str(r), str(g), str(b)])
                has_fg = True
                i += 1
            elif code in ANSI_16_COLORS_BG:
                orig_r, orig_g, orig_b = ANSI_16_COLORS_BG[code]
                r = int(orig_r * factor)
                g = int(orig_g * factor)
                b = int(orig_b * factor)
                new_tokens.extend(["48", "2", str(r), str(g), str(b)])
                i += 1
            elif code == 39:
                if buffer_wide:
                    new_tokens.extend(["38", "2", str(dim_def_r), str(dim_def_g), str(dim_def_b)])
                    has_fg = True
                else:
                    new_tokens.append("39")
                i += 1
            else:
                new_tokens.append(str(code))
                i += 1

        result = f"\033[{';'.join(new_tokens)}m"
        if buffer_wide and has_reset and not has_fg:
            result = f"{result}{dim_def_fg_seq}"
        return result

    result = _SGR_RE.sub(repl_sgr, ansi_str)
    if buffer_wide:
        result = f"{dim_def_fg_seq}{result}"
    return result


def dim_buffer(
    ansi_str: str,
    factor: float,
    default_fg: TrueColor | None = None,
) -> str:
    """
    Dims an entire terminal screen buffer by scaling all color sequences
    (24-bit TrueColor, 256-color, and 16-color ANSI) and enforcing dimmed default
    foreground on unstyled text and after SGR resets.
    """
    return dim_ansi(ansi_str, factor, buffer_wide=True, default_fg=default_fg)



