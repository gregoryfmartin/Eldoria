using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BETHUNDERPAULDRON
#
###############################################################################

Class BEThunderPauldron : BEPauldron {
	BEThunderPauldron() : base() {
		$this.Name               = 'Thunder Pauldron'
		$this.MapObjName         = 'thunderpauldron'
		$this.PurchasePrice      = 4200
		$this.SellPrice          = 2100
		$this.TargetStats        = @{
			[StatId]::Defense = 84
			[StatId]::MagicDefense = 26
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Resonates with the roar of thunder, empowering lightning defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
