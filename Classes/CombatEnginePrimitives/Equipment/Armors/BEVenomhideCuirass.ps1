using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEVENOMHIDECUIRASS
#
###############################################################################

Class BEVenomhideCuirass : BEArmor {
	BEVenomhideCuirass() : base() {
		$this.Name               = 'Venomhide Cuirass'
		$this.MapObjName         = 'venomhidecuirass'
		$this.PurchasePrice      = 980
		$this.SellPrice          = 490
		$this.TargetStats        = @{
			[StatId]::Defense = 18
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A cuirass made from poisonous beast hide, offering minor toxin resistance.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
