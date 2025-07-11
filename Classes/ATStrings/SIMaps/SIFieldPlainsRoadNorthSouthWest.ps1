using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# SI FIELD PLAINS ROAD NORTH SOUTH WEST
#
###############################################################################

Class SIFieldPlainsRoadNorthSouthWest : SIInternalBase {
    SIFieldPlainsRoadNorthSouthWest() : base("$(Get-Location)\Image Data\SIFieldPlainsRoadNorthSouthWest.json") {}
}
