using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESTARLIGHTGAUNTLETS
#
###############################################################################

Class BEStarlightGauntlets : BEGauntlets {
	BEStarlightGauntlets() : base() {
		$this.Name               = 'Starlight Gauntlets'
		$this.MapObjName         = 'starlightgauntlets'
		$this.PurchasePrice      = 1080
		$this.SellPrice          = 540
		$this.TargetStats        = @{
			[StatId]::Defense = 20
			[StatId]::MagicDefense = 36
			[StatId]::Accuracy = 8
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets shimmering with starlight, offering celestial guidance.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Female
	}
}
