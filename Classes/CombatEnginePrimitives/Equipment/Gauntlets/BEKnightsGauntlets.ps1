using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEKNIGHTSGAUNTLETS
#
###############################################################################

Class BEKnightsGauntlets : BEGauntlets {
	BEKnightsGauntlets() : base() {
		$this.Name               = 'Knight''s Gauntlets'
		$this.MapObjName         = 'knightsgauntlets'
		$this.PurchasePrice      = 500
		$this.SellPrice          = 250
		$this.TargetStats        = @{
			[StatId]::Defense = 22
			[StatId]::MagicDefense = 8
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Polished and robust gauntlets, fit for a knight.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
