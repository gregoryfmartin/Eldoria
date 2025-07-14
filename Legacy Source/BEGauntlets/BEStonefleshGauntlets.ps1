using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESTONEFLESHGAUNTLETS
#
###############################################################################

Class BEStonefleshGauntlets : BEGauntlets {
	BEStonefleshGauntlets() : base() {
		$this.Name               = 'Stoneflesh Gauntlets'
		$this.MapObjName         = 'stonefleshgauntlets'
		$this.PurchasePrice      = 1000
		$this.SellPrice          = 500
		$this.TargetStats        = @{
			[StatId]::Defense = 45
			[StatId]::MagicDefense = 18
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets that seem to turn skin to stone.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
