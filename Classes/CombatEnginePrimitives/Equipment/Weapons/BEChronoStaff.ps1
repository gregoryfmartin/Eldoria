using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECHRONOSTAFF
#
###############################################################################

Class BEChronoStaff : BEWeapon {
	BEChronoStaff() : base() {
		$this.Name          = 'Chrono Staff'
		$this.MapObjName    = 'chronostaff'
		$this.PurchasePrice = 4500
		$this.SellPrice     = 2250
		$this.TargetStats   = @{
			[StatId]::Attack      = 18
			[StatId]::MagicAttack = 120
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A staff that can manipulate time, slowing enemies or speeding up allies.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}
