using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEWHISPERWINDTUNIC
#
###############################################################################

Class BEWhisperwindTunic : BEArmor {
	BEWhisperwindTunic() : base() {
		$this.Name               = 'Whisperwind Tunic'
		$this.MapObjName         = 'whisperwindtunic'
		$this.PurchasePrice      = 140
		$this.SellPrice          = 70
		$this.TargetStats        = @{
			[StatId]::Defense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A lightweight tunic that barely rustles, ideal for stealth and speed.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
