using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEJEWELERSLOUPERING
#
###############################################################################

Class BEJewelersLoupeRing : BEJewelry {
	BEJewelersLoupeRing() : base() {
		$this.Name               = 'Jeweler''s Loupe Ring'
		$this.MapObjName         = 'jewelersloupering'
		$this.PurchasePrice      = 800
		$this.SellPrice          = 400
		$this.TargetStats        = @{
			[StatId]::Accuracy = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A ring with a tiny magnifying glass, for discerning details.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Unisex
	}
}
