using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BENIGHTFALLGAUNTLETSII
#
###############################################################################

Class BENightfallGauntletsII : BEGauntlets {
	BENightfallGauntletsII() : base() {
		$this.Name               = 'Nightfall Gauntlets II'
		$this.MapObjName         = 'nightfallgauntletsii'
		$this.PurchasePrice      = 1450
		$this.SellPrice          = 725
		$this.TargetStats        = @{
			[StatId]::Defense = 70
			[StatId]::MagicDefense = 30
			[StatId]::Accuracy = 20
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'More potent Nightfall Gauntlets, deeper shadows.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Unisex
	}
}
