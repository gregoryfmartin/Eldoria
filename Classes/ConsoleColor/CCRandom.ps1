using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# CC RANDOM 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCRandom24 : ConsoleColor24 {
    CCRandom24() : base($(Get-Random -Maximum 255 -Minimum 0), $(Get-Random -Maximum 255 -Minimum 0), $(Get-Random -Maximum 255 -Minimum 0)) {}
}
