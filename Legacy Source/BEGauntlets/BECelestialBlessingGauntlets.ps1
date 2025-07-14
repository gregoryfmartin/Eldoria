using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECELESTIALBLESSINGGAUNTLETS
#
###############################################################################

Class BECelestialBlessingGauntlets : BEGauntlets {
	BECelestialBlessingGauntlets() : base() {
		$this.Name               = 'Celestial Blessing Gauntlets'
		$this.MapObjName         = 'celestialblessinggauntlets'
		$this.PurchasePrice      = 1600
		$this.SellPrice          = 800
		$this.TargetStats        = @{
			[StatId]::Defense = 78
			[StatId]::MagicDefense = 38
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets blessed by celestial beings, divine protection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
