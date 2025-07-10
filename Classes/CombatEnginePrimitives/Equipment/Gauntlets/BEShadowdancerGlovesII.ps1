using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESHADOWDANCERGLOVESII
#
###############################################################################

Class BEShadowdancerGlovesII : BEGauntlets {
	BEShadowdancerGlovesII() : base() {
		$this.Name               = 'Shadowdancer Gloves II'
		$this.MapObjName         = 'shadowdancerglovesii'
		$this.PurchasePrice      = 700
		$this.SellPrice          = 350
		$this.TargetStats        = @{
			[StatId]::Defense = 12
			[StatId]::MagicDefense = 22
			[StatId]::Accuracy = 18
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'More advanced Shadowdancer Gloves, allowing greater agility.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Unisex
	}
}
