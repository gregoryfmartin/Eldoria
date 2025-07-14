using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEINVENTORSBLUEPRINTFRAGMENT
#
###############################################################################

Class BEInventorsBlueprintFragment : BEJewelry {
	BEInventorsBlueprintFragment() : base() {
		$this.Name               = 'Inventor''s Blueprint Fragment'
		$this.MapObjName         = 'inventorsblueprintfragment'
		$this.PurchasePrice      = 1200
		$this.SellPrice          = 600
		$this.TargetStats        = @{
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A fragment of an ingenious blueprint.'
		$this.PlayerEffectString = ""
		$this.TargetGender       = [Gender]::Unisex
	}
}
