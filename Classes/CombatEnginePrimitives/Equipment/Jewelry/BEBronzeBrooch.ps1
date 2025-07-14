using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEBRONZEBROOCH
#
###############################################################################

Class BEBronzeBrooch : BEJewelry {
	BEBronzeBrooch() : base() {
		$this.Name               = 'Bronze Brooch'
		$this.MapObjName         = 'bronzebrooch'
		$this.PurchasePrice      = 70
		$this.SellPrice          = 35
		$this.TargetStats        = @{
			[StatId]::Defense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A small bronze brooch, often used to fasten cloaks.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
