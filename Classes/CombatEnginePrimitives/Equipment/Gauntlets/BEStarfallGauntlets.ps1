using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESTARFALLGAUNTLETS
#
###############################################################################

Class BEStarfallGauntlets : BEGauntlets {
	BEStarfallGauntlets() : base() {
		$this.Name               = 'Starfall Gauntlets'
		$this.MapObjName         = 'starfallgauntlets'
		$this.PurchasePrice      = 1200
		$this.SellPrice          = 600
		$this.TargetStats        = @{
			[StatId]::Defense = 55
			[StatId]::MagicDefense = 30
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets embedded with fallen star fragments, radiating power.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
