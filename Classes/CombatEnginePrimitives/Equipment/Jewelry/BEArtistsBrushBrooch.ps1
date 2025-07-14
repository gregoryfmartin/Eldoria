using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEARTISTSBRUSHBROOCH
#
###############################################################################

Class BEArtistsBrushBrooch : BEJewelry {
	BEArtistsBrushBrooch() : base() {
		$this.Name               = 'Artist''s Brush Brooch'
		$this.MapObjName         = 'artistsbrushbrooch'
		$this.PurchasePrice      = 680
		$this.SellPrice          = 340
		$this.TargetStats        = @{
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A brooch shaped like a paint brush, for creativity.'
		$this.PlayerEffectString = ""
		$this.TargetGender       = [Gender]::Unisex
	}
}
