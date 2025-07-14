using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECELESTIALTEARGAUNTLETSII
#
###############################################################################

Class BECelestialTearGauntletsII : BEGauntlets {
	BECelestialTearGauntletsII() : base() {
		$this.Name               = 'Celestial Tear Gauntlets II'
		$this.MapObjName         = 'celestialteargauntletsii'
		$this.PurchasePrice      = 2100
		$this.SellPrice          = 1050
		$this.TargetStats        = @{
			[StatId]::Defense = 100
			[StatId]::MagicDefense = 45
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Enhanced Celestial Tear Gauntlets, drawing more cosmic power.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
