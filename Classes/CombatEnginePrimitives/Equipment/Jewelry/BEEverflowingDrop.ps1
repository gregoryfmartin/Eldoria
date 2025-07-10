using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEEVERFLOWINGDROP
#
###############################################################################

Class BEEverflowingDrop : BEJewelry {
	BEEverflowingDrop() : base() {
		$this.Name               = 'Everflowing Drop'
		$this.MapObjName         = 'everflowingdrop'
		$this.PurchasePrice      = 1250
		$this.SellPrice          = 625
		$this.TargetStats        = @{
			[StatId]::MagicAttack = 1
			[StatId]::MagicDefense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A drop of water that never dries.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
