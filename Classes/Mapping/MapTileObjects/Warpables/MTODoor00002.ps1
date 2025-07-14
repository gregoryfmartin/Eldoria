using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# MTO DOOR 00002
#
###############################################################################

Class MTODoor00002 : MTODoor {
    MTODoor00002() {
        $this.WarpToReference = ([Ref]$Script:SampleWarpMap01)
        $this.WarpToX         = 3
    }
}
