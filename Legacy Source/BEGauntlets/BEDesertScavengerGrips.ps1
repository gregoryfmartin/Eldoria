using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEDESERTSCAVENGERGRIPS
#
###############################################################################

Class BEDesertScavengerGrips : BEGauntlets {
	BEDesertScavengerGrips() : base() {
		$this.Name               = 'Desert Scavenger Grips'
		$this.MapObjName         = 'desertscavengergrips'
		$this.PurchasePrice      = 200
		$this.SellPrice          = 100
		$this.TargetStats        = @{
			[StatId]::Defense = 10
			[StatId]::MagicDefense = 3
			[StatId]::Accuracy = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Makeshift grips used by desert scavengers, rugged.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Unisex
	}
}
