using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# CC APPLE RED LIGHT 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleRedLight24 : ConsoleColor24 {
    CCAppleRedLight24() : base(255, 59, 48) {}
}
