using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEDIVINERADIANCEGAUNTLETS
#
###############################################################################

Class BEDivineRadianceGauntlets : BEGauntlets {
	BEDivineRadianceGauntlets() : base() {
		$this.Name               = 'Divine Radiance Gauntlets'
		$this.MapObjName         = 'divineradiancegauntlets'
		$this.PurchasePrice      = 1900
		$this.SellPrice          = 950
		$this.TargetStats        = @{
			[StatId]::Defense = 85
			[StatId]::MagicDefense = 45
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets emanating intense divine light, scorching foes.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
