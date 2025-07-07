using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# MTO STAIRS
#
###############################################################################

Class MTOStairs : MapTileObject {
    MTOStairs() {
        $this.Name              = 'Stairs'
        $this.MapObjName        = $this.Name.ToLower()
        $this.CanAddToInventory = $true
        $this.ExamineString     = 'A faithful ally for elevating one''s position.'
    }
}
