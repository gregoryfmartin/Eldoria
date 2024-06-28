using namespace System
using namespace System.Collections
using namespace System.Collections.Generic
using namespace System.Management.Automation.Host
using namespace System.Media

Add-Type -AssemblyName PresentationCore





###############################################################################
#
# GLOBAL VARIABLE DECLARATIONS
#
###############################################################################
[String]$Script:ForegroundColor24Prefix = "`e[38;2;"
[String]$Script:BackgroundColor24Prefix = "`e[48;2;"
[String]$Script:DecorationBlink         = "`e[5m"
[String]$Script:DecorationItalic        = "`e[3m"
[String]$Script:DecorationUnderline     = "`e[4m"
[String]$Script:DecorationStrikethru    = "`e[9m"
[String]$Script:ModifierReset           = "`e[0m"
[String]$Script:CursorHide              = "`e[?25l"
[String]$Script:CursorShow              = "`e[?25h"





###############################################################################
#
# COLOR DEFINITIONS
#
# Hashtables here match the function signatures for the calls to the functions:
#
#    EldAtGenFg24Str
#    EldAtGenBg24Str
#
# Note also that for said functions, black is an implied color since each
# channel will default to zero. Further, Partial Splats are used here due to the
# implement of default parameter values in said functions.
#
###############################################################################
$Script:CCBlack = @{}

$Script:CCWhite = @{
    Red   = 255
    Green = 255
    Blue  = 255
}

$Script:CCRed = @{
    Red = 255
}

$Script:CCGreen = @{
    Green = 255
}

$Script:CCBlue = @{
    Blue = 255
}

$Script:CCYellow = @{
    Red   = 255
    Green = 255
}

$Script:CCDarkYellow = @{
    Red   = 255
    Green = 204
}

$Script:CCDarkCyan = @{
    Green = 139
    Blue  = 139
}

$Script:CCDarkGrey = @{
    Red   = 45
    Green = 45
    Blue  = 45
}

$Script:CCRandom = @{
    Red   = $(Get-Random -Minimum 0 -Maximum 255)
    Green = $(Get-Random -Minimum 0 -Maximum 255)
    Blue  = $(Get-Random -Minimum 0 -Maximum 255)
}

$Script:CCAppleNRedLight = @{
    Red   = 255
    Green = 59
    Blue  = 48
}

$Script:CCAppleNRedDark = @{
    Red   = 255
    Green = 69
    Blue  = 58
}

$Script:CCAppleNRedALight = @{
    Red  = 215
    Blue = 21
}

$Script:CCAppleNRedADark = @{
    Red   = 255
    Green = 105
    Blue  = 97
}

$Script:CCAppleNOrangeLight = @{
    Red   = 255
    Green = 149
}

$Script:CCAppleNOrangeDark = @{
    Red   = 255
    Green = 159
    Blue  = 10
}

$Script:CCAppleNOrangeALight = @{
    Red   = 201
    Green = 52
}

$Script:CCAppleNOrangeADark = @{
    Red   = 255
    Green = 179
    Blue  = 64
}

$Script:CCAppleNYellowLight = @{
    Red   = 255
    Green = 204
}

$Script:CCAppleNYellowDark = @{
    Red   = 255
    Green = 214
    Blue  = 10
}

$Script:CCAppleNYellowALight = @{
    Red   = 178
    Green = 80
}

$Script:CCAppleNYellowADark = @{
    Red   = 255
    Green = 212
    Blue  = 38
}

$Script:CCAppleNGreenLight = @{
    Red   = 52
    Green = 199
    Blue  = 89
}

$Script:CCAppleNGreenDark = @{
    Red   = 48
    Green = 209
    Blue  = 88
}

$Script:CCAppleNGreenALight = @{
    Red   = 36
    Green = 138
    Blue  = 61
}

# TODO: Add the rest of the colors





<##############################################################################
.SYNOPSIS
Generates an ANSI SGR 24-bit Foreground Color Sequence.

.PARAMETER Red
The red channel, clamped to unsigned 8-bit.

.PARAMETER Green
The green channel, clamped to unsigned 8-bit.

.PARAMETER Blue
The blue channel, clamped to unsigned 8-bit.
#>
Function Script:EldAtGenFg24Str {
    [CmdletBinding()]
    Param(
        [ValidateRange(0, 255)]
        [Int]$Red = 0,
        [ValidateRange(0, 255)]
        [Int]$Green = 0,
        [ValidateRange(0, 255)]
        [Int]$Blue = 0
    )

    Process {
        Return "$($Script:ForegroundColor24Prefix)$($Red.ToString());$($Green.ToString());$($Blue.ToString())m"
    }
}





<##############################################################################
.SYNOPSIS
A symbolic placeholder for an empty ANSI SGR 24-bit Foreground Color Sequence.
#>
Function Script:EldAtGenFg24EmptyStr {
    [CmdletBinding()]
    Param()

    Process {
        Return ''
    }
}





<##############################################################################
.SYNOPSIS
Generates an ANSI SGR 24-bit Background Color Sequence.

.PARAMETER Red
The red channel, clamped to unsigned 8-bit.

.PARAMETER Green
The green channel, clamped to unsigned 8-bit.

.PARAMETER Blue
The blue channel, clamped to unsigned 8-bit.
#>
Function Script:EldAtGenBg24Str {
    [CmdletBinding()]
    Param(
        [ValidateRange(0, 255)]
        [Int]$Red = 0,
        [ValidateRange(0, 255)]
        [Int]$Green = 0,
        [ValidateRange(0, 255)]
        [Int]$Blue = 0
    )

    Process {
        Return "$($Script:BackgroundColor24Prefix)$($Red.ToString());$($Green.ToString());$($Blue.ToString())m"
    }
}





<##############################################################################
.SYNOPSIS
A symbolic placeholder for an empty ANSI SGR 24-bit Background Color Sequence.
#>
Function Script:EldAtGenBg24EmptyStr {
    [CmdletBinding()]
    Param()

    Process {
        Return ''
    }
}





<##############################################################################
.SYNOPSIS
Generates an ANSI SGR Cursor Move Sequence.

.PARAMETER Row
The row to move the cursor to. Should be 1 or greater.

.PARAMETER Col
The column to move the cursor to. Should be 1 or greater.
#>
Function Script:EldAtGenCoordStr {
    [CmdletBinding()]
    Param(
        [ValidateRange(1, 100)]
        [Int]$Row = 1,
        [ValidateRange(1, 100)]
        [Int]$Col = 1
    )

    Process {
        Return "`e[$($Row.ToString());$($Col.ToString())H"
    }
}





<##############################################################################
.SYNOPSIS
A symbolic placeholder for an empty ANSI SGR Cursor Move Sequence.
#>
Function Script:EldAtGenCoordEmptyStr {
    [CmdletBinding()]
    Param()

    Process {
        Return ''
    }
}





<##############################################################################
.SYNOPSIS
Generates an ANSI SGR String with various formattings.

.PARAMETER Blink
Does this sequence use the blink modifier?

.PARAMETER Italic
Does this sequence use the italic modifier?

.PARAMETER Underline
Does this sequence use the underline modifier?

.PARAMETER Strikethru
Does this sequence use the strikethru modifier?
#>
Function Script:EldAtGenDecoStr {
    [CmdletBinding()]
    Param(
        [Switch]$Blink,
        [Switch]$Italic,
        [Switch]$Underline,
        [Switch]$Strikethru
    )

    Process {
        [String]$a = ''

        If($Blink) {
            $a += "$($Script:DecorationBlink)"
        }
        If($Italic) {
            $a += "$($Script:DecorationItalic)"
        }
        If($Underline) {
            $a += "$($Script:DecorationUnderline)"
        }
        If($Strikethru) {
            $a += "$($Script:DecorationStrikethru)"
        }

        Return $a
    }
}





<##############################################################################
.SYNOPSIS
A symbolic placeholder for an empty ANSI SGR Decorator Sequence.
#>
Function Script:EldAtGenDecoEmptyStr {
    [CmdletBinding()]
    Param()

    Process {
        Return ''
    }
}





<##############################################################################
.SYNOPSIS
Generates an aggregate of several aspects to a "prefix" of SGRs. Written in the
following order:

    Coordinates -> Decorations -> Foreground Color -> Background Color

.PARAMETER ForegroundColor
The foreground color of the preceeding string.

.PARAMETER BackgroundColor
The background color of the preceeding string.

.PARAMETER Decorations
Any SGR decorations to apply to the preceeding string.

.PARAMETER Coordinates
Where to draw the preceeding string.
#>
Function Script:EldAtGenPrefixStr {
    [CmdletBinding()]
    Param(
        [ValidateNotNull()]
        [String]$ForegroundColor = '',
        [ValidateNotNull()]
        [String]$BackgroundColor = '',
        [ValidateNotNull()]
        [String]$Decorations = '',
        [ValidateNotNull()]
        [String]$Coordinates = ''
    )

    Process {
        Return "$($Coordinates)$($Decorations)$($ForegroundColor)$($BackgroundColor)"
    }
}