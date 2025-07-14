using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEINFERNOCOREGAUNTLETS
#
###############################################################################

Class BEInfernoCoreGauntlets : BEGauntlets {
	BEInfernoCoreGauntlets() : base() {
		$this.Name               = 'Inferno Core Gauntlets'
		$this.MapObjName         = 'infernocoregauntlets'
		$this.PurchasePrice      = 1500
		$this.SellPrice          = 750
		$this.TargetStats        = @{
			[StatId]::Defense = 75
			[StatId]::MagicDefense = 33
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets with a perpetual internal flame, burning hot.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
