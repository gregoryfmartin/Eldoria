using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEHEIRLOOMBROOCH
#
###############################################################################

Class BEHeirloomBrooch : BEJewelry {
	BEHeirloomBrooch() : base() {
		$this.Name               = 'Heirloom Brooch'
		$this.MapObjName         = 'heirloombrooch'
		$this.PurchasePrice      = 1200
		$this.SellPrice          = 600
		$this.TargetStats        = @{
			[StatId]::Luck = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A family heirloom, imbued with sentimental value.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Luck]) LCK"
		$this.TargetGender       = [Gender]::Unisex
	}
}
