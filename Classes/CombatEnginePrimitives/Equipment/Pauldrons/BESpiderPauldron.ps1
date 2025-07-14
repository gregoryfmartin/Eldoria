using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESPIDERPAULDRON
#
###############################################################################

Class BESpiderPauldron : BEPauldron {
	BESpiderPauldron() : base() {
		$this.Name               = 'Spider Pauldron'
		$this.MapObjName         = 'spiderpauldron'
		$this.PurchasePrice      = 5500
		$this.SellPrice          = 2750
		$this.TargetStats        = @{
			[StatId]::Defense = 110
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Allows for agile movement and offers venom resistance.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
