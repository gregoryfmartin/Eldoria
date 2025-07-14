using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEARTIFICERSCOGWHEEL
#
###############################################################################

Class BEArtificersCogwheel : BEJewelry {
	BEArtificersCogwheel() : base() {
		$this.Name               = 'Artificer''s Cogwheel'
		$this.MapObjName         = 'artificerscogwheel'
		$this.PurchasePrice      = 1300
		$this.SellPrice          = 650
		$this.TargetStats        = @{
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A tiny, perpetually turning cogwheel.'
		$this.PlayerEffectString = ""
		$this.TargetGender       = [Gender]::Unisex
	}
}
