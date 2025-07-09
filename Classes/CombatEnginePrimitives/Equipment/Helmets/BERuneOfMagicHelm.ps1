using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE RUNE OF MAGIC HELM
#
###############################################################################

Class BERuneOfMagicHelm : BEHelmet {
	BERuneOfMagicHelm() : base() {
		$this.Name               = 'Rune of Magic Helm'
		$this.MapObjName         = 'runeofmagichelm'
		$this.PurchasePrice      = 1900
		$this.SellPrice          = 950
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 20
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm inscribed with a rune of magic, greatly boosting magical power.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
