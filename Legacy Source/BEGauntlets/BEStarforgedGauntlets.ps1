using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESTARFORGEDGAUNTLETS
#
###############################################################################

Class BEStarforgedGauntlets : BEGauntlets {
	BEStarforgedGauntlets() : base() {
		$this.Name               = 'Starforged Gauntlets'
		$this.MapObjName         = 'starforgedgauntlets'
		$this.PurchasePrice      = 1550
		$this.SellPrice          = 775
		$this.TargetStats        = @{
			[StatId]::Defense = 70
			[StatId]::MagicDefense = 30
			[StatId]::Accuracy = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets forged under a specific constellation, granting luck.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Unisex
	}
}
