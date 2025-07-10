using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEPLAGUEDGREAVES
#
###############################################################################

Class BEPlaguedGreaves : BEGreaves {
	BEPlaguedGreaves() : base() {
		$this.Name               = 'Plagued Greaves'
		$this.MapObjName         = 'plaguedgreaves'
		$this.PurchasePrice      = 850
		$this.SellPrice          = 425
		$this.TargetStats        = @{
			[StatId]::Defense = 32
			[StatId]::MagicDefense = 16
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves spreading disease and decay.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
