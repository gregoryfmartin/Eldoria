using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEWHISPERWINDGAUNTLETSII
#
###############################################################################

Class BEWhisperwindGauntletsII : BEGauntlets {
	BEWhisperwindGauntletsII() : base() {
		$this.Name               = 'Whisperwind Gauntlets II'
		$this.MapObjName         = 'whisperwindgauntletsii'
		$this.PurchasePrice      = 1000
		$this.SellPrice          = 500
		$this.TargetStats        = @{
			[StatId]::Defense = 25
			[StatId]::MagicDefense = 25
			[StatId]::Accuracy = 20
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Improved Whisperwind Gauntlets, even swifter.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Unisex
	}
}
