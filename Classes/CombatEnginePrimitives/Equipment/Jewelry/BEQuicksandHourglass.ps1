using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEQUICKSANDHOURGLASS
#
###############################################################################

Class BEQuicksandHourglass : BEJewelry {
	BEQuicksandHourglass() : base() {
		$this.Name               = 'Quicksand Hourglass'
		$this.MapObjName         = 'quicksandhourglass'
		$this.PurchasePrice      = 800
		$this.SellPrice          = 400
		$this.TargetStats        = @{
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A tiny hourglass with perpetually shifting sand.'
		$this.PlayerEffectString = ""
		$this.TargetGender       = [Gender]::Unisex
	}
}
