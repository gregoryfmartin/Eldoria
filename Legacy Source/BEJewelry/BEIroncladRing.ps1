using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEIRONCLADRING
#
###############################################################################

Class BEIroncladRing : BEJewelry {
	BEIroncladRing() : base() {
		$this.Name               = 'Ironclad Ring'
		$this.MapObjName         = 'ironcladring'
		$this.PurchasePrice      = 150
		$this.SellPrice          = 75
		$this.TargetStats        = @{
			[StatId]::Defense = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A sturdy iron ring, offering basic defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}
