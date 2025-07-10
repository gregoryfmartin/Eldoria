using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEEXECUTIONERGREAVES
#
###############################################################################

Class BEExecutionerGreaves : BEGreaves {
	BEExecutionerGreaves() : base() {
		$this.Name               = 'Executioner Greaves'
		$this.MapObjName         = 'executionergreaves'
		$this.PurchasePrice      = 800
		$this.SellPrice          = 400
		$this.TargetStats        = @{
			[StatId]::Defense = 35
			[StatId]::MagicDefense = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Heavy greaves for those who carry out sentences.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
