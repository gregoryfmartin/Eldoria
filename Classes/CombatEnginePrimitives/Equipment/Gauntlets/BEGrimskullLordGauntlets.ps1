using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEGRIMSKULLLORDGAUNTLETS
#
###############################################################################

Class BEGrimskullLordGauntlets : BEGauntlets {
	BEGrimskullLordGauntlets() : base() {
		$this.Name               = 'Grimskull Lord Gauntlets'
		$this.MapObjName         = 'grimskulllordgauntlets'
		$this.PurchasePrice      = 1700
		$this.SellPrice          = 850
		$this.TargetStats        = @{
			[StatId]::Defense = 85
			[StatId]::MagicDefense = 25
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets of a grimskull lord, radiating immense dread.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
