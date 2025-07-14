using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECELESTIALHELM
#
###############################################################################

Class BECelestialHelm : BEHelmet {
	BECelestialHelm() : base() {
		$this.Name               = 'Celestial Helm'
		$this.MapObjName         = 'celestialhelm'
		$this.PurchasePrice      = 4200
		$this.SellPrice          = 2100
		$this.TargetStats        = @{
			[StatId]::Defense = 30
			[StatId]::MagicDefense = 38
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm descended from the heavens, radiating pure light.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
