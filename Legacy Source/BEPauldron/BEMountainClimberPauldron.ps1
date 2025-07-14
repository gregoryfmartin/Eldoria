using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEMOUNTAINCLIMBERPAULDRON
#
###############################################################################

Class BEMountainClimberPauldron : BEPauldron {
	BEMountainClimberPauldron() : base() {
		$this.Name               = 'Mountain Climber Pauldron'
		$this.MapObjName         = 'mountainclimberpauldron'
		$this.PurchasePrice      = 2600
		$this.SellPrice          = 1300
		$this.TargetStats        = @{
			[StatId]::Defense = 52
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Aids in scaling peaks and offers protection against falling debris.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}
