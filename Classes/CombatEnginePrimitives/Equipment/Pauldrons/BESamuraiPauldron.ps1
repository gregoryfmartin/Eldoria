using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESAMURAIPAULDRON
#
###############################################################################

Class BESamuraiPauldron : BEPauldron {
	BESamuraiPauldron() : base() {
		$this.Name               = 'Samurai Pauldron'
		$this.MapObjName         = 'samuraipauldron'
		$this.PurchasePrice      = 9250
		$this.SellPrice          = 4625
		$this.TargetStats        = @{
			[StatId]::Defense = 185
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Refined and honorable, offering balanced defense and attack.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}
