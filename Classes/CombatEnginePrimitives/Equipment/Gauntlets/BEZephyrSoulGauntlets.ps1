using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEZEPHYRSOULGAUNTLETS
#
###############################################################################

Class BEZephyrSoulGauntlets : BEGauntlets {
	BEZephyrSoulGauntlets() : base() {
		$this.Name               = 'Zephyr Soul Gauntlets'
		$this.MapObjName         = 'zephyrsoulgauntlets'
		$this.PurchasePrice      = 1200
		$this.SellPrice          = 600
		$this.TargetStats        = @{
			[StatId]::Defense = 30
			[StatId]::MagicDefense = 35
			[StatId]::Accuracy = 15
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets imbued with the soul of the wind, incredibly light.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Unisex
	}
}
