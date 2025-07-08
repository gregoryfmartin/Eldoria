using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE STAFF OF THE COSMOS
#
###############################################################################

Class BEStaffOfTheCosmos : BEWeapon {
	BEStaffOfTheCosmos() : base() {
		$this.Name          = 'Staff of the Cosmos'
		$this.MapObjName    = 'staffofthecosmos'
		$this.PurchasePrice = 6300
		$this.SellPrice     = 3150
		$this.TargetStats   = @{
			[StatId]::Attack      = 48
			[StatId]::MagicAttack = 180
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A staff that channels cosmic energies, capable of summoning minor celestial events.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}
