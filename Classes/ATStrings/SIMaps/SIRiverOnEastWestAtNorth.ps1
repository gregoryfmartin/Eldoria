using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# SI RIVER ON EAST WEST AT NORTH
#
###############################################################################

Class SIRiverOnEastWestAtNorth : SIInternalBase {
    SIRiverOnEastWestAtNorth() : base("$(Get-Location)\Image Data\SIRiverOnEastWestAtNorth.json") {}
}
