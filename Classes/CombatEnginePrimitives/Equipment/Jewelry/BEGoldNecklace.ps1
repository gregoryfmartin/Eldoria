using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEGOLDNECKLACE
#
###############################################################################

Class BEGoldNecklace : BEJewelry {
	BEGoldNecklace() : base() {
		$this.Name               = 'Gold Necklace'
		$this.MapObjName         = 'goldnecklace'
		$this.PurchasePrice      = 180
		$this.SellPrice          = 90
		$this.TargetStats        = @{
			[StatId]::Luck = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A gleaming gold necklace, a sign of wealth.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Luck]) LCK"
		$this.TargetGender       = [Gender]::Unisex
	}
}
