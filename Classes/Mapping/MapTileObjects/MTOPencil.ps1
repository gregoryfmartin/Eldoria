using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# MTO PENCIL
#
###############################################################################

Class MTOPencil : MapTileObject {
    MTOPencil() : base() {
        $this.Name = 'Pencil'
        $this.MapObjName = $this.Name.ToLower()
        $this.CanAddToInventory = $true
        $this.ExamineString = 'Something to write your will with.'
    }
}
