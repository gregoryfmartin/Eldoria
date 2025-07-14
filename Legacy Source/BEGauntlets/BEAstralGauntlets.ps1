using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEASTRALGAUNTLETS
#
###############################################################################

Class BEAstralGauntlets : BEGauntlets {
	BEAstralGauntlets() : base() {
		$this.Name               = 'Astral Gauntlets'
		$this.MapObjName         = 'astralgauntlets'
		$this.PurchasePrice      = 1700
		$this.SellPrice          = 850
		$this.TargetStats        = @{
			[StatId]::Defense = 35
			[StatId]::MagicDefense = 55
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets connected to the astral plane, enhancing spiritual power.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
