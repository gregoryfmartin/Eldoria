using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESOULREAVERSTAFF
#
###############################################################################

Class BESoulreaverStaff : BEWeapon {
	BESoulreaverStaff() : base() {
		$this.Name          = 'Soulreaver Staff'
		$this.MapObjName    = 'soulreaverstaff'
		$this.PurchasePrice = 6400
		$this.SellPrice     = 3200
		$this.TargetStats   = @{
			[StatId]::Attack      = 50
			[StatId]::MagicAttack = 190
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A staff that rips souls from bodies, draining life force.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}
