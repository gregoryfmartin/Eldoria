using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# CC APPLE YELLOW LIGHT 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleYellowLight24 : ConsoleColor24 {
    CCAppleYellowLight24() : base(255, 204, 0) {}
}
