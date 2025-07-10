using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESTARFALLSTAFF
#
###############################################################################

Class BEStarfallStaff : BEWeapon {
	BEStarfallStaff() : base() {
		$this.Name          = 'Starfall Staff'
		$this.MapObjName    = 'starfallstaff'
		$this.PurchasePrice = 4800
		$this.SellPrice     = 2400
		$this.TargetStats   = @{
			[StatId]::Attack      = 22
			[StatId]::MagicAttack = 125
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A staff that can call down small celestial bodies, dealing area damage.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}
