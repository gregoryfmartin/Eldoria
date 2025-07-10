using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEWATERELEMENTALCOREHELM
#
###############################################################################

Class BEWaterElementalCoreHelm : BEHelmet {
	BEWaterElementalCoreHelm() : base() {
		$this.Name               = 'Water Elemental Core Helm'
		$this.MapObjName         = 'waterelementalcorehelm'
		$this.PurchasePrice      = 2000
		$this.SellPrice          = 1000
		$this.TargetStats        = @{
			[StatId]::Defense = 10
			[StatId]::MagicDefense = 15
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm infused with a water elemental core, granting water breathing.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
