using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEMOONWHISPERCAPE
#
###############################################################################

Class BEMoonwhisperCape : BECape {
	BEMoonwhisperCape() : base() {
		$this.Name               = 'Moonwhisper Cape'
		$this.MapObjName         = 'moonwhispercape'
		$this.PurchasePrice      = 800
		$this.SellPrice          = 400
		$this.TargetStats        = @{
			[StatId]::Accuracy = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A dark cape that seems to hum with lunar power, aiding intuition.'
		$this.PlayerEffectString = "  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Female
	}
}
