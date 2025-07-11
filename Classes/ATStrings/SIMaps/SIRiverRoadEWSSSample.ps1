using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# SI RIVER ROAD EWSS SAMPLE
#
###############################################################################

Class SIRiverRoadEWSSSample : SIInternalBase {
    SIRiverRoadEWSSSample() : base("$(Get-Location)\Image Data\SIRiverRoadEWSSSample.json") {}
}
