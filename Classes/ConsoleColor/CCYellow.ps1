using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# CC YELLOW 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCYellow24 : ConsoleColor24 {
    CCYellow24() : base(255, 255, 0) {}
}
