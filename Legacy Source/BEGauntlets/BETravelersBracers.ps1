using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BETRAVELERSBRACERS
#
###############################################################################

Class BETravelersBracers : BEGauntlets {
	BETravelersBracers() : base() {
		$this.Name               = 'Traveler''s Bracers'
		$this.MapObjName         = 'travelersbracers'
		$this.PurchasePrice      = 110
		$this.SellPrice          = 55
		$this.TargetStats        = @{
			[StatId]::Defense = 5
			[StatId]::MagicDefense = 3
			[StatId]::Accuracy = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Comfortable bracers for long journeys.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Unisex
	}
}
