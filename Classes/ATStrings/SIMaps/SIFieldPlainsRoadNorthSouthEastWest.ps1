using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# SI FIELD PLAINS ROAD NORTH SOUTH EAST WEST
#
###############################################################################

Class SIFieldPlainsRoadNorthSouthEastWest : SIInternalBase {
    SIFieldPlainsRoadNorthSouthEastWest() : base("$(Get-Location)\Image Data\SIFieldPlainsRoadNorthSouthEastWest.json") {}
}
