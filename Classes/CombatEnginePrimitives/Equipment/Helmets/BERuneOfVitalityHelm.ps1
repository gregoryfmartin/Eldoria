using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE RUNE OF VITALITY HELM
#
###############################################################################

Class BERuneOfVitalityHelm : BEHelmet {
	BERuneOfVitalityHelm() : base() {
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
