using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEVANGUARDPAULDRON
#
###############################################################################

Class BEVanguardPauldron : BEPauldron {
	BEVanguardPauldron() : base() {
		$this.Name               = 'Vanguard Pauldron'
		$this.MapObjName         = 'vanguardpauldron'
		$this.PurchasePrice      = 1400
		$this.SellPrice          = 700
		$this.TargetStats        = @{
			[StatId]::Defense = 28
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Leads the charge, offering robust protection in the front lines.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}
