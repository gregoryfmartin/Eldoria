using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEFIENDGREAVES
#
###############################################################################

Class BEFiendGreaves : BEGreaves {
	BEFiendGreaves() : base() {
		$this.Name               = 'Fiend Greaves'
		$this.MapObjName         = 'fiendgreaves'
		$this.PurchasePrice      = 1500
		$this.SellPrice          = 750
		$this.TargetStats        = @{
			[StatId]::Defense = 60
			[StatId]::MagicDefense = 28
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves of a malevolent spirit.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
