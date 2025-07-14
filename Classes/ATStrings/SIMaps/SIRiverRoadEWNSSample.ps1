using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# SI RIVER ROAD EWNS SAMPLE
#
###############################################################################

Class SIRiverRoadEWNSSample : SIInternalBase {
    SIRiverRoadEWNSSample() : base("$PSScriptRoot\..\..\..\Resources\ImageData\SIRiverRoadEWNSSample.json") {}
}
