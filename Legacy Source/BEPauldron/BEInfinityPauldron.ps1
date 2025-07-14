using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEINFINITYPAULDRON
#
###############################################################################

Class BEInfinityPauldron : BEPauldron {
	BEInfinityPauldron() : base() {
		$this.Name               = 'Infinity Pauldron'
		$this.MapObjName         = 'infinitypauldron'
		$this.PurchasePrice      = 6650
		$this.SellPrice          = 3325
		$this.TargetStats        = @{
			[StatId]::Defense = 133
			[StatId]::MagicDefense = 54
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Embodies infinite possibilities, granting varied resistances.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
