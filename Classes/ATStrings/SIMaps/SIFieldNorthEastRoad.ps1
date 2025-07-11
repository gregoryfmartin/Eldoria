using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# SI FIELD NORTH EAST ROAD
#
###############################################################################

Class SIFieldNorthEastRoad : SIInternalBase {
    SIFieldNorthEastRoad() : base("$(Get-Location)\Image Data\SIFieldNorthEastRoadNew.json") {}
}
