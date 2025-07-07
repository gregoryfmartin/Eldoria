using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# MTO ROCK
#
###############################################################################

Class MTORock : MapTileObject {
    MTORock() {
        $this.Name              = 'Rock'
        $this.MapObjName        = $this.Name.ToLower()
        $this.CanAddToInventory = $true
        $this.ExamineString     = 'A garden variety rock. Good for taunting raccoons with.'
    }
}
