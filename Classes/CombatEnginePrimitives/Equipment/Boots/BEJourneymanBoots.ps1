using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEJOURNEYMANBOOTS
#
###############################################################################

Class BEJourneymanBoots : BEBoots {
	BEJourneymanBoots() : base() {
		$this.Name               = 'Journeyman Boots'
		$this.MapObjName         = 'journeymanboots'
		$this.PurchasePrice      = 130
		$this.SellPrice          = 65
		$this.TargetStats        = @{
			[StatId]::Defense = 5
			[StatId]::MagicDefense = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots for those gaining experience.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
