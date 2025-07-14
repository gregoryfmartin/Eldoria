using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEPLANETARYRING
#
###############################################################################

Class BEPlanetaryRing : BEJewelry {
	BEPlanetaryRing() : base() {
		$this.Name               = 'Planetary Ring'
		$this.MapObjName         = 'planetaryring'
		$this.PurchasePrice      = 1800
		$this.SellPrice          = 900
		$this.TargetStats        = @{
			[StatId]::MagicAttack = 2
			[StatId]::MagicDefense = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A ring that has miniature planets orbiting it.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
