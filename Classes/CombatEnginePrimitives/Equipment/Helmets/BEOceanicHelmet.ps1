using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE OCEANIC HELMET
#
###############################################################################

Class BEOceanicHelmet : BEHelmet {
	BEOceanicHelmet() : base() {
		$this.Name               = 'Oceanic Helmet'
		$this.MapObjName         = 'oceanichelmet'
		$this.PurchasePrice      = 900
		$this.SellPrice          = 450
		$this.TargetStats        = @{
			[StatId]::Defense = 10
			[StatId]::MagicDefense = 7
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helmet crafted from deep-sea materials, providing protection against water-based attacks.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
