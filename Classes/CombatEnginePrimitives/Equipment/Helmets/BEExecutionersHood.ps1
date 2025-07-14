using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEEXECUTIONERSHOOD
#
###############################################################################

Class BEExecutionersHood : BEHelmet {
	BEExecutionersHood() : base() {
		$this.Name               = 'Executioner''s Hood'
		$this.MapObjName         = 'executionershood'
		$this.PurchasePrice      = 300
		$this.SellPrice          = 150
		$this.TargetStats        = @{
			[StatId]::Defense = 9
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A grim hood worn by executioners, concealing their identity.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
