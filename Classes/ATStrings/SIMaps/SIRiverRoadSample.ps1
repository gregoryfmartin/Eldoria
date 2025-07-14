using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# SI RIVER ROAD SAMPLE
#
###############################################################################

Class SIRiverRoadSample : SIInternalBase {
    SIRiverRoadSample() : base("$PSScriptRoot\..\..\..\Resources\ImageData\SIRiverRoadSample.json") {}
}
