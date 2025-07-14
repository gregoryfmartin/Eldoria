using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEEARTHSHAKERGAUNTLETS
#
###############################################################################

Class BEEarthshakerGauntlets : BEGauntlets {
	BEEarthshakerGauntlets() : base() {
		$this.Name               = 'Earthshaker Gauntlets'
		$this.MapObjName         = 'earthshakergauntlets'
		$this.PurchasePrice      = 1400
		$this.SellPrice          = 700
		$this.TargetStats        = @{
			[StatId]::Defense = 70
			[StatId]::MagicDefense = 15
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets that can cause minor tremors with each strike.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
