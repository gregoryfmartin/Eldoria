using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BELEATHERCAPE
#
###############################################################################

Class BELeatherCape : BECape {
	BELeatherCape() : base() {
		$this.Name               = 'Leather Cape'
		$this.MapObjName         = 'leathercape'
		$this.PurchasePrice      = 150
		$this.SellPrice          = 75
		$this.TargetStats        = @{
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A sturdy leather cape, providing a touch of defense.'
		$this.PlayerEffectString = ""
		$this.TargetGender       = [Gender]::Unisex
	}
}
