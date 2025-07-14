using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BETRAVELERSSHIRT
#
###############################################################################

Class BETravelersShirt : BEArmor {
	BETravelersShirt() : base() {
		$this.Name               = 'Traveler''s Shirt'
		$this.MapObjName         = 'travelersshirt'
		$this.PurchasePrice      = 70
		$this.SellPrice          = 35
		$this.TargetStats        = @{
			[StatId]::Defense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A comfortable and durable shirt for long journeys.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
