using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEOCEANICGREAVES
#
###############################################################################

Class BEOceanicGreaves : BEGreaves {
	BEOceanicGreaves() : base() {
		$this.Name               = 'Oceanic Greaves'
		$this.MapObjName         = 'oceanicgreaves'
		$this.PurchasePrice      = 1050
		$this.SellPrice          = 525
		$this.TargetStats        = @{
			[StatId]::Defense = 40
			[StatId]::MagicDefense = 28
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves found in the depths of the ocean, resistant to water.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
