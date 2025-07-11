using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# SI FIELD PLAINS ROAD EAST
#
###############################################################################

Class SIFieldPlainsRoadEast : SIInternalBase {
    SIFieldPlainsRoadEast() : base("$(Get-Location)\Image Data\SIFieldPlainsRoadEast.json") {}
}
