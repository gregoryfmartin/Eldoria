using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# CC DARK YELLOW 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCDarkYellow24 : ConsoleColor24 {
    CCDarkYellow24() : base(255, 204, 0) {}
}
