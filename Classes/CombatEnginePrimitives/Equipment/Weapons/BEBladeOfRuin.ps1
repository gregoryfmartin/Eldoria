using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BLADE OF RUIN
#
###############################################################################

Class BEBladeOfRuin : BEWeapon {
	BEBladeOfRuin() : base() {
		$this.Name          = 'Blade of Ruin'
		$this.MapObjName    = 'bladeofruin'
		$this.PurchasePrice = 6800
		$this.SellPrice     = 3400
		$this.TargetStats   = @{
			[StatId]::Attack      = 160
			[StatId]::MagicAttack = 75
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A sword that leaves destruction in its wake, shattering defenses.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}
