using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# SI RIVER ON NORTH SOUTH AT WEST
#
###############################################################################

Class SIRiverOnNorthSouthAtWest : SIInternalBase {
    SIRiverOnNorthSouthAtWest() : base("$(Get-Location)\Image Data\SIRiverOnNorthSouthAtWest.json") {}
}
