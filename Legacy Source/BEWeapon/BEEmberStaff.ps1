using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEEMBERSTAFF
#
###############################################################################

Class BEEmberStaff : BEWeapon {
	BEEmberStaff() : base() {
		$this.Name          = 'Ember Staff'
		$this.MapObjName    = 'emberstaff'
		$this.PurchasePrice = 3700
		$this.SellPrice     = 1850
		$this.TargetStats   = @{
			[StatId]::Attack      = 12
			[StatId]::MagicAttack = 88
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A staff constantly aglow with embers, dealing fire damage.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}
