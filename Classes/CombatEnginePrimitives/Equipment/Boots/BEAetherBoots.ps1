using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEAETHERBOOTS
#
###############################################################################

Class BEAetherBoots : BEBoots {
	BEAetherBoots() : base() {
		$this.Name               = 'Aether Boots'
		$this.MapObjName         = 'aetherboots'
		$this.PurchasePrice      = 1600
		$this.SellPrice          = 800
		$this.TargetStats        = @{
			[StatId]::Defense = 60
			[StatId]::MagicDefense = 40
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots from another dimension, ethereal.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
