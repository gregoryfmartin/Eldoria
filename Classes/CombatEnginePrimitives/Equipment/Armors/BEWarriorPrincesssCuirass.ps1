using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEWARRIORPRINCESSSCUIRASS
#
###############################################################################

Class BEWarriorPrincesssCuirass : BEArmor {
	BEWarriorPrincesssCuirass() : base() {
		$this.Name               = 'Warrior Princess''s Cuirass'
		$this.MapObjName         = 'warriorprincessscuirass'
		$this.PurchasePrice      = 1700
		$this.SellPrice          = 850
		$this.TargetStats        = @{
			[StatId]::Defense = 27
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A decorative yet strong cuirass for a royal warrior.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Female
	}
}
