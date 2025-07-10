using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEDARKELEMENTALCOREHELM
#
###############################################################################

Class BEDarkElementalCoreHelm : BEHelmet {
	BEDarkElementalCoreHelm() : base() {
		$this.Name               = 'Dark Elemental Core Helm'
		$this.MapObjName         = 'darkelementalcorehelm'
		$this.PurchasePrice      = 2500
		$this.SellPrice          = 1250
		$this.TargetStats        = @{
			[StatId]::Defense = 5
			[StatId]::MagicDefense = 20
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm infused with a dark elemental core, manipulating shadows.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
