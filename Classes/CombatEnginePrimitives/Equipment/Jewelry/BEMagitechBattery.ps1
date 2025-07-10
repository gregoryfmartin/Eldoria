using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEMAGITECHBATTERY
#
###############################################################################

Class BEMagitechBattery : BEJewelry {
	BEMagitechBattery() : base() {
		$this.Name               = 'Magitech Battery'
		$this.MapObjName         = 'magitechbattery'
		$this.PurchasePrice      = 1700
		$this.SellPrice          = 850
		$this.TargetStats        = @{
			[StatId]::MagicAttack = 3
			[StatId]::MagicDefense = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A small battery that stores both magic and electricity.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
