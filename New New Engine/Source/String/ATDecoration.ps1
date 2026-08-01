using namespace System

Set-StrictMode -Version Latest





###############################################################################
#
# AT DECORATION
#
# A SYMBOLIC ENCAPSULATION OF ONE OR MANY ANSI DECORATIONS TO APPLY TO A
# PRECEEDING STRING LITERAL.
#
###############################################################################

Class ATDecoration {
    [Boolean]$Blink
    [Boolean]$Italic
    [Boolean]$Underline
    [Boolean]$Strikethru

    ATDecoration() {
        $this.Blink      = $false
        $this.Italic     = $false
        $this.Underline  = $false
        $this.Strikethru = $false
    }

    [String]ToAnsiControlSequenceString() {
        [String]$Composite = ''

        If($this.Blink -EQ $true) {
            $Composite += "$([ATControlSequences]::DecorationBlink)"
        }
        If($this.Italic -EQ $true) {
            $Composite += "$([ATControlSequences]::DecorationItalic)"
        }
        If($this.Underline -EQ $true) {
            $Composite += "$([ATControlSequences]::DecorationUnderline)"
        }
        If($this.Strikethru -EQ $true) {
            $Composite += "$([ATControlSequences]::DecorationStrikethru)"
        }

        Return "$($Composite)"
    }
}
