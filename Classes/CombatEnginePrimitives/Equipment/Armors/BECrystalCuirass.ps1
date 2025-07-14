using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECRYSTALCUIRASS
#
###############################################################################

Class BECrystalCuirass : BEArmor {
	BECrystalCuirass() : base() {
		$this.Name               = 'Crystal Cuirass'
		$this.MapObjName         = 'crystalcuirass'
		$this.PurchasePrice      = 1600
		$this.SellPrice          = 800
		$this.TargetStats        = @{
			[StatId]::Defense = 24
			[StatId]::MagicDefense = 8
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A cuirass made from hardened magical crystals, somewhat fragile.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
