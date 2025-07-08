using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE WHISPER OF THE ANCIENTS
#
###############################################################################

Class BEWhisperOfTheAncients : BEWeapon {
	BEWhisperOfTheAncients() : base() {
		$this.Name          = 'Whisper of the Ancients'
		$this.MapObjName    = 'whisperoftheancients'
		$this.PurchasePrice = 5400
		$this.SellPrice     = 2700
		$this.TargetStats   = @{
			[StatId]::Attack      = 122
			[StatId]::MagicAttack = 46
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A dagger that carries ancient whispers, confusing enemies.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}
