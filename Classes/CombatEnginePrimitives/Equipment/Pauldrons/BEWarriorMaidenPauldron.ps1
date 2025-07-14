using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEWARRIORMAIDENPAULDRON
#
###############################################################################

Class BEWarriorMaidenPauldron : BEPauldron {
	BEWarriorMaidenPauldron() : base() {
		$this.Name               = 'Warrior Maiden Pauldron'
		$this.MapObjName         = 'warriormaidenpauldron'
		$this.PurchasePrice      = 700
		$this.SellPrice          = 350
		$this.TargetStats        = @{
			[StatId]::Defense = 14
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Designed for courageous female warriors.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Female
	}
}
