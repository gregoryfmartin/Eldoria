using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BELIGHTELEMENTALCOREHELM
#
###############################################################################

Class BELightElementalCoreHelm : BEHelmet {
	BELightElementalCoreHelm() : base() {
		$this.Name               = 'Light Elemental Core Helm'
		$this.MapObjName         = 'lightelementalcorehelm'
		$this.PurchasePrice      = 2500
		$this.SellPrice          = 1250
		$this.TargetStats        = @{
			[StatId]::Defense = 5
			[StatId]::MagicDefense = 20
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm infused with a light elemental core, radiating holy energy.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
