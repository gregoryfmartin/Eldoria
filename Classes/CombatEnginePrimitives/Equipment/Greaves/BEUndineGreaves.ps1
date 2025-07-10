using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEUNDINEGREAVES
#
###############################################################################

Class BEUndineGreaves : BEGreaves {
	BEUndineGreaves() : base() {
		$this.Name               = 'Undine Greaves'
		$this.MapObjName         = 'undinegreaves'
		$this.PurchasePrice      = 550
		$this.SellPrice          = 275
		$this.TargetStats        = @{
			[StatId]::Defense = 18
			[StatId]::MagicDefense = 22
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves of a water spirit.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
