using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# MTO DOOR
#
###############################################################################

Class MTODoor : MTOWarpable {
    MTODoor() {
        $this.Name       = 'Door'
        $this.MapObjName = 'door'
    }
}
