using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE ASTRONOMER'S HOOD
#
###############################################################################

Class BEAstronomersHood : BEHelmet {
	BEAstronomersHood() : base() {
		$this.Name               = 'Astronomer''s Hood'
		$this.MapObjName         = 'astronomershood'
		$this.PurchasePrice      = 120
		$this.SellPrice          = 60
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 6
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A hood that aids astronomers in observing the night sky.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
