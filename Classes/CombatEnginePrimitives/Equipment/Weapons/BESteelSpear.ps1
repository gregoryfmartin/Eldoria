using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESTEELSPEAR
#
###############################################################################

Class BESteelSpear : BEWeapon {
	BESteelSpear() : base() {
		$this.Name          = 'Steel Spear'
		$this.MapObjName    = 'steelspear'
		$this.PurchasePrice = 260
		$this.SellPrice     = 130
		$this.TargetStats   = @{
			[StatId]::Attack = 18
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A sharp and sturdy spear made of steel.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}
