using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# SI RIVER ON WEST NORTH AT NORTH
#
###############################################################################

Class SIRiverOnWestNorthAtNorth : SIInternalBase {
    SIRiverOnWestNorthAtNorth() : base("$(Get-Location)\Image Data\SIRiverOnWestNorthAtNorth.json") {}
}
