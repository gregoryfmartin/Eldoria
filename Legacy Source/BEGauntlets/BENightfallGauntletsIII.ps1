using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BENIGHTFALLGAUNTLETSIII
#
###############################################################################

Class BENightfallGauntletsIII : BEGauntlets {
	BENightfallGauntletsIII() : base() {
		$this.Name               = 'Nightfall Gauntlets III'
		$this.MapObjName         = 'nightfallgauntletsiii'
		$this.PurchasePrice      = 1550
		$this.SellPrice          = 775
		$this.TargetStats        = @{
			[StatId]::Defense = 75
			[StatId]::MagicDefense = 35
			[StatId]::Accuracy = 20
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Final tier Nightfall Gauntlets, deepest shadows, supreme stealth.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Unisex
	}
}
