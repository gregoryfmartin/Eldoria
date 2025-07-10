using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESPIRITPAULDRON
#
###############################################################################

Class BESpiritPauldron : BEPauldron {
	BESpiritPauldron() : base() {
		$this.Name               = 'Spirit Pauldron'
		$this.MapObjName         = 'spiritpauldron'
		$this.PurchasePrice      = 4850
		$this.SellPrice          = 2425
		$this.TargetStats        = @{
			[StatId]::Defense = 97
			[StatId]::MagicDefense = 37
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Allows communication with spirits, enhancing spiritual defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
