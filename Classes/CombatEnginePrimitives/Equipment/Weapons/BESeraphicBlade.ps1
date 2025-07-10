using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESERAPHICBLADE
#
###############################################################################

Class BESeraphicBlade : BEWeapon {
	BESeraphicBlade() : base() {
		$this.Name          = 'Seraphic Blade'
		$this.MapObjName    = 'seraphicblade'
		$this.PurchasePrice = 4900
		$this.SellPrice     = 2450
		$this.TargetStats   = @{
			[StatId]::Attack      = 118
			[StatId]::MagicAttack = 45
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A sword of celestial origin, imbued with divine light.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}
