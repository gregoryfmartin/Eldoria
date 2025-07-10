using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECHRONOFLUXGAUNTLETS
#
###############################################################################

Class BEChronoFluxGauntlets : BEGauntlets {
	BEChronoFluxGauntlets() : base() {
		$this.Name               = 'Chrono Flux Gauntlets'
		$this.MapObjName         = 'chronofluxgauntlets'
		$this.PurchasePrice      = 1700
		$this.SellPrice          = 850
		$this.TargetStats        = @{
			[StatId]::Defense = 30
			[StatId]::MagicDefense = 35
			[StatId]::Accuracy = 12
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets that bend time, granting rapid movements.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Unisex
	}
}
