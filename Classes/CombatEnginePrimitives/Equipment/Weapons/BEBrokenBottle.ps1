using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEBROKENBOTTLE
#
###############################################################################

Class BEBrokenBottle : BEWeapon {
	BEBrokenBottle() : base() {
		$this.Name          = 'Broken Bottle'
		$this.MapObjName    = 'brokenbottle'
		$this.PurchasePrice = 25
		$this.SellPrice     = 12
		$this.TargetStats   = @{
			[StatId]::Attack = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A shattered bottle. Very sharp, but fragile.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}
