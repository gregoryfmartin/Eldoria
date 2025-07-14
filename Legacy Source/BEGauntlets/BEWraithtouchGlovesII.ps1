using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEWRAITHTOUCHGLOVESII
#
###############################################################################

Class BEWraithtouchGlovesII : BEGauntlets {
	BEWraithtouchGlovesII() : base() {
		$this.Name               = 'Wraithtouch Gloves II'
		$this.MapObjName         = 'wraithtouchglovesii'
		$this.PurchasePrice      = 1400
		$this.SellPrice          = 700
		$this.TargetStats        = @{
			[StatId]::Defense = 32
			[StatId]::MagicDefense = 50
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'More potent Wraithtouch Gloves, chilling effect intensified.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
