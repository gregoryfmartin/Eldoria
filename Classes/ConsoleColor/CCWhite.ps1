using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# CC WHITE 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCWhite24 : ConsoleColor24 {
    CCWhite24() : base(255, 255, 255) {}
}
