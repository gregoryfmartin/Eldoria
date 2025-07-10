using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BETURQUOISENECKLACE
#
###############################################################################

Class BETurquoiseNecklace : BEJewelry {
	BETurquoiseNecklace() : base() {
		$this.Name               = 'Turquoise Necklace'
		$this.MapObjName         = 'turquoisenecklace'
		$this.PurchasePrice      = 480
		$this.SellPrice          = 240
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A vibrant turquoise necklace, connecting to the sky.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
