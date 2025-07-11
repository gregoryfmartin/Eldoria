using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# SI FIELD PLAINS ROAD SOUTH
#
###############################################################################

Class SIFieldPlainsRoadSouth : SIInternalBase {
    SIFieldPlainsRoadSouth() : base("$(Get-Location)\Image Data\SIFieldPlainsRoadSouth.json") {}
}
