using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# MTO APPLE
#
###############################################################################

Class MTOApple : MapTileObject {
    MTOApple() {
        $this.Name              = 'Apple'
        $this.MapObjName        = $this.Name.ToLower()
        $this.CanAddToInventory = $true
        $this.ExamineString     = 'A big, juicy, red apple. Worm not included.'
    }
}
