using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEHOLYGREAVES
#
###############################################################################

Class BEHolyGreaves : BEGreaves {
	BEHolyGreaves() : base() {
		$this.Name               = 'Holy Greaves'
		$this.MapObjName         = 'holygreaves'
		$this.PurchasePrice      = 1000
		$this.SellPrice          = 500
		$this.TargetStats        = @{
			[StatId]::Defense = 32
			[StatId]::MagicDefense = 35
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Blessed greaves that ward off evil.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
