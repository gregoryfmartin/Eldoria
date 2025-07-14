using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEDREADSKULLGAUNTLETS
#
###############################################################################

Class BEDreadskullGauntlets : BEGauntlets {
	BEDreadskullGauntlets() : base() {
		$this.Name               = 'Dreadskull Gauntlets'
		$this.MapObjName         = 'dreadskullgauntlets'
		$this.PurchasePrice      = 1600
		$this.SellPrice          = 800
		$this.TargetStats        = @{
			[StatId]::Defense = 80
			[StatId]::MagicDefense = 27
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets shaped like skulls, exuding fear.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
