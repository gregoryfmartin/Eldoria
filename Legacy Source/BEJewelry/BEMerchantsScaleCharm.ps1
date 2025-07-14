using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEMERCHANTSSCALECHARM
#
###############################################################################

Class BEMerchantsScaleCharm : BEJewelry {
	BEMerchantsScaleCharm() : base() {
		$this.Name               = 'Merchant''s Scale Charm'
		$this.MapObjName         = 'merchantsscalecharm'
		$this.PurchasePrice      = 600
		$this.SellPrice          = 300
		$this.TargetStats        = @{
			[StatId]::Luck = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A charm shaped like a tiny balance scale, for good deals.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Luck]) LCK"
		$this.TargetGender       = [Gender]::Unisex
	}
}
