using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BETRANSMUTERSCATALYST
#
###############################################################################

Class BETransmutersCatalyst : BEJewelry {
	BETransmutersCatalyst() : base() {
		$this.Name               = 'Transmuter''s Catalyst'
		$this.MapObjName         = 'transmuterscatalyst'
		$this.PurchasePrice      = 1200
		$this.SellPrice          = 600
		$this.TargetStats        = @{
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A small, heavy catalyst that aids in transformations.'
		$this.PlayerEffectString = ""
		$this.TargetGender       = [Gender]::Unisex
	}
}
