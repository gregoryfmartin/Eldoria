using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEWARRIORQUEENSBREASTPLATE
#
###############################################################################

Class BEWarriorQueensBreastplate : BEArmor {
	BEWarriorQueensBreastplate() : base() {
		$this.Name               = 'Warrior Queen''s Breastplate'
		$this.MapObjName         = 'warriorqueensbreastplate'
		$this.PurchasePrice      = 2000
		$this.SellPrice          = 1000
		$this.TargetStats        = @{
			[StatId]::Defense = 31
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A fearsome breastplate worn by a powerful female leader.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Female
	}
}
