using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE DREAMWEAVER STAFF
#
###############################################################################

Class BEDreamweaverStaff : BEWeapon {
	BEDreamweaverStaff() : base() {
		$this.Name          = 'Dream Weaver Staff'
		$this.MapObjName    = 'dreamweaverstaff'
		$this.PurchasePrice = 820
		$this.SellPrice     = 410
		$this.TargetStats   = @{
			[StatId]::Attack      = 6
			[StatId]::MagicAttack = 49
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A staff that can induce sleep or vivid illusions.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}
