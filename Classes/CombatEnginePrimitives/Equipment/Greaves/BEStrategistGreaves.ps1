using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESTRATEGISTGREAVES
#
###############################################################################

Class BEStrategistGreaves : BEGreaves {
	BEStrategistGreaves() : base() {
		$this.Name               = 'Strategist Greaves'
		$this.MapObjName         = 'strategistgreaves'
		$this.PurchasePrice      = 550
		$this.SellPrice          = 275
		$this.TargetStats        = @{
			[StatId]::Defense = 22
			[StatId]::MagicDefense = 18
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves for grand scale planning.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
