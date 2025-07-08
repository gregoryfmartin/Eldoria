using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE ABYSSAL STAFF
#
###############################################################################

Class BEAbyssalStaff : BEWeapon {
	BEAbyssalStaff() : base() {
		$this.Name          = 'Abyssal Staff'
		$this.MapObjName    = 'abyssalstaff'
		$this.PurchasePrice = 5600
		$this.SellPrice     = 2800
		$this.TargetStats   = @{
			[StatId]::Attack      = 32
			[StatId]::MagicAttack = 155
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A staff that channels dark energies from the abyss, powerful but corrupting.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}
