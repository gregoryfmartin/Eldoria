using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE FRYING PAN
#
###############################################################################

Class BEFryingPan : BEWeapon {
	BEFryingPan() : base() {
		$this.Name          = 'Frying Pan'
		$this.MapObjName    = 'fryingpan'
		$this.PurchasePrice = 40
		$this.SellPrice     = 20
		$this.TargetStats   = @{
			[StatId]::Attack = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A common kitchen item. Surprisingly sturdy.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}
