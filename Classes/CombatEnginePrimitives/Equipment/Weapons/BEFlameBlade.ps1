using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEFLAMEBLADE
#
###############################################################################

Class BEFlameBlade : BEWeapon {
	BEFlameBlade() : base() {
		$this.Name          = 'Flame Blade'
		$this.MapObjName    = 'flameblade'
		$this.PurchasePrice = 780
		$this.SellPrice     = 390
		$this.TargetStats   = @{
			[StatId]::Attack      = 48
			[StatId]::MagicAttack = 8
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A sword wreathed in fire, dealing burn damage.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}
