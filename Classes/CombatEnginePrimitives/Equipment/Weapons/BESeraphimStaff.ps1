using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESERAPHIMSTAFF
#
###############################################################################

Class BESeraphimStaff : BEWeapon {
	BESeraphimStaff() : base() {
		$this.Name          = 'Seraphim Staff'
		$this.MapObjName    = 'seraphimstaff'
		$this.PurchasePrice = 6700
		$this.SellPrice     = 3350
		$this.TargetStats   = @{
			[StatId]::Attack      = 45
			[StatId]::MagicAttack = 195
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A staff of pure light, used for healing and banishing evil.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}
