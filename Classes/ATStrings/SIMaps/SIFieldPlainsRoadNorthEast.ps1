using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# SI FIELD PLAINS ROAD NORTH EAST
#
###############################################################################

Class SIFieldPlainsRoadNorthEast : SIInternalBase {
    SIFieldPlainsRoadNorthEast() : base("$(Get-Location)\Image Data\SIFieldPlainsRoadNorthEast.json") {}
}
