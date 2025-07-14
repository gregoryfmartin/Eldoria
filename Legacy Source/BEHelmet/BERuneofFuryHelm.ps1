using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BERUNEOFFURYHELM
#
###############################################################################

Class BERuneofFuryHelm : BEHelmet {
	BERuneofFuryHelm() : base() {
		$this.Name               = 'Rune of Fury Helm'
		$this.MapObjName         = 'runeoffuryhelm'
		$this.PurchasePrice      = 2000
		$this.SellPrice          = 1000
		$this.TargetStats        = @{
			[StatId]::Defense = 22
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm inscribed with a rune of fury, increasing attack at low health.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}
