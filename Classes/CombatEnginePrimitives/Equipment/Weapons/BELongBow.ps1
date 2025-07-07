using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE LONG BOW
#
###############################################################################

Class BELongBow : BEWeapon {
	BELongBow() : base() {
		$this.Name          = 'Long Bow'
		$this.MapObjName    = 'longbow'
		$this.PurchasePrice = 250
		$this.SellPrice     = 125
		$this.TargetStats   = @{
			[StatId]::Attack = 18
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A more powerful bow, requiring greater strength.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}
