using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# SI RIVER ON NORTH SOUTH EAST AT EAST
#
###############################################################################

Class SIRiverOnNorthSouthEastAtEast : SIInternalBase {
    SIRiverOnNorthSouthEastAtEast() : base("$(Get-Location)\Image Data\SIRiverOnNorthSouthEastAtEast.json") {}
}
