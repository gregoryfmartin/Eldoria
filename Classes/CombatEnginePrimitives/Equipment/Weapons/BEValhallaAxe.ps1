using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEVALHALLAAXE
#
###############################################################################

Class BEValhallaAxe : BEWeapon {
	BEValhallaAxe() : base() {
		$this.Name          = 'Valhalla Axe'
		$this.MapObjName    = 'valhallaaxe'
		$this.PurchasePrice = 4700
		$this.SellPrice     = 2350
		$this.TargetStats   = @{
			[StatId]::Attack      = 125
			[StatId]::MagicAttack = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'An axe that sings in battle, inspiring allies and striking fear into foes.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}
