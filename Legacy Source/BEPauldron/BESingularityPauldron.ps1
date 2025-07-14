using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESINGULARITYPAULDRON
#
###############################################################################

Class BESingularityPauldron : BEPauldron {
	BESingularityPauldron() : base() {
		$this.Name               = 'Singularity Pauldron'
		$this.MapObjName         = 'singularitypauldron'
		$this.PurchasePrice      = 6900
		$this.SellPrice          = 3450
		$this.TargetStats        = @{
			[StatId]::Defense = 138
			[StatId]::MagicDefense = 59
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Contains the power of a collapsing star, incredibly potent.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
