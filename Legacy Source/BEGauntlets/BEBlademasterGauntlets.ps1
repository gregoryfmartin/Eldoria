using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEBLADEMASTERGAUNTLETS
#
###############################################################################

Class BEBlademasterGauntlets : BEGauntlets {
	BEBlademasterGauntlets() : base() {
		$this.Name               = 'Blademaster Gauntlets'
		$this.MapObjName         = 'blademastergauntlets'
		$this.PurchasePrice      = 900
		$this.SellPrice          = 450
		$this.TargetStats        = @{
			[StatId]::Defense = 40
			[StatId]::MagicDefense = 10
			[StatId]::Accuracy = 12
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets designed for precision and offensive strikes.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Unisex
	}
}
