using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESORCERERSFOCUSCRYSTAL
#
###############################################################################

Class BESorcerersFocusCrystal : BEJewelry {
	BESorcerersFocusCrystal() : base() {
		$this.Name               = 'Sorcerer''s Focus Crystal'
		$this.MapObjName         = 'sorcerersfocuscrystal'
		$this.PurchasePrice      = 1600
		$this.SellPrice          = 800
		$this.TargetStats        = @{
			[StatId]::MagicAttack = 4
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A crystal that enhances magical concentration.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}
