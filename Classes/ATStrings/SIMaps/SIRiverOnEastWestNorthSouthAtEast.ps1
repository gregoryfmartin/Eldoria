using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# SI RIVER ON EAST WEST NORTH SOUTH AT EAST
#
###############################################################################

Class SIRiverOnEastWestNorthSouthAtEast : SIInternalBase {
    SIRiverOnEastWestNorthSouthAtEast() : base("$(Get-Location)\Image Data\SIRiverOnEastWestNorthSouthAtEast.json") {}
}
