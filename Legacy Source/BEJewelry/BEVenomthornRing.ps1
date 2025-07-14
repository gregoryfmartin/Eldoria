using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEVENOMTHORNRING
#
###############################################################################

Class BEVenomthornRing : BEJewelry {
	BEVenomthornRing() : base() {
		$this.Name               = 'Venomthorn Ring'
		$this.MapObjName         = 'venomthornring'
		$this.PurchasePrice      = 950
		$this.SellPrice          = 475
		$this.TargetStats        = @{
			[StatId]::Attack = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A ring with a sharp, poisoned thorn.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}
