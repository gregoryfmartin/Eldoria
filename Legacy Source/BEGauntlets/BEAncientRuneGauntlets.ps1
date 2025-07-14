using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEANCIENTRUNEGAUNTLETS
#
###############################################################################

Class BEAncientRuneGauntlets : BEGauntlets {
	BEAncientRuneGauntlets() : base() {
		$this.Name               = 'Ancient Rune Gauntlets'
		$this.MapObjName         = 'ancientrunegauntlets'
		$this.PurchasePrice      = 1150
		$this.SellPrice          = 575
		$this.TargetStats        = @{
			[StatId]::Defense = 47
			[StatId]::MagicDefense = 24
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets covered in ancient, forgotten runes.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
