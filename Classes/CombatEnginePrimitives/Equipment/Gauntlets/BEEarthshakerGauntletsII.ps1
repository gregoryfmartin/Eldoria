using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEEARTHSHAKERGAUNTLETSII
#
###############################################################################

Class BEEarthshakerGauntletsII : BEGauntlets {
	BEEarthshakerGauntletsII() : base() {
		$this.Name               = 'Earthshaker Gauntlets II'
		$this.MapObjName         = 'earthshakergauntletsii'
		$this.PurchasePrice      = 1500
		$this.SellPrice          = 750
		$this.TargetStats        = @{
			[StatId]::Defense = 75
			[StatId]::MagicDefense = 20
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Improved Earthshaker Gauntlets, causing stronger tremors.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
