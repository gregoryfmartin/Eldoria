using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BETRAVELERGREAVES
#
###############################################################################

Class BETravelerGreaves : BEGreaves {
	BETravelerGreaves() : base() {
		$this.Name               = 'Traveler Greaves'
		$this.MapObjName         = 'travelergreaves'
		$this.PurchasePrice      = 90
		$this.SellPrice          = 45
		$this.TargetStats        = @{
			[StatId]::Defense = 4
			[StatId]::MagicDefense = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Simple and comfortable greaves for long journeys.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
