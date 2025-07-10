using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEWHISPERWINDEARRING
#
###############################################################################

Class BEWhisperwindEarring : BEJewelry {
	BEWhisperwindEarring() : base() {
		$this.Name               = 'Whisperwind Earring'
		$this.MapObjName         = 'whisperwindearring'
		$this.PurchasePrice      = 700
		$this.SellPrice          = 350
		$this.TargetStats        = @{
			[StatId]::Accuracy = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'An earring that carries whispers on the wind, granting insight.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Female
	}
}
