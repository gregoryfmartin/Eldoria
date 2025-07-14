using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESHADOWGRIPS
#
###############################################################################

Class BEShadowGrips : BEGauntlets {
	BEShadowGrips() : base() {
		$this.Name               = 'Shadow Grips'
		$this.MapObjName         = 'shadowgrips'
		$this.PurchasePrice      = 260
		$this.SellPrice          = 130
		$this.TargetStats        = @{
			[StatId]::Defense = 5
			[StatId]::MagicDefense = 10
			[StatId]::Accuracy = 12
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Dark, lightweight gloves for those who operate in shadows.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Unisex
	}
}
