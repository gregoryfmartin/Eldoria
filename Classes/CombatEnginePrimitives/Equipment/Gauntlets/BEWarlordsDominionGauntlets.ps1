using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEWARLORDSDOMINIONGAUNTLETS
#
###############################################################################

Class BEWarlordsDominionGauntlets : BEGauntlets {
	BEWarlordsDominionGauntlets() : base() {
		$this.Name               = 'Warlord''s Dominion Gauntlets'
		$this.MapObjName         = 'warlordsdominiongauntlets'
		$this.PurchasePrice      = 1800
		$this.SellPrice          = 900
		$this.TargetStats        = @{
			[StatId]::Defense = 88
			[StatId]::MagicDefense = 30
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets that command absolute dominion, inspiring awe.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
