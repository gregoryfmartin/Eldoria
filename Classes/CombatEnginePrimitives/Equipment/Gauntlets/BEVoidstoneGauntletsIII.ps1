using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEVOIDSTONEGAUNTLETSIII
#
###############################################################################

Class BEVoidstoneGauntletsIII : BEGauntlets {
	BEVoidstoneGauntletsIII() : base() {
		$this.Name               = 'Voidstone Gauntlets III'
		$this.MapObjName         = 'voidstonegauntletsiii'
		$this.PurchasePrice      = 2000
		$this.SellPrice          = 1000
		$this.TargetStats        = @{
			[StatId]::Defense = 90
			[StatId]::MagicDefense = 55
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Final tier Voidstone Gauntlets, absorbing all magical attacks.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
