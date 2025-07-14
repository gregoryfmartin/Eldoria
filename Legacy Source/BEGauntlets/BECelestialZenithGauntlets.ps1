using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECELESTIALZENITHGAUNTLETS
#
###############################################################################

Class BECelestialZenithGauntlets : BEGauntlets {
	BECelestialZenithGauntlets() : base() {
		$this.Name               = 'Celestial Zenith Gauntlets'
		$this.MapObjName         = 'celestialzenithgauntlets'
		$this.PurchasePrice      = 2100
		$this.SellPrice          = 1050
		$this.TargetStats        = @{
			[StatId]::Defense = 100
			[StatId]::MagicDefense = 45
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets that draw power from the highest heavens.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
