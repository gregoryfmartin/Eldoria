using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEPLATINUMAMULET
#
###############################################################################

Class BEPlatinumAmulet : BEJewelry {
	BEPlatinumAmulet() : base() {
		$this.Name               = 'Platinum Amulet'
		$this.MapObjName         = 'platinumamulet'
		$this.PurchasePrice      = 600
		$this.SellPrice          = 300
		$this.TargetStats        = @{
			[StatId]::Defense = 1
			[StatId]::MagicAttack = 1
			[StatId]::MagicDefense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A sleek platinum amulet, radiating sophistication.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
