using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEPERMAFROSTSHARD
#
###############################################################################

Class BEPermafrostShard : BEJewelry {
	BEPermafrostShard() : base() {
		$this.Name               = 'Permafrost Shard'
		$this.MapObjName         = 'permafrostshard'
		$this.PurchasePrice      = 1350
		$this.SellPrice          = 675
		$this.TargetStats        = @{
			[StatId]::Defense = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A shard of ice that never melts.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
