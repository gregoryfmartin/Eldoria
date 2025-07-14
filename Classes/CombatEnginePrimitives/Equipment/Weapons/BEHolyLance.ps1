using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEHOLYLANCE
#
###############################################################################

Class BEHolyLance : BEWeapon {
	BEHolyLance() : base() {
		$this.Name          = 'Holy Lance'
		$this.MapObjName    = 'holylance'
		$this.PurchasePrice = 950
		$this.SellPrice     = 475
		$this.TargetStats   = @{
			[StatId]::Attack      = 50
			[StatId]::MagicAttack = 15
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A blessed spear said to smite evil.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}
