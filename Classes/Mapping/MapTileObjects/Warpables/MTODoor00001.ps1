using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# MTO DOOR 00001
#
###############################################################################

Class MTODoor00001 : MTODoor {
    MTODoor00001() {
        $this.WarpToReference = ([Ref]$Script:SampleWarpMap02)
    }
}
