using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEWILDHEARTGAUNTLETS
#
###############################################################################

Class BEWildheartGauntlets : BEGauntlets {
	BEWildheartGauntlets() : base() {
		$this.Name               = 'Wildheart Gauntlets'
		$this.MapObjName         = 'wildheartgauntlets'
		$this.PurchasePrice      = 500
		$this.SellPrice          = 250
		$this.TargetStats        = @{
			[StatId]::Defense = 26
			[StatId]::MagicDefense = 7
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets made from primal beast hide, granting strength.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
