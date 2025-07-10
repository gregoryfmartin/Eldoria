using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEFIREELEMENTALCOREHELM
#
###############################################################################

Class BEFireElementalCoreHelm : BEHelmet {
	BEFireElementalCoreHelm() : base() {
		$this.Name               = 'Fire Elemental Core Helm'
		$this.MapObjName         = 'fireelementalcorehelm'
		$this.PurchasePrice      = 2000
		$this.SellPrice          = 1000
		$this.TargetStats        = @{
			[StatId]::Defense = 10
			[StatId]::MagicDefense = 15
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm infused with a fire elemental core, granting fire immunity.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
