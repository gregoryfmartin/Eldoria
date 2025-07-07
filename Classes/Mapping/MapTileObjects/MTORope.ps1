using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# MTO ROPE
#
###############################################################################

Class MTORope : MapTileObject {
    MTORope() {
        $this.Name              = 'Rope'
        $this.MapObjName        = $this.Name.ToLower()
        $this.CanAddToInventory = $true
        $this.ExamineString     = 'It''s not a snake. Hopefully.'
    }
}
