using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEDIAMONDNECKLACE
#
###############################################################################

Class BEDiamondNecklace : BEJewelry {
	BEDiamondNecklace() : base() {
		$this.Name               = 'Diamond Necklace'
		$this.MapObjName         = 'diamondnecklace'
		$this.PurchasePrice      = 800
		$this.SellPrice          = 400
		$this.TargetStats        = @{
			[StatId]::Luck = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A dazzling diamond necklace, exuding prestige.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Luck]) LCK"
		$this.TargetGender       = [Gender]::Unisex
	}
}
