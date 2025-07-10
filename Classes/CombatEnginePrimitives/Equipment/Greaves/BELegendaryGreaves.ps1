using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BELEGENDARYGREAVES
#
###############################################################################

Class BELegendaryGreaves : BEGreaves {
	BELegendaryGreaves() : base() {
		$this.Name               = 'Legendary Greaves'
		$this.MapObjName         = 'legendarygreaves'
		$this.PurchasePrice      = 2000
		$this.SellPrice          = 1000
		$this.TargetStats        = @{
			[StatId]::Defense = 75
			[StatId]::MagicDefense = 55
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves spoken of in ancient tales.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
