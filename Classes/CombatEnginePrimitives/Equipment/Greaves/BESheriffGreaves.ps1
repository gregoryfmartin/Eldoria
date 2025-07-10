using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESHERIFFGREAVES
#
###############################################################################

Class BESheriffGreaves : BEGreaves {
	BESheriffGreaves() : base() {
		$this.Name               = 'Sheriff Greaves'
		$this.MapObjName         = 'sheriffgreaves'
		$this.PurchasePrice      = 400
		$this.SellPrice          = 200
		$this.TargetStats        = @{
			[StatId]::Defense = 18
			[StatId]::MagicDefense = 8
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves of a law enforcer.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
