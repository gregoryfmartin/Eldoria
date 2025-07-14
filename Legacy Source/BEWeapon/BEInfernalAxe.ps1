using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEINFERNALAXE
#
###############################################################################

Class BEInfernalAxe : BEWeapon {
	BEInfernalAxe() : base() {
		$this.Name          = 'Infernal Axe'
		$this.MapObjName    = 'infernalaxe'
		$this.PurchasePrice = 5100
		$this.SellPrice     = 2550
		$this.TargetStats   = @{
			[StatId]::Attack      = 130
			[StatId]::MagicAttack = 25
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'An axe burning with hellfire, capable of melting armor.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}
