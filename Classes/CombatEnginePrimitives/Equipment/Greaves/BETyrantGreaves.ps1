using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BETYRANTGREAVES
#
###############################################################################

Class BETyrantGreaves : BEGreaves {
	BETyrantGreaves() : base() {
		$this.Name               = 'Tyrant Greaves'
		$this.MapObjName         = 'tyrantgreaves'
		$this.PurchasePrice      = 1000
		$this.SellPrice          = 500
		$this.TargetStats        = @{
			[StatId]::Defense = 42
			[StatId]::MagicDefense = 15
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves of an oppressive ruler.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
