using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEJOURNEYMANGREAVES
#
###############################################################################

Class BEJourneymanGreaves : BEGreaves {
	BEJourneymanGreaves() : base() {
		$this.Name               = 'Journeyman Greaves'
		$this.MapObjName         = 'journeymangreaves'
		$this.PurchasePrice      = 150
		$this.SellPrice          = 75
		$this.TargetStats        = @{
			[StatId]::Defense = 7
			[StatId]::MagicDefense = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves for those gaining experience.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
