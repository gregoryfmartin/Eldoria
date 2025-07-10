using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEINVENTORGREAVES
#
###############################################################################

Class BEInventorGreaves : BEGreaves {
	BEInventorGreaves() : base() {
		$this.Name               = 'Inventor Greaves'
		$this.MapObjName         = 'inventorgreaves'
		$this.PurchasePrice      = 550
		$this.SellPrice          = 275
		$this.TargetStats        = @{
			[StatId]::Defense = 22
			[StatId]::MagicDefense = 12
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves for creative minds.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
