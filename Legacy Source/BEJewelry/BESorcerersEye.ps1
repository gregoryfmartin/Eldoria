using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESORCERERSEYE
#
###############################################################################

Class BESorcerersEye : BEJewelry {
	BESorcerersEye() : base() {
		$this.Name               = 'Sorcerer''s Eye'
		$this.MapObjName         = 'sorcererseye'
		$this.PurchasePrice      = 1700
		$this.SellPrice          = 850
		$this.TargetStats        = @{
			[StatId]::MagicAttack = 4
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'An ominous eye shaped gem, enhancing dark magic.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Male
	}
}
