using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE SOULBINDER STAFF
#
###############################################################################

Class BESoulbinderStaff : BEWeapon {
	BESoulbinderStaff() : base() {
		$this.Name          = 'Soulbinder Staff'
		$this.MapObjName    = 'soulbinderstaff'
		$this.PurchasePrice = 4600
		$this.SellPrice     = 2300
		$this.TargetStats   = @{
			[StatId]::Attack      = 18
			[StatId]::MagicAttack = 115
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A staff that can temporarily bind an enemy''s soul, preventing actions.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}
