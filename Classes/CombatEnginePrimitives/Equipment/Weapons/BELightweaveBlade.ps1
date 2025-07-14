using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BELIGHTWEAVEBLADE
#
###############################################################################

Class BELightweaveBlade : BEWeapon {
	BELightweaveBlade() : base() {
		$this.Name          = 'Lightweave Blade'
		$this.MapObjName    = 'lightweaveblade'
		$this.PurchasePrice = 5700
		$this.SellPrice     = 2850
		$this.TargetStats   = @{
			[StatId]::Attack      = 138
			[StatId]::MagicAttack = 65
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A sword woven from pure light, incredibly fast and precise.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}
