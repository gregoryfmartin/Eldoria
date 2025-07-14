using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEBLACKSMITHSHAMMERCHARM
#
###############################################################################

Class BEBlacksmithsHammerCharm : BEJewelry {
	BEBlacksmithsHammerCharm() : base() {
		$this.Name               = 'Blacksmith''s Hammer Charm'
		$this.MapObjName         = 'blacksmithshammercharm'
		$this.PurchasePrice      = 700
		$this.SellPrice          = 350
		$this.TargetStats        = @{
			[StatId]::Attack = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A charm shaped like a tiny hammer, for crafting.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Male
	}
}
