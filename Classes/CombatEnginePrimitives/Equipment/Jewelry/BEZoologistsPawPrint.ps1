using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEZOOLOGISTSPAWPRINT
#
###############################################################################

Class BEZoologistsPawPrint : BEJewelry {
	BEZoologistsPawPrint() : base() {
		$this.Name               = 'Zoologist''s Paw Print'
		$this.MapObjName         = 'zoologistspawprint'
		$this.PurchasePrice      = 850
		$this.SellPrice          = 425
		$this.TargetStats        = @{
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A charm with a delicate paw print, for animal empathy.'
		$this.PlayerEffectString = ""
		$this.TargetGender       = [Gender]::Unisex
	}
}
