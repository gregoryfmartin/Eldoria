using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEREDEEMERGREAVES
#
###############################################################################

Class BERedeemerGreaves : BEGreaves {
	BERedeemerGreaves() : base() {
		$this.Name               = 'Redeemer Greaves'
		$this.MapObjName         = 'redeemergreaves'
		$this.PurchasePrice      = 1100
		$this.SellPrice          = 550
		$this.TargetStats        = @{
			[StatId]::Defense = 45
			[StatId]::MagicDefense = 25
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves that bring salvation.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
