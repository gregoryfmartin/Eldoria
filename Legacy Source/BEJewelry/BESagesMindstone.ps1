using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESAGESMINDSTONE
#
###############################################################################

Class BESagesMindstone : BEJewelry {
	BESagesMindstone() : base() {
		$this.Name               = 'Sage''s Mindstone'
		$this.MapObjName         = 'sagesmindstone'
		$this.PurchasePrice      = 1650
		$this.SellPrice          = 825
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 4
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A smooth, polished stone that enhances intellect.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
