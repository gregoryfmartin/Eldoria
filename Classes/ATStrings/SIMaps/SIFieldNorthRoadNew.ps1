using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# SI FIELD NORTH ROAD NEW
#
###############################################################################

Class SIFieldNorthRoadNew : SIInternalBase {
    SIFieldNorthRoadNew() : base("$PSScriptRoot\..\..\..\Resources\ImageData\SIFieldNorthEastRoadNew.json") {}
}
