using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# CC APPLE CYAN LIGHT 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleCyanLight24 : ConsoleColor24 {
    CCAppleCyanLight24() : base(50, 173, 230) {}
}
