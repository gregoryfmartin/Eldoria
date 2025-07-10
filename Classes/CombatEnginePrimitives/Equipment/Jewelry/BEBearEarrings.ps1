using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEBEAREARRINGS
#
###############################################################################

Class BEBearEarrings : BEJewelry {
    BEBearEarrings() : base() {
		$this.Name               = 'Bear Earrings'
		$this.MapObjName         = 'bearearrings'
		$this.PurchasePrice      = 0
		$this.SellPrice          = 0
		$this.TargetStats        = @{
			[StatId]::Speed    = 999
            [StatId]::Accuracy = 999
            [StatId]::Luck     = 999
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'The ultimate in fuzzy ear accessories.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Speed]) SPD  +$($this.TargetStats[[StatId]::Accuracy]) ACC  +$($this.TargetStats[[StatId]::Luck]) LCK"
		$this.TargetGender       = [Gender]::Unisex
    }
}
