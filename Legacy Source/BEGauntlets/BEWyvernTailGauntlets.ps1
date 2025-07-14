using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEWYVERNTAILGAUNTLETS
#
###############################################################################

Class BEWyvernTailGauntlets : BEGauntlets {
	BEWyvernTailGauntlets() : base() {
		$this.Name               = 'Wyvern Tail Gauntlets'
		$this.MapObjName         = 'wyverntailgauntlets'
		$this.PurchasePrice      = 620
		$this.SellPrice          = 310
		$this.TargetStats        = @{
			[StatId]::Defense = 28
			[StatId]::MagicDefense = 10
			[StatId]::Accuracy = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets ending in a segmented wyvern tail, for agile strikes.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Unisex
	}
}
