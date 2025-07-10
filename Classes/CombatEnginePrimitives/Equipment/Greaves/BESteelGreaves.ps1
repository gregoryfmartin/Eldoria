using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESTEELGREAVES
#
###############################################################################

Class BESteelGreaves : BEGreaves {
	BESteelGreaves() : base() {
		$this.Name               = 'Steel Greaves'
		$this.MapObjName         = 'steelgreaves'
		$this.PurchasePrice      = 350
		$this.SellPrice          = 175
		$this.TargetStats        = @{
			[StatId]::Defense = 18
			[StatId]::MagicDefense = 7
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Heavy steel greaves, offering solid defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
