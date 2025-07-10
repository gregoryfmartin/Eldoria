using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BETEMPESTSPEAR
#
###############################################################################

Class BETempestSpear : BEWeapon {
	BETempestSpear() : base() {
		$this.Name          = 'Tempest Spear'
		$this.MapObjName    = 'tempestspear'
		$this.PurchasePrice = 3900
		$this.SellPrice     = 1950
		$this.TargetStats   = @{
			[StatId]::Attack      = 98
			[StatId]::MagicAttack = 25
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A spear that can conjure small whirlwinds.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}
