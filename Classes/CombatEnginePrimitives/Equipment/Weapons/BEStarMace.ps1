using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE STAR MACE
#
###############################################################################

Class BEStarMace : BEWeapon {
	BEStarMace() : base() {
		$this.Name          = 'Star Mace'
		$this.MapObjName    = 'starmace'
		$this.PurchasePrice = 950
		$this.SellPrice     = 475
		$this.TargetStats   = @{
			[StatId]::Attack      = 54
			[StatId]::MagicAttack = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A mace studded with celestial fragments, glittering with cosmic energy.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}
