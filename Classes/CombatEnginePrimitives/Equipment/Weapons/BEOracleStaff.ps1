using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE ORACLE STAFF
#
###############################################################################

Class BEOraclesStaff : BEWeapon {
	BEOraclesStaff() : base() {
		$this.Name          = 'Oracle''s Staff'
		$this.MapObjName    = 'oraclesstaff'
		$this.PurchasePrice = 4200
		$this.SellPrice     = 2100
		$this.TargetStats   = @{
			[StatId]::Attack      = 15
			[StatId]::MagicAttack = 105
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A staff that grants glimpses of the future, aiding in critical hits.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}
