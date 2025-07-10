using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESHORTBOW
#
###############################################################################

Class BEShortBow : BEWeapon {
	BEShortBow() : base() {
		$this.Name          = 'Short Bow'
		$this.MapObjName    = 'shortbow'
		$this.PurchasePrice = 160
		$this.SellPrice     = 80
		$this.TargetStats   = @{
			[StatId]::Attack = 12
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A compact bow, good for quick shots.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}
