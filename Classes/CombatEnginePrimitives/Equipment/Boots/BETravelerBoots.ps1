using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BETRAVELERBOOTS
#
###############################################################################

Class BETravelerBoots : BEBoots {
	BETravelerBoots() : base() {
		$this.Name               = 'Traveler Boots'
		$this.MapObjName         = 'travelerboots'
		$this.PurchasePrice      = 80
		$this.SellPrice          = 40
		$this.TargetStats        = @{
			[StatId]::Defense = 3
			[StatId]::MagicDefense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Simple and comfortable boots for long journeys.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
