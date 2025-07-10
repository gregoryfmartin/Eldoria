using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEEXECUTIONERSPLATE
#
###############################################################################

Class BEExecutionersPlate : BEArmor {
	BEExecutionersPlate() : base() {
		$this.Name               = 'Executioner''s Plate'
		$this.MapObjName         = 'executionersplate'
		$this.PurchasePrice      = 1700
		$this.SellPrice          = 850
		$this.TargetStats        = @{
			[StatId]::Defense = 29
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Heavy and dark plate armor, designed for maximum intimidation.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
