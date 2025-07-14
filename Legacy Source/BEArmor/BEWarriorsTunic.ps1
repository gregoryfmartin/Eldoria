using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEWARRIORSTUNIC
#
###############################################################################

Class BEWarriorsTunic : BEArmor {
	BEWarriorsTunic() : base() {
		$this.Name               = 'Warrior''s Tunic'
		$this.MapObjName         = 'warriorstunic'
		$this.PurchasePrice      = 190
		$this.SellPrice          = 95
		$this.TargetStats        = @{
			[StatId]::Defense = 4
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A sturdy tunic designed for frontline combatants.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
