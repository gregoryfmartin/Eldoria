using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEWATERFALLGEM
#
###############################################################################

Class BEWaterfallGem : BEJewelry {
	BEWaterfallGem() : base() {
		$this.Name               = 'Waterfall Gem'
		$this.MapObjName         = 'waterfallgem'
		$this.PurchasePrice      = 600
		$this.SellPrice          = 300
		$this.TargetStats        = @{
			[StatId]::MagicAttack = 1
			[StatId]::MagicDefense = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A gem that constantly reflects flowing water.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
