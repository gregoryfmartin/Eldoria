using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESTARSHARDGAUNTLETS
#
###############################################################################

Class BEStarshardGauntlets : BEGauntlets {
	BEStarshardGauntlets() : base() {
		$this.Name               = 'Starshard Gauntlets'
		$this.MapObjName         = 'starshardgauntlets'
		$this.PurchasePrice      = 1400
		$this.SellPrice          = 700
		$this.TargetStats        = @{
			[StatId]::Defense = 65
			[StatId]::MagicDefense = 28
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets embedded with fragments of fallen stars, radiating cosmic energy.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
