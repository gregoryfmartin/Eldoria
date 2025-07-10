using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECELESTIALHANDGUARDS
#
###############################################################################

Class BECelestialHandguards : BEGauntlets {
	BECelestialHandguards() : base() {
		$this.Name               = 'Celestial Handguards'
		$this.MapObjName         = 'celestialhandguards'
		$this.PurchasePrice      = 1700
		$this.SellPrice          = 850
		$this.TargetStats        = @{
			[StatId]::Defense = 78
			[StatId]::MagicDefense = 33
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Handguards of celestial origin, radiating divine light.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
