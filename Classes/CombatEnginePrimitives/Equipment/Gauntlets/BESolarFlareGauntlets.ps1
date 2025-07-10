using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESOLARFLAREGAUNTLETS
#
###############################################################################

Class BESolarFlareGauntlets : BEGauntlets {
	BESolarFlareGauntlets() : base() {
		$this.Name               = 'Solar Flare Gauntlets'
		$this.MapObjName         = 'solarflaregauntlets'
		$this.PurchasePrice      = 1550
		$this.SellPrice          = 775
		$this.TargetStats        = @{
			[StatId]::Defense = 72
			[StatId]::MagicDefense = 38
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets that periodically unleash bursts of sunlight.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
