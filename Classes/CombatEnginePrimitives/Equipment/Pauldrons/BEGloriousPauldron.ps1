using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEGLORIOUSPAULDRON
#
###############################################################################

Class BEGloriousPauldron : BEPauldron {
	BEGloriousPauldron() : base() {
		$this.Name               = 'Glorious Pauldron'
		$this.MapObjName         = 'gloriouspauldron'
		$this.PurchasePrice      = 800
		$this.SellPrice          = 400
		$this.TargetStats        = @{
			[StatId]::Defense = 16
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A shining pauldron, symbolizing victory and honor.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}
