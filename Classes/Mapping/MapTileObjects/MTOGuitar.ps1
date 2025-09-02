using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# MTO GUITAR
#
###############################################################################

Class MTOGuitar : MapTileObject {
    MTOGuitar() : base() {
        $this.Name = 'Guitar'
        $this.MapObjName = $this.Name.ToLower()
        $this.CanAddToInventory = $true
        $this.ExamineString = 'Shred like Sam and Higgs.'
    }
}
