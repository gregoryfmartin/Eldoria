using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEDRAGONHEARTGAUNTLETS
#
###############################################################################

Class BEDragonheartGauntlets : BEGauntlets {
	BEDragonheartGauntlets() : base() {
		$this.Name               = 'Dragonheart Gauntlets'
		$this.MapObjName         = 'dragonheartgauntlets'
		$this.PurchasePrice      = 1900
		$this.SellPrice          = 950
		$this.TargetStats        = @{
			[StatId]::Defense = 90
			[StatId]::MagicDefense = 35
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets from the heart of a dragon, radiating power.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
