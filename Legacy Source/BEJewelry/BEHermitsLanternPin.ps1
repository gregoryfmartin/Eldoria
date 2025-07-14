using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEHERMITSLANTERNPIN
#
###############################################################################

Class BEHermitsLanternPin : BEJewelry {
	BEHermitsLanternPin() : base() {
		$this.Name               = 'Hermit''s Lantern Pin'
		$this.MapObjName         = 'hermitslanternpin'
		$this.PurchasePrice      = 700
		$this.SellPrice          = 350
		$this.TargetStats        = @{
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A pin shaped like a small lantern, for solitary exploration.'
		$this.PlayerEffectString = ""
		$this.TargetGender       = [Gender]::Unisex
	}
}
