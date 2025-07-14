using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BELUNARECLIPSEGAUNTLETS
#
###############################################################################

Class BELunarEclipseGauntlets : BEGauntlets {
	BELunarEclipseGauntlets() : base() {
		$this.Name               = 'Lunar Eclipse Gauntlets'
		$this.MapObjName         = 'lunareclipsegauntlets'
		$this.PurchasePrice      = 1450
		$this.SellPrice          = 725
		$this.TargetStats        = @{
			[StatId]::Defense = 68
			[StatId]::MagicDefense = 32
			[StatId]::Accuracy = 18
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets that dim the light around them, aiding stealth.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Unisex
	}
}
