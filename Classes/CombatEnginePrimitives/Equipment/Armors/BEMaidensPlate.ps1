using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEMAIDENSPLATE
#
###############################################################################

Class BEMaidensPlate : BEArmor {
	BEMaidensPlate() : base() {
		$this.Name               = 'Maiden''s Plate'
		$this.MapObjName         = 'maidensplate'
		$this.PurchasePrice      = 950
		$this.SellPrice          = 475
		$this.TargetStats        = @{
			[StatId]::Defense = 20
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Light plate armor designed for female combatants.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Female
	}
}
