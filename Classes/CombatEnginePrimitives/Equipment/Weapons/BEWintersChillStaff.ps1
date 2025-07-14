using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEWINTERSCHILLSTAFF
#
###############################################################################

Class BEWintersChillStaff : BEWeapon {
	BEWintersChillStaff() : base() {
		$this.Name          = 'Winter''s Chill Staff'
		$this.MapObjName    = 'winterschillstaff'
		$this.PurchasePrice = 6000
		$this.SellPrice     = 3000
		$this.TargetStats   = @{
			[StatId]::Attack      = 42
			[StatId]::MagicAttack = 165
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A staff that freezes anything it touches, creating icy blasts.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}
