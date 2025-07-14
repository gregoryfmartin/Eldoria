using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEGLADIATORPAULDRON
#
###############################################################################

Class BEGladiatorPauldron : BEPauldron {
	BEGladiatorPauldron() : base() {
		$this.Name               = 'Gladiator Pauldron'
		$this.MapObjName         = 'gladiatorpauldron'
		$this.PurchasePrice      = 8250
		$this.SellPrice          = 4125
		$this.TargetStats        = @{
			[StatId]::Defense = 165
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Built for the arena, offering robust protection and intimidation.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}
