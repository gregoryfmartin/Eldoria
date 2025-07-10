using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEWHISPERWINDBOW
#
###############################################################################

Class BEWhisperwindBow : BEWeapon {
	BEWhisperwindBow() : base() {
		$this.Name          = 'Whisperwind Bow'
		$this.MapObjName    = 'whisperwindbow'
		$this.PurchasePrice = 3800
		$this.SellPrice     = 1900
		$this.TargetStats   = @{
			[StatId]::Attack      = 92
			[StatId]::MagicAttack = 18
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A bow whose arrows are carried by invisible winds, striking silently.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}
