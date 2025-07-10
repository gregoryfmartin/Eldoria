using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEGUNGNIR
#
###############################################################################

Class BEGungnir : BEWeapon {
	BEGungnir() : base() {
		$this.Name          = 'Gungnir'
		$this.MapObjName    = 'gungnir'
		$this.PurchasePrice = 4800
		$this.SellPrice     = 2400
		$this.TargetStats   = @{
			[StatId]::Attack      = 115
			[StatId]::MagicAttack = 40
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A divine spear that never misses its target, piercing any defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}
