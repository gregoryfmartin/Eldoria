using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BETRICKSTERPAULDRON
#
###############################################################################

Class BETricksterPauldron : BEPauldron {
	BETricksterPauldron() : base() {
		$this.Name               = 'Trickster Pauldron'
		$this.MapObjName         = 'tricksterpauldron'
		$this.PurchasePrice      = 7800
		$this.SellPrice          = 3900
		$this.TargetStats        = @{
			[StatId]::Defense = 156
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Allows for agile evasions and cunning deceptions.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
