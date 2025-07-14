using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# MTO BACON
#
###############################################################################

Class MTOBacon : MapTileObject {
    MTOBacon() {
        $this.Name              = 'Bacon'
        $this.MapObjName        = $this.Name.ToLower()
        $this.CanAddToInventory = $true
        $this.ExamineString     = 'Shredded swine flesh. Cholesterol never tasted so good.'
        $this.KeyItem           = $true
    }
}
