using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEINNOCENCEGREAVES
#
###############################################################################

Class BEInnocenceGreaves : BEGreaves {
	BEInnocenceGreaves() : base() {
		$this.Name               = 'Innocence Greaves'
		$this.MapObjName         = 'innocencegreaves'
		$this.PurchasePrice      = 800
		$this.SellPrice          = 400
		$this.TargetStats        = @{
			[StatId]::Defense = 30
			[StatId]::MagicDefense = 14
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves of a pure heart.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
