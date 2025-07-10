using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEORCPAULDRON
#
###############################################################################

Class BEOrcPauldron : BEPauldron {
	BEOrcPauldron() : base() {
		$this.Name               = 'Orc Pauldron'
		$this.MapObjName         = 'orcpauldron'
		$this.PurchasePrice      = 5950
		$this.SellPrice          = 2975
		$this.TargetStats        = @{
			[StatId]::Defense = 119
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Heavy and brutal, designed for sheer destructive power.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}
