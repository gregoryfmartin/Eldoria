using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEFADINGEMBER
#
###############################################################################

Class BEFadingEmber : BEJewelry {
	BEFadingEmber() : base() {
		$this.Name               = 'Fading Ember'
		$this.MapObjName         = 'fadingember'
		$this.PurchasePrice      = 500
		$this.SellPrice          = 250
		$this.TargetStats        = @{
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A dying ember that occasionally flares.'
		$this.PlayerEffectString = ""
		$this.TargetGender       = [Gender]::Unisex
	}
}
