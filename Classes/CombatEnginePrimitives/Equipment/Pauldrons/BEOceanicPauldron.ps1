using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEOCEANICPAULDRON
#
###############################################################################

Class BEOceanicPauldron : BEPauldron {
	BEOceanicPauldron() : base() {
		$this.Name               = 'Oceanic Pauldron'
		$this.MapObjName         = 'oceanicpauldron'
		$this.PurchasePrice      = 3900
		$this.SellPrice          = 1950
		$this.TargetStats        = @{
			[StatId]::Defense = 78
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Shimmers with the colors of the deep sea, resistant to water.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
