using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEGOLDWEAVEBROOCH
#
###############################################################################

Class BEGoldweaveBrooch : BEJewelry {
	BEGoldweaveBrooch() : base() {
		$this.Name               = 'Goldweave Brooch'
		$this.MapObjName         = 'goldweavebrooch'
		$this.PurchasePrice      = 280
		$this.SellPrice          = 140
		$this.TargetStats        = @{
			[StatId]::Luck = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A brooch woven with gold threads, enhancing beauty.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Luck]) LCK"
		$this.TargetGender       = [Gender]::Female
	}
}
