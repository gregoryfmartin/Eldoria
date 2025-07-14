using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEJUSTICEGREAVES
#
###############################################################################

Class BEJusticeGreaves : BEGreaves {
	BEJusticeGreaves() : base() {
		$this.Name               = 'Justice Greaves'
		$this.MapObjName         = 'justicegreaves'
		$this.PurchasePrice      = 1000
		$this.SellPrice          = 500
		$this.TargetStats        = @{
			[StatId]::Defense = 40
			[StatId]::MagicDefense = 20
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves of unwavering fairness.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
