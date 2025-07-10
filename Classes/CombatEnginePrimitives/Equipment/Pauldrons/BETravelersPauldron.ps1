using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BETRAVELERSPAULDRON
#
###############################################################################

Class BETravelersPauldron : BEPauldron {
	BETravelersPauldron() : base() {
		$this.Name               = 'Traveler''s Pauldron'
		$this.MapObjName         = 'travelerspauldron'
		$this.PurchasePrice      = 2300
		$this.SellPrice          = 1150
		$this.TargetStats        = @{
			[StatId]::Defense = 46
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Comfortable and reliable for long expeditions.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}
