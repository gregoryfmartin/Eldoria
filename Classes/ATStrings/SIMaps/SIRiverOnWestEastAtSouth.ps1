using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# SI RIVER ON WEST EAST AT SOUTH
#
###############################################################################

Class SIRiverOnWestEastAtSouth : SIInternalBase {
    SIRiverOnWestEastAtSouth() : base("$(Get-Location)\Image Data\SIRiverOnWestEastAtSouth.json") {}
}
