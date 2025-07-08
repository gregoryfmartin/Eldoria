using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE ETERNITYS EMBRACE
#
###############################################################################

Class BEEternitysEmbrace : BEWeapon {
	BEEternitysEmbrace() : base() {
		$this.Name          = 'Eternity''s Embrace'
		$this.MapObjName    = 'eternitysembrace'
		$this.PurchasePrice = 5900
		$this.SellPrice     = 2950
		$this.TargetStats   = @{
			[StatId]::Attack      = 40
			[StatId]::MagicAttack = 170
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A staff that can briefly halt the flow of time around the wielder.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}
