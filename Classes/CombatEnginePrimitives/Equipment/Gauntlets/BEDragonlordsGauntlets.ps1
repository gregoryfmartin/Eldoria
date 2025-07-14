using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEDRAGONLORDSGAUNTLETS
#
###############################################################################

Class BEDragonlordsGauntlets : BEGauntlets {
	BEDragonlordsGauntlets() : base() {
		$this.Name               = 'Dragonlord''s Gauntlets'
		$this.MapObjName         = 'dragonlordsgauntlets'
		$this.PurchasePrice      = 1800
		$this.SellPrice          = 900
		$this.TargetStats        = @{
			[StatId]::Defense = 88
			[StatId]::MagicDefense = 35
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets fit for a dragonlord, of immense power.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
