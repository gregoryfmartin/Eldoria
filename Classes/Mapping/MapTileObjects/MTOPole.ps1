using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# MTO POLE
#
###############################################################################

Class MTOPole : MapTileObject {
    MTOPole() {
        $this.Name              = 'Pole'
        $this.MapObjName        = $this.Name.ToLower()
        $this.CanAddToInventory = $false
        $this.ExamineString     = 'Not the north or the south one.'
    }
}
