using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE RUNE OF STRENGTH HELM
#
###############################################################################

Class BERuneOfStrengthHelm : BEHelmet {
	BERuneOfStrengthHelm() : base() {
		$this.Name               = 'Rune of Strength Helm'
		$this.MapObjName         = 'runeofstrengthhelm'
		$this.PurchasePrice      = 1900
		$this.SellPrice          = 950
		$this.TargetStats        = @{
			[StatId]::Defense = 20
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm inscribed with a rune of strength, greatly boosting physical power.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}
