using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEREVENANTGREAVES
#
###############################################################################

Class BERevenantGreaves : BEGreaves {
	BERevenantGreaves() : base() {
		$this.Name               = 'Revenant Greaves'
		$this.MapObjName         = 'revenantgreaves'
		$this.PurchasePrice      = 1100
		$this.SellPrice          = 550
		$this.TargetStats        = @{
			[StatId]::Defense = 42
			[StatId]::MagicDefense = 25
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves of one returned from the grave.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
