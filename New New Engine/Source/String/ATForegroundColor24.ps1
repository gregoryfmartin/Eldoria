using namespace System

Set-StrictMode -Version Latest





###############################################################################
#
# AT FOREGROUND COLOR 24
#
# A SYMBOLIC ENCAPSULATION OF CONSOLE COLOR 24 TO BE USED SPECIFICALLY FOR
# FOREGROUND COLOR APPLICATIONS.
#
###############################################################################

Class ATForegroundColor24 {
    [TrueColor]$Color

    ATForegroundColor24(
        [TrueColor]$Color
    ) {
        $this.Color = $Color
    }

    [String]ToAnsiControlSequenceString() {
        Return [ATControlSequences]::GenerateFG24String($this.Color)
    }
}
