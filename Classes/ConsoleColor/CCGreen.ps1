using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# CC GREEN 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCGreen24 : ConsoleColor24 {
    CCGreen24() : base(0, 255, 0) {}
}
