using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEELDERWOODGAUNTLETS
#
###############################################################################

Class BEElderwoodGauntlets : BEGauntlets {
	BEElderwoodGauntlets() : base() {
		$this.Name               = 'Elderwood Gauntlets'
		$this.MapObjName         = 'elderwoodgauntlets'
		$this.PurchasePrice      = 980
		$this.SellPrice          = 490
		$this.TargetStats        = @{
			[StatId]::Defense = 30
			[StatId]::MagicDefense = 20
			[StatId]::Accuracy = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets carved from ancient, sentient wood.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Unisex
	}
}
