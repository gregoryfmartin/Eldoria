using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESHADOWFANGGLOVES
#
###############################################################################

Class BEShadowfangGloves : BEGauntlets {
	BEShadowfangGloves() : base() {
		$this.Name               = 'Shadowfang Gloves'
		$this.MapObjName         = 'shadowfanggloves'
		$this.PurchasePrice      = 800
		$this.SellPrice          = 400
		$this.TargetStats        = @{
			[StatId]::Defense = 12
			[StatId]::MagicDefense = 25
			[StatId]::Accuracy = 18
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gloves with retractable shadow claws, for stealthy strikes.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Unisex
	}
}
