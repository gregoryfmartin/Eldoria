using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESHADOWSCALEGLOVES
#
###############################################################################

Class BEShadowscaleGloves : BEGauntlets {
	BEShadowscaleGloves() : base() {
		$this.Name               = 'Shadowscale Gloves'
		$this.MapObjName         = 'shadowscalegloves'
		$this.PurchasePrice      = 430
		$this.SellPrice          = 215
		$this.TargetStats        = @{
			[StatId]::Defense = 9
			[StatId]::MagicDefense = 16
			[StatId]::Accuracy = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gloves made from the scales of a shadowy creature, light and elusive.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Unisex
	}
}
