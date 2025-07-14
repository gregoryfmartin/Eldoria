using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEEMPERORSPAULDRON
#
###############################################################################

Class BEEmperorsPauldron : BEPauldron {
	BEEmperorsPauldron() : base() {
		$this.Name               = 'Emperor''s Pauldron'
		$this.MapObjName         = 'emperorspauldron'
		$this.PurchasePrice      = 9500
		$this.SellPrice          = 4750
		$this.TargetStats        = @{
			[StatId]::Defense = 190
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Fit for a true ruler, bestowing regal authority and immense protection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}
