using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESOLARSTAFF
#
###############################################################################

Class BESolarStaff : BEWeapon {
	BESolarStaff() : base() {
		$this.Name          = 'Solar Staff'
		$this.MapObjName    = 'solarstaff'
		$this.PurchasePrice = 920
		$this.SellPrice     = 460
		$this.TargetStats   = @{
			[StatId]::Attack      = 12
			[StatId]::MagicAttack = 55
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A staff that harnesses the power of the sun, radiating healing energy.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}
