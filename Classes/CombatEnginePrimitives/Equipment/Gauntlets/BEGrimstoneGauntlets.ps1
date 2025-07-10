using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEGRIMSTONEGAUNTLETS
#
###############################################################################

Class BEGrimstoneGauntlets : BEGauntlets {
	BEGrimstoneGauntlets() : base() {
		$this.Name               = 'Grimstone Gauntlets'
		$this.MapObjName         = 'grimstonegauntlets'
		$this.PurchasePrice      = 1750
		$this.SellPrice          = 875
		$this.TargetStats        = @{
			[StatId]::Defense = 82
			[StatId]::MagicDefense = 28
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets carved from cursed stone, heavy and menacing.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
