using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEVOIDEDGE
#
###############################################################################

Class BEVoidEdge : BEWeapon {
	BEVoidEdge() : base() {
		$this.Name          = 'Void Edge'
		$this.MapObjName    = 'voidedge'
		$this.PurchasePrice = 5900
		$this.SellPrice     = 2950
		$this.TargetStats   = @{
			[StatId]::Attack      = 142
			[StatId]::MagicAttack = 68
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A blade that tears open small rifts in space, causing disorientation.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}
