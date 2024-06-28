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





<#
.SYNOPSIS
Generates an ANSI SGR 24-bit Foreground Color sequence.

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





<#
.SYNOPSIS
Generates an ANSI SGR 24-bit Background Color sequence.

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
        Return "$($Script:BackgroundColor24Prefix)$($Red.ToString());$($Green.ToString());$($Blue.ToString())m"
    }
}





<#
.SYNOPSIS
Generates an ANSI SGR Cursor Move sequence.

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