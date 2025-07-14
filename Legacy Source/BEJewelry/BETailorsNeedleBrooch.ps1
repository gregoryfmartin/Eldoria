using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BETAILORSNEEDLEBROOCH
#
###############################################################################

Class BETailorsNeedleBrooch : BEJewelry {
	BETailorsNeedleBrooch() : base() {
		$this.Name               = 'Tailor''s Needle Brooch'
		$this.MapObjName         = 'tailorsneedlebrooch'
		$this.PurchasePrice      = 650
		$this.SellPrice          = 325
		$this.TargetStats        = @{
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A brooch shaped like a needle, for fine stitching.'
		$this.PlayerEffectString = ""
		$this.TargetGender       = [Gender]::Female
	}
}
