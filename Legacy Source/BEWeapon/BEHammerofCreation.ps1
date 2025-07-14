using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEHAMMEROFCREATION
#
###############################################################################

Class BEHammerofCreation : BEWeapon {
	BEHammerofCreation() : base() {
		$this.Name          = 'Hammer of Creation'
		$this.MapObjName    = 'hammerofcreation'
		$this.PurchasePrice = 6900
		$this.SellPrice     = 3450
		$this.TargetStats   = @{
			[StatId]::Attack      = 180
			[StatId]::MagicAttack = 90
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A hammer said to have helped shape the world, capable of mending.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}
