using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESHADECLOTHGLOVES
#
###############################################################################

Class BEShadeclothGloves : BEGauntlets {
	BEShadeclothGloves() : base() {
		$this.Name               = 'Shadecloth Gloves'
		$this.MapObjName         = 'shadeclothgloves'
		$this.PurchasePrice      = 470
		$this.SellPrice          = 235
		$this.TargetStats        = @{
			[StatId]::Defense = 10
			[StatId]::MagicDefense = 19
			[StatId]::Accuracy = 12
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gloves made of cloth spun from shadows, very stealthy.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Unisex
	}
}
