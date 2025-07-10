using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESTONEGAUNTLETS
#
###############################################################################

Class BEStoneGauntlets : BEGauntlets {
	BEStoneGauntlets() : base() {
		$this.Name               = 'Stone Gauntlets'
		$this.MapObjName         = 'stonegauntlets'
		$this.PurchasePrice      = 420
		$this.SellPrice          = 210
		$this.TargetStats        = @{
			[StatId]::Defense = 21
			[StatId]::MagicDefense = 6
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets carved from solid stone, heavy and resilient.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
