using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEMYSTICRELICGAUNTLETSII
#
###############################################################################

Class BEMysticRelicGauntletsII : BEGauntlets {
	BEMysticRelicGauntletsII() : base() {
		$this.Name               = 'Mystic Relic Gauntlets II'
		$this.MapObjName         = 'mysticrelicgauntletsii'
		$this.PurchasePrice      = 1200
		$this.SellPrice          = 600
		$this.TargetStats        = @{
			[StatId]::Defense = 55
			[StatId]::MagicDefense = 25
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'More powerful Mystic Relic Gauntlets, holding stronger ancient power.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
