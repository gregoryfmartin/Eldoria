using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECELESTIALMESSENGERSROBE
#
###############################################################################

Class BECelestialMessengersRobe : BEArmor {
	BECelestialMessengersRobe() : base() {
		$this.Name               = 'Celestial Messenger''s Robe'
		$this.MapObjName         = 'celestialmessengersrobe'
		$this.PurchasePrice      = 1750
		$this.SellPrice          = 875
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 36
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A robe said to be worn by celestial beings, granting wisdom and foresight.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
