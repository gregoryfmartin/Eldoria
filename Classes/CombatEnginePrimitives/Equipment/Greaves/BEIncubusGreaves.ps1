using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEINCUBUSGREAVES
#
###############################################################################

Class BEIncubusGreaves : BEGreaves {
	BEIncubusGreaves() : base() {
		$this.Name               = 'Incubus Greaves'
		$this.MapObjName         = 'incubusgreaves'
		$this.PurchasePrice      = 900
		$this.SellPrice          = 450
		$this.TargetStats        = @{
			[StatId]::Defense = 28
			[StatId]::MagicDefense = 32
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves of a charming demon.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
