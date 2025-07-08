using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE VORTEX STAFF
#
###############################################################################

Class BEVortexStaff : BEWeapon {
	BEVortexStaff() : base() {
		$this.Name          = 'Vortex Staff'
		$this.MapObjName    = 'vortexstaff'
		$this.PurchasePrice = 4400
		$this.SellPrice     = 2200
		$this.TargetStats   = @{
			[StatId]::Attack      = 20
			[StatId]::MagicAttack = 110
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A staff that can create small localized vortices, pulling enemies in.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}
