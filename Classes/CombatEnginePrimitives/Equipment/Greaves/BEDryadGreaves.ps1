using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEDRYADGREAVES
#
###############################################################################

Class BEDryadGreaves : BEGreaves {
	BEDryadGreaves() : base() {
		$this.Name               = 'Dryad Greaves'
		$this.MapObjName         = 'dryadgreaves'
		$this.PurchasePrice      = 600
		$this.SellPrice          = 300
		$this.TargetStats        = @{
			[StatId]::Defense = 20
			[StatId]::MagicDefense = 20
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves made from living wood, attuned to forests.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
