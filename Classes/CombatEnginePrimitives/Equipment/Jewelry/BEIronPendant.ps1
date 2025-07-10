using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEIRONPENDANT
#
###############################################################################

Class BEIronPendant : BEJewelry {
	BEIronPendant() : base() {
		$this.Name               = 'Iron Pendant'
		$this.MapObjName         = 'ironpendant'
		$this.PurchasePrice      = 80
		$this.SellPrice          = 40
		$this.TargetStats        = @{
			[StatId]::Attack = 1
			[StatId]::Defense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A heavy iron pendant, often worn by warriors.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}
