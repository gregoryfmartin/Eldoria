using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE CELESTIAL BOW
#
###############################################################################

Class BECelestialBow : BEWeapon {
	BECelestialBow() : base() {
		$this.Name          = 'Celestial Bow'
		$this.MapObjName    = 'celestialbow'
		$this.PurchasePrice = 6400
		$this.SellPrice     = 3200
		$this.TargetStats   = @{
			[StatId]::Attack      = 135
			[StatId]::MagicAttack = 55
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A bow that fires arrows of pure starlight, illuminating and striking foes.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}
