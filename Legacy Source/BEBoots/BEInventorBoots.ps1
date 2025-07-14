using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEINVENTORBOOTS
#
###############################################################################

Class BEInventorBoots : BEBoots {
	BEInventorBoots() : base() {
		$this.Name               = 'Inventor Boots'
		$this.MapObjName         = 'inventorboots'
		$this.PurchasePrice      = 500
		$this.SellPrice          = 250
		$this.TargetStats        = @{
			[StatId]::Defense = 20
			[StatId]::MagicDefense = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots for creative minds.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
