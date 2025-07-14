using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEVALKYRIESCUIRASS
#
###############################################################################

Class BEValkyriesCuirass : BEArmor {
	BEValkyriesCuirass() : base() {
		$this.Name               = 'Valkyrie''s Cuirass'
		$this.MapObjName         = 'valkyriescuirass'
		$this.PurchasePrice      = 1600
		$this.SellPrice          = 800
		$this.TargetStats        = @{
			[StatId]::Defense = 26
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A golden cuirass worn by valiant warrior women.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Female
	}
}
