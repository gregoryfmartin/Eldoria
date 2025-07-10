using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEWHISPERWINDGAUNTLETS
#
###############################################################################

Class BEWhisperwindGauntlets : BEGauntlets {
	BEWhisperwindGauntlets() : base() {
		$this.Name               = 'Whisperwind Gauntlets'
		$this.MapObjName         = 'whisperwindgauntlets'
		$this.PurchasePrice      = 900
		$this.SellPrice          = 450
		$this.TargetStats        = @{
			[StatId]::Defense = 22
			[StatId]::MagicDefense = 20
			[StatId]::Accuracy = 20
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets light as a breeze, granting unparalleled agility.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Unisex
	}
}
