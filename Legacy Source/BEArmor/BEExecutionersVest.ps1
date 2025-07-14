using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEEXECUTIONERSVEST
#
###############################################################################

Class BEExecutionersVest : BEArmor {
	BEExecutionersVest() : base() {
		$this.Name               = 'Executioner''s Vest'
		$this.MapObjName         = 'executionersvest'
		$this.PurchasePrice      = 240
		$this.SellPrice          = 120
		$this.TargetStats        = @{
			[StatId]::Defense = 6
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A sturdy, dark vest worn by those carrying out justice.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
