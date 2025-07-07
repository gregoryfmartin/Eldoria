using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE SILVER DAGGER
#
###############################################################################

Class BESilverDagger : BEWeapon {
	BESilverDagger() : base() {
		$this.Name          = 'Silver Dagger'
		$this.MapObjName    = 'silverdagger'
		$this.PurchasePrice = 750
		$this.SellPrice     = 375
		$this.TargetStats   = @{
			[StatId]::Attack      = 40
			[StatId]::MagicAttack = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A dagger made of pure silver, effective against supernatural foes.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}
