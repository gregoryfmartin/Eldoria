using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BELIGHTCRYSTAL
#
###############################################################################

Class BELightCrystal : BEJewelry {
	BELightCrystal() : base() {
		$this.Name               = 'Light Crystal'
		$this.MapObjName         = 'lightcrystal'
		$this.PurchasePrice      = 1600
		$this.SellPrice          = 800
		$this.TargetStats        = @{
			[StatId]::MagicAttack = 3
			[StatId]::MagicDefense = 4
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A radiant crystal, emitting pure light.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
