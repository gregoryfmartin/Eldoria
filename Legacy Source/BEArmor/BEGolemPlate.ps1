using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEGOLEMPLATE
#
###############################################################################

Class BEGolemPlate : BEArmor {
	BEGolemPlate() : base() {
		$this.Name               = 'Golem Plate'
		$this.MapObjName         = 'golemplate'
		$this.PurchasePrice      = 2200
		$this.SellPrice          = 1100
		$this.TargetStats        = @{
			[StatId]::Defense = 32
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Extremely heavy and tough plate armor, slows movement.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
