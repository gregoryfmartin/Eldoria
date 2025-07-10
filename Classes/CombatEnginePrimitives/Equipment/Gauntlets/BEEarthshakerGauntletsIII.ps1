using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEEARTHSHAKERGAUNTLETSIII
#
###############################################################################

Class BEEarthshakerGauntletsIII : BEGauntlets {
	BEEarthshakerGauntletsIII() : base() {
		$this.Name               = 'Earthshaker Gauntlets III'
		$this.MapObjName         = 'earthshakergauntletsiii'
		$this.PurchasePrice      = 1600
		$this.SellPrice          = 800
		$this.TargetStats        = @{
			[StatId]::Defense = 80
			[StatId]::MagicDefense = 25
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Ultimate Earthshaker Gauntlets, causing devastating tremors.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
