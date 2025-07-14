using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEDESPOTGREAVES
#
###############################################################################

Class BEDespotGreaves : BEGreaves {
	BEDespotGreaves() : base() {
		$this.Name               = 'Despot Greaves'
		$this.MapObjName         = 'despotgreaves'
		$this.PurchasePrice      = 1100
		$this.SellPrice          = 550
		$this.TargetStats        = @{
			[StatId]::Defense = 45
			[StatId]::MagicDefense = 18
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves of an absolute ruler.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
