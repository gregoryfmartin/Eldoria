using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEGRAVITYAXE
#
###############################################################################

Class BEGravityAxe : BEWeapon {
	BEGravityAxe() : base() {
		$this.Name          = 'Gravity Axe'
		$this.MapObjName    = 'gravityaxe'
		$this.PurchasePrice = 4400
		$this.SellPrice     = 2200
		$this.TargetStats   = @{
			[StatId]::Attack      = 110
			[StatId]::MagicAttack = 15
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'An axe that can manipulate gravity, crushing enemies under immense weight.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}
