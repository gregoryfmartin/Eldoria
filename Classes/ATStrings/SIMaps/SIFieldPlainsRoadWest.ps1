using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# SI FIELD PLAINS ROAD WEST
#
###############################################################################

Class SIFieldPlainsRoadWest : SIInternalBase {
    SIFieldPlainsRoadWest() : base("$(Get-Location)\Image Data\SIFieldPlainsRoadWest.json") {}
}
