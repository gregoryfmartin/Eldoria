using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESHIMMERSTONEBRACELET
#
###############################################################################

Class BEShimmerstoneBracelet : BEJewelry {
	BEShimmerstoneBracelet() : base() {
		$this.Name               = 'Shimmerstone Bracelet'
		$this.MapObjName         = 'shimmerstonebracelet'
		$this.PurchasePrice      = 730
		$this.SellPrice          = 365
		$this.TargetStats        = @{
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A bracelet made of stones that subtly shimmer.'
		$this.PlayerEffectString = ""
		$this.TargetGender       = [Gender]::Unisex
	}
}
