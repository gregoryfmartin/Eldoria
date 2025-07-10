using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEONYXHEARTGAUNTLETS
#
###############################################################################

Class BEOnyxHeartGauntlets : BEGauntlets {
	BEOnyxHeartGauntlets() : base() {
		$this.Name               = 'Onyx Heart Gauntlets'
		$this.MapObjName         = 'onyxheartgauntlets'
		$this.PurchasePrice      = 1800
		$this.SellPrice          = 900
		$this.TargetStats        = @{
			[StatId]::Defense = 85
			[StatId]::MagicDefense = 30
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets with an onyx core, drawing dark energy.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
