using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESIRENGREAVES
#
###############################################################################

Class BESirenGreaves : BEGreaves {
	BESirenGreaves() : base() {
		$this.Name               = 'Siren Greaves'
		$this.MapObjName         = 'sirengreaves'
		$this.PurchasePrice      = 700
		$this.SellPrice          = 350
		$this.TargetStats        = @{
			[StatId]::Defense = 20
			[StatId]::MagicDefense = 28
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves that lure sailors to their doom.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
