using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEDEEPSEAPAULDRON
#
###############################################################################

Class BEDeepSeaPauldron : BEPauldron {
	BEDeepSeaPauldron() : base() {
		$this.Name               = 'Deep Sea Pauldron'
		$this.MapObjName         = 'deepseapauldron'
		$this.PurchasePrice      = 2750
		$this.SellPrice          = 1375
		$this.TargetStats        = @{
			[StatId]::Defense = 55
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Offers protection against the pressures of the ocean depths.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}
