using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEPHOENIXASHDAGGER
#
###############################################################################

Class BEPhoenixAshDagger : BEWeapon {
	BEPhoenixAshDagger() : base() {
		$this.Name          = 'Phoenix Ash Dagger'
		$this.MapObjName    = 'phoenixashdagger'
		$this.PurchasePrice = 5400
		$this.SellPrice     = 2700
		$this.TargetStats   = @{
			[StatId]::Attack      = 125
			[StatId]::MagicAttack = 50
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A dagger made from the ashes of a phoenix, capable of burning foes.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}
