using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESHADOWBOW
#
###############################################################################

Class BEShadowBow : BEWeapon {
	BEShadowBow() : base() {
		$this.Name          = 'Shadow Bow'
		$this.MapObjName    = 'shadowbow'
		$this.PurchasePrice = 1050
		$this.SellPrice     = 525
		$this.TargetStats   = @{
			[StatId]::Attack      = 55
			[StatId]::MagicAttack = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A bow that fires arrows of pure shadow, piercing defenses.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}
