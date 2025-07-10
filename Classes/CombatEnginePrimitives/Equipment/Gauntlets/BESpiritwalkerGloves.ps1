using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESPIRITWALKERGLOVES
#
###############################################################################

Class BESpiritwalkerGloves : BEGauntlets {
	BESpiritwalkerGloves() : base() {
		$this.Name               = 'Spiritwalker Gloves'
		$this.MapObjName         = 'spiritwalkergloves'
		$this.PurchasePrice      = 1100
		$this.SellPrice          = 550
		$this.TargetStats        = @{
			[StatId]::Defense = 20
			[StatId]::MagicDefense = 42
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gloves that allow brief interaction with spirits.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
