using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEPOETSLAURELWREATH
#
###############################################################################

Class BEPoetsLaurelWreath : BEHelmet {
	BEPoetsLaurelWreath() : base() {
		$this.Name               = 'Poet''s Laurel Wreath'
		$this.MapObjName         = 'poetslaurelwreath'
		$this.PurchasePrice      = 90
		$this.SellPrice          = 45
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A laurel wreath worn by poets, inspiring eloquence.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
