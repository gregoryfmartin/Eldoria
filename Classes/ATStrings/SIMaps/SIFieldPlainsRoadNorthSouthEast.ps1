using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# SI FIELD PLAINS ROAD NORTH SOUTH EAST
#
###############################################################################

Class SIFieldPlainsRoadNorthSouthEast : SIInternalBase {
    SIFieldPlainsRoadNorthSouthEast() : base("$(Get-Location)\Image Data\SIFieldPlainsRoadNorthSouthEast.json") {}
}
