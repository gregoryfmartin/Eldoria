using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BERADIANTPAULDRON
#
###############################################################################

Class BERadiantPauldron : BEPauldron {
	BERadiantPauldron() : base() {
		$this.Name               = 'Radiant Pauldron'
		$this.MapObjName         = 'radiantpauldron'
		$this.PurchasePrice      = 4350
		$this.SellPrice          = 2175
		$this.TargetStats        = @{
			[StatId]::Defense = 87
			[StatId]::MagicDefense = 28
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Glows with a warm light, warding off darkness.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
