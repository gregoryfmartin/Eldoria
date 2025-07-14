using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECRIMSONFURYGAUNTLETS
#
###############################################################################

Class BECrimsonFuryGauntlets : BEGauntlets {
	BECrimsonFuryGauntlets() : base() {
		$this.Name               = 'Crimson Fury Gauntlets'
		$this.MapObjName         = 'crimsonfurygauntlets'
		$this.PurchasePrice      = 1300
		$this.SellPrice          = 650
		$this.TargetStats        = @{
			[StatId]::Defense = 60
			[StatId]::MagicDefense = 20
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets that boil with controlled rage, increasing strength.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
