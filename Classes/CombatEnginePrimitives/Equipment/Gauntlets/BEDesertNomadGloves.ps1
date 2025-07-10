using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEDESERTNOMADGLOVES
#
###############################################################################

Class BEDesertNomadGloves : BEGauntlets {
	BEDesertNomadGloves() : base() {
		$this.Name               = 'Desert Nomad Gloves'
		$this.MapObjName         = 'desertnomadgloves'
		$this.PurchasePrice      = 130
		$this.SellPrice          = 65
		$this.TargetStats        = @{
			[StatId]::Defense = 4
			[StatId]::MagicDefense = 5
			[StatId]::Accuracy = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Dust-resistant gloves for arid environments.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Unisex
	}
}
