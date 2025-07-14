using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEEARTHELEMENTALCOREHELM
#
###############################################################################

Class BEEarthElementalCoreHelm : BEHelmet {
	BEEarthElementalCoreHelm() : base() {
		$this.Name               = 'Earth Elemental Core Helm'
		$this.MapObjName         = 'earthelementalcorehelm'
		$this.PurchasePrice      = 2000
		$this.SellPrice          = 1000
		$this.TargetStats        = @{
			[StatId]::Defense = 10
			[StatId]::MagicDefense = 15
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm infused with an earth elemental core, granting increased fortitude.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
