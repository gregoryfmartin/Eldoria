using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEWARLORDSGAUNTLETS
#
###############################################################################

Class BEWarlordsGauntlets : BEGauntlets {
	BEWarlordsGauntlets() : base() {
		$this.Name               = 'Warlord''s Gauntlets'
		$this.MapObjName         = 'warlordsgauntlets'
		$this.PurchasePrice      = 1600
		$this.SellPrice          = 800
		$this.TargetStats        = @{
			[StatId]::Defense = 78
			[StatId]::MagicDefense = 20
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets of a fearsome warlord, commanding respect.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
