using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BERUNEOFSERENITYHELM
#
###############################################################################

Class BERuneofSerenityHelm : BEHelmet {
	BERuneofSerenityHelm() : base() {
		$this.Name               = 'Rune of Serenity Helm'
		$this.MapObjName         = 'runeofserenityhelm'
		$this.PurchasePrice      = 2000
		$this.SellPrice          = 1000
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 22
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm inscribed with a rune of serenity, calming the mind and boosting magic.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
