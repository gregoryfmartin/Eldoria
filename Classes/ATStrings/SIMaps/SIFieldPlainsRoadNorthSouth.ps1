using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# SI FIELD PLAINS ROAD NORTH SOUTH
#
###############################################################################

Class SIFieldPlainsRoadNorthSouth : SIInternalBase {
    SIFieldPlainsRoadNorthSouth() : base("$(Get-Location)\Image Data\SIFieldPlainsRoadNorthSouth.json") {}
}
