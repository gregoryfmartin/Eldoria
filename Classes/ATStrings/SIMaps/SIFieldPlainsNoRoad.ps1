using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# SI FIELD PLAINS NO ROAD
#
###############################################################################

Class SIFieldPlainsNoRoad : SIInternalBase {
    SIFieldPlainsNoRoad() : base("$PSScriptRoot\..\..\..\Resources\ImageData\SIFieldPlainsNoRoad.json") {}
}
