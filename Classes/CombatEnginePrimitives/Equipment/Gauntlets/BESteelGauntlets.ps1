using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESTEELGAUNTLETS
#
###############################################################################

Class BESteelGauntlets : BEGauntlets {
	BESteelGauntlets() : base() {
		$this.Name               = 'Steel Gauntlets'
		$this.MapObjName         = 'steelgauntlets'
		$this.PurchasePrice      = 250
		$this.SellPrice          = 125
		$this.TargetStats        = @{
			[StatId]::Defense = 12
			[StatId]::MagicDefense = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Reinforced steel gauntlets, a common choice for adventurers.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
