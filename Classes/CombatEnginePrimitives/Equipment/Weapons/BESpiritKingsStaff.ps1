using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESPIRITKINGSSTAFF
#
###############################################################################

Class BESpiritKingsStaff : BEWeapon {
	BESpiritKingsStaff() : base() {
		$this.Name          = 'Spirit King''s Staff'
		$this.MapObjName    = 'spiritkingsstaff'
		$this.PurchasePrice = 6200
		$this.SellPrice     = 3100
		$this.TargetStats   = @{
			[StatId]::Attack      = 45
			[StatId]::MagicAttack = 175
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A staff once wielded by a king of spirits, commanding spectral allies.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}
