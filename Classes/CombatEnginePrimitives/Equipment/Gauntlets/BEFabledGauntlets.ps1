using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEFABLEDGAUNTLETS
#
###############################################################################

Class BEFabledGauntlets : BEGauntlets {
	BEFabledGauntlets() : base() {
		$this.Name               = 'Fabled Gauntlets'
		$this.MapObjName         = 'fabledgauntlets'
		$this.PurchasePrice      = 2500
		$this.SellPrice          = 1250
		$this.TargetStats        = @{
			[StatId]::Defense = 90
			[StatId]::MagicDefense = 45
			[StatId]::Accuracy = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets spoken of in legends, their power growing.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Unisex
	}
}
