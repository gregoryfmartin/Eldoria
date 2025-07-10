using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESEERGREAVES
#
###############################################################################

Class BESeerGreaves : BEGreaves {
	BESeerGreaves() : base() {
		$this.Name               = 'Seer Greaves'
		$this.MapObjName         = 'seergreaves'
		$this.PurchasePrice      = 650
		$this.SellPrice          = 325
		$this.TargetStats        = @{
			[StatId]::Defense = 18
			[StatId]::MagicDefense = 28
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves that reveal hidden truths.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
