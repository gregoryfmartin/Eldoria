using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEDIVINEESSENCEGAUNTLETS
#
###############################################################################

Class BEDivineEssenceGauntlets : BEGauntlets {
	BEDivineEssenceGauntlets() : base() {
		$this.Name               = 'Divine Essence Gauntlets'
		$this.MapObjName         = 'divineessencegauntlets'
		$this.PurchasePrice      = 1800
		$this.SellPrice          = 900
		$this.TargetStats        = @{
			[StatId]::Defense = 80
			[StatId]::MagicDefense = 40
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets pulsating with pure divine essence, warding off evil.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
