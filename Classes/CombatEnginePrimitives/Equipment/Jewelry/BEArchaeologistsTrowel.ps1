using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEARCHAEOLOGISTSTROWEL
#
###############################################################################

Class BEArchaeologistsTrowel : BEJewelry {
	BEArchaeologistsTrowel() : base() {
		$this.Name               = 'Archaeologist''s Trowel'
		$this.MapObjName         = 'archaeologiststrowel'
		$this.PurchasePrice      = 950
		$this.SellPrice          = 475
		$this.TargetStats        = @{
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A tiny trowel for uncovering ancient secrets.'
		$this.PlayerEffectString = ""
		$this.TargetGender       = [Gender]::Unisex
	}
}
