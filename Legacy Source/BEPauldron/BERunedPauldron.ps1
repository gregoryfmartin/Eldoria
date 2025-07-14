using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BERUNEDPAULDRON
#
###############################################################################

Class BERunedPauldron : BEPauldron {
	BERunedPauldron() : base() {
		$this.Name               = 'Runed Pauldron'
		$this.MapObjName         = 'runedpauldron'
		$this.PurchasePrice      = 650
		$this.SellPrice          = 325
		$this.TargetStats        = @{
			[StatId]::Defense = 13
			[StatId]::MagicDefense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Etched with ancient runes, granting minor magical resistance.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
