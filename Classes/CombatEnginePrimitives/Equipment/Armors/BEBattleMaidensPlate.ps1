using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEBATTLEMAIDENSPLATE
#
###############################################################################

Class BEBattleMaidensPlate : BEArmor {
	BEBattleMaidensPlate() : base() {
		$this.Name               = 'Battle Maiden''s Plate'
		$this.MapObjName         = 'battlemaidensplate'
		$this.PurchasePrice      = 1100
		$this.SellPrice          = 550
		$this.TargetStats        = @{
			[StatId]::Defense = 21
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Sturdy plate armor designed for female warriors, allowing flexibility.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Female
	}
}
