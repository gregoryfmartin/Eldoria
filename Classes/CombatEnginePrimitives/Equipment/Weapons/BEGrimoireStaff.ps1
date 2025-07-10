using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEGRIMOIRESTAFF
#
###############################################################################

Class BEGrimoireStaff : BEWeapon {
	BEGrimoireStaff() : base() {
		$this.Name          = 'Grimoire Staff'
		$this.MapObjName    = 'grimoirestaff'
		$this.PurchasePrice = 5000
		$this.SellPrice     = 2500
		$this.TargetStats   = @{
			[StatId]::Attack      = 25
			[StatId]::MagicAttack = 140
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A staff with an attached grimoire, granting access to powerful spells.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}
