using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEMISFORTUNETOKEN
#
###############################################################################

Class BEMisfortuneToken : BEJewelry {
	BEMisfortuneToken() : base() {
		$this.Name               = 'Misfortune Token'
		$this.MapObjName         = 'misfortunetoken'
		$this.PurchasePrice      = 750
		$this.SellPrice          = 375
		$this.TargetStats        = @{
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A token that brings bad luck.'
		$this.PlayerEffectString = ""
		$this.TargetGender       = [Gender]::Unisex
	}
}
