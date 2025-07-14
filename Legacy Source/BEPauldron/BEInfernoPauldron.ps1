using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEINFERNOPAULDRON
#
###############################################################################

Class BEInfernoPauldron : BEPauldron {
	BEInfernoPauldron() : base() {
		$this.Name               = 'Inferno Pauldron'
		$this.MapObjName         = 'infernopauldron'
		$this.PurchasePrice      = 3650
		$this.SellPrice          = 1825
		$this.TargetStats        = @{
			[StatId]::Defense = 73
			[StatId]::MagicDefense = 19
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Blazes with infernal fire, empowering fire defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
