using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESTORMHEARTGAUNTLETS
#
###############################################################################

Class BEStormheartGauntlets : BEGauntlets {
	BEStormheartGauntlets() : base() {
		$this.Name               = 'Stormheart Gauntlets'
		$this.MapObjName         = 'stormheartgauntlets'
		$this.PurchasePrice      = 900
		$this.SellPrice          = 450
		$this.TargetStats        = @{
			[StatId]::Defense = 45
			[StatId]::MagicDefense = 20
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets that seem to beat with a storm''s heart, powerful.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
