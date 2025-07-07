using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# MTO YOGURT
#
###############################################################################

Class MTOYogurt : MapTileObject {
    MTOYogurt() {
        $this.Name              = 'Yogurt'
        $this.MapObjName        = $this.Name.ToLower()
        $this.CanAddToInventory = $true
        $this.ExamineString     = 'For some reason, people enjoy this spoiled milk.'
    }
}
