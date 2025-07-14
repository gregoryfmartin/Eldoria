using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# MTO LADDER
#
###############################################################################

Class MTOLadder : MapTileObject {
    MTOLadder() {
        $this.Name              = 'Ladder'
        $this.MapObjName        = $this.Name.ToLower()
        $this.CanAddToInventory = $false
        $this.ExamineString     = 'Used to climb things. Just don''t walk under one.'
    }
}
