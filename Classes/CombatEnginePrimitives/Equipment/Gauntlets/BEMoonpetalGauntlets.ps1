using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEMOONPETALGAUNTLETS
#
###############################################################################

Class BEMoonpetalGauntlets : BEGauntlets {
	BEMoonpetalGauntlets() : base() {
		$this.Name               = 'Moonpetal Gauntlets'
		$this.MapObjName         = 'moonpetalgauntlets'
		$this.PurchasePrice      = 750
		$this.SellPrice          = 375
		$this.TargetStats        = @{
			[StatId]::Defense = 15
			[StatId]::MagicDefense = 35
			[StatId]::Accuracy = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets made of moonlight-infused petals, magically potent.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Female
	}
}
