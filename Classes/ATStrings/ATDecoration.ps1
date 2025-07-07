using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# AT DECORATION
#
# A SYMBOLIC ENCAPSULATION OF ONE OR MANY ANSI DECORATIONS TO APPLY TO A
# PRECEEDING STRING LITERAL.
#
# RELYS ON:
#   ATCONTROLSEQUENCES
#
###############################################################################

Class ATDecoration {
    [ValidateNotNull()][Boolean]$Blink
    [ValidateNotNull()][Boolean]$Italic
    [ValidateNotNull()][Boolean]$Underline
    [ValidateNotNull()][Boolean]$Strikethru

    ATDecoration() {
        $this.Blink      = $false
        $this.Italic     = $false
        $this.Underline  = $false
        $this.Strikethru = $false
    }

    [String]ToAnsiControlSequenceString() {
        [String]$a = ''

        If($this.Blink -EQ $true) {
            $a += [ATControlSequences]::DecorationBlink
        }
        If($this.Italic -EQ $true) {
            $a += [ATControlSequences]::DecorationItalic
        }
        If($this.Underline -EQ $true) {
            $a += [ATControlSequences]::DecorationUnderline
        }
        If($this.Strikethru -EQ $true) {
            $a += [ATControlSequences]::DecorationStrikethru
        }

        Return $a
    }
}
