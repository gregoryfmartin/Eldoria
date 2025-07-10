using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEVOIDPAULDRON
#
###############################################################################

Class BEVoidPauldron : BEPauldron {
	BEVoidPauldron() : base() {
		$this.Name               = 'Void Pauldron'
		$this.MapObjName         = 'voidpauldron'
		$this.PurchasePrice      = 4600
		$this.SellPrice          = 2300
		$this.TargetStats        = @{
			[StatId]::Defense = 92
			[StatId]::MagicDefense = 33
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Woven from the fabric of the void, absorbing all light.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
