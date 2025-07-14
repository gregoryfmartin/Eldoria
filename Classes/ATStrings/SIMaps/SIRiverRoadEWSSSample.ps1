using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# SI RIVER ROAD EWSS SAMPLE
#
###############################################################################

Class SIRiverRoadEWSSSample : SIInternalBase {
    SIRiverRoadEWSSSample() : base("$PSScriptRoot\..\..\..\Resources\ImageData\SIRiverRoadEWSSSample.json") {}
}
