using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESURVIVORSPAULDRON
#
###############################################################################

Class BESurvivorsPauldron : BEPauldron {
	BESurvivorsPauldron() : base() {
		$this.Name               = 'Survivor''s Pauldron'
		$this.MapObjName         = 'survivorspauldron'
		$this.PurchasePrice      = 2350
		$this.SellPrice          = 1175
		$this.TargetStats        = @{
			[StatId]::Defense = 47
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Shows signs of wear but has endured countless hardships.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}
