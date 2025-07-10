using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE FARMER'S STRAW HAT
#
###############################################################################

Class BEFarmersStrawHat : BEHelmet {
	BEFarmersStrawHat() : base() {
		$this.Name               = 'Farmer''s Straw Hat'
		$this.MapObjName         = 'farmersstrawhat'
		$this.PurchasePrice      = 30
		$this.SellPrice          = 15
		$this.TargetStats        = @{
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A simple straw hat, offering basic sun protection.'
		$this.PlayerEffectString = ""
		$this.TargetGender       = [Gender]::Unisex
	}
}
