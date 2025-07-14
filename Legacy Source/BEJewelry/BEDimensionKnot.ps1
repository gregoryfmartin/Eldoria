using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEDIMENSIONKNOT
#
###############################################################################

Class BEDimensionKnot : BEJewelry {
	BEDimensionKnot() : base() {
		$this.Name               = 'Dimension Knot'
		$this.MapObjName         = 'dimensionknot'
		$this.PurchasePrice      = 2100
		$this.SellPrice          = 1050
		$this.TargetStats        = @{
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A tangled knot of dimensional threads.'
		$this.PlayerEffectString = ""
		$this.TargetGender       = [Gender]::Unisex
	}
}
