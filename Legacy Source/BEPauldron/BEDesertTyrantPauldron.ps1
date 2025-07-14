using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEDESERTTYRANTPAULDRON
#
###############################################################################

Class BEDesertTyrantPauldron : BEPauldron {
	BEDesertTyrantPauldron() : base() {
		$this.Name               = 'Desert Tyrant Pauldron'
		$this.MapObjName         = 'deserttyrantpauldron'
		$this.PurchasePrice      = 8550
		$this.SellPrice          = 4275
		$this.TargetStats        = @{
			[StatId]::Defense = 171
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Worn by rulers of arid lands, exuding oppressive power.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}
