using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESERPENTSTAFF
#
###############################################################################

Class BESerpentStaff : BEWeapon {
	BESerpentStaff() : base() {
		$this.Name          = 'Serpent Staff'
		$this.MapObjName    = 'serpentstaff'
		$this.PurchasePrice = 800
		$this.SellPrice     = 400
		$this.TargetStats   = @{
			[StatId]::Attack      = 7
			[StatId]::MagicAttack = 47
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A staff topped with a coiling serpent, capable of charming foes.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}
