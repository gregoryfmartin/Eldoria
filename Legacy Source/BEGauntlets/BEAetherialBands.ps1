using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEAETHERIALBANDS
#
###############################################################################

Class BEAetherialBands : BEGauntlets {
	BEAetherialBands() : base() {
		$this.Name               = 'Aetherial Bands'
		$this.MapObjName         = 'aetherialbands'
		$this.PurchasePrice      = 1100
		$this.SellPrice          = 550
		$this.TargetStats        = @{
			[StatId]::Defense = 17
			[StatId]::MagicDefense = 38
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Bands pulsating with pure magical essence.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
