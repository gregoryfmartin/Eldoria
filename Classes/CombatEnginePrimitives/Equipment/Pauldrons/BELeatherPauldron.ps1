using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BELEATHERPAULDRON
#
###############################################################################

Class BELeatherPauldron : BEPauldron {
	BELeatherPauldron() : base() {
		$this.Name               = 'Leather Pauldron'
		$this.MapObjName         = 'leatherpauldron'
		$this.PurchasePrice      = 150
		$this.SellPrice          = 75
		$this.TargetStats        = @{
			[StatId]::Defense = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Crafted from cured leather, providing light defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
