using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BETHROWINGDAGGERS
#
###############################################################################

Class BEThrowingDaggers : BEWeapon {
	BEThrowingDaggers() : base() {
		$this.Name          = 'Throwing Daggers'
		$this.MapObjName    = 'throwingdaggers'
		$this.PurchasePrice = 110
		$this.SellPrice     = 55
		$this.TargetStats   = @{
			[StatId]::Attack = 9
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A set of small daggers designed for throwing.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}
