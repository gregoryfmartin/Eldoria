using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEWYRMHIDEGAUNTLETS
#
###############################################################################

Class BEWyrmhideGauntlets : BEGauntlets {
	BEWyrmhideGauntlets() : base() {
		$this.Name               = 'Wyrmhide Gauntlets'
		$this.MapObjName         = 'wyrmhidegauntlets'
		$this.PurchasePrice      = 720
		$this.SellPrice          = 360
		$this.TargetStats        = @{
			[StatId]::Defense = 31
			[StatId]::MagicDefense = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets made from the tough hide of a lesser wyrm.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
