using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECLOTHCAPE
#
###############################################################################

Class BEClothCape : BECape {
	BEClothCape() : base() {
		$this.Name               = 'Cloth Cape'
		$this.MapObjName         = 'clothcape'
		$this.PurchasePrice      = 80
		$this.SellPrice          = 40
		$this.TargetStats        = @{
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A simple cloth cape, light and unassuming.'
		$this.PlayerEffectString = ""
		$this.TargetGender       = [Gender]::Unisex
	}
}
