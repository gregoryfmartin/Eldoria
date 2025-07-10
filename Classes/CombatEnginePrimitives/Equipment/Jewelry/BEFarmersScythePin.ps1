using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEFARMERSSCYTHEPIN
#
###############################################################################

Class BEFarmersScythePin : BEJewelry {
	BEFarmersScythePin() : base() {
		$this.Name               = 'Farmer''s Scythe Pin'
		$this.MapObjName         = 'farmersscythepin'
		$this.PurchasePrice      = 500
		$this.SellPrice          = 250
		$this.TargetStats        = @{
			[StatId]::Luck = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A pin shaped like a miniature scythe, for good harvests.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Luck]) LCK"
		$this.TargetGender       = [Gender]::Unisex
	}
}
