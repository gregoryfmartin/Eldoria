using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# SI RIVER ON WEST AT NORTH
#
###############################################################################

Class SIRiverOnWestAtNorth : SIInternalBase {
    SIRiverOnWestAtNorth() : base("$(Get-Location)\Image Data\SIRiverOnWestAtNorth.json") {}
}
