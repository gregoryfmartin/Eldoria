using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEVALIANTPAULDRON
#
###############################################################################

Class BEValiantPauldron : BEPauldron {
	BEValiantPauldron() : base() {
		$this.Name               = 'Valiant Pauldron'
		$this.MapObjName         = 'valiantpauldron'
		$this.PurchasePrice      = 750
		$this.SellPrice          = 375
		$this.TargetStats        = @{
			[StatId]::Defense = 15
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Signifies courage and strength, often worn by knights.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}
