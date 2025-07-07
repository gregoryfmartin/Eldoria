using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE DRAGON AXE
#
###############################################################################

Class BEDragonAxe : BEWeapon {
	BEDragonAxe() : base() {
		$this.Name          = 'Dragon Axe'
		$this.MapObjName    = 'dragonaxe'
		$this.PurchasePrice = 1000
		$this.SellPrice     = 500
		$this.TargetStats   = @{
			[StatId]::Attack      = 60
			[StatId]::MagicAttack = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'An axe forged in dragonfire, capable of burning foes.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}
