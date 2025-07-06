using namespace System

Set-StrictMode -Version Latest

#//////////////////////////////////////////////////////////////////////////////
#
# AT FOREGROUND COLOR 24
#
# A SYMBOLIC ENCAPSULATION OF CONSOLE COLOR 24 TO BE USED SPECIFICALLY FOR
# FOREGROUND COLOR APPLICATIONS.
#
# RELIES ON:
#   CONSOLECOLOR24
#   ATCONTROLSEQUENCES
#
#//////////////////////////////////////////////////////////////////////////////
Class ATForegroundColor24 {
    [ValidateNotNull()][ConsoleColor24]$Color

    ATForegroundColor24(
        [ConsoleColor24]$Color
    ) {
        $this.Color = $Color
    }

    [String]ToAnsiControlSequenceString() {
        Return [ATControlSequences]::GenerateFG24String($this.Color)
    }
}
