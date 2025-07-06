using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# CC APPLE NEUTRAL YELLOW LIGHT 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleNYellowLight24 : ConsoleColor24 {
    CCAppleNYellowLight24() : base(255, 179, 64) {}
}
