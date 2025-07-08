using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE MASAMUNE
#
###############################################################################

Class BEMasamune : BEWeapon {
	BEMasamune() : base() {
		$this.Name          = 'Masamune'
		$this.MapObjName    = 'masamune'
		$this.PurchasePrice = 4500
		$this.SellPrice     = 2250
		$this.TargetStats   = @{
			[StatId]::Attack      = 110
			[StatId]::MagicAttack = 30
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A katana of unparalleled sharpness, whispered to be cursed.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}
