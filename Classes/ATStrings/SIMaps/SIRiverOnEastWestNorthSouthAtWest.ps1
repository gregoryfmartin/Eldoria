using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# SI RIVER ON EAST WEST NORTH SOUTH AT WEST
#
###############################################################################

Class SIRiverOnEastWestNorthSouthAtWest : SIInternalBase {
    SIRiverOnEastWestNorthSouthAtWest() : base("$(Get-Location)\Image Data\SIRiverOnEastWestNorthSouthAtWest.json") {}
}
