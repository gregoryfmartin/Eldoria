using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECELESTIALSPHEREEARRING
#
###############################################################################

Class BECelestialSphereEarring : BEJewelry {
	BECelestialSphereEarring() : base() {
		$this.Name               = 'Celestial Sphere Earring'
		$this.MapObjName         = 'celestialsphereearring'
		$this.PurchasePrice      = 1700
		$this.SellPrice          = 850
		$this.TargetStats        = @{
			[StatId]::MagicAttack = 3
			[StatId]::MagicDefense = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'An earring with a tiny celestial sphere.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
