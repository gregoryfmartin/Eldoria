using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESTARFALLBOOTS
#
###############################################################################

Class BEStarfallBoots : BEBoots {
	BEStarfallBoots() : base() {
		$this.Name               = 'Starfall Boots'
		$this.MapObjName         = 'starfallboots'
		$this.PurchasePrice      = 1500
		$this.SellPrice          = 750
		$this.TargetStats        = @{
			[StatId]::Defense = 55
			[StatId]::MagicDefense = 35
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots said to be crafted from fallen stars.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
