using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEHUNTERSPAULDRON
#
###############################################################################

Class BEHuntersPauldron : BEPauldron {
	BEHuntersPauldron() : base() {
		$this.Name               = 'Hunter''s Pauldron'
		$this.MapObjName         = 'hunterspauldron'
		$this.PurchasePrice      = 1900
		$this.SellPrice          = 950
		$this.TargetStats        = @{
			[StatId]::Defense = 38
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Provides decent protection without sacrificing mobility.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}
