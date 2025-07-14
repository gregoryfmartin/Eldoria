using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BETRAVELERSGLOVES
#
###############################################################################

Class BETravelersGloves : BEGauntlets {
	BETravelersGloves() : base() {
		$this.Name               = 'Traveler''s Gloves'
		$this.MapObjName         = 'travelersgloves'
		$this.PurchasePrice      = 70
		$this.SellPrice          = 35
		$this.TargetStats        = @{
			[StatId]::Defense = 2
			[StatId]::MagicDefense = 3
			[StatId]::Accuracy = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Simple, comfortable gloves for long journeys.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Unisex
	}
}
