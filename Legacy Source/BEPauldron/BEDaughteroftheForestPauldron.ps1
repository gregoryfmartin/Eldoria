using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEDAUGHTEROFTHEFORESTPAULDRON
#
###############################################################################

Class BEDaughteroftheForestPauldron : BEPauldron {
	BEDaughteroftheForestPauldron() : base() {
		$this.Name               = 'Daughter of the Forest Pauldron'
		$this.MapObjName         = 'daughteroftheforestpauldron'
		$this.PurchasePrice      = 950
		$this.SellPrice          = 475
		$this.TargetStats        = @{
			[StatId]::Defense = 19
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Blends with nature, offering subtle protection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Female
	}
}
