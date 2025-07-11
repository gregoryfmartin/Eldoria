using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# SI FIELD NORTH ROAD
#
###############################################################################

Class SIFieldNorthRoad : SIInternalBase {
    SIFieldNorthRoad() : base("$(Get-Location)\Image Data\SIFieldNorthRoadNew.json") {}
}
