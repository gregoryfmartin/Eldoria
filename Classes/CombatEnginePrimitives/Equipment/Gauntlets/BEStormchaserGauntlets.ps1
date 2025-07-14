using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESTORMCHASERGAUNTLETS
#
###############################################################################

Class BEStormchaserGauntlets : BEGauntlets {
	BEStormchaserGauntlets() : base() {
		$this.Name               = 'Stormchaser Gauntlets'
		$this.MapObjName         = 'stormchasergauntlets'
		$this.PurchasePrice      = 550
		$this.SellPrice          = 275
		$this.TargetStats        = @{
			[StatId]::Defense = 27
			[StatId]::MagicDefense = 15
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets designed to withstand and channel lightning.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
