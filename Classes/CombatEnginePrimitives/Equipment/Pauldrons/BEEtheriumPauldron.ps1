using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEETHERIUMPAULDRON
#
###############################################################################

Class BEEtheriumPauldron : BEPauldron {
	BEEtheriumPauldron() : base() {
		$this.Name               = 'Etherium Pauldron'
		$this.MapObjName         = 'etheriumpauldron'
		$this.PurchasePrice      = 6500
		$this.SellPrice          = 3250
		$this.TargetStats        = @{
			[StatId]::Defense = 130
			[StatId]::MagicDefense = 52
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Woven from pure magical energy, incredibly light and potent.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
