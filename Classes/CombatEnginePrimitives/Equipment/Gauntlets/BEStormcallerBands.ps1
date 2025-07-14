using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESTORMCALLERBANDS
#
###############################################################################

Class BEStormcallerBands : BEGauntlets {
	BEStormcallerBands() : base() {
		$this.Name               = 'Stormcaller Bands'
		$this.MapObjName         = 'stormcallerbands'
		$this.PurchasePrice      = 880
		$this.SellPrice          = 440
		$this.TargetStats        = @{
			[StatId]::Defense = 18
			[StatId]::MagicDefense = 30
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Bands crackling with elemental energy, summoning lightning.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
