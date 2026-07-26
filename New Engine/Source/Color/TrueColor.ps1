using namespace System

Set-StrictMode -Version Latest





###############################################################################
#
# TRUE COLOR SUPPORT
#
###############################################################################

Class TrueColor {
    [ColorChannel]$Red
    [ColorChannel]$Green
    [ColorChannel]$Blue
    
    TrueColor() {
        $this.Red   = [ColorChannel]::new()
        $this.Green = [ColorChannel]::new()
        $this.Blue  = [ColorChannel]::new()
    }

    TrueColor(
        [ColorChannel]$Red,
        [ColorChannel]$Green,
        [ColorChannel]$Blue
    ) {
        If($null -EQ $Red -OR
            $null -EQ $Green -OR
            $null -EQ $Red) {
                $this.Red = [ColorChannel]::new()
                $this.Green = [ColorChannel]::new()
                $this.Blue = [ColorChannel]::new()
        }

        $this.Red = $Red
        $this.Green = $Green
        $this.Blue = $Blue
    }

    TrueColor(
        [Int]$Hex
    ) {
        $this.Red = [ColorChannel]::new(($Hex -SHR 16) -BAND 0xFF)
        $this.Green = [ColorChannel]::new(($Hex -SHR 8) -BAND 0xFF)
        $this.Blue = [ColorChannel]::new($Hex -BAND 0xFF)
    }
}

Class ColorLibrary {
    Static [TrueColor]$IndianRed = [TrueColor]::new(0xCD5C5C)
    Static [TrueColor]$Crimson = [TrueColor]::new(0xDC143C)
    Static [TrueColor]$LightCoral = [TrueColor]::new(0xF08080)
    Static [TrueColor]$Red = [TrueColor]::new(0xFF0000)
    Static [TrueColor]$Salmon = [TrueColor]::new(0xFA8072)
    Static [TrueColor]$FireBrick = [TrueColor]::new(0xB22222)
    Static [TrueColor]$DarkSalmon = [TrueColor]::new(0xE9967A)
    Static [TrueColor]$DarkRed = [TrueColor]::new(0x8B0000)
    Static [TrueColor]$Pink = [TrueColor]::new(0xFFC0CB)
    Static [TrueColor]$MediumVioletRed = [TrueColor]::new(0xC71585)
    Static [TrueColor]$LightPink = [TrueColor]::new(0xFFB6C1)
    Static [TrueColor]$PaleVioletRed = [TrueColor]::new(0xDB7093)
    Static [TrueColor]$HotPink = [TrueColor]::new(0xFF69B4)
    Static [TrueColor]$DeepPink = [TrueColor]::new(0xFF1493)
    Static [TrueColor]$LightSalmon = [TrueColor]::new(0xFFA07A)
    Static [TrueColor]$DarkOrange = [TrueColor]::new(0xFF8C00)
    Static [TrueColor]$Coral = [TrueColor]::new(0xFF7F50)
    Static [TrueColor]$Orange = [TrueColor]::new(0xFFA500)
    Static [TrueColor]$Tomato = [TrueColor]::new(0xFF6347)
    Static [TrueColor]$Gold = [TrueColor]::new(0xFFD700)
    Static [TrueColor]$OrangeRed = [TrueColor]::new(0xFF4500)
    Static [TrueColor]$Yellow = [TrueColor]::new(0xFFFF00)
    Static [TrueColor]$LightYellow = [TrueColor]::new(0xFFFFE0)
    Static [TrueColor]$PapayaWhip = [TrueColor]::new(0xFFEFD5)
    Static [TrueColor]$LemonChiffon = [TrueColor]::new(0xFFFACD)
    Static [TrueColor]$Moccasin = [TrueColor]::new(0xFFE4B5)
    Static [TrueColor]$LightGoldenrodYellow = [TrueColor]::new(0xFAFAD2)
    Static [TrueColor]$PeachPuff = [TrueColor]::new(0xFFDAB9)
    Static [TrueColor]$PaleGoldenrod = [TrueColor]::new(0xEEE8AA)
    Static [TrueColor]$Khaki = [TrueColor]::new(0xF0E68C)
    Static [TrueColor]$DarkKhaki = [TrueColor]::new(0xBDB76B)
    Static [TrueColor]$Lavender = [TrueColor]::new(0xE6E6FA)
    Static [TrueColor]$MediumOrchid = [TrueColor]::new(0xBA55D3)
    Static [TrueColor]$Thistle = [TrueColor]::new(0xD8BFD8)
    Static [TrueColor]$Plum = [TrueColor]::new(0xDDA0DD)
    Static [TrueColor]$DarkViolet = [TrueColor]::new(0x9400D3)
    Static [TrueColor]$Violet = [TrueColor]::new(0xEE82EE)
    Static [TrueColor]$BlueViolet = [TrueColor]::new(0x8A2BE2)
    Static [TrueColor]$Orchid = [TrueColor]::new(0xDA70D6)
    Static [TrueColor]$MediumPurple = [TrueColor]::new(0x9370DB)
    Static [TrueColor]$Magenta = [TrueColor]::new(0xFF00FF)
    Static [TrueColor]$Fuchsia = [TrueColor]::new(0xFF00FF)
    Static [TrueColor]$SlateBlue = [TrueColor]::new(0x6A5ACD)
    Static [TrueColor]$MediumSlateBlue = [TrueColor]::new(0x7B68EE)
    Static [TrueColor]$DarkSlateBlue = [TrueColor]::new(0x483D8B)
    Static [TrueColor]$Purple = [TrueColor]::new(0x800080)
    Static [TrueColor]$Indigo = [TrueColor]::new(0x4B0082)
    Static [TrueColor]$GreenYellow = [TrueColor]::new(0xADFF2F)
    Static [TrueColor]$SeaGreen = [TrueColor]::new(0x2E8B57)
    Static [TrueColor]$Chartreuse = [TrueColor]::new(0x7FFF00)
    Static [TrueColor]$ForestGreen = [TrueColor]::new(0x228B22)
    Static [TrueColor]$LawnGreen = [TrueColor]::new(0x7CFC00)
    Static [TrueColor]$Green = [TrueColor]::new(0x008000)
    Static [TrueColor]$Lime = [TrueColor]::new(0x00FF00)
    Static [TrueColor]$DarkGreen = [TrueColor]::new(0x006400)
    Static [TrueColor]$LimeGreen = [TrueColor]::new(0x32CD32)
    Static [TrueColor]$YellowGreen = [TrueColor]::new(0x9ACD32)
    Static [TrueColor]$PaleGreen = [TrueColor]::new(0x98FB98)
    Static [TrueColor]$OliveDrab = [TrueColor]::new(0x6B8E23)
    Static [TrueColor]$LightGreen = [TrueColor]::new(0x90EE90)
    Static [TrueColor]$Olive = [TrueColor]::new(0x808000)
    Static [TrueColor]$MediumSpringGreen = [TrueColor]::new(0x00FA9A)
    Static [TrueColor]$DarkOliveGreen = [TrueColor]::new(0x556B2F)
    Static [TrueColor]$SpringGreen = [TrueColor]::new(0x00FF7F)
    Static [TrueColor]$MediumAquamarine = [TrueColor]::new(0x66CDAA)
    Static [TrueColor]$MediumSeaGreen = [TrueColor]::new(0x3CB371)
    Static [TrueColor]$DarkSeaGreen = [TrueColor]::new(0x8FBC8F)
    Static [TrueColor]$LightSeaGreen = [TrueColor]::new(0x20B2AA)
    Static [TrueColor]$DarkCyan = [TrueColor]::new(0x008B8B)
    Static [TrueColor]$Teal = [TrueColor]::new(0x008080)
    Static [TrueColor]$Aqua = [TrueColor]::new(0x00FFFF)
    Static [TrueColor]$Cyan = [TrueColor]::new(0x00FFFF)
    Static [TrueColor]$SkyBlue = [TrueColor]::new(0x87CEEB)
    Static [TrueColor]$LightCyan = [TrueColor]::new(0xE0FFFF)
    Static [TrueColor]$LightSkyBlue = [TrueColor]::new(0x87CEFA)
    Static [TrueColor]$PaleTurquoise = [TrueColor]::new(0xAFEEEE)
    Static [TrueColor]$DeepSkyBlue = [TrueColor]::new(0x00BFFF)
    Static [TrueColor]$Aquamarine = [TrueColor]::new(0x7FFFD4)
    Static [TrueColor]$DodgerBlue = [TrueColor]::new(0x1E90FF)
    Static [TrueColor]$Turquoise = [TrueColor]::new(0x40E0D0)
    Static [TrueColor]$CornflowerBlue = [TrueColor]::new(0x6495ED)
    Static [TrueColor]$MediumTurquoise = [TrueColor]::new(0x48D1CC)
    Static [TrueColor]$RoyalBlue = [TrueColor]::new(0x4169E1)
    Static [TrueColor]$DarkTurquoise = [TrueColor]::new(0x00CED1)
    Static [TrueColor]$Blue = [TrueColor]::new(0x0000FF)
    Static [TrueColor]$CadetBlue = [TrueColor]::new(0x5F9EA0)
    Static [TrueColor]$MediumBlue = [TrueColor]::new(0x0000CD)
    Static [TrueColor]$SteelBlue = [TrueColor]::new(0x4682B4)
    Static [TrueColor]$DarkBlue = [TrueColor]::new(0x00008B)
    Static [TrueColor]$LightSteelBlue = [TrueColor]::new(0xB0C4DE)
    Static [TrueColor]$Navy = [TrueColor]::new(0x000080)
    Static [TrueColor]$PowderBlue = [TrueColor]::new(0xB0E0E6)
    Static [TrueColor]$MidnightBlue = [TrueColor]::new(0x191970)
    Static [TrueColor]$LightBlue = [TrueColor]::new(0xADD8E6)
    Static [TrueColor]$Cornsilk = [TrueColor]::new(0xFFF8DC)
    Static [TrueColor]$RosyBrown = [TrueColor]::new(0xBC8F8F)
    Static [TrueColor]$BlanchedAlmond = [TrueColor]::new(0xFFEBCD)
    Static [TrueColor]$SandyBrown = [TrueColor]::new(0xF4A460)
    Static [TrueColor]$Bisque = [TrueColor]::new(0xFFE4C4)
    Static [TrueColor]$Goldenrod = [TrueColor]::new(0xDAA520)
    Static [TrueColor]$NavajoWhite = [TrueColor]::new(0xFFDEAD)
    Static [TrueColor]$DarkGoldenrod = [TrueColor]::new(0xB8860B)
    Static [TrueColor]$Wheat = [TrueColor]::new(0xF5DEB3)
    Static [TrueColor]$Peru = [TrueColor]::new(0xCD853F)
    Static [TrueColor]$BurlyWood = [TrueColor]::new(0xDEB887)
    Static [TrueColor]$Chocolate = [TrueColor]::new(0xD2691E)
    Static [TrueColor]$Tan = [TrueColor]::new(0xD2B48C)
    Static [TrueColor]$SaddleBrown = [TrueColor]::new(0x8B4513)
    Static [TrueColor]$Sienna = [TrueColor]::new(0xA0522D)
    Static [TrueColor]$Maroon = [TrueColor]::new(0x800000)
    Static [TrueColor]$Brown = [TrueColor]::new(0xA52A2A)
    Static [TrueColor]$White = [TrueColor]::new(0xFFFFFF)
    Static [TrueColor]$Gainsboro = [TrueColor]::new(0xDCDCDC)
    Static [TrueColor]$Snow = [TrueColor]::new(0xFFFAFA)
    Static [TrueColor]$LightGrey = [TrueColor]::new(0xD3D3D3)
    Static [TrueColor]$Honeydew = [TrueColor]::new(0xF0FFF0)
    Static [TrueColor]$Silver = [TrueColor]::new(0xC0C0C0)
    Static [TrueColor]$MintCream = [TrueColor]::new(0xF5FFFA)
    Static [TrueColor]$DarkGrey = [TrueColor]::new(0xA9A9A9)
    Static [TrueColor]$Azure = [TrueColor]::new(0xF0FFFF)
    Static [TrueColor]$Grey = [TrueColor]::new(0x808080)
    Static [TrueColor]$AliceBlue = [TrueColor]::new(0xF0F8FF)
    Static [TrueColor]$DimGrey = [TrueColor]::new(0x696969)
    Static [TrueColor]$GhostWhite = [TrueColor]::new(0xF8F8FF)
    Static [TrueColor]$LightSlateGrey = [TrueColor]::new(0x778899)
    Static [TrueColor]$WhiteSmoke = [TrueColor]::new(0xF5F5F5)
    Static [TrueColor]$SlateGrey = [TrueColor]::new(0x708090)
    Static [TrueColor]$Seashell = [TrueColor]::new(0xFFF5EE)
    Static [TrueColor]$DarkSlateGrey = [TrueColor]::new(0x2F4F4F)
    Static [TrueColor]$Beige = [TrueColor]::new(0xF5F5DC)
    Static [TrueColor]$Black = [TrueColor]::new(0x000000)
    Static [TrueColor]$OldLace = [TrueColor]::new(0xFDF5E6)
    Static [TrueColor]$FloralWhite = [TrueColor]::new(0xFFFAF0)
    Static [TrueColor]$Ivory = [TrueColor]::new(0xFFFFF0)
    Static [TrueColor]$AntiqueWhite = [TrueColor]::new(0xFAEBD7)
    Static [TrueColor]$Linen = [TrueColor]::new(0xFAF0E6)
    Static [TrueColor]$LavenderBlush = [TrueColor]::new(0xFFF0F5)
    Static [TrueColor]$AppleRedLight = [TrueColor]::new(0xFF383C)
    Static [TrueColor]$AppleRedDark = [TrueColor]::new(0xFF4245)
    Static [TrueColor]$AppleOrangeLight = [TrueColor]::new(0xFF8D28)
    Static [TrueColor]$AppleOrangeDark = [TrueColor]::new(0xFF9230)
    Static [TrueColor]$AppleYellowLight = [TrueColor]::new(0xFFCC00)
    Static [TrueColor]$AppleYellowDark = [TrueColor]::new(0xFFD600)
    Static [TrueColor]$AppleGreenLight = [TrueColor]::new(0x34C759)
    Static [TrueColor]$AppleGreenDark = [TrueColor]::new(0x30D158)
    Static [TrueColor]$AppleMintLight = [TrueColor]::new(0x00C8B3)
    Static [TrueColor]$AppleMintDark = [TrueColor]::new(0x00DAC3)
    Static [TrueColor]$AppleTealLight = [TrueColor]::new(0x00C3D0)
    Static [TrueColor]$AppleTealDark = [TrueColor]::new(0x00D2E0)
    Static [TrueColor]$AppleCyanLight = [TrueColor]::new(0x00C0E8)
    Static [TrueColor]$AppleCyanDark = [TrueColor]::new(0x3CD3FE)
    Static [TrueColor]$AppleBlueLight = [TrueColor]::new(0x0088FF)
    Static [TrueColor]$AppleBlueDark = [TrueColor]::new(0x0091FF)
    Static [TrueColor]$AppleIndigoLight = [TrueColor]::new(0x6155F5)
    Static [TrueColor]$AppleIndigoDark = [TrueColor]::new(0x6D7CFF)
    Static [TrueColor]$ApplePurpleLight = [TrueColor]::new(0xCB30E0)
    Static [TrueColor]$ApplePurpleDark = [TrueColor]::new(0xDB34F2)
    Static [TrueColor]$ApplePinkLight = [TrueColor]::new(0xFF2D55)
    Static [TrueColor]$ApplePinkDark = [TrueColor]::new(0xFF375F)
    Static [TrueColor]$AppleBrownLight = [TrueColor]::new(0xAC7F5E)
    Static [TrueColor]$AppleBrownDark = [TrueColor]::new(0xB78A66)
    Static [TrueColor]$MistyRose = [TrueColor]::new(0xFFE4E1)
}
