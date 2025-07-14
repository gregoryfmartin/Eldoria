using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# CC DARK CYAN 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCDarkCyan24 : ConsoleColor24 {
    CCDarkCyan24() : base(0, 139, 139) {}
}
