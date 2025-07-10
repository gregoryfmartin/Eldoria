using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BENOMADSGAUNTLETS
#
###############################################################################

Class BENomadsGauntlets : BEGauntlets {
	BENomadsGauntlets() : base() {
		$this.Name               = 'Nomad''s Gauntlets'
		$this.MapObjName         = 'nomadsgauntlets'
		$this.PurchasePrice      = 280
		$this.SellPrice          = 140
		$this.TargetStats        = @{
			[StatId]::Defense = 14
			[StatId]::MagicDefense = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Practical and robust gauntlets for a wanderer.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
