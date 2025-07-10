using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEZEPHYRBOW
#
###############################################################################

Class BEZephyrBow : BEWeapon {
	BEZephyrBow() : base() {
		$this.Name          = 'Zephyr Bow'
		$this.MapObjName    = 'zephyrbow'
		$this.PurchasePrice = 4300
		$this.SellPrice     = 2150
		$this.TargetStats   = @{
			[StatId]::Attack      = 105
			[StatId]::MagicAttack = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A bow that allows arrows to travel at incredible speeds, almost instantly.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}
