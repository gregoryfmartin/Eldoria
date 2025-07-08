using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE MJOLNIR
#
###############################################################################

Class BEMjolnir : BEWeapon {
	BEMjolnir() : base() {
		$this.Name          = 'Mjolnir'
		$this.MapObjName    = 'mjolnir'
		$this.PurchasePrice = 5200
		$this.SellPrice     = 2600
		$this.TargetStats   = @{
			[StatId]::Attack      = 130
			[StatId]::MagicAttack = 60
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A mythical hammer that calls down lightning, only wieldable by the worthy.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}
