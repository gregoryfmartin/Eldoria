using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEWHISPERSTEELGAUNTLETS
#
###############################################################################

Class BEWhispersteelGauntlets : BEGauntlets {
	BEWhispersteelGauntlets() : base() {
		$this.Name               = 'Whispersteel Gauntlets'
		$this.MapObjName         = 'whispersteelgauntlets'
		$this.PurchasePrice      = 1400
		$this.SellPrice          = 700
		$this.TargetStats        = @{
			[StatId]::Defense = 65
			[StatId]::MagicDefense = 25
			[StatId]::Accuracy = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets made of a silent, shadowy metal.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Unisex
	}
}
