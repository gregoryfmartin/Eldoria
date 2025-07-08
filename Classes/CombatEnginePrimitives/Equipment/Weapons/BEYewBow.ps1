using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE YEW BOW
#
###############################################################################

Class BEYewBow : BEWeapon {
	BEYewBow() : base() {
		$this.Name          = 'Yew Bow'
		$this.MapObjName    = 'yewbow'
		$this.PurchasePrice = 4200
		$this.SellPrice     = 2100
		$this.TargetStats   = @{
			[StatId]::Attack      = 105
			[StatId]::MagicAttack = 20
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A bow carved from ancient yew, its arrows seek out vital points.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}
