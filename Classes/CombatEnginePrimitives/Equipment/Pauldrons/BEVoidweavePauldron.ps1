using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEVOIDWEAVEPAULDRON
#
###############################################################################

Class BEVoidweavePauldron : BEPauldron {
	BEVoidweavePauldron() : base() {
		$this.Name               = 'Voidweave Pauldron'
		$this.MapObjName         = 'voidweavepauldron'
		$this.PurchasePrice      = 6550
		$this.SellPrice          = 3275
		$this.TargetStats        = @{
			[StatId]::Defense = 131
			[StatId]::MagicDefense = 53
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Crafted from the threads of nothingness, absorbing all magic.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
