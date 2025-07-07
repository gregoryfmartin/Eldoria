using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# CC RED 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCRed24 : ConsoleColor24 {
    CCRed24() : base(255, 0, 0) {}
}
