using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE MAGIC STAFF
#
###############################################################################

Class BEMagicStaff : BEWeapon {
	BEMagicStaff() : base() {
		$this.Name          = 'Magic Staff'
		$this.MapObjName    = 'magicstaff'
		$this.PurchasePrice = 200
		$this.SellPrice     = 100
		$this.TargetStats   = @{
			[StatId]::Attack      = 5
			[StatId]::MagicAttack = 18
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A staff imbued with minor magical properties.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}
