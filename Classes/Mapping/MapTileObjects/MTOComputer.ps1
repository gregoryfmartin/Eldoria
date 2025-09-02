using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# MTO COMPUTER
#
###############################################################################

Class MTOComputer : MapTileObject {
    MTOComputer() : base() {
        $this.Name = 'Computer'
        $this.MapObjName = $this.Name.ToLower()
        $this.CanAddToInventory = $true
        $this.ExamineString = 'Beep Beep Boop'
    }
}
