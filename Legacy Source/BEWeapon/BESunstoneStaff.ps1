using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESUNSTONESTAFF
#
###############################################################################

Class BESunstoneStaff : BEWeapon {
	BESunstoneStaff() : base() {
		$this.Name          = 'Sunstone Staff'
		$this.MapObjName    = 'sunstonestaff'
		$this.PurchasePrice = 900
		$this.SellPrice     = 450
		$this.TargetStats   = @{
			[StatId]::Attack      = 10
			[StatId]::MagicAttack = 53
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A staff topped with a radiant sunstone, bolstering healing spells.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}
