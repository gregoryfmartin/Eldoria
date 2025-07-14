using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# SI FIELD NORTH ROAD
#
###############################################################################

Class SIFieldNorthRoad : SIInternalBase {
    SIFieldNorthRoad() : base("$PSScriptRoot\..\..\..\Resources\ImageData\SIFieldNorthRoadNew.json") {}
}
