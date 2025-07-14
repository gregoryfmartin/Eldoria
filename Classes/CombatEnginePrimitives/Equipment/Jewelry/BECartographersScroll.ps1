using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECARTOGRAPHERSSCROLL
#
###############################################################################

Class BECartographersScroll : BEJewelry {
	BECartographersScroll() : base() {
		$this.Name               = 'Cartographer''s Scroll'
		$this.MapObjName         = 'cartographersscroll'
		$this.PurchasePrice      = 900
		$this.SellPrice          = 450
		$this.TargetStats        = @{
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A miniature scroll that always unrolls to a map.'
		$this.PlayerEffectString = ""
		$this.TargetGender       = [Gender]::Unisex
	}
}
