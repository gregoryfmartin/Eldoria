using namespace System

Set-StrictMode -Version Latest





###############################################################################
#
# AT CONTROL SEQUENCES
#
# CONTAINS COMMON ANSI-TERMINATED STRINGS THAT ARE USED THROUGHT THE PROGRAM.
#
###############################################################################

Class ATControlSequences {
    Static [String]$ForegroundColor24Prefix = "`e[38;2;"
    Static [String]$BackgroundColor24Prefix = "`e[48;2;"
    Static [String]$DecorationBlink         = "`e[5m"
    Static [String]$DecorationItalic        = "`e[3m"
    Static [String]$DecorationUnderline     = "`e[4m"
    Static [String]$DecorationStrikethru    = "`e[9m"
    Static [String]$ModifierReset           = "`e[0m"
    Static [String]$CursorHide              = "`e[?25l"
    Static [String]$CursorShow              = "`e[?25h"
    Static [String]$DrawOptimizeOn          = "`e[?2026h"
    Static [String]$DrawOptimizeOff         = "`e[?2026l"

    Static [String]GenerateFG24String(
        [TrueColor]$Color
    ) {
        Return "$([ATControlSequences]::ForegroundColor24Prefix)$($Color.Red.Value);$($Color.Green.Value);$($Color.Blue.Value)m"
    }

    Static [String]GenerateBG24String(
        [TrueColor]$Color
    ) {
        Return "$([ATControlSequences]::BackgroundColor24Prefix)$($Color.Red.Value);$($Color.Green.Value);$($Color.Blue.Value)m"
    }

    Static [String]GenerateCoordinateString(
        [Int]$Row, 
        [Int]$Column
    ) {
        Return "`e[$($Row.ToString());$($Column.ToString())H"
    }
}
