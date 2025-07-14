using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEDRAGONHIDEGAUNTLETS
#
###############################################################################

Class BEDragonhideGauntlets : BEGauntlets {
	BEDragonhideGauntlets() : base() {
		$this.Name               = 'Dragonhide Gauntlets'
		$this.MapObjName         = 'dragonhidegauntlets'
		$this.PurchasePrice      = 1350
		$this.SellPrice          = 675
		$this.TargetStats        = @{
			[StatId]::Defense = 65
			[StatId]::MagicDefense = 25
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets crafted from the hide of a mature dragon.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
