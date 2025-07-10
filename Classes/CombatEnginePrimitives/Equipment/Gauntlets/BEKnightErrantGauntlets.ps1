using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEKNIGHTERRANTGAUNTLETS
#
###############################################################################

Class BEKnightErrantGauntlets : BEGauntlets {
	BEKnightErrantGauntlets() : base() {
		$this.Name               = 'Knight-Errant Gauntlets'
		$this.MapObjName         = 'knighterrantgauntlets'
		$this.PurchasePrice      = 500
		$this.SellPrice          = 250
		$this.TargetStats        = @{
			[StatId]::Defense = 26
			[StatId]::MagicDefense = 8
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets of a wandering knight, reliable and well-kept.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
