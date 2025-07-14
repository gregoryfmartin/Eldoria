using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BENIGHTFALLGAUNTLETS
#
###############################################################################

Class BENightfallGauntlets : BEGauntlets {
	BENightfallGauntlets() : base() {
		$this.Name               = 'Nightfall Gauntlets'
		$this.MapObjName         = 'nightfallgauntlets'
		$this.PurchasePrice      = 1350
		$this.SellPrice          = 675
		$this.TargetStats        = @{
			[StatId]::Defense = 50
			[StatId]::MagicDefense = 25
			[StatId]::Accuracy = 12
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets that absorb surrounding light, cloaking the wearer.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Unisex
	}
}
