using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEIRONGUARDGAUNTLETSII
#
###############################################################################

Class BEIronGuardGauntletsII : BEGauntlets {
	BEIronGuardGauntletsII() : base() {
		$this.Name               = 'Iron Guard Gauntlets II'
		$this.MapObjName         = 'ironguardgauntletsii'
		$this.PurchasePrice      = 250
		$this.SellPrice          = 125
		$this.TargetStats        = @{
			[StatId]::Defense = 13
			[StatId]::MagicDefense = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Reinforced Iron Guard Gauntlets, sturdier.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
