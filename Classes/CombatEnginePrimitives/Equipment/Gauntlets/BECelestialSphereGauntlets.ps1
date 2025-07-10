using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECELESTIALSPHEREGAUNTLETS
#
###############################################################################

Class BECelestialSphereGauntlets : BEGauntlets {
	BECelestialSphereGauntlets() : base() {
		$this.Name               = 'Celestial Sphere Gauntlets'
		$this.MapObjName         = 'celestialspheregauntlets'
		$this.PurchasePrice      = 1200
		$this.SellPrice          = 600
		$this.TargetStats        = @{
			[StatId]::Defense = 25
			[StatId]::MagicDefense = 50
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets adorned with miniature celestial spheres, aiding astral magic.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
