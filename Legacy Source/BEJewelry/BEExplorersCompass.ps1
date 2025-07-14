using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEEXPLORERSCOMPASS
#
###############################################################################

Class BEExplorersCompass : BEJewelry {
	BEExplorersCompass() : base() {
		$this.Name               = 'Explorer''s Compass'
		$this.MapObjName         = 'explorerscompass'
		$this.PurchasePrice      = 800
		$this.SellPrice          = 400
		$this.TargetStats        = @{
			[StatId]::Accuracy = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A tiny compass that always points true.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Unisex
	}
}
