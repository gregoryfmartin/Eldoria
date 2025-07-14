using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEDESERTROSEBROOCH
#
###############################################################################

Class BEDesertRoseBrooch : BEJewelry {
	BEDesertRoseBrooch() : base() {
		$this.Name               = 'Desert Rose Brooch'
		$this.MapObjName         = 'desertrosebrooch'
		$this.PurchasePrice      = 900
		$this.SellPrice          = 450
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A delicate brooch resembling a desert rose, enduring.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
