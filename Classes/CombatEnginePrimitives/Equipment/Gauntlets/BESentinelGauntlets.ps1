using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESENTINELGAUNTLETS
#
###############################################################################

Class BESentinelGauntlets : BEGauntlets {
	BESentinelGauntlets() : base() {
		$this.Name               = 'Sentinel Gauntlets'
		$this.MapObjName         = 'sentinelgauntlets'
		$this.PurchasePrice      = 400
		$this.SellPrice          = 200
		$this.TargetStats        = @{
			[StatId]::Defense = 20
			[StatId]::MagicDefense = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Heavy duty gauntlets for guardians, built for endurance.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
