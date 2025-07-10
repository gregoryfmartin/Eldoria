using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEABYSSALGAUNTLETS
#
###############################################################################

Class BEAbyssalGauntlets : BEGauntlets {
	BEAbyssalGauntlets() : base() {
		$this.Name               = 'Abyssal Gauntlets'
		$this.MapObjName         = 'abyssalgauntlets'
		$this.PurchasePrice      = 900
		$this.SellPrice          = 450
		$this.TargetStats        = @{
			[StatId]::Defense = 42
			[StatId]::MagicDefense = 15
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets from the depths, reeking of darkness.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
