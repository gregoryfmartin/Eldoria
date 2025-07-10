using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEAETHERGREAVES
#
###############################################################################

Class BEAetherGreaves : BEGreaves {
	BEAetherGreaves() : base() {
		$this.Name               = 'Aether Greaves'
		$this.MapObjName         = 'aethergreaves'
		$this.PurchasePrice      = 1700
		$this.SellPrice          = 850
		$this.TargetStats        = @{
			[StatId]::Defense = 65
			[StatId]::MagicDefense = 45
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves from another dimension, ethereal.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
