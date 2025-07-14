using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BERUNEOFVITALITYHELM
#
###############################################################################

Class BERuneofVitalityHelm : BEHelmet {
	BERuneofVitalityHelm() : base() {
		$this.Name               = 'Rune of Vitality Helm'
		$this.MapObjName         = 'runeofvitalityhelm'
		$this.PurchasePrice      = 1900
		$this.SellPrice          = 950
		$this.TargetStats        = @{
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm inscribed with a rune of vitality, increasing health.'
		$this.PlayerEffectString = ""
		$this.TargetGender       = [Gender]::Unisex
	}
}
