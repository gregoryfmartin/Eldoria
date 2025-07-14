using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEVOIDSTONEGAUNTLETSII
#
###############################################################################

Class BEVoidstoneGauntletsII : BEGauntlets {
	BEVoidstoneGauntletsII() : base() {
		$this.Name               = 'Voidstone Gauntlets II'
		$this.MapObjName         = 'voidstonegauntletsii'
		$this.PurchasePrice      = 1900
		$this.SellPrice          = 950
		$this.TargetStats        = @{
			[StatId]::Defense = 85
			[StatId]::MagicDefense = 50
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Superior Voidstone Gauntlets, absorbing more magical attacks.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
