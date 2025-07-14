using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEPADDEDSHIRT
#
###############################################################################

Class BEPaddedShirt : BEArmor {
	BEPaddedShirt() : base() {
		$this.Name               = 'Padded Shirt'
		$this.MapObjName         = 'paddedshirt'
		$this.PurchasePrice      = 120
		$this.SellPrice          = 60
		$this.TargetStats        = @{
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A quilted shirt providing light defense.'
		$this.PlayerEffectString = ""
		$this.TargetGender       = [Gender]::Unisex
	}
}
