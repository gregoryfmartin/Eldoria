using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEVENOMOUSGRIPSII
#
###############################################################################

Class BEVenomousGripsII : BEGauntlets {
	BEVenomousGripsII() : base() {
		$this.Name               = 'Venomous Grips II'
		$this.MapObjName         = 'venomousgripsii'
		$this.PurchasePrice      = 550
		$this.SellPrice          = 275
		$this.TargetStats        = @{
			[StatId]::Defense = 15
			[StatId]::MagicDefense = 12
			[StatId]::Accuracy = 8
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'More potent Venomous Grips, dripping with stronger poison.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Unisex
	}
}
