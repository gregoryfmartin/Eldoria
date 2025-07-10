using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESUNFORGEDBLADE
#
###############################################################################

Class BESunforgedBlade : BEWeapon {
	BESunforgedBlade() : base() {
		$this.Name          = 'Sunforged Blade'
		$this.MapObjName    = 'sunforgedblade'
		$this.PurchasePrice = 4200
		$this.SellPrice     = 2100
		$this.TargetStats   = @{
			[StatId]::Attack      = 102
			[StatId]::MagicAttack = 28
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A sword crafted in the heart of a volcano, radiating immense heat.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}
