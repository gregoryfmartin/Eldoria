using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BLAZE OF GLORY BOW
#
###############################################################################

Class BEBlazeOfGloryBow : BEWeapon {
	BEBlazeOfGloryBow() : base() {
		$this.Name          = 'Blaze of Glory Bow'
		$this.MapObjName    = 'blazeofglorybow'
		$this.PurchasePrice = 5700
		$this.SellPrice     = 2850
		$this.TargetStats   = @{
			[StatId]::Attack      = 125
			[StatId]::MagicAttack = 48
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A bow that sets arrows aflame, creating a trail of fire.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}
