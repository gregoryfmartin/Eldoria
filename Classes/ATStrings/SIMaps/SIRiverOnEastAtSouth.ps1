using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# SI RIVER ON EAST AT SOUTH
#
###############################################################################

Class SIRiverOnEastAtSouth : SIInternalBase {
    SIRiverOnEastAtSouth() : base("$(Get-Location)\Image Data\SIRiverOnEastAtSouth.json") {}
}
