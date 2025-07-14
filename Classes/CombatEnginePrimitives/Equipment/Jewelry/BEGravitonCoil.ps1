using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEGRAVITONCOIL
#
###############################################################################

Class BEGravitonCoil : BEJewelry {
	BEGravitonCoil() : base() {
		$this.Name               = 'Graviton Coil'
		$this.MapObjName         = 'gravitoncoil'
		$this.PurchasePrice      = 2500
		$this.SellPrice          = 1250
		$this.TargetStats        = @{
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A small coil that subtly alters gravity.'
		$this.PlayerEffectString = ""
		$this.TargetGender       = [Gender]::Unisex
	}
}
