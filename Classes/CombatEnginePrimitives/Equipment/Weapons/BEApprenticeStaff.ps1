using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE APPRENTICE STAFF
#
###############################################################################

Class BEApprenticeStaff : BEWeapon {
	BEApprenticeStaff() : base() {
		$this.Name          = 'Apprentice Staff'
		$this.MapObjName    = 'apprenticestaff'
		$this.PurchasePrice = 120
		$this.SellPrice     = 60
		$this.TargetStats   = @{
			[StatId]::Attack      = 4
			[StatId]::MagicAttack = 13
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A staff suitable for an apprentice mage.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}
