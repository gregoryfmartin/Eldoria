using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEGRIMSKULLGAUNTLETS
#
###############################################################################

Class BEGrimskullGauntlets : BEGauntlets {
	BEGrimskullGauntlets() : base() {
		$this.Name               = 'Grimskull Gauntlets'
		$this.MapObjName         = 'grimskullgauntlets'
		$this.PurchasePrice      = 1600
		$this.SellPrice          = 800
		$this.TargetStats        = @{
			[StatId]::Defense = 75
			[StatId]::MagicDefense = 20
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets adorned with skulls, intimidating and dark.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
