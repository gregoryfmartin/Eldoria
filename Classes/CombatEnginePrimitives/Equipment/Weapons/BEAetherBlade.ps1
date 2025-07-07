using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE AETHER BLADE
#
###############################################################################

Class BEAetherBlade : BEWeapon {
	BEAetherBlade() : base() {
		$this.Name          = 'Aether Blade'
		$this.MapObjName    = 'aetherblade'
		$this.PurchasePrice = 1120
		$this.SellPrice     = 560
		$this.TargetStats   = @{
			[StatId]::Attack      = 59
			[StatId]::MagicAttack = 22
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A sword that hums with ethereal energy, able to phase through some defenses.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}
