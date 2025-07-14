using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEOCEANICBOOTS
#
###############################################################################

Class BEOceanicBoots : BEBoots {
	BEOceanicBoots() : base() {
		$this.Name               = 'Oceanic Boots'
		$this.MapObjName         = 'oceanicboots'
		$this.PurchasePrice      = 980
		$this.SellPrice          = 490
		$this.TargetStats        = @{
			[StatId]::Defense = 37
			[StatId]::MagicDefense = 25
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots found in the depths of the ocean, resistant to water.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
