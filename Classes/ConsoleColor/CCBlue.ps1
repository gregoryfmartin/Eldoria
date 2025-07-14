using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# CC BLUE 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCBlue24 : ConsoleColor24 {
    CCBlue24() : base (0, 0, 255) {}
}
