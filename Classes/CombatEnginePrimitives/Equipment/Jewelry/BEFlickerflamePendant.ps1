using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEFLICKERFLAMEPENDANT
#
###############################################################################

Class BEFlickerflamePendant : BEJewelry {
	BEFlickerflamePendant() : base() {
		$this.Name               = 'Flickerflame Pendant'
		$this.MapObjName         = 'flickerflamependant'
		$this.PurchasePrice      = 820
		$this.SellPrice          = 410
		$this.TargetStats        = @{
			[StatId]::Attack = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A pendant with a perpetual, tiny flame.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}
