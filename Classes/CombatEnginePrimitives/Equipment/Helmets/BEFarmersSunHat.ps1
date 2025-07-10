using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE FARMER'S SUN HAT
#
###############################################################################

Class BEFarmersSunHat : BEHelmet {
	BEFarmersSunHat() : base() {
		$this.Name               = 'Farmer''s Sun Hat'
		$this.MapObjName         = 'farmerssunhat'
		$this.PurchasePrice      = 35
		$this.SellPrice          = 17
		$this.TargetStats        = @{
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A wide sun hat for farmers, protecting from the sun''s glare.'
		$this.PlayerEffectString = ""
		$this.TargetGender       = [Gender]::Unisex
	}
}
