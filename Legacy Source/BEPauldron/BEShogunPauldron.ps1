using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESHOGUNPAULDRON
#
###############################################################################

Class BEShogunPauldron : BEPauldron {
	BEShogunPauldron() : base() {
		$this.Name               = 'Shogun Pauldron'
		$this.MapObjName         = 'shogunpauldron'
		$this.PurchasePrice      = 9450
		$this.SellPrice          = 4725
		$this.TargetStats        = @{
			[StatId]::Defense = 189
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A symbol of ultimate military authority and power.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}
