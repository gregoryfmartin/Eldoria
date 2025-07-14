using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEDEEPRUNEGAUNTLETS
#
###############################################################################

Class BEDeepruneGauntlets : BEGauntlets {
	BEDeepruneGauntlets() : base() {
		$this.Name               = 'Deeprune Gauntlets'
		$this.MapObjName         = 'deeprunegauntlets'
		$this.PurchasePrice      = 650
		$this.SellPrice          = 325
		$this.TargetStats        = @{
			[StatId]::Defense = 32
			[StatId]::MagicDefense = 16
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets with deeply etched runes, enhancing their power.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
