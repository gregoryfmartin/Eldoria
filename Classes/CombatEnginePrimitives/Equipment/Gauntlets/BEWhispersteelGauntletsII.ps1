using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEWHISPERSTEELGAUNTLETSII
#
###############################################################################

Class BEWhispersteelGauntletsII : BEGauntlets {
	BEWhispersteelGauntletsII() : base() {
		$this.Name               = 'Whispersteel Gauntlets II'
		$this.MapObjName         = 'whispersteelgauntletsii'
		$this.PurchasePrice      = 1500
		$this.SellPrice          = 750
		$this.TargetStats        = @{
			[StatId]::Defense = 70
			[StatId]::MagicDefense = 30
			[StatId]::Accuracy = 15
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Further enhanced Whispersteel Gauntlets, more silent and potent.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Unisex
	}
}
