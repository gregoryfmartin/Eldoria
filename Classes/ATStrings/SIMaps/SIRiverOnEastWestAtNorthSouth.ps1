using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# SI RIVER ON EAST WEST AT NORTH SOUTH
#
###############################################################################

Class SIRiverOnEastWestAtNorthSouth : SIInternalBase {
    SIRiverOnEastWestAtNorthSouth() : base("$(Get-Location)\Image Data\SIRiverOnEastWestAtNorthSouth.json") {}
}
