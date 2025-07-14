using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# SI FIELD NORTH EAST ROAD
#
###############################################################################

Class SIFieldNorthEastRoad : SIInternalBase {
    SIFieldNorthEastRoad() : base("$PSScriptRoot\..\..\..\Resources\ImageData\SIFieldNorthEastRoadNew.json") {}
}
