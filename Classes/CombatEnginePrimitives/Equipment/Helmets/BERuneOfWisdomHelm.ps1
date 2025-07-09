using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE RUNE OF WISDOM HELM
#
###############################################################################

Class BERuneOfWisdomHelm : BEHelmet {
	BERuneOfWisdomHelm() : base() {
		$this.Name               = 'Rune of Wisdom Helm'
		$this.MapObjName         = 'runeofwisdomhelm'
		$this.PurchasePrice      = 1900
		$this.SellPrice          = 950
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 18
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm inscribed with a rune of wisdom, boosting intellect.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
