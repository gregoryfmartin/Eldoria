using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# SI RIVER ON EAST AT NORTH
#
###############################################################################

Class SIRiverOnEastAtNorth : SIInternalBase {
    SIRiverOnEastAtNorth() : base("$(Get-Location)\Image Data\SIRiverOnEastAtNorth.json") {}
}
