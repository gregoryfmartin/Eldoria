using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEVENOMOUSGRIPS
#
###############################################################################

Class BEVenomousGrips : BEGauntlets {
	BEVenomousGrips() : base() {
		$this.Name               = 'Venomous Grips'
		$this.MapObjName         = 'venomousgrips'
		$this.PurchasePrice      = 450
		$this.SellPrice          = 225
		$this.TargetStats        = @{
			[StatId]::Defense = 12
			[StatId]::MagicDefense = 10
			[StatId]::Accuracy = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets dripping with faint poison, for subtle attacks.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Unisex
	}
}
