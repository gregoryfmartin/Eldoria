using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEMYSTICRELICGAUNTLETS
#
###############################################################################

Class BEMysticRelicGauntlets : BEGauntlets {
	BEMysticRelicGauntlets() : base() {
		$this.Name               = 'Mystic Relic Gauntlets'
		$this.MapObjName         = 'mysticrelicgauntlets'
		$this.PurchasePrice      = 1100
		$this.SellPrice          = 550
		$this.TargetStats        = @{
			[StatId]::Defense = 50
			[StatId]::MagicDefense = 20
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets from a forgotten civilization, holding ancient power.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
