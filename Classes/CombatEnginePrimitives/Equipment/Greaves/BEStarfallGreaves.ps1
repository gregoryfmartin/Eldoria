using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESTARFALLGREAVES
#
###############################################################################

Class BEStarfallGreaves : BEGreaves {
	BEStarfallGreaves() : base() {
		$this.Name               = 'Starfall Greaves'
		$this.MapObjName         = 'starfallgreaves'
		$this.PurchasePrice      = 1600
		$this.SellPrice          = 800
		$this.TargetStats        = @{
			[StatId]::Defense = 60
			[StatId]::MagicDefense = 40
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves said to be crafted from fallen stars.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
