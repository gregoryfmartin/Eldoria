using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEWHISPERROBE
#
###############################################################################

Class BEWhisperRobe : BEArmor {
	BEWhisperRobe() : base() {
		$this.Name               = 'Whisper Robe'
		$this.MapObjName         = 'whisperrobe'
		$this.PurchasePrice      = 650
		$this.SellPrice          = 325
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 19
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A robe that makes a soft rustling sound, used for quiet movement.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
