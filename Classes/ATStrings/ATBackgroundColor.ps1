using namespace System

Set-StrictMode -Version Latest

#//////////////////////////////////////////////////////////////////////////////
#
# AT BACKGROUND COLOR 24
#
# A SYMBOLIC ENCAPSULATION OF CONSOLE COLOR 24 TO BE USED SPECIFICALLY FOR
# BACKGROUND COLOR APPLICATIONS.
#
# RELIES ON:
#   CONSOLECOLOR24
#   ATCONTROLSEQUENCES
#
#//////////////////////////////////////////////////////////////////////////////
Class ATBackgroundColor24 {
    [ValidateNotNull()][ConsoleColor24]$Color

    ATBackgroundColor24(
        [ConsoleColor24]$Color
    ) {
        $this.Color = $Color
    }

    [String]ToAnsiControlSequenceString() {
        Return [ATControlSequences]::GenerateBG24String($this.Color)
    }
}
