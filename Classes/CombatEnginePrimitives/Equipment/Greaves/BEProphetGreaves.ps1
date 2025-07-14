using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEPROPHETGREAVES
#
###############################################################################

Class BEProphetGreaves : BEGreaves {
	BEProphetGreaves() : base() {
		$this.Name               = 'Prophet Greaves'
		$this.MapObjName         = 'prophetgreaves'
		$this.PurchasePrice      = 800
		$this.SellPrice          = 400
		$this.TargetStats        = @{
			[StatId]::Defense = 25
			[StatId]::MagicDefense = 35
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves of a divine messenger.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
