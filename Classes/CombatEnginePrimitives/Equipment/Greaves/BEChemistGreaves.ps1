using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECHEMISTGREAVES
#
###############################################################################

Class BEChemistGreaves : BEGreaves {
	BEChemistGreaves() : base() {
		$this.Name               = 'Chemist Greaves'
		$this.MapObjName         = 'chemistgreaves'
		$this.PurchasePrice      = 580
		$this.SellPrice          = 290
		$this.TargetStats        = @{
			[StatId]::Defense = 20
			[StatId]::MagicDefense = 18
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves for scientific experimenters.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
