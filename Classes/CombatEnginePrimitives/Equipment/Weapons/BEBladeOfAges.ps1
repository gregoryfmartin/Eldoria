using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEBLADEOFAGES
#
###############################################################################

Class BEBladeofAges : BEWeapon {
	BEBladeofAges() : base() {
		$this.Name          = 'Blade of Ages'
		$this.MapObjName    = 'bladeofages'
		$this.PurchasePrice = 5800
		$this.SellPrice     = 2900
		$this.TargetStats   = @{
			[StatId]::Attack      = 140
			[StatId]::MagicAttack = 60
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A sword said to have witnessed the dawn of time, granting wisdom.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}
