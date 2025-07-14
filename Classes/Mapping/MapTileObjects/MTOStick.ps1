using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# MTO STICK
#
###############################################################################

Class MTOStick : MapTileObject {
    MTOStick() {
        $this.Name              = 'Stick'
        $this.MapObjName        = $this.Name.ToLower()
        $this.CanAddToInventory = $true
        $this.ExamineString     = 'Be careful not to poke your eye out with it.'
    }
}
