using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEABYSSALMAWGAUNTLETS
#
###############################################################################

Class BEAbyssalMawGauntlets : BEGauntlets {
	BEAbyssalMawGauntlets() : base() {
		$this.Name               = 'Abyssal Maw Gauntlets'
		$this.MapObjName         = 'abyssalmawgauntlets'
		$this.PurchasePrice      = 1450
		$this.SellPrice          = 725
		$this.TargetStats        = @{
			[StatId]::Defense = 65
			[StatId]::MagicDefense = 22
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets resembling a gaping maw, crushing foes.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
