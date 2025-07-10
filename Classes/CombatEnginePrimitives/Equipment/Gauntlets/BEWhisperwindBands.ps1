using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEWHISPERWINDBANDS
#
###############################################################################

Class BEWhisperwindBands : BEGauntlets {
	BEWhisperwindBands() : base() {
		$this.Name               = 'Whisperwind Bands'
		$this.MapObjName         = 'whisperwindbands'
		$this.PurchasePrice      = 580
		$this.SellPrice          = 290
		$this.TargetStats        = @{
			[StatId]::Defense = 12
			[StatId]::MagicDefense = 23
			[StatId]::Accuracy = 12
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Bands that carry the faintest whispers, granting keen senses.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Unisex
	}
}
