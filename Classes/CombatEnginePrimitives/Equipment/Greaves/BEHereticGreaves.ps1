using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEHERETICGREAVES
#
###############################################################################

Class BEHereticGreaves : BEGreaves {
	BEHereticGreaves() : base() {
		$this.Name               = 'Heretic Greaves'
		$this.MapObjName         = 'hereticgreaves'
		$this.PurchasePrice      = 800
		$this.SellPrice          = 400
		$this.TargetStats        = @{
			[StatId]::Defense = 30
			[StatId]::MagicDefense = 28
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves of those who defy dogma.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
