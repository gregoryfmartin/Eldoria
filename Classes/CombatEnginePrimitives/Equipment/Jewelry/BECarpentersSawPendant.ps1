using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECARPENTERSSAWPENDANT
#
###############################################################################

Class BECarpentersSawPendant : BEJewelry {
	BECarpentersSawPendant() : base() {
		$this.Name               = 'Carpenter''s Saw Pendant'
		$this.MapObjName         = 'carpenterssawpendant'
		$this.PurchasePrice      = 600
		$this.SellPrice          = 300
		$this.TargetStats        = @{
			[StatId]::Attack = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A pendant shaped like a small saw, for construction.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Male
	}
}
