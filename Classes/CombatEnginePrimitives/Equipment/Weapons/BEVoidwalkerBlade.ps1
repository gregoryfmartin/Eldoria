using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE VOIDWALKER BLADE
#
###############################################################################

Class BEVoidwalkerBlade : BEWeapon {
	BEVoidwalkerBlade() : base() {
		$this.Name          = 'Voidwalker Blade'
		$this.MapObjName    = 'voidwalkerblade'
		$this.PurchasePrice = 4000
		$this.SellPrice     = 2000
		$this.TargetStats   = @{
			[StatId]::Attack      = 95
			[StatId]::MagicAttack = 35
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A sword that allows the wielder to briefly teleport.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}
