using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEVANGUARDGAUNTLETS
#
###############################################################################

Class BEVanguardGauntlets : BEGauntlets {
	BEVanguardGauntlets() : base() {
		$this.Name               = 'Vanguard Gauntlets'
		$this.MapObjName         = 'vanguardgauntlets'
		$this.PurchasePrice      = 1000
		$this.SellPrice          = 500
		$this.TargetStats        = @{
			[StatId]::Defense = 52
			[StatId]::MagicDefense = 12
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'The first line of defense, heavy and reliable.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
