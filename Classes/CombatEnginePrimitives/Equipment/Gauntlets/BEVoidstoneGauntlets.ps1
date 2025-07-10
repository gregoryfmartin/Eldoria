using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEVOIDSTONEGAUNTLETS
#
###############################################################################

Class BEVoidstoneGauntlets : BEGauntlets {
	BEVoidstoneGauntlets() : base() {
		$this.Name               = 'Voidstone Gauntlets'
		$this.MapObjName         = 'voidstonegauntlets'
		$this.PurchasePrice      = 1800
		$this.SellPrice          = 900
		$this.TargetStats        = @{
			[StatId]::Defense = 80
			[StatId]::MagicDefense = 45
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets made of voidstone, absorbing all magical attacks.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
