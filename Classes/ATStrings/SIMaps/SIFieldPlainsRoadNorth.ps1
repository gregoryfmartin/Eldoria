using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# SI FIELD PLAINS ROAD NORTH
#
###############################################################################

Class SIFieldPlainsRoadNorth : SIInternalBase {
    SIFieldPlainsRoadNorth() : base("$(Get-Location)\Image Data\SIFieldPlainsRoadNorth.json") {}
}
