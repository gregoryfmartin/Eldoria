using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECELESTIALTEARGAUNTLETSIII
#
###############################################################################

Class BECelestialTearGauntletsIII : BEGauntlets {
	BECelestialTearGauntletsIII() : base() {
		$this.Name               = 'Celestial Tear Gauntlets III'
		$this.MapObjName         = 'celestialteargauntletsiii'
		$this.PurchasePrice      = 2200
		$this.SellPrice          = 1100
		$this.TargetStats        = @{
			[StatId]::Defense = 105
			[StatId]::MagicDefense = 50
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Ultimate Celestial Tear Gauntlets, drawing maximum cosmic power.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
