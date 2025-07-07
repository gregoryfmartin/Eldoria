using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE SPIRIT STAFF
#
###############################################################################

Class BESpiritStaff : BEWeapon {
	BESpiritStaff() : base() {
		$this.Name          = 'Spirit Staff'
		$this.MapObjName    = 'spiritstaff'
		$this.PurchasePrice = 780
		$this.SellPrice     = 390
		$this.TargetStats   = @{
			[StatId]::Attack      = 5
			[StatId]::MagicAttack = 48
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A staff that amplifies the wielder''s connection to the spirit world.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}
