using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEIRONGUARDGAUNTLETS
#
###############################################################################

Class BEIronGuardGauntlets : BEGauntlets {
	BEIronGuardGauntlets() : base() {
		$this.Name               = 'Iron Guard Gauntlets'
		$this.MapObjName         = 'ironguardgauntlets'
		$this.PurchasePrice      = 180
		$this.SellPrice          = 90
		$this.TargetStats        = @{
			[StatId]::Defense = 9
			[StatId]::MagicDefense = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Reinforced iron gauntlets, preferred by city guards.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
