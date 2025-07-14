using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECELESTIALTEARGAUNTLETS
#
###############################################################################

Class BECelestialTearGauntlets : BEGauntlets {
	BECelestialTearGauntlets() : base() {
		$this.Name               = 'Celestial Tear Gauntlets'
		$this.MapObjName         = 'celestialteargauntlets'
		$this.PurchasePrice      = 2000
		$this.SellPrice          = 1000
		$this.TargetStats        = @{
			[StatId]::Defense = 95
			[StatId]::MagicDefense = 40
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets said to be formed from a fallen star''s tear.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
