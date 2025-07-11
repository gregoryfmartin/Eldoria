using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# SI FIELD PLAINS ROAD NORTH WEST
#
###############################################################################

Class SIFieldPlainsRoadNorthWest : SIInternalBase {
    SIFieldPlainsRoadNorthWest() : base("$(Get-Location)\Image Data\SIFieldPlainsRoadNorthWest.json") {}
}
