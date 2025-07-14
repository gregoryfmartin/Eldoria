using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEBOTANISTSLEAFBROOCH
#
###############################################################################

Class BEBotanistsLeafBrooch : BEJewelry {
	BEBotanistsLeafBrooch() : base() {
		$this.Name               = 'Botanist''s Leaf Brooch'
		$this.MapObjName         = 'botanistsleafbrooch'
		$this.PurchasePrice      = 800
		$this.SellPrice          = 400
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A brooch shaped like a perfect leaf, for plant growth.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
