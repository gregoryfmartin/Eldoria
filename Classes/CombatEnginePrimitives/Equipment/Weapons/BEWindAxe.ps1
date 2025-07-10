using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEWINDAXE
#
###############################################################################

Class BEWindAxe : BEWeapon {
	BEWindAxe() : base() {
		$this.Name          = 'Wind Axe'
		$this.MapObjName    = 'windaxe'
		$this.PurchasePrice = 920
		$this.SellPrice     = 460
		$this.TargetStats   = @{
			[StatId]::Attack      = 54
			[StatId]::MagicAttack = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'An axe that cuts through the air with ease, creating gusts of wind.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}
