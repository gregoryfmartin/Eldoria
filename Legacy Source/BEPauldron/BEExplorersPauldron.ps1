using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEEXPLORERSPAULDRON
#
###############################################################################

Class BEExplorersPauldron : BEPauldron {
	BEExplorersPauldron() : base() {
		$this.Name               = 'Explorer''s Pauldron'
		$this.MapObjName         = 'explorerspauldron'
		$this.PurchasePrice      = 2250
		$this.SellPrice          = 1125
		$this.TargetStats        = @{
			[StatId]::Defense = 45
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'For venturing into uncharted territories, offering decent protection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}
