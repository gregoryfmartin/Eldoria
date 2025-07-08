using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE STAFF OF CREATION
#
###############################################################################

Class BEStaffOfCreation : BEWeapon {
	BEStaffOfCreation() : base() {
		$this.Name          = 'Staff of Creation'
		$this.MapObjName    = 'staffofcreation'
		$this.PurchasePrice = 5700
		$this.SellPrice     = 2850
		$this.TargetStats   = @{
			[StatId]::Attack      = 35
			[StatId]::MagicAttack = 160
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A staff capable of minor creation, shaping the environment.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}
