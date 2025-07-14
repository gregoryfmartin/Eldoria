using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEEBONSHADOWGAUNTLETS
#
###############################################################################

Class BEEbonShadowGauntlets : BEGauntlets {
	BEEbonShadowGauntlets() : base() {
		$this.Name               = 'Ebon Shadow Gauntlets'
		$this.MapObjName         = 'ebonshadowgauntlets'
		$this.PurchasePrice      = 1850
		$this.SellPrice          = 925
		$this.TargetStats        = @{
			[StatId]::Defense = 75
			[StatId]::MagicDefense = 35
			[StatId]::Accuracy = 17
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets that melt into shadows, making the wearer unseen.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Unisex
	}
}
