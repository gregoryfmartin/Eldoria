using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECELESTIALTUNIC
#
###############################################################################

Class BECelestialTunic : BEArmor {
	BECelestialTunic() : base() {
		$this.Name               = 'Celestial Tunic'
		$this.MapObjName         = 'celestialtunic'
		$this.PurchasePrice      = 150
		$this.SellPrice          = 75
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 8
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A tunic said to be woven from starlight, offering slight protection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
