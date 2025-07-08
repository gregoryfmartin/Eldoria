using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE ARCANE SCEPTER
#
###############################################################################

Class BEArcaneScepter : BEWeapon {
	BEArcaneScepter() : base() {
		$this.Name          = 'Arcane Scepter'
		$this.MapObjName    = 'arcanescepter'
		$this.PurchasePrice = 5500
		$this.SellPrice     = 2750
		$this.TargetStats   = @{
			[StatId]::Attack      = 30
			[StatId]::MagicAttack = 150
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A scepter humming with raw arcane energy, amplifying all spells.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}
