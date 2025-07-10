using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESTARFORGEDVAMBRACES
#
###############################################################################

Class BEStarforgedVambraces : BEGauntlets {
	BEStarforgedVambraces() : base() {
		$this.Name               = 'Starforged Vambraces'
		$this.MapObjName         = 'starforgedvambraces'
		$this.PurchasePrice      = 1200
		$this.SellPrice          = 600
		$this.TargetStats        = @{
			[StatId]::Defense = 55
			[StatId]::MagicDefense = 22
			[StatId]::Accuracy = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Vambraces forged under a specific constellation, granting luck.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Unisex
	}
}
