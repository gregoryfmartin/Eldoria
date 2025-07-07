using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# CC DARK GREY 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCDarkGrey24 : ConsoleColor24 {
    CCDarkGrey24() : base(45, 45, 45) {}
}
