using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEDEEPWOODGRIPS
#
###############################################################################

Class BEDeepwoodGrips : BEGauntlets {
	BEDeepwoodGrips() : base() {
		$this.Name               = 'Deepwood Grips'
		$this.MapObjName         = 'deepwoodgrips'
		$this.PurchasePrice      = 360
		$this.SellPrice          = 180
		$this.TargetStats        = @{
			[StatId]::Defense = 6
			[StatId]::MagicDefense = 15
			[StatId]::Accuracy = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gloves made from ancient forest materials, blending with shadows.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Unisex
	}
}
