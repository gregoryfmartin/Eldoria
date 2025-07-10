using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECRUSADERSMIGHTGAUNTLETS
#
###############################################################################

Class BECrusadersMightGauntlets : BEGauntlets {
	BECrusadersMightGauntlets() : base() {
		$this.Name               = 'Crusader''s Might Gauntlets'
		$this.MapObjName         = 'crusadersmightgauntlets'
		$this.PurchasePrice      = 750
		$this.SellPrice          = 375
		$this.TargetStats        = @{
			[StatId]::Defense = 40
			[StatId]::MagicDefense = 18
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Heavily fortified gauntlets of a valiant crusader.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
