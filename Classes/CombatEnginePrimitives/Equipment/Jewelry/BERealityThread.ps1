using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEREALITYTHREAD
#
###############################################################################

Class BERealityThread : BEJewelry {
	BERealityThread() : base() {
		$this.Name               = 'Reality Thread'
		$this.MapObjName         = 'realitythread'
		$this.PurchasePrice      = 2200
		$this.SellPrice          = 1100
		$this.TargetStats        = @{
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A single, unbroken thread of reality.'
		$this.PlayerEffectString = ""
		$this.TargetGender       = [Gender]::Unisex
	}
}
