using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE STAFF
#
###############################################################################

Class BEStaff : BEWeapon {
	BEStaff() : base() {
		$this.Name          = 'Staff'
		$this.MapObjName    = 'staff'
		$this.PurchasePrice = 100
		$this.SellPrice     = 50
		$this.TargetStats   = @{
			[StatId]::Attack      = 3
			[StatId]::MagicAttack = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A plain wooden staff, often used by mages.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}
