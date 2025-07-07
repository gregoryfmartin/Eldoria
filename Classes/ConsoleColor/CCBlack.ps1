using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# CC BLACK 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCBlack24 : ConsoleColor24 {
    CCBlack24() : base(0, 0, 0) {}
}
