using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEPATHFINDERPAULDRON
#
###############################################################################

Class BEPathfinderPauldron : BEPauldron {
	BEPathfinderPauldron() : base() {
		$this.Name               = 'Pathfinder Pauldron'
		$this.MapObjName         = 'pathfinderpauldron'
		$this.PurchasePrice      = 2200
		$this.SellPrice          = 1100
		$this.TargetStats        = @{
			[StatId]::Defense = 44
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Aids in navigating difficult terrain and evading threats.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}
