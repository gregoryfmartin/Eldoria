using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEWARLORDSFURYGAUNTLETS
#
###############################################################################

Class BEWarlordsFuryGauntlets : BEGauntlets {
	BEWarlordsFuryGauntlets() : base() {
		$this.Name               = 'Warlord''s Fury Gauntlets'
		$this.MapObjName         = 'warlordsfurygauntlets'
		$this.PurchasePrice      = 1700
		$this.SellPrice          = 850
		$this.TargetStats        = @{
			[StatId]::Defense = 82
			[StatId]::MagicDefense = 25
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets boiling with warlord''s fury, inspiring fear.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
