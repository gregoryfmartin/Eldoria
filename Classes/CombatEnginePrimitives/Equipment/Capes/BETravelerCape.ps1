using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BETRAVELERCAPE
#
###############################################################################

Class BETravelerCape : BECape {
	BETravelerCape() : base() {
		$this.Name               = 'Traveler Cape'
		$this.MapObjName         = 'travelercape'
		$this.PurchasePrice      = 200
		$this.SellPrice          = 100
		$this.TargetStats        = @{
			[StatId]::Luck = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A durable cape designed for long journeys.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Luck]) LCK"
		$this.TargetGender       = [Gender]::Unisex
	}
}
