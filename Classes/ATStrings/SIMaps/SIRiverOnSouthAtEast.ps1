using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# SI RIVER ON SOUTH AT EAST
#
###############################################################################

Class SIRiverOnSouthAtEast : SIInternalBase {
    SIRiverOnSouthAtEast() : base("$(Get-Location)\Image Data\SIRiverOnSouthAtEast.json") {}
}
