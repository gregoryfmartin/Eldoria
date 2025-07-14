using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECOPPERRING
#
###############################################################################

Class BECopperRing : BEJewelry {
	BECopperRing() : base() {
		$this.Name               = 'Copper Ring'
		$this.MapObjName         = 'copperring'
		$this.PurchasePrice      = 50
		$this.SellPrice          = 25
		$this.TargetStats        = @{
			[StatId]::Defense = 1
			[StatId]::MagicDefense = 1
			[StatId]::Luck = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A simple, unadorned copper ring.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Luck]) LCK"
		$this.TargetGender       = [Gender]::Unisex
	}
}
