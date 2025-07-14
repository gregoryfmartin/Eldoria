using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESHADOWDANCERGLOVES
#
###############################################################################

Class BEShadowdancerGloves : BEGauntlets {
	BEShadowdancerGloves() : base() {
		$this.Name               = 'Shadowdancer Gloves'
		$this.MapObjName         = 'shadowdancergloves'
		$this.PurchasePrice      = 600
		$this.SellPrice          = 300
		$this.TargetStats        = @{
			[StatId]::Defense = 10
			[StatId]::MagicDefense = 18
			[StatId]::Accuracy = 15
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gloves allowing swift, silent movement through shadows.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Unisex
	}
}
